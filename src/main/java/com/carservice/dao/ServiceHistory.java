package com.carservice.dao;

import com.carservice.model.Booking;
import java.util.LinkedList;

public class ServiceHistory {
    private LinkedList<Booking> history;

    public ServiceHistory() {
        this.history = new LinkedList<>();
    }

    public void addBooking(Booking booking) {
        history.add(booking);
    }

    public LinkedList<Booking> getHistory() {
        return history;
    }
}