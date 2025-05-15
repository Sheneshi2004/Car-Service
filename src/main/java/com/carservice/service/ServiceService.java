package com.carservice.service;

import com.carservice.model.Service;
import jakarta.servlet.ServletContext;
import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class ServiceService {
    private static final String SERVICES_FILE = "services.txt";
    private static final String DATA_DIR = "/WEB-INF/data/";
    private final ServletContext servletContext;

    public ServiceService(ServletContext context) throws IOException {
        this.servletContext = context;
        createFileIfNotExist(SERVICES_FILE);
    }

    private void createFileIfNotExist(String fileName) throws IOException {
        String directoryPath = servletContext.getRealPath(DATA_DIR);
        if (directoryPath != null) {
            File dataDir = new File(directoryPath);
            if (!dataDir.exists()) {
                dataDir.mkdirs();
            }
            File file = new File(dataDir, fileName);
            if (!file.exists()) {
                file.createNewFile();
            }
            System.out.println("ServiceService: Created/verified file at " + file.getAbsolutePath());
        } else {
            System.err.println("ServiceService: Could not get real path for " + DATA_DIR);
        }
    }

    private String getFilePath(String fileName) {
        String relativePath = DATA_DIR + fileName;
        String realPath = servletContext.getRealPath(relativePath);
        if (realPath == null) {
            File fallbackDir = new File("src/main/resources");
            if (!fallbackDir.exists()) fallbackDir.mkdirs();
            realPath = new File(fallbackDir, fileName).getPath();
        }
        System.out.println("ServiceService: Using file path: " + realPath);
        return realPath;
    }

    private void saveRecord(String action, String description) {
        try {
            String logFile = getFilePath("service_log.txt");
            try (PrintWriter writer = new PrintWriter(new FileWriter(logFile, true))) {
                writer.println(action + " - " + description);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public void saveService(Service service) throws IOException {
        List<Service> services = getAllServices();
        services.add(service);
        saveAllServices(services);
        saveRecord("ADD", "Service added: " + service.getName());
        System.out.println("ServiceService: Added new service: " + service.getName());
    }

    public List<Service> getAllServices() throws IOException {
        List<Service> services = new ArrayList<>();
        File file = new File(getFilePath(SERVICES_FILE));
        System.out.println("ServiceService: Reading services from: " + file.getAbsolutePath());
        
        if (!file.exists() || file.length() == 0) {
            System.out.println("ServiceService: File is empty or doesn't exist");
            return services;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) continue;
                String[] parts = line.split(",");
                if (parts.length >= 4) {
                    String name = parts[0];
                    double price = Double.parseDouble(parts[1]);
                    String description = parts[2];
                    String category = parts[3];
                    services.add(new Service(name, price, description, category));
                    System.out.println("ServiceService: Loaded service: " + name);
                }
            }
        }
        System.out.println("ServiceService: Total services loaded: " + services.size());
        return services;
    }

    public void updateService(String originalName, Service updatedService) throws IOException {
        List<Service> services = getAllServices();
        for (int i = 0; i < services.size(); i++) {
            if (services.get(i).getName().equals(originalName)) {
                services.set(i, updatedService);
                break;
            }
        }
        saveAllServices(services);
        saveRecord("UPDATE", "Service updated: " + originalName + " to " + updatedService.getName());
        System.out.println("ServiceService: Updated service from " + originalName + " to " + updatedService.getName());
    }

    public void deleteService(String name) throws IOException {
        List<Service> services = getAllServices();
        services.removeIf(service -> service.getName().equals(name));
        saveAllServices(services);
        saveRecord("DELETE", "Service deleted: " + name);
        System.out.println("ServiceService: Deleted service: " + name);
    }

    private void saveAllServices(List<Service> services) throws IOException {
        File file = new File(getFilePath(SERVICES_FILE));
        try (PrintWriter writer = new PrintWriter(new FileWriter(file))) {
            for (Service service : services) {
                writer.println(service.getName() + "," + service.getPrice() + "," + 
                             service.getDescription() + "," + service.getCategory());
            }
        }
        System.out.println("ServiceService: Saved " + services.size() + " services to file");
    }
} 