package com.carservice.controller;

import com.carservice.service.ServiceService;
import com.carservice.service.EmployeeService;
import com.carservice.model.Service;
import com.carservice.model.Employee;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

public class BookingFormServlet extends HttpServlet {
    private ServiceService serviceService;
    private EmployeeService employeeService; //Add BookingFormServlet with services

    @Override
    public void init() throws ServletException { 
        try {
            serviceService = new ServiceService(getServletContext());
            employeeService = new EmployeeService(getServletContext());
        } catch (IOException e) {
            throw new ServletException("Failed to initialize services", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Fetch all services from the ServiceService
            List<Service> services = serviceService.getAllServices();
            // Fetch all employees from the EmployeeService
            List<Employee> employees = employeeService.getAllEmployees();
            
            // Set the list of services as a request attribute
            request.setAttribute("services", services);
            // Set the list of employees as a request attribute
            request.setAttribute("employees", employees);
            
            // Forward the request to the booking form JSP
            request.getRequestDispatcher("/booking_form.jsp").forward(request, response);
        } catch (IOException e) {
            // Log the error and potentially show an error page
            System.err.println("Error fetching services for booking form: " + e.getMessage());
            // Forward to an error page or show a generic error message
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Unable to load services. Please try again later.");
            // Or forward to a dedicated error JSP:
            // request.setAttribute("errorMessage", "Unable to load services.");
            // request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
} //Set up data for booking form in doGet