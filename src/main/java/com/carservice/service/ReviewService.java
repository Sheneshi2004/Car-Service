package com.carservice.service;

import com.carservice.model.Review;
import com.carservice.model.Records;
import jakarta.servlet.ServletContext;
import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class ReviewService {
    private static final String REVIEW_FILE = "reviews.txt";
    private static final String DATA_DIR = "/WEB-INF/data/";
    private final ServletContext servletContext;
    private final RecordService recordService;

    public ReviewService(ServletContext servletContext) throws IOException {
        this.servletContext = servletContext;
        this.recordService = new RecordService(servletContext);
        createFileIfNotExist(REVIEW_FILE);
    }

    public void createFileIfNotExist(String fileName) throws IOException {
        String directoryPath = servletContext.getRealPath(DATA_DIR);
        if (directoryPath != null) {
            File dataDir = new File(directoryPath);
            if (!dataDir.exists()) {
                dataDir.mkdirs();
            }
            File file = new File(dataDir, fileName);
            if (!file.exists()) {
                file.createNewFile();
            }
        }
    }

    public String getFilePath(String fileName) {
        String relativePath = DATA_DIR + fileName;
        String realPath = servletContext.getRealPath(relativePath);
        if (realPath == null) {
            File fallbackDir = new File("src/main/resources");
            if (!fallbackDir.exists()) fallbackDir.mkdirs();
            realPath = new File(fallbackDir, fileName).getPath();
        }
        return realPath;
    }

    public void saveRecord(String action, String description) throws IOException {
        recordService.saveRecord(new Records(recordService.generateRecordId(), action, description, 
            java.time.LocalDateTime.now().toString()));
    }

    public void saveReview(Review review) throws IOException {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(getFilePath(REVIEW_FILE), true))) {
            writer.write(review.toString());
            writer.newLine();
        }
        saveRecord("Review Creation", "Review ID " + review.getReviewId() + " created by " + review.getUsername());
    }

    public List<Review> getReviewsByUser(String username) throws IOException {
        List<Review> reviews = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new FileReader(getFilePath(REVIEW_FILE)))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) continue;
                String[] parts = line.split(",");
                if (parts.length >= 5 && parts[1].equals(username)) {
                    reviews.add(new Review(
                        Integer.parseInt(parts[0]),
                        parts[1],
                        parts[2],
                        parts[3],
                        Integer.parseInt(parts[4])
                    ));
                }
            }
        }
        return reviews;
    }

    public List<Review> getAllReviews() throws IOException {
        List<Review> reviews = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new FileReader(getFilePath(REVIEW_FILE)))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) continue;
                String[] parts = line.split(",");
                if (parts.length >= 5) {
                    reviews.add(new Review(
                        Integer.parseInt(parts[0]),
                        parts[1],
                        parts[2],
                        parts[3],
                        Integer.parseInt(parts[4])
                    ));
                }
            }
        }
        return reviews;
    }

    public void updateReview(Review review) throws IOException {
        List<Review> reviews = getAllReviews();
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(getFilePath(REVIEW_FILE)))) {
            for (Review r : reviews) {
                if (r.getReviewId() == review.getReviewId()) {
                    writer.write(review.toString());
                } else {
                    writer.write(r.toString());
                }
                writer.newLine();
            }
        }
        saveRecord("Review Update", "Review ID " + review.getReviewId() + " updated");
    }

    public void deleteReview(int reviewId) throws IOException {
        List<Review> reviews = getAllReviews();
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(getFilePath(REVIEW_FILE)))) {
            for (Review r : reviews) {
                if (r.getReviewId() != reviewId) {
                    writer.write(r.toString());
                    writer.newLine();
                }
            }
        }
        saveRecord("Review Deletion", "Review ID " + reviewId + " deleted");
    }

    public int generateReviewId() throws IOException {
        List<Review> reviews = getAllReviews();
        return reviews.isEmpty() ? 1 : reviews.get(reviews.size() - 1).getReviewId() + 1;
    }
} 