package com.carservice.service;

import com.carservice.model.Records;
import jakarta.servlet.ServletContext;
import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class RecordService {
    private static final String RECORDS_FILE = "records.txt";
    private static final String DATA_DIR = "/WEB-INF/data/";
    private final ServletContext servletContext;

    public RecordService(ServletContext servletContext) throws IOException {
        this.servletContext = servletContext;
        createFileIfNotExist(RECORDS_FILE);
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
        saveRecord(new Records(generateRecordId(), action, description, 
            java.time.LocalDateTime.now().toString()));
    }

    public void saveRecord(Records record) throws IOException {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(getFilePath(RECORDS_FILE), true))) {
            writer.write(record.toString());
            writer.newLine();
        }
    }

    public List<Records> getAllRecords() throws IOException {
        List<Records> records = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new FileReader(getFilePath(RECORDS_FILE)))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) continue;
                String[] parts = line.split(",");
                if (parts.length >= 4) {
                    records.add(new Records(
                        Integer.parseInt(parts[0].trim()),
                        parts[1].trim(),
                        parts[2].trim(),
                        parts[3].trim()
                    ));
                }
            }
        }
        return records;
    }

    public List<Records> getRecordsByUsername(String username) throws IOException {
        List<Records> records = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new FileReader(getFilePath(RECORDS_FILE)))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) continue;
                String[] parts = line.split(",");
                if (parts.length >= 4 && parts[2].contains(username)) {
                    records.add(new Records(
                        Integer.parseInt(parts[0].trim()),
                        parts[1].trim(),
                        parts[2].trim(),
                        parts[3].trim()
                    ));
                }
            }
        }
        return records;
    }

    public int generateRecordId() throws IOException {
        List<Records> records = getAllRecords();
        return records.isEmpty() ? 1 : records.get(records.size() - 1).getRecordId() + 1;
    }
} 