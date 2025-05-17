package com.carservice.service;

//import statements
import com.carservice.model.Employee;
import com.carservice.model.Records;
import jakarta.servlet.ServletContext; //For web application context
import java.io.*; //For file operations
import java.util.ArrayList; //for dynamic lists
import java.util.List; //for list interface

public class EmployeeService {
    private static final String EMPLOYEE_FILE = "employee.txt"; //Constant employee data file name
    private static final String DATA_DIR = "/WEB-INF/data/"; //Directory where data files are stored
    private final ServletContext servletContext;
    private final RecordService recordService;

    public EmployeeService(ServletContext servletContext) throws IOException {
        this.servletContext = servletContext;
        this.recordService = new RecordService(servletContext);
        createFileIfNotExist(EMPLOYEE_FILE);
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
            System.out.println("EmployeeService: Created/verified file at " + file.getAbsolutePath());
        } else {
            System.err.println("EmployeeService: Could not get real path for " + DATA_DIR);
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
        System.out.println("EmployeeService: Using file path: " + realPath);
        return realPath;
    }

    public void saveRecord(String action, String description) throws IOException {
        recordService.saveRecord(new Records(recordService.generateRecordId(), action, description, 
            java.time.LocalDateTime.now().toString()));
    }

    public void saveEmployee(Employee employee) throws IOException {
        File file = new File(getFilePath(EMPLOYEE_FILE));
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(file, true))) {
            writer.write(employee.toString());
            writer.newLine();
        }
        saveRecord("Employee Creation", "Employee " + employee.getName() + " added");
        System.out.println("EmployeeService: Added new employee: " + employee.getName());
    }

    public List<Employee> getAllEmployees() throws IOException {
        List<Employee> employees = new ArrayList<>();
        File file = new File(getFilePath(EMPLOYEE_FILE));
        System.out.println("EmployeeService: Reading employees from: " + file.getAbsolutePath());
        
        if (!file.exists() || file.length() == 0) {
            System.out.println("EmployeeService: File is empty or doesn't exist");
            return employees;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) continue;
                String[] parts = line.split(",");
                if (parts.length >= 3) {
                    employees.add(new Employee(
                        parts[0],
                        parts[1],
                        parts[2]
                    ));
                    System.out.println("EmployeeService: Loaded employee: " + parts[1]);
                }
            }
        }
        System.out.println("EmployeeService: Total employees loaded: " + employees.size());
        return employees;
    }

    public Employee getEmployeeById(String employeeId) throws IOException {
        File file = new File(getFilePath(EMPLOYEE_FILE));
        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) continue;
                String[] parts = line.split(",");
                if (parts.length >= 3 && parts[0].equals(employeeId)) {
                    System.out.println("EmployeeService: Found employee with ID: " + employeeId);
                    return new Employee(
                        parts[0],
                        parts[1],
                        parts[2]
                    );
                }
            }
        }
        System.out.println("EmployeeService: No employee found with ID: " + employeeId);
        return null;
    }

    public void updateEmployee(Employee employee) throws IOException {
        List<Employee> employees = getAllEmployees();
        File file = new File(getFilePath(EMPLOYEE_FILE));
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
            for (Employee e : employees) {
                if (e.getEmployeeId().equals(employee.getEmployeeId())) {
                    writer.write(employee.toString());
                } else {
                    writer.write(e.toString());
                }
                writer.newLine();
            }
        }
        saveRecord("Employee Update", "Employee ID " + employee.getEmployeeId() + " updated");
        System.out.println("EmployeeService: Updated employee: " + employee.getName());
    }

    public void deleteEmployee(String employeeId) throws IOException {
        List<Employee> employees = getAllEmployees();
        File file = new File(getFilePath(EMPLOYEE_FILE));
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
            for (Employee e : employees) {
                if (!e.getEmployeeId().equals(employeeId)) {
                    writer.write(e.toString());
                    writer.newLine();
                }
            }
        }
        saveRecord("Employee Deletion", "Employee ID " + employeeId + " deleted");
        System.out.println("EmployeeService: Deleted employee with ID: " + employeeId);
    }

    public String generateEmployeeId() throws IOException {
        List<Employee> employees = getAllEmployees();
        if (employees.isEmpty()) {
            System.out.println("EmployeeService: Generating first employee ID: EMP001");
            return "EMP001";
        }
        String lastId = employees.get(employees.size() - 1).getEmployeeId();
        int num = Integer.parseInt(lastId.substring(3)) + 1;
        String newId = String.format("EMP%03d", num);
        System.out.println("EmployeeService: Generated new employee ID: " + newId);
        return newId;
    }
} 