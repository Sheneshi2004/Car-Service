package com.carservice.service;

import com.carservice.model.Booking;
import com.carservice.model.Records;
import jakarta.servlet.ServletContext;
import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class BookingService {
    private static final String BOOKING_FILE = "booking.txt";
    private static final String DATA_DIR = "/WEB-INF/data/";
    private final ServletContext servletContext;
    private final RecordService recordService;

    public BookingService(ServletContext servletContext) throws IOException {
        this.servletContext = servletContext;
        this.recordService = new RecordService(servletContext);
        createFileIfNotExist(BOOKING_FILE);
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
    } //Get file path method added

    public void saveRecord(String action, String description) throws IOException {
        recordService.saveRecord(new Records(recordService.generateRecordId(), action, description, 
            java.time.LocalDateTime.now().toString()));
    }

    public void saveBooking(Booking booking) throws IOException {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(getFilePath(BOOKING_FILE), true))) {
            writer.write(booking.toString());
            writer.newLine();
        }
        saveRecord("Booking Creation", "Booking ID " + booking.getBookingId() + " created for " + booking.getUsername());
    }

    public List<Booking> getBookingsByUser(String username) throws IOException {
        List<Booking> bookings = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new FileReader(getFilePath(BOOKING_FILE)))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) continue;
                String[] parts = line.split(",");
                if (parts.length >= 8 && parts[1].equals(username)) {
                    bookings.add(new Booking(
                        Integer.parseInt(parts[0]),
                        parts[1],
                        parts[2],
                        parts[3],
                        parts[4],
                        parts[5],
                        parts[6],
                        parts[7]
                    ));
                }
            }
        }
        return bookings;
    }

    public List<Booking> getAllBookings() throws IOException {
        List<Booking> bookings = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new FileReader(getFilePath(BOOKING_FILE)))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) continue;
                String[] parts = line.split(",");
                if (parts.length >= 8) {
                    bookings.add(new Booking(
                        Integer.parseInt(parts[0]),
                        parts[1],
                        parts[2],
                        parts[3],
                        parts[4],
                        parts[5],
                        parts[6],
                        parts[7]
                    ));
                }
            }
        }
        return bookings;
    }

    public void updateBooking(Booking booking) throws IOException {
        List<Booking> bookings = getAllBookings();
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(getFilePath(BOOKING_FILE)))) {
            for (Booking b : bookings) {
                if (b.getBookingId() == booking.getBookingId()) {
                    writer.write(booking.toString());
                } else {
                    writer.write(b.toString());
                }
                writer.newLine();
            }
        }
        saveRecord("Booking Update", "Booking ID " + booking.getBookingId() + " updated");
    }

    public int generateBookingId() throws IOException {
        List<Booking> bookings = getAllBookings();
        return bookings.isEmpty() ? 1 : bookings.get(bookings.size() - 1).getBookingId() + 1;
    }
} 