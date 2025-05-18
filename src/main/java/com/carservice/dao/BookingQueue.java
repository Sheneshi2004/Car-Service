package com.carservice.dao;

import com.carservice.model.Booking;
import java.util.LinkedList;
import java.util.Queue;

public class BookingQueue {
    private static Queue<Booking> bookingQueue = new LinkedList<>();

    public static void addBooking(Booking booking) {
        bookingQueue.add(booking);
    }

    public static Booking processNextBooking() {
        return bookingQueue.poll();
    }

    public static Queue<Booking> getAllBookings() {
        return bookingQueue;
    }
}