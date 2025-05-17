package com.carservice.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.util.List;

public class AddRecordServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Basic security check: Ensure user is logged in (optional, could rely on filter or JSP check)
        HttpSession session = request.getSession(false); // Don't create session if it doesn't exist
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp?error=Authentication required");
            return;
        }
        // Optional: Add admin role check if needed
        /*
        User user = (User) session.getAttribute("user");
        if (!"admin".equals(user.getRole())) {
            response.sendRedirect("login.jsp?error=Admin access required");
            return;
        }
        */

        // Retrieve form parameters
        String recordNo = request.getParameter("recordNo"); // This is pre-filled but read for consistency
        String carNo = request.getParameter("carNo");
        String date = request.getParameter("date");
        String currentMileage = request.getParameter("currentMileage");
        String customerUsername = request.getParameter("customerUsername"); // Changed parameter name to match select element
        String nextServiceMileage = request.getParameter("nextServiceMileage");

        // --- Data Validation (Basic Example) ---
        if (carNo == null || carNo.trim().isEmpty() ||
            date == null || date.trim().isEmpty() ||
            currentMileage == null || currentMileage.trim().isEmpty() ||
            customerUsername == null || customerUsername.trim().isEmpty() || // Updated validation check
            nextServiceMileage == null || nextServiceMileage.trim().isEmpty()) {

            // Handle invalid input - redirect back with an error message
            response.sendRedirect("manage_records.jsp?error=Missing required fields");
            return;
        }

        // Validate numeric fields
        try {
            Integer.parseInt(currentMileage);
            Integer.parseInt(nextServiceMileage);
             // Integer.parseInt(recordNo); // Already generated/validated in JSP
             // Customer name is a string, no need to parse as int
        } catch (NumberFormatException e) {
            response.sendRedirect("manage_records.jsp?error=Invalid number format for mileage"); // Removed user ID from msg
            return;
        }

        // Construct the record string
        String newRecord = String.join(",",
                recordNo,
                carNo,
                date,
                currentMileage,
                customerUsername, // Use updated variable
                nextServiceMileage
        ) + System.lineSeparator(); // Add newline

        // Get the real path to the records file
        String recordsFilePath = getServletContext().getRealPath("/WEB-INF/records.txt");

        // Append the new record to the file
        try {
            File recordsFile = new File(recordsFilePath);
            // Create the file and directory if they don't exist
            if (!recordsFile.exists()) {
                recordsFile.getParentFile().mkdirs(); // Create parent directories if needed
                recordsFile.createNewFile();
            }

            // Append using try-with-resources for automatic closing
             try (BufferedWriter writer = new BufferedWriter(new FileWriter(recordsFile, true))) { // 'true' for append mode
                writer.write(newRecord);
                writer.flush(); // Explicitly flush the buffer
            }

        } catch (IOException e) {
            // Handle file writing errors
            e.printStackTrace(); // Log the error
            response.sendRedirect("manage_records.jsp?error=Failed to save record: " + e.getMessage());
            return;
        }

        // Redirect back to the manage records page after successful addition
        response.sendRedirect("manage_records.jsp?success=Record added successfully");
    }
} 