package com.carservice.model;

public class Records {
    private int recordId;
    private String action;
    private String details;
    private String timestamp;

    public Records(int recordId, String action, String details, String timestamp) {
        this.recordId = recordId;
        this.action = action;
        this.details = details;
        this.timestamp = timestamp;
    }

    public int getRecordId() { return recordId; }
    public String getAction() { return action; }
    public String getDetails() { return details; }
    public String getTimestamp() { return timestamp; }

    @Override
    public String toString() {
        return recordId + "," + action + "," + details + "," + timestamp;
    }
}