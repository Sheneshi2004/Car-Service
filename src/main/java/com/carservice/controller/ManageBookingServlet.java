package com.carservice.controller;

import com.carservice.service.BookingService;
import com.carservice.model.Booking;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class ManageBookingServlet extends HttpServlet {
    private BookingService bookingService;

    @Override
    public void init() throws ServletException {
        try {
            bookingService = new BookingService(getServletContext());
        } catch (IOException e) {
            throw new ServletException("Failed to initialize BookingService", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<Booking> allBookings = bookingService.getAllBookings();
            request.setAttribute("bookings", allBookings);
            request.getRequestDispatcher("/manage_booking.jsp").forward(request, response);
        } catch (IOException e) {
            System.err.println("Error fetching all bookings: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Unable to load bookings.");
        }
    }
} 