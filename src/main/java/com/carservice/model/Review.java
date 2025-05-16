package com.carservice.model;// pacage name and class located

public class Review {
    private int reviewId;//public class nemed review
    private String username;
    private String serviceName;
    private String comment;
    private int rating;

    public Review(int reviewId, String username, String serviceName, String comment, int rating) {
        this.reviewId = reviewId; //keyword refers to the current instance 
        this.username = username;
        this.serviceName = serviceName;
        this.comment = comment;
        this.rating = rating;
    }

    public int getReviewId() { return reviewId; }
    public String getUsername() { return username; }
    public String getServiceName() { return serviceName; }
    public String getComment() { return comment; }
    public int getRating() { return rating; }

    @Override
    public String toString() {
        return reviewId + "," + username + "," + serviceName + "," + comment + "," + rating;
    }
}