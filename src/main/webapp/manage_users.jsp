<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.carservice.model.User" %>
<%@ page import="com.carservice.service.UserService" %>
<%@ page import="java.util.List" %>
<html>
<head>
    <title>Manage Users</title>
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

        .message {
            padding: 10px 15px;
            margin-bottom: 20px;
            border-radius: 4px;
            font-size: 0.95rem;
        }

        .message.error {
            background: #f8d7da;
            color: #721c24;
        }

        .message.success {
            background: #d4edda;
            color: #155724;
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

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 1rem;
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
        }

        .form-submit-button:hover {
            background-color: var(--primary-dark);
        }

        .users-table {
            width: 100%;
            border-collapse: collapse;
            background: var(--card-bg);
            border-radius: 8px;
            box-shadow: var(--shadow);
            overflow: hidden;
            margin-bottom: 30px;
        }

        .users-table th,
        .users-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid var(--background);
        }

        .users-table th {
            background-color: var(--background);
            font-weight: 600;
        }

        .users-table tr:last-child td {
            border-bottom: none;
        }

        .users-table tr:hover {
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
        }

        .table-action-button.delete {
            border-color: var(--accent);
            color: var(--accent);
        }

        .table-action-button:hover,
        .table-action-button.delete:hover {
            background-color: var(--primary);
            color: white;
        }

        .table-action-button.delete:hover {
            background-color: var(--accent);
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

            .nav-links {
                display: none;
            }

            .container {
                padding: 20px;
                margin-top: 80px;
            }
        }
    </style>
</head>
<body>
    <div class="navbar">
        <div class="nav-links">
            <a href="index.jsp">Home</a>
            <a href="admin_dashboard.jsp">Admin Dashboard</a>
            <a href="manage_records.jsp">Service Records</a>
            <a href="manage_users.jsp">Manage Users</a>
            <a href="manage_services.jsp">Manage Services</a>
            <a href="manage_booking.jsp">Manage Bookings</a>
            <a href="manage_employees.jsp">Manage Employees</a>
        </div>
        <a href="login.jsp">Logout</a>
    </div>

    <div class="container">
        <div class="header">
            <h1>Manage Users</h1>
            <p>View, update, and remove user accounts.</p>
        </div>

        <%
            String error = request.getParameter("error");
            String success = request.getParameter("success");
            if (error != null && !error.isEmpty()) {
        %>
            <div class="message error"><%= error %></div>
        <%
            }
            if (success != null && !success.isEmpty()) {
        %>
            <div class="message success"><%= success %></div>
        <%
            }
        %>

        <div class="styled-form">
            <h2>User List</h2>
            <%
                List<User> users = (List<User>) request.getAttribute("users");
                if (users == null) {
                    try {
                        users = new UserService(application).getAllUsers();
                    } catch (Exception e) {
                        users = java.util.Collections.emptyList();
                    }
                }
            %>

            <% if (users != null && !users.isEmpty()) { %>
            <table class="users-table">
                <thead>
                    <tr>
                        <th>Username</th>
                        <th>Password</th>
                        <th>Role</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                <% for (User user : users) { %>
                    <tr>
                        <form action="user" method="post">
                            <td><input type="text" name="username" value="<%= user.getUsername() %>" readonly></td>
                            <td><input type="text" name="password" value="<%= user.getPassword() %>"></td>
                            <td>
                                <select name="role">
                                    <option value="customer" <%= "customer".equals(user.getRole()) ? "selected" : "" %>>customer</option>
                                    <option value="admin" <%= "admin".equals(user.getRole()) ? "selected" : "" %>>admin</option>
                                </select>
                            </td>
                            <td>
                                <input type="hidden" name="action" value="updateUser">
                                <button type="submit" class="table-action-button">Update</button>
                        </form>
                        <form action="user" method="post" style="display:inline;" onsubmit="return confirm('Delete user <%= user.getUsername() %>?');">
                            <input type="hidden" name="action" value="deleteUser">
                            <input type="hidden" name="username" value="<%= user.getUsername() %>">
                            <button type="submit" class="table-action-button delete">Delete</button>
                        </form>
                            </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
            <% } else { %>
                <p>No users found.</p>
            <% } %>
        </div>

        <a href="admin_dashboard.jsp" class="back-link"><i class="fas fa-arrow-left"></i> Back to Admin Dashboard</a>
    </div>
</body>
</html>