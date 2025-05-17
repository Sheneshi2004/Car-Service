package com.carservice.controller;

import com.carservice.service.EmployeeService; //For employee operations
import com.carservice.model.Employee; //Employee model class
import jakarta.servlet.ServletException; //servlet errors
import jakarta.servlet.http.HttpServlet; //Base servlet class
import jakarta.servlet.http.HttpServletRequest; //To handle HTTP requests
import jakarta.servlet.http.HttpServletResponse; //To handle HTTP responses
import java.io.IOException; //For I/O operations
import java.util.List;//To store employee lists

//class declaration-extends HttpServlet to create EmployeeServlet
public class EmployeeServlet extends HttpServlet {
    private EmployeeService employeeService;

    @Override
    public void init() throws ServletException {
        try {
            employeeService = new EmployeeService(getServletContext());
        } catch (IOException e) {
            throw new ServletException("Failed to initialize EmployeeService", e);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Employee> employees = employeeService.getAllEmployees();
        request.setAttribute("employees", employees);
        request.getRequestDispatcher("manage_employees.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            String employeeId = request.getParameter("employeeId");
            String name = request.getParameter("name");
            String specialization = request.getParameter("specialization");
            Employee employee = new Employee(employeeId, name, specialization);
            employeeService.saveEmployee(employee);
            response.sendRedirect("admin_dashboard.jsp");
        }
    }
}