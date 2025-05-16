<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.carservice.model.Employee" %>
<%@ page import="java.util.List" %>
<%@ page import="com.carservice.model.User" %>
<html>
<head>
    <title>Manage Employees</title>
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
        }

        .navbar {
            background: var(--card-bg);
            padding: 15px 50px;
            position: fixed;
            width: 100%;
            top: 0;
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
            padding: 8px 15px;
            border-radius: 25px;
            background: var(--card-bg);
            font-size: 15px;
        }
        
        .admin-info i {
            color: var(--primary);
        }

        .container {
            margin-top: 100px;
            padding: 40px 50px;
            max-width: 1400px;
            margin-left: auto;
            margin-right: auto;
        }

        .header {
            margin-bottom: 40px;
        }

        .header h1 {
            font-size: 2.5rem;
            margin-bottom: 10px;
        }

        .header p {
            color: var(--text-light);
            font-size: 1.1rem;
        }

        .styled-form {
            background: var(--card-bg);
            padding: 30px;
            border-radius: 8px;
            box-shadow: var(--shadow);
            margin-bottom: 40px;
        }

        .styled-form h2 {
            font-size: 1.8rem;
            color: var(--text);
            margin-bottom: 25px;
            border-bottom: 1px solid var(--background);
            padding-bottom: 15px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-weight: 500;
            margin-bottom: 8px;
            color: var(--text-light);
        }

        .form-group input[type="text"],
        .form-group input[type="number"],
        .form-group select {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 1rem;
            transition: var(--transition);
        }

        .form-group input[type="text"]:focus,
        .form-group input[type="number"]:focus,
        .form-group select:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 2px rgba(52, 152, 219, 0.2);
            outline: none;
        }

        .form-submit-button {
            background-color: var(--primary);
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 4px;
            font-size: 1rem;
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
            display: inline-block;
            text-decoration: none;
        }

        .form-submit-button:hover {
            background-color: var(--primary-dark);
        }
        
        .employees-table {
            width: 100%;
            border-collapse: collapse;
            background: var(--card-bg);
            border-radius: 8px;
            box-shadow: var(--shadow);
            overflow: hidden;
            margin-bottom: 30px;
        }

        .employees-table th, .employees-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid var(--background);
        }

        .employees-table th {
            background-color: var(--background);
            font-weight: 600;
        }

        .employees-table tr:last-child td {
            border-bottom: none;
        }

        .employees-table tr:hover {
            background-color: #f1f1f1;
        }
        
        .table-action-button {
            padding: 6px 10px;
            margin-right: 5px;
            border: 1px solid var(--primary);
            border-radius: 4px;
            font-size: 0.9rem;
            background-color: transparent;
            color: var(--primary);
            cursor: pointer;
            transition: var(--transition);
        }

        .table-action-button:hover {
            background-color: var(--primary);
            color: white;
        }
        
        .table-action-button.delete {
            border-color: var(--accent);
            color: var(--accent);
        }
        .table-action-button.delete:hover {
            background-color: var(--accent);
            color: white;
        }

        .back-link {
            display: inline-block;
            margin-top: 20px;
            color: var(--primary);
            text-decoration: none;
            font-weight: 500;
        }

        .back-link:hover {
            text-decoration: underline;
        }

        @media (max-width: 768px) {
            .navbar {
                padding: 15px 20px;
            }

            .container {
                padding: 20px;
                margin-top: 80px;
            }

            .header h1 {
                font-size: 2rem;
            }
            
            .styled-form {
                padding: 20px;
            }
            .styled-form h2 {
                font-size: 1.5rem;
            }
            .employees-table th, .employees-table td {
                padding: 10px;
                font-size: 0.9rem;
            }
        }
    </style>
</head>
<body>
    <div class="navbar">
        <div class="nav-links">
            <a href="index.jsp">Home</a>
            <a href="manage_records.jsp">Service Logs</a>
            <a href="manage_users.jsp">Manage Users</a>
            <a href="manage_services.jsp">Manage Services</a>
            <a href="manage_booking.jsp">Manage Bookings</a>
            <a href="manage_employees.jsp">Manage Employees</a>
        </div>
        <a href="login.jsp">Logout</a>
        <% User admin = (User) session.getAttribute("user"); %>
        <% if (admin != null && "admin".equals(admin.getUsername())) { %>
        <div class="admin-info">
            <i class="fas fa-user-shield"></i>
            Admin: <%= admin.getUsername() %>
        </div>
        <% } %>
    </div>

    <div class="container">
        <div class="header">
            <h1>Manage Employees</h1>
            <p>Add, view, and manage employee details.</p>
        </div>

        <form action="employee" method="post" class="styled-form">
            <h2>Add New Employee</h2>
            <input type="hidden" name="action" value="add">
            <div class="form-group">
                <label for="name">Name:</label>
                <input type="text" id="name" name="name" required>
            </div>
            <div class="form-group">
                <label for="specialization">Specialization:</label>
                <input type="text" id="specialization" name="specialization" required>
            </div>
            <input type="submit" value="Add Employee" class="form-submit-button">
        </form>

        <% List<Employee> employees = (List<Employee>) request.getAttribute("employees"); %>
        <% if (employees != null && !employees.isEmpty()) { %>
        <h2>Current Employees</h2>
        <table class="employees-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Specialization</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
            <% for (Employee employee : employees) { %>
            <tr>
                <td><%= employee.getEmployeeId() %></td>
                <td><%= employee.getName() %></td>
                <td><%= employee.getSpecialization() %></td>
                <td>
                    <button class="table-action-button">Edit</button>
                    <button class="table-action-button delete">Delete</button>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
        <% } else { %>
        <p>No employees found. Add one using the form above.</p>
        <% } %>
        
        <a href="admin_dashboard.jsp" class="back-link"><i class="fas fa-arrow-left"></i> Back to Admin Dashboard</a>
    </div>
</body>
</html>