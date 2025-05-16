<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.carservice.model.User" %>
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

        .admin-info {
            display: flex;
            align-items: center;
            gap: 8px;
            color: var(--text);
            font-size: 15px;
            font-weight: 500;
            padding: 8px 15px;
            border-radius: 25px;
            background: var(--card-bg);
            transition: var(--transition);
        }

        .admin-info:hover {
            background: var(--primary);
            color: white;
        }

        .admin-info i {
            color: var(--primary);
            transition: var(--transition);
        }

        .admin-info:hover i {
            color: white;
        }

        .dashboard-container {
            margin-top: 100px;
            padding: 40px 50px;
            max-width: 1200px;
            margin-left: auto;
            margin-right: auto;
        }

        .dashboard-header {
            margin-bottom: 40px;
        }

        .dashboard-header h1 {
            font-size: 2.5rem;
            color: var(--text);
            margin-bottom: 10px;
        }

        .dashboard-header p {
            color: var(--text-light);
            font-size: 1.1rem;
        }

        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            margin-bottom: 40px;
        }

        .dashboard-card {
            background: var(--card-bg);
            border-radius: 15px;
            padding: 30px;
            box-shadow: var(--shadow);
            transition: var(--transition);
            border: 2px solid transparent;
            text-decoration: none;
            color: var(--text);
        }

        .dashboard-card:hover {
            transform: translateY(-5px);
            border-color: var(--primary);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
        }

        .card-header {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid var(--card-bg);
        }

        .card-icon {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            background: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
        }

        .card-title {
            font-size: 1.2rem;
            color: var(--text);
            font-weight: 600;
        }

        .card-description {
            color: var(--text-light);
            font-size: 0.95rem;
            margin-bottom: 20px;
        }

        .card-stats {
            display: flex;
            align-items: center;
            gap: 10px;
            color: var(--primary);
            font-weight: 500;
        }

        .card-stats i {
            font-size: 1.2rem;
        }

        @media (max-width: 768px) {
            .navbar {
                padding: 15px 20px;
            }

            .nav-links {
                display: none;
            }

            .dashboard-container {
                padding: 20px;
                margin-top: 80px;
            }

            .dashboard-header h1 {
                font-size: 2rem;
            }
        }
    </style>
</head>
<body>
    <div class="navbar">
        <div class="nav-links">
            <a href="index.jsp">Home</a>
            <a href="manage_records.jsp">Service Records</a>
            <a href="manage_users.jsp">Manage Users</a>
            <a href="manage_services.jsp">Manage Services</a>
        </div>
        <a href="login.jsp">Logout</a>
        <% User admin = (User) session.getAttribute("user"); %>
        <% if (admin != null) { %>
        <div class="admin-info">
            <i class="fas fa-user-shield"></i>
            Admin: <%= admin.getUsername() %>
        </div>
        <% } %>
    </div>

    <div class="dashboard-container">
        <div class="dashboard-header">
            <h1>Manage Users</h1>
            <p>Add, edit, or remove user accounts</p>
        </div>

        <% List<User> users = (List<User>) request.getAttribute("users"); %>
        <% if (users != null) { %>
        <table border="1">
            <tr>
                <th>Username</th>
                <th>Role</th>
                <th>Actions</th>
            </tr>
            <% for (User user : users) { %>
            <tr>
                <td><%= user.getUsername() %></td>
                <td><%= user.getRole() %></td>
                <td>
                    <form action="user" method="post" style="display:inline;">
                        <input type="hidden" name="action" value="updateUser">
                        <input type="hidden" name="username" value="<%= user.getUsername() %>">
                        New Password: <input type="password" name="password"><br>
                        New Role: 
                        <select name="role">
                            <option value="customer" <%= "customer".equals(user.getRole()) ? "selected" : "" %>>Customer</option>
                            <option value="admin" <%= "admin".equals(user.getRole()) ? "selected" : "" %>>Admin</option>
                        </select><br>
                        <input type="submit" value="Update">
                    </form>
                    <form action="user" method="post" style="display:inline;">
                        <input type="hidden" name="action" value="deleteUser">
                        <input type="hidden" name="username" value="<%= user.getUsername() %>">
                        <input type="submit" value="Delete">
                    </form>
                </td>
            </tr>
            <% } %>
        </table>
        <% } %>
        <a href="admin_dashboard.jsp">Back</a>
    </div>
</body>
</html>