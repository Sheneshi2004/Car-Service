package com.carservice.controller;

import com.carservice.service.BookingService;
import com.carservice.service.ServiceService;
import com.carservice.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Collections;
import java.util.List;
import java.util.Set;
import java.util.HashSet;
import java.util.stream.Collectors;

public class UserDashboardServlet extends HttpServlet {
    private BookingService bookingService;
    private ServiceService serviceService;

    @Override
    public void init() throws ServletException {
        try {
            bookingService = new BookingService(getServletContext());
            serviceService = new ServiceService(getServletContext());
        } catch (IOException e) {
            throw new ServletException("Failed to initialize services", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        String username = user.getUsername();
        
        List<Booking> userBookings = Collections.emptyList();
        List<Service> userSpecificServices = Collections.emptyList();
        List<AdminServiceRecord> detailedServiceRecords = Collections.emptyList();

        System.err.println("[UserDashboardServlet] Logged in user: " + username);

        try {
            userBookings = bookingService.getBookingsByUser(username);
            request.setAttribute("userBookings", userBookings);
            System.err.println("[UserDashboardServlet] Number of bookings for " + username + ": " + (userBookings != null ? userBookings.size() : 0));

            if (userBookings != null && !userBookings.isEmpty()) {
                Set<String> serviceNamesFromBookings = userBookings.stream()
                    .map(Booking::getServiceName)
                    .filter(name -> name != null && !name.trim().isEmpty())
                    .collect(Collectors.toSet());
                System.err.println("[UserDashboardServlet] Service names from user's bookings: " + serviceNamesFromBookings);

                if (!serviceNamesFromBookings.isEmpty()) {
                    List<Service> allServices = serviceService.getAllServices();
                    System.err.println("[UserDashboardServlet] Total services in system: " + (allServices != null ? allServices.size() : 0));
                    userSpecificServices = allServices.stream()
                        .filter(service -> serviceNamesFromBookings.contains(service.getName()))
                        .collect(Collectors.toList());
                    System.err.println("[UserDashboardServlet] Number of user-specific services (from services.txt) after filter: " + userSpecificServices.size());
                } else {
                    System.err.println("[UserDashboardServlet] No service names extracted from user's bookings.");
                }
            }
            request.setAttribute("userSpecificServices", userSpecificServices);

            // Note: AdminServiceRecord functionality needs to be moved to a separate service
            // For now, we'll keep it empty until that service is created
            detailedServiceRecords = Collections.emptyList();
            request.setAttribute("detailedServiceRecords", detailedServiceRecords);
            System.err.println("[UserDashboardServlet] Number of detailed admin service records for " + username + ": " + detailedServiceRecords.size());

            request.getRequestDispatcher("/user_dashboard.jsp").forward(request, response);
        } catch (IOException e) {
            System.err.println("Error fetching data for user dashboard: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("dashboardError", "Unable to load dashboard data. Please try again later.");
            request.setAttribute("userBookings", userBookings);
            request.setAttribute("userSpecificServices", userSpecificServices);
            request.setAttribute("detailedServiceRecords", detailedServiceRecords);
            request.getRequestDispatcher("/user_dashboard.jsp").forward(request, response);
        }
    }
} 