package com.carservice.controller;

import com.carservice.service.UserService;
import com.carservice.service.BookingService;
import com.carservice.model.User;
import com.carservice.model.Booking;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Queue;

public class UserServlet extends HttpServlet {
    private UserService userService;
    private BookingService bookingService;

    @Override
    public void init() throws ServletException {
        try {
            userService = new UserService(getServletContext());
            bookingService = new BookingService(getServletContext());
        } catch (IOException e) {
            throw new ServletException("Failed to initialize services", e);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<User> users = userService.getAllUsers();
        List<Booking> bookings = bookingService.getAllBookings();
        request.setAttribute("users", users);
        request.setAttribute("queuedBookings", bookings);
        request.getRequestDispatcher("manage_users.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String username = request.getParameter("username");
        String callingPage = "manage_users.jsp"; // Default redirect page

        try {
            if ("updateUser".equals(action)) {
                String password = request.getParameter("password");
                String role = request.getParameter("role");

                // Validation (basic example)
                if (username == null || username.trim().isEmpty() || role == null || role.trim().isEmpty()) {
                    response.sendRedirect(callingPage + "?error=Username+and+Role+cannot+be+empty");
                    return;
                }

                User existingUser = userService.getUser(username);
                if (existingUser == null) {
                    response.sendRedirect(callingPage + "?error=User+not+found");
                    return;
                }

                // Update role
                existingUser.setRole(role);
                // Update password only if a new one is provided and it's not empty
                if (password != null && !password.trim().isEmpty()) {
                    existingUser.setPassword(password);
                }

                userService.updateUser(existingUser);
                response.sendRedirect(callingPage + "?success=User+" + username + "+updated+successfully");

            } else if ("deleteUser".equals(action)) {
                if (username == null || username.trim().isEmpty()) {
                    response.sendRedirect(callingPage + "?error=Username+cannot+be+empty+for+deletion");
                    return;
                }
                userService.deleteUser(username);
                response.sendRedirect(callingPage + "?success=User+" + username + "+deleted+successfully");
            } else {
                response.sendRedirect(callingPage + "?error=Invalid+action");
            }
        } catch (IOException e) {
            // Log the exception (important for debugging)
            e.printStackTrace(); // Or use a proper logging framework
            // Redirect with a generic error message
            response.sendRedirect(callingPage + "?error=An+error+occurred:+ " + e.getMessage());
        }
    }
}