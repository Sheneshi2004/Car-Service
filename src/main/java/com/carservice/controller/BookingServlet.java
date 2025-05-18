package com.carservice.controller;

import com.carservice.service.BookingService;
import com.carservice.service.RecordService;
import com.carservice.model.Booking;
import com.carservice.dao.BookingQueue;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import com.carservice.model.User;
import com.carservice.model.Records;

public class BookingServlet extends HttpServlet {
    private BookingService bookingService;
    private RecordService recordService;

    @Override
    public void init() throws ServletException {
        try {
            bookingService = new BookingService(getServletContext());
            recordService = new RecordService(getServletContext());
        } catch (IOException e) {
            throw new ServletException("Failed to initialize services", e);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        List<Booking> bookings = bookingService.getBookingsByUser(username);
        request.setAttribute("bookings", bookings);
        request.getRequestDispatcher("user_records.jsp").forward(request, response);
    } //Add doGet to show user bookings

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession(false); // Get existing session, don't create new

        // Check if session exists and user attribute is present
        if (session == null || session.getAttribute("user") == null) {
            System.err.println("User not logged in or session expired during booking.");
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=session_timeout");
            return; // Stop processing
        }

        User user = (User) session.getAttribute("user"); // Get User object
        String username = user.getUsername(); // Get username from User object

        if ("book".equals(action)) {
            String serviceName = request.getParameter("serviceName");
            String employeeId = request.getParameter("employeeId"); // Get employee ID
            String date = request.getParameter("date");
            String time = request.getParameter("time");
            String vehicleNumber = request.getParameter("vehicleNumber");
            String status = "Pending";
            
            // Use retrieved employeeId (handle empty string if none selected)
            Booking booking = new Booking(bookingService.generateBookingId(), username, serviceName, employeeId != null ? employeeId : "", date, time, vehicleNumber, status);
            bookingService.saveBooking(booking);
            BookingQueue.addBooking(booking);
            response.sendRedirect("user_dashboard.jsp");
        } else if ("update".equals(action)) {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            String status = request.getParameter("status");
            List<Booking> bookings = bookingService.getAllBookings();
            for (Booking booking : bookings) {
                if (booking.getBookingId() == bookingId) {
                    booking.setStatus(status);
                    bookingService.updateBooking(booking);
                    
                    // Log completed booking to report.txt
                    if ("Completed".equalsIgnoreCase(status)) {
                        String details = String.format("Booking ID %d (%s) for user %s marked as Completed.", 
                                                     booking.getBookingId(), booking.getServiceName(), booking.getUsername());
                        Records record = new Records(recordService.generateRecordId(), "Booking Completion", details, java.time.LocalDateTime.now().toString());
                        recordService.saveRecord(record);
                    }
                    break;
                }
            }
            response.sendRedirect("admin_dashboard.jsp");
        }
    }
}