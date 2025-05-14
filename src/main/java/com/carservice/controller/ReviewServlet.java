package com.carservice.controller;

import com.carservice.service.ReviewService;
import com.carservice.model.Review;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class ReviewServlet extends HttpServlet {
    private ReviewService reviewService;

    @Override
    public void init() throws ServletException {
        try {
            reviewService = new ReviewService(getServletContext());
        } catch (IOException e) {
            throw new ServletException("Failed to initialize ReviewService", e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if ("submit".equals(action)) {
            String serviceName = request.getParameter("serviceName");
            String comment = request.getParameter("comment");
            int rating = Integer.parseInt(request.getParameter("rating"));
            
            Review review = new Review(reviewService.generateReviewId(), username, serviceName, comment, rating);
            reviewService.saveReview(review);
            response.sendRedirect("user_dashboard.jsp");
        }
    }
}