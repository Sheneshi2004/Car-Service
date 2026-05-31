package com.carservice.controller;

import java.io.IOException; //For employee operations
import java.util.List; //Employee model class

import com.carservice.model.Employee; //servlet errors
import com.carservice.service.EmployeeService; //Base servlet class

import jakarta.servlet.ServletException; //To handle HTTP requests
import jakarta.servlet.http.HttpServlet; //To handle HTTP responses
import jakarta.servlet.http.HttpServletRequest; //For I/O operations
import jakarta.servlet.http.HttpServletResponse;//To store employee lists

//class declaration-extends HttpServlet to create EmployeeServlet
public class EmployeeServlet extends HttpServlet {
    private EmployeeService employeeService;

    //To handle servlet errors
    @Override
    public void init() throws ServletException {
        try {
            //new EmployeeService object with ServletContext
            employeeService = new EmployeeService(getServletContext());
        } catch (IOException e) {
            //convert IO Exception to ServletException
            throw new ServletException("Failed to initialize EmployeeService", e);
        }
    }

    //To handle HTTP get requests
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //Get list of all employees from service
        List<Employee> employees = employeeService.getAllEmployees();
        //To store employee list in request attribute
        request.setAttribute("employees", employees);
        //Forward the request list to manage_employees.jsp for displaying
        request.getRequestDispatcher("manage_employees.jsp").forward(request, response);
    }

    //To handle HTTP Post requests
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //get action parameter from requests
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            //Get employee details from request parameters
            String employeeId = request.getParameter("employeeId");
            String name = request.getParameter("name");
            String specialization = request.getParameter("specialization");

            if (employeeId == null || employeeId.trim().isEmpty()) {
                employeeId = employeeService.generateEmployeeId();
            }

            //New employee object with parameters
            Employee employee = new Employee(employeeId, name, specialization);
            //Saving employee using service
            employeeService.saveEmployee(employee);

            //Redirecting to admin dashboard after successful addition
            response.sendRedirect("admin_dashboard.jsp");
        }
    }
}