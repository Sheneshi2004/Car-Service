package com.carservice.model;

public class AdminServiceRecord {
    private int recordNo;
    private String carNo;
    private String date;
    private String currentMileage;
    private String customerUsername; // This is the key for filtering
    private String nextServiceMileage;

    public AdminServiceRecord(int recordNo, String carNo, String date, 
                              String currentMileage, String customerUsername, String nextServiceMileage) {
        this.recordNo = recordNo;
        this.carNo = carNo;
        this.date = date;
        this.currentMileage = currentMileage;
        this.customerUsername = customerUsername;
        this.nextServiceMileage = nextServiceMileage;
    }

    // Getters
    public int getRecordNo() {
        return recordNo;
    }

    public String getCarNo() {
        return carNo;
    }

    public String getDate() {
        return date;
    }

    public String getCurrentMileage() {
        return currentMileage;
    }

    public String getCustomerUsername() {
        return customerUsername;
    }

    public String getNextServiceMileage() {
        return nextServiceMileage;
    }

    // No setters needed if records are read-only from the user's perspective
    // toString() might be useful for debugging but not strictly necessary for this task
} 