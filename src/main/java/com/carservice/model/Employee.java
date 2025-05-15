package com.carservice.model;

public class Employee {
    private String employeeId;
    private String name;
    private String specialization;

    public Employee(String employeeId, String name, String specialization) {
        this.employeeId = employeeId;
        this.name = name;
        this.specialization = specialization;
    }

    public String getEmployeeId() { return employeeId; }
    public String getName() { return name; }
    public String getSpecialization() { return specialization; }

    @Override
    public String toString() {
        return employeeId + "," + name + "," + specialization;
    }
}