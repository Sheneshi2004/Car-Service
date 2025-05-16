package com.carservice.model;

public class ServiceRecord {
    private int recordNo;
    private String carNo;
    private String date;
    private int currentMileage;
    private String customerUsername;
    private int nextServiceMileage;

    // Constructor
    public ServiceRecord() {
    }

    public ServiceRecord(int recordNo, String carNo, String date, int currentMileage, 
                        String customerUsername, int nextServiceMileage) {
        this.recordNo = recordNo;
        this.carNo = carNo;
        this.date = date;
        this.currentMileage = currentMileage;
        this.customerUsername = customerUsername;
        this.nextServiceMileage = nextServiceMileage;
    }

    // Getters and Setters
    public int getRecordNo() {
        return recordNo;
    }

    public void setRecordNo(int recordNo) {
        this.recordNo = recordNo;
    }

    public String getCarNo() {
        return carNo;
    }

    public void setCarNo(String carNo) {
        this.carNo = carNo;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public int getCurrentMileage() {
        return currentMileage;
    }

    public void setCurrentMileage(int currentMileage) {
        this.currentMileage = currentMileage;
    }

    public String getCustomerUsername() {
        return customerUsername;
    }

    public void setCustomerUsername(String customerUsername) {
        this.customerUsername = customerUsername;
    }

    public int getNextServiceMileage() {
        return nextServiceMileage;
    }

    public void setNextServiceMileage(int nextServiceMileage) {
        this.nextServiceMileage = nextServiceMileage;
    }

    @Override
    public String toString() {
        return "ServiceRecord{" +
                "recordNo=" + recordNo +
                ", carNo='" + carNo + '\'' +
                ", date='" + date + '\'' +
                ", currentMileage=" + currentMileage +
                ", customerUsername='" + customerUsername + '\'' +
                ", nextServiceMileage=" + nextServiceMileage +
                '}';
    }
} 