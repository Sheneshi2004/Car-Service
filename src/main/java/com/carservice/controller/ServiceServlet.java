package com.carservice.controller;

import com.carservice.service.ServiceService;
import com.carservice.model.Service;
import com.carservice.util.MergeSort;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

public class ServiceServlet extends HttpServlet {
    private ServiceService serviceService;

    @Override
    public void init() throws ServletException {
        try {
            serviceService = new ServiceService(getServletContext());
        } catch (IOException e) {
            throw new ServletException("Failed to initialize ServiceService", e);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String sortBy = request.getParameter("sortBy");
        System.out.println("ServiceServlet doGet: Called with sortBy = " + sortBy);
        List<Service> services = null;
        String errorMsg = null;

        try {
            services = serviceService.getAllServices();
            if (services == null) {
                System.err.println("ServiceServlet doGet: serviceService.getAllServices() returned null!");
                services = new ArrayList<>(); // Prevent NullPointerException later
                errorMsg = "Service list could not be retrieved (returned null).";
            } else {
                System.out.println("ServiceServlet doGet: Fetched " + services.size() + " services initially.");
            }

            if (sortBy != null && !services.isEmpty()) {
                System.out.println("ServiceServlet doGet: Attempting to sort by " + sortBy);
                if ("category".equals(sortBy)) {
                    MergeSort.sortByCategory(services);
                    System.out.println("ServiceServlet doGet: Sorted by category.");
                } else if ("price".equals(sortBy)) {
                    MergeSort.sortByPrice(services);
                    System.out.println("ServiceServlet doGet: Sorted by price.");
                } else if ("name".equals(sortBy)) {
                    services.sort(Comparator.comparing(Service::getName));
                    System.out.println("ServiceServlet doGet: Sorted by name using Comparator.");
                } else {
                    System.out.println("ServiceServlet doGet: Unknown sortBy parameter - " + sortBy);
                }
            } else if (sortBy != null && services.isEmpty()) {
                System.out.println("ServiceServlet doGet: List is empty, no sorting needed for sortBy = " + sortBy);
            }

        } catch (IOException e) {
            System.err.println("ServiceServlet doGet: IOException while getting/sorting services.");
            e.printStackTrace();
            errorMsg = "Error loading services from data source: " + e.getMessage();
            if (services == null) services = new ArrayList<>(); // Ensure not null for JSP
        } catch (Exception e) {
            System.err.println("ServiceServlet doGet: Unexpected exception while getting/sorting services.");
            e.printStackTrace();
            errorMsg = "An unexpected error occurred: " + e.getMessage();
            if (services == null) services = new ArrayList<>(); // Ensure not null for JSP
        }

        if (errorMsg != null) {
            request.setAttribute("error", errorMsg);
        }
        request.setAttribute("services", services);
        System.out.println("ServiceServlet doGet: Forwarding to JSP with " + (services != null ? services.size() : "null") + " services.");
        request.getRequestDispatcher("manage_services.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String callingPage = "manage_services.jsp"; // Page to redirect back to

        try {
            if ("addService".equals(action)) {
                String name = request.getParameter("name");
                String priceStr = request.getParameter("price");
                String description = request.getParameter("description");
                String category = request.getParameter("category");

                if (name == null || name.trim().isEmpty() || 
                    priceStr == null || priceStr.trim().isEmpty() || 
                    description == null || description.trim().isEmpty() || 
                    category == null || category.trim().isEmpty()) {
                    response.sendRedirect(callingPage + "?error=All+fields+(Name,+Price,+Description,+Category)+are+required.");
                    return;
                }

                double price = Double.parseDouble(priceStr);
                Service service = new Service(name.trim(), price, description.trim(), category.trim());
                serviceService.saveService(service);
                response.sendRedirect(callingPage + "?success=Service+" + name + "+added+successfully");

            } else if ("updateService".equals(action)) {
                String originalName = request.getParameter("originalName");
                String name = request.getParameter("name");
                String priceStr = request.getParameter("price");
                String description = request.getParameter("description");
                String category = request.getParameter("category");

                if (originalName == null || originalName.trim().isEmpty() ||
                    name == null || name.trim().isEmpty() || 
                    priceStr == null || priceStr.trim().isEmpty() || 
                    description == null || description.trim().isEmpty() || 
                    category == null || category.trim().isEmpty()) {
                    response.sendRedirect(callingPage + "?error=All+fields+(Name,+Price,+Description,+Category)+are+required+for+updating.");
                    return;
                }
                
                double price = Double.parseDouble(priceStr);
                Service updatedService = new Service(name.trim(), price, description.trim(), category.trim());
                
                serviceService.updateService(originalName, updatedService);

                response.sendRedirect(callingPage + "?success=Service+" + name + "+updated+successfully");

            } else if ("deleteService".equals(action)) {
                String name = request.getParameter("name");
                 if (name == null || name.trim().isEmpty()) {
                    response.sendRedirect(callingPage + "?error=Service+name+cannot+be+empty+for+deletion.");
                    return;
                }
                serviceService.deleteService(name);
                response.sendRedirect(callingPage + "?success=Service+" + name + "+deleted+successfully");
            } else {
                response.sendRedirect(callingPage + "?error=Invalid+action+specified.");
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect(callingPage + "?error=Invalid+price+format.+Please+enter+a+valid+number.");
        } catch (IOException e) {
            e.printStackTrace();
            response.sendRedirect(callingPage + "?error=An+IO+error+occurred:+ " + e.getMessage().replace(" ", "+"));
        }
    }
}