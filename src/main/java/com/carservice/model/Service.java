package com.carservice.model;

public class Service {
    private String name;
    private double price;
    private String description;
    private String category;

    public Service(String name, double price, String description, String category) {
        this.name = name;
        this.price = price;
        this.description = description;
        this.category = category;
    }

    public String getName() { return name; }
    public double getPrice() { return price; }
    public String getDescription() { return description; }
    public String getCategory() { return category; }

    @Override
    public String toString() {
        return name + "," + price + "," + description + "," + category;
    }
}