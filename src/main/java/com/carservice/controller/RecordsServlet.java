package com.carservice.controller;

import com.carservice.dao.BookingQueue;
import com.carservice.model.Records;
import com.carservice.service.RecordService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class RecordsServlet extends HttpServlet {
    private RecordService recordService;

    @Override
    public void init() throws ServletException {
        try {
            recordService = new RecordService(getServletContext());
        } catch (IOException e) {
            throw new ServletException("Failed to initialize RecordService", e);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Records> records = recordService.getAllRecords();
        request.setAttribute("records", records);
        request.setAttribute("queuedBookings", BookingQueue.getAllBookings());
        request.getRequestDispatcher("manage_records.jsp").forward(request, response);
    }
}