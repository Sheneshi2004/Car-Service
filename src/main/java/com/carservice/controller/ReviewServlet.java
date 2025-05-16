package com.carservice.controller;

import com.carservice.service.ReviewService;
import com.carservice.service.ServiceService;
import com.carservice.model.Review;
import com.carservice.model.Service;
import com.carservice.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class ReviewServlet extends HttpServlet {
    private ReviewService reviewService;
    private ServiceService serviceService;

    @Override
    public void init() throws ServletException {
        try {
            reviewService = new ReviewService(getServletContext());
            serviceService = new ServiceService(getServletContext());
        } catch (IOException e) {
            throw new ServletException("Failed to initialize services", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        
        if ("viewAll".equals(action)) {
            // Display all reviews
            List<Review> allReviews = reviewService.getAllReviews();
            request.setAttribute("allReviews", allReviews);
            request.getRequestDispatcher("reviews.jsp").forward(request, response);
        } else if ("viewUser".equals(action)) {
            // Display user's reviews
            List<Review> userReviews = reviewService.getReviewsByUser(user.getUsername());
            request.setAttribute("userReviews", userReviews);
            request.getRequestDispatcher("user_reviews.jsp").forward(request, response);
        } else {
            // Default: show review form
            try {
                List<Service> services = serviceService.getAllServices();
                request.setAttribute("services", services);
            } catch (IOException e) {
                System.err.println("Error fetching services: " + e.getMessage());
                request.setAttribute("error", "Failed to load services. Please try again later.");
            }
            request.getRequestDispatcher("review_form.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String username = user.getUsername(); // Get username from session

        if ("submit".equals(action)) {
            try {
                String serviceName = request.getParameter("serviceName");
                String comment = request.getParameter("comment");
                String ratingStr = request.getParameter("rating");
                
                // Validate inputs
                if (serviceName == null || serviceName.trim().isEmpty() ||
                    comment == null || comment.trim().isEmpty() ||
                    ratingStr == null || ratingStr.trim().isEmpty()) {
                    request.setAttribute("error", "All fields are required");
                    request.getRequestDispatcher("review_form.jsp").forward(request, response);
                    return;
                }

                int rating = Integer.parseInt(ratingStr);
                if (rating < 1 || rating > 5) {
                    request.setAttribute("error", "Rating must be between 1 and 5");
                    request.getRequestDispatcher("review_form.jsp").forward(request, response);
                    return;
                }
                
                System.out.println("Submitting review - Username: " + username);
                System.out.println("Service Name: " + serviceName);
                System.out.println("Comment: " + comment);
                System.out.println("Rating: " + rating);
                
                Review review = new Review(reviewService.generateReviewId(), username, serviceName, comment, rating);
                reviewService.saveReview(review);
                System.out.println("Review saved successfully with ID: " + review.getReviewId());
                
                response.sendRedirect("review?action=viewAll");
            } catch (Exception e) {
                System.err.println("Error saving review: " + e.getMessage());
                e.printStackTrace();
                request.setAttribute("error", "Failed to save review: " + e.getMessage());
                request.getRequestDispatcher("review_form.jsp").forward(request, response);
            }
        } else if ("update".equals(action)) {
            int reviewId = Integer.parseInt(request.getParameter("reviewId"));
            String serviceName = request.getParameter("serviceName");
            String comment = request.getParameter("comment");
            int rating = Integer.parseInt(request.getParameter("rating"));
            
            Review review = new Review(reviewId, username, serviceName, comment, rating);
            reviewService.updateReview(review);
            response.sendRedirect("review?action=viewUser");
        } else if ("delete".equals(action)) {
            int reviewId = Integer.parseInt(request.getParameter("reviewId"));
            reviewService.deleteReview(reviewId);
            response.sendRedirect("review?action=viewUser");
        }
    }
}