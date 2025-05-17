<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.carservice.model.User" %>
<%@ page import="com.carservice.model.ServiceRecord" %>
<%@ page import="com.carservice.service.UserService" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.carservice.DSA.SelectionSort" %>
<html>
<head>
    <title>Manage Service Records</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary: #3498db;
            --primary-dark: #2980b9;
            --secondary: #2c3e50;
            --accent: #e74c3c;
            --background: #f9f9f9;
            --card-bg: #ffffff;
            --text: #333333;
            --text-light: #666666;
            --shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            --transition: all 0.3s ease;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Inter', sans-serif;
        }

        body {
            background-color: var(--background);
            color: var(--text);
            line-height: 1.6;
            min-height: 100vh;
            padding-top: 80px; /* Account for fixed navbar */
        }

        .navbar {
            background: var(--card-bg);
            padding: 15px 50px;
            position: fixed;
            width: 100%;
            top: 0;
            left: 0;
            z-index: 1000;
            box-shadow: var(--shadow);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .nav-links {
            display: flex;
            gap: 20px;
        }

        .navbar a {
            color: var(--text);
            text-decoration: none;
            font-size: 15px;
            font-weight: 500;
            padding: 8px 15px;
            border-radius: 4px;
            transition: var(--transition);
        }

        .navbar a:hover {
            color: var(--primary);
        }

        .admin-info {
            display: flex;
            align-items: center;
            gap: 8px;
            color: var(--text);
            font-size: 15px;
            font-weight: 500;
        }

         .admin-info i {
            color: var(--primary);
        }


        .container {
            padding: 40px 50px;
            max-width: 1200px;
            margin-left: auto;
            margin-right: auto;
        }

        .page-header {
            margin-bottom: 30px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }

        .page-header h1 {
            font-size: 2rem;
            color: var(--text);
        }

        .form-section, .table-section {
            background: var(--card-bg);
            border-radius: 10px;
            padding: 30px;
            box-shadow: var(--shadow);
            margin-bottom: 30px;
        }

        .form-section h2, .table-section h2 {
            font-size: 1.5rem;
            margin-bottom: 20px;
            color: var(--secondary);
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: var(--text-light);
        }

        .form-group input[type="text"],
        .form-group input[type="date"],
        .form-group input[type="number"],
        .form-group select {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 1rem;
            transition: var(--transition);
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 2px rgba(52, 152, 219, 0.2);
        }

        .form-group input[readonly] {
            background-color: #eee;
            cursor: not-allowed;
        }

        .submit-btn {
            background-color: var(--primary);
            color: white;
            padding: 12px 25px;
            border: none;
            border-radius: 6px;
            font-size: 1rem;
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
        }

        .submit-btn:hover {
            background-color: var(--primary-dark);
        }

        .records-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        .records-table th, .records-table td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
            font-size: 0.95rem;
        }

        .records-table th {
            background-color: #f2f2f2;
            font-weight: 600;
            color: var(--secondary);
        }

        .records-table tbody tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        .records-table tbody tr:hover {
            background-color: #e8f4fd;
        }

        .no-records {
            text-align: center;
            color: var(--text-light);
            padding: 20px;
        }

        @media (max-width: 768px) {
            .navbar { padding: 15px 20px; }
            .container { padding: 20px; }
            .form-grid { grid-template-columns: 1fr; }
        }

    </style>
