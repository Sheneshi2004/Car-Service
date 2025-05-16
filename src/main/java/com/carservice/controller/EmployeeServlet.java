package com.carservice.controller;

import com.carservice.service.EmployeeService;
import com.carservice.model.Employee;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

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