package com.carservice.service;

import com.carservice.model.User;
import com.carservice.model.Records;
import jakarta.servlet.ServletContext;
import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class UserService {
    private static final String USER_FILE = "User.txt";
    private static final String DATA_DIR = "/WEB-INF/data/";
    private final ServletContext servletContext;
    private final RecordService recordService;

    public UserService(ServletContext servletContext) throws IOException {
        this.servletContext = servletContext;
        this.recordService = new RecordService(servletContext);
        createFileIfNotExist(USER_FILE);
    }

    public void createFileIfNotExist(String fileName) throws IOException {
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
        }
    }

    public String getFilePath(String fileName) {
        String relativePath = DATA_DIR + fileName;
        String realPath = servletContext.getRealPath(relativePath);
        if (realPath == null) {
            File fallbackDir = new File("src/main/resources");
            if (!fallbackDir.exists()) fallbackDir.mkdirs();
            realPath = new File(fallbackDir, fileName).getPath();
        }
        return realPath;
    }

    public void saveRecord(String action, String description) throws IOException {
        recordService.saveRecord(new Records(recordService.generateRecordId(), action, description, 
            java.time.LocalDateTime.now().toString()));
    }

    public void saveUser(User user) throws IOException {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(getFilePath(USER_FILE), true))) {
            writer.write(user.toString());
            writer.newLine();
        }
        saveRecord("User Registration", "User " + user.getUsername() + " registered");
    }

    public User getUser(String username) throws IOException {
        try (BufferedReader reader = new BufferedReader(new FileReader(getFilePath(USER_FILE)))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts[0].equals(username)) {
                    return new User(parts[0], parts[1], parts[2]);
                }
            }
        }
        return null;
    }

    public List<User> getAllUsers() throws IOException {
        List<User> users = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new FileReader(getFilePath(USER_FILE)))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) continue;
                String[] parts = line.split(",");
                if (parts.length == 3) {
                    users.add(new User(parts[0].trim(), parts[1].trim(), parts[2].trim()));
                }
            }
        }
        return users;
    }

    public void updateUser(User user) throws IOException {
        List<User> users = getAllUsers();
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(getFilePath(USER_FILE)))) {
            for (User u : users) {
                if (u.getUsername().equals(user.getUsername())) {
                    writer.write(user.toString());
                } else {
                    writer.write(u.toString());
                }
                writer.newLine();
            }
        }
        saveRecord("User Update", "User " + user.getUsername() + " updated");
    }

    public void deleteUser(String username) throws IOException {
        List<User> users = getAllUsers();
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(getFilePath(USER_FILE)))) {
            for (User u : users) {
                if (!u.getUsername().equals(username)) {
                    writer.write(u.toString());
                    writer.newLine();
                }
            }
        }
        saveRecord("User Deletion", "User " + username + " deleted");
    }
} 