</head>
<body>
    <%
        // Check if user is logged in and is an admin
        User admin = (User) session.getAttribute("user");
        if (admin == null) {
            response.sendRedirect("login.jsp?error=Please login as admin");
            return;
        }

        // Get list of users for dropdown using UserService
        List<User> users = new ArrayList<>();
        try {
            UserService userService = new UserService(application);
            users = userService.getAllUsers();
            // Filter out admin users
            users.removeIf(user -> "admin".equals(user.getUsername()));
            System.out.println("Total users loaded for dropdown: " + users.size());
        } catch (Exception e) {
            System.err.println("Error loading users: " + e.getMessage());
            e.printStackTrace();
        }

        // Get current date
        String currentDate = new SimpleDateFormat("yyyy-MM-dd").format(new Date());

        // Get next record number
        int nextRecordNo = 1;
        String recordsFilePath = application.getRealPath("/WEB-INF/records.txt");
        try {
            File recordsFile = new File(recordsFilePath);
            if (recordsFile.exists() && recordsFile.length() > 0) {
                try (BufferedReader reader = new BufferedReader(new FileReader(recordsFile))) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        if (line.trim().isEmpty()) continue;
                        String[] parts = line.split(",");
                        if (parts.length >= 6) {
                            try {
                                int currentId = Integer.parseInt(parts[0].trim());
                                if (currentId >= nextRecordNo) {
                                    nextRecordNo = currentId + 1;
                                }
                            } catch (NumberFormatException e) {
                                System.err.println("Error parsing record number: " + e.getMessage());
                            }
                        }
                    }
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading records file: " + e.getMessage());
        }

        // Get all service records
        List<ServiceRecord> serviceRecords = new ArrayList<>();
        try {
            File recordsFile = new File(recordsFilePath);
            if (recordsFile.exists() && recordsFile.length() > 0) {
                try (BufferedReader reader = new BufferedReader(new FileReader(recordsFile))) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        if (line.trim().isEmpty()) continue;
                        String[] parts = line.split(",");
                        if (parts.length >= 6) {
                            ServiceRecord record = new ServiceRecord();
                            record.setRecordNo(Integer.parseInt(parts[0].trim()));
                            record.setCarNo(parts[1].trim());
                            record.setDate(parts[2].trim());
                            record.setCurrentMileage(Integer.parseInt(parts[3].trim()));
                            record.setCustomerUsername(parts[4].trim());
                            record.setNextServiceMileage(Integer.parseInt(parts[5].trim()));
                            serviceRecords.add(record);
                        }
                    }
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading service records: " + e.getMessage());
        }

        // Sort records by date if requested
        String sortBy = request.getParameter("sortBy");
        if ("date".equals(sortBy) && !serviceRecords.isEmpty()) {
            ServiceRecord[] recordsArray = serviceRecords.toArray(new ServiceRecord[0]);
            SelectionSort.sortByDate(recordsArray);
            serviceRecords.clear();
            for (ServiceRecord record : recordsArray) {
                serviceRecords.add(record);
            }
        }
    %>

    <div class="navbar">
        <div class="nav-links">
            <a href="admin_dashboard.jsp">Dashboard</a>
            <a href="manage_records.jsp">Service Records</a>
            <a href="manage_users.jsp">Manage Users</a>
            <a href="manage_services.jsp">Manage Services</a>
            <a href="manage-booking">Manage Bookings</a>
            <a href="employee">Manage Employees</a>
        </div>
        <div>
            <% if (admin != null) { %>
                <span class="admin-info">
                    <i class="fas fa-user-shield"></i>
                    Admin: <%= admin.getUsername() %>
                </span>
                <a href="LogoutServlet" style="margin-left: 15px;">Logout</a>
            <% } %>
        </div>
    </div>

    <div class="container">
        <div class="page-header">
            <h1>Manage Service Records</h1>
        </div>

        <!-- Add Service Record Form -->
        <div class="form-section">
            <h2>Add New Service Record</h2>
            <form action="AddRecordServlet" method="post">
                <div class="form-grid">
                    <div class="form-group">
                        <label for="recordNo">Record No</label>
                        <input type="text" id="recordNo" name="recordNo" value="<%= nextRecordNo %>" readonly>
                    </div>
                    <div class="form-group">
                        <label for="carNo">Car No</label>
                        <input type="text" id="carNo" name="carNo" required>
                    </div>
                    <div class="form-group">
                        <label for="date">Date</label>
                        <input type="date" id="date" name="date" value="<%= currentDate %>" required>
                    </div>
                    <div class="form-group">
                        <label for="currentMileage">Current Mileage (km)</label>
                        <input type="number" id="currentMileage" name="currentMileage" required min="0">
                    </div>
                    <div class="form-group">
                        <label for="customerUsername">Customer</label>
                        <select id="customerUsername" name="customerUsername" required>
                            <option value="">-- Select Customer --</option>
                            <% 
                            if (users.isEmpty()) { %>
                                <option value="" disabled>No customers available</option>
                            <% } else {
                                for (User user : users) { %>
                                    <option value="<%= user.getUsername() %>"><%= user.getUsername() %></option>
                                <% }
                            } %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="nextServiceMileage">Next Service Mileage (km)</label>
                        <input type="number" id="nextServiceMileage" name="nextServiceMileage" required min="0">
                    </div>
                </div>
                <button type="submit" class="submit-btn">Add Record</button>
            </form>
        </div>

        <!-- Display Service Records -->
        <div class="table-section">
            <h2>Service Records</h2>
            <div class="sort-links">
                <a href="manage_records.jsp?sortBy=date">Sort by Date</a>
            </div>
            <table class="records-table">
                <thead>
                    <tr>
                        <th>Record No</th>
                        <th>Car No</th>
                        <th>Date</th>
                        <th>Current Mileage</th>
                        <th>Customer</th>
                        <th>Next Service Mileage</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (serviceRecords.isEmpty()) { %>
                        <tr>
                            <td colspan="6" class="no-records">No service records found</td>
                        </tr>
                    <% } else { 
                        for (ServiceRecord record : serviceRecords) { %>
                            <tr>
                                <td><%= record.getRecordNo() %></td>
                                <td><%= record.getCarNo() %></td>
                                <td><%= record.getDate() %></td>
                                <td><%= record.getCurrentMileage() %></td>
                                <td><%= record.getCustomerUsername() %></td>
                                <td><%= record.getNextServiceMileage() %></td>
                            </tr>
                        <% }
                    } %>
                </tbody>
            </table>
        </div>
    </div>

</body>
</html>