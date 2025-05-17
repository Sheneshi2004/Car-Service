package com.carservice.model;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;

public class Booking { 
    private int bookingId;
    private String username;
    private String serviceName;
    private String employeeId;
    private String date;
    private String time;
    private String vehicleNumber;
    private String status;

    public Booking(int bookingId, String username, String serviceName, String employeeId, String date, String time, String vehicleNumber, String status) { //parameterized constructor
        this.bookingId = bookingId;
        this.username = username;
        this.serviceName = serviceName;
        this.employeeId = employeeId;
        this.date = date;
        this.time = time;
        this.vehicleNumber = vehicleNumber;
        this.status = status;
    }

    public int getBookingId() { return bookingId; }
    public String getUsername() { return username; }
    public String getServiceName() { return serviceName; }
    public String getEmployeeId() { return employeeId; }
    public String getDate() { return date; }
    public String getTime() { return time; }
    public String getVehicleNumber() { return vehicleNumber; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    @Override
    public String toString() {
        return bookingId + "," + username + "," + serviceName + "," + employeeId + "," + date + "," + time + "," + vehicleNumber + "," + status;
    }
}