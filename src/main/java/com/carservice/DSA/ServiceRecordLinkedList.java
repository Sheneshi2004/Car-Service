package com.carservice.DSA;

import com.carservice.model.ServiceRecord;

public class ServiceRecordLinkedList {
    private Node head;
    private int size;

    // Node class for LinkedList
    private static class Node {
        ServiceRecord data;
        Node next;

        Node(ServiceRecord data) {
            this.data = data;
            this.next = null;
        }
    }

    // Constructor
    public ServiceRecordLinkedList() {
        head = null;
        size = 0;
    }

    // Add a record at the end of the list
    public void add(ServiceRecord record) {
        Node newNode = new Node(record);
        if (head == null) {
            head = newNode;
        } else {
            Node current = head;
            while (current.next != null) {
                current = current.next;
            }
            current.next = newNode;
        }
        size++;
    }

    // Remove a record by record number
    public boolean remove(int recordNo) {
        if (head == null) {
            return false;
        }

        if (head.data.getRecordNo() == recordNo) {
            head = head.next;
            size--;
            return true;
        }

        Node current = head;
        while (current.next != null) {
            if (current.next.data.getRecordNo() == recordNo) {
                current.next = current.next.next;
                size--;
                return true;
            }
            current = current.next;
        }
        return false;
    }

    // Get a record by record number
    public ServiceRecord get(int recordNo) {
        Node current = head;
        while (current != null) {
            if (current.data.getRecordNo() == recordNo) {
                return current.data;
            }
            current = current.next;
        }
        return null;
    }

    // Get all records as an array
    public ServiceRecord[] getAllRecords() {
        ServiceRecord[] records = new ServiceRecord[size];
        Node current = head;
        int index = 0;
        while (current != null) {
            records[index++] = current.data;
            current = current.next;
        }
        return records;
    }

    // Get the size of the list
    public int size() {
        return size;
    }

    // Check if the list is empty
    public boolean isEmpty() {
        return size == 0;
    }

    // Clear all records
    public void clear() {
        head = null;
        size = 0;
    }

    // Convert list to array for sorting
    public ServiceRecord[] toArray() {
        return getAllRecords();
    }
} 