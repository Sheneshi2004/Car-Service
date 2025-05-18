package com.carservice.controller;

import com.carservice.service.UserService;
import com.carservice.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class LoginServlet extends HttpServlet {
    private UserService userService;

    @Override
    public void init() throws ServletException {
        try {
            userService = new UserService(getServletContext());
        } catch (IOException e) {
            throw new ServletException("Failed to initialize UserService", e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("login".equals(action)) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            
            // Check for admin login first
            if (username.equals("admin") && password.equals("admin123")) {
                HttpSession session = request.getSession();
                User adminUser = new User("admin", "admin123", "admin");
                session.setAttribute("user", adminUser);
                response.sendRedirect(request.getContextPath() + "/admin_dashboard.jsp");
                return;
            }
            
            // Regular user login
            User user = userService.getUser(username);
            if (user != null && user.getPassword().equals(password)) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                response.sendRedirect(request.getContextPath() + "/user-dashboard");
            } else {
                request.setAttribute("error", "Invalid credentials");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } else if ("register".equals(action)) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            
            // Check if username already exists
            if (userService.getUser(username) != null) {
                request.setAttribute("error", "Username already exists");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }
            
            // Create new user with customer role
            User user = new User(username, password, "customer");
            try {
                userService.saveUser(user);
                request.setAttribute("success", "Registration successful! Please login.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            } catch (IOException e) {
                request.setAttribute("error", "Registration failed: " + e.getMessage());
                request.getRequestDispatcher("/register.jsp").forward(request, response);
            }
        }
    }
}