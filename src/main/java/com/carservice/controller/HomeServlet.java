package com.carservice.controller;

import com.carservice.service.ReviewService;//Handles review related operations
import com.carservice.model.Review;//model class for reviews
import com.carservice.model.User; // For session check if needed for personalized content later

import jakarta.servlet.ServletException;//To handle servlet specific errors
import jakarta.servlet.http.HttpServlet;//Base class for HttpServlet
import jakarta.servlet.http.HttpServletRequest;//To represent client requests
import jakarta.servlet.http.HttpServletResponse;//To represent server's response
import jakarta.servlet.http.HttpSession;//Manages user sessions
import jakarta.servlet.annotation.WebServlet;//To configure servlets

import java.io.IOException;//To handle input output errors
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;//For sorting reviews
import java.util.List;
import java.util.stream.Collectors;//For stream operations

@WebServlet(name = "HomeServlet", urlPatterns = {"/", "/home", "/index"}) // Map to root, /home, and /index
//inherits all basic servlet functions from HttpServlet
public class HomeServlet extends HttpServlet {
    private ReviewService reviewService; // hasdh

    @Override
    public void init() throws ServletException {  //init() - called once when servlet is created
        try {
            reviewService = new ReviewService(getServletContext());
        } catch (IOException e) {
            throw new ServletException("Failed to initialize ReviewService", e);
        }
    }


    //Handles get requests
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //request from client and response to client
        System.out.println("HomeServlet doGet: Called");
        List<Review> topReviews = new ArrayList<>();//Empty list to store top reviews
        String errorMsg = null;

        try {
            List<Review> allReviews = reviewService.getAllReviews();  //Fetch all reviews from the database
            System.out.println("HomeServlet doGet: Fetched " + (allReviews != null ? allReviews.size() : "null") + " total reviews.");

            if (allReviews != null && !allReviews.isEmpty()) {
                // Define "top reviews": Higher rating first, then more recent (higher ID) first.
                // Filter for good ratings (e.g., 4 or 5 stars) first, then sort and limit.
                topReviews = allReviews.stream()
                    .filter(r -> r.getRating() >= 4) // Filter for 4 or 5 stars
                    .sorted(Comparator.comparing(Review::getRating).reversed() // Higher rating first
                                      .thenComparing(Review::getReviewId).reversed()) // Then by newer ID (assuming higher ID is newer)
                    .limit(5) // Show top 5 high-rated reviews
                    .collect(Collectors.toList());
                
                System.out.println("HomeServlet doGet: Selected " + topReviews.size() + " top reviews.");
            } else if (allReviews == null) {
                 errorMsg = "Could not retrieve reviews (ReviewService returned null).";
                 System.err.println("HomeServlet doGet: reviewService.getAllReviews() returned null.");
            }

        } catch (IOException e) {
            e.printStackTrace(); //print full stack error to the console
            errorMsg = "Error loading reviews: " + e.getMessage();
            System.err.println("HomeServlet doGet: IOException while getting reviews: " + e.getMessage()); //log to error stream
        } catch (Exception e) { //all other types of exceptions
            e.printStackTrace();
            errorMsg = "An unexpected error occurred while preparing the home page: " + e.getMessage();
            System.err.println("HomeServlet doGet: Unexpected exception: " + e.getMessage());
        }

        if (errorMsg != null) {
            request.setAttribute("homePageError", errorMsg); // Use a specific error attribute for this page
        }
        request.setAttribute("topReviews", topReviews); //sets list of top reviews for JSP to use
        
        //HttpSession session = request.getSession(false);
        //if (session != null && session.getAttribute("user") != null) {
        //    User user = (User) session.getAttribute("user");
        //    request.setAttribute("currentUser", user);
        //}

        System.out.println("HomeServlet doGet: Forwarding to /index.jsp");
        request.getRequestDispatcher("/index.jsp").forward(request, response);
        //forwarding request to index.jsp which will display the data
    }
} 