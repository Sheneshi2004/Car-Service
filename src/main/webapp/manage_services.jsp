<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.carservice.model.Service" %>
<%@ page import="com.carservice.model.User" %>
<%@ page import="java.util.List" %>
<html>
<head>
    <title>Manage Services</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary: #3498db;
            --primary-dark: #2980b9;
            --secondary: #2c3e50;
            --accent: #e74c3c; /* Adjusted for delete buttons */
            --success: #2ecc71; /* For success messages/status */
            --background: #f9f9f9;
            --card-bg: #ffffff;
            --text: #333333;
            --text-light: #666666;
            --border-color: #ecf0f1;
            --shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            --transition: all 0.3s ease;
            --border-radius-sm: 0.25rem; /* 4px */
            --border-radius-md: 0.5rem;  /* 8px */
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
            border-radius: var(--border-radius-sm);
            transition: var(--transition);
        }

        .navbar a:hover, .navbar a.active {
            color: var(--primary);
        }
        
        .navbar .logout-link {
            background-color: var(--accent);
            color: white;
            padding: 8px 15px;
            border-radius: var(--border-radius-sm);
            text-decoration: none;
            font-weight: 500;
            transition: background-color 0.3s ease;
        }

        .navbar .logout-link:hover {
            background-color: #c0392b; 
            color: white;
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

        .page-container {
            padding: 20px 50px;
            max-width: 1200px;
            margin-left: auto;
            margin-right: auto;
        }

        .page-header {
            margin-bottom: 30px;
        }

        .page-header h1 {
            font-size: 2.2rem;
            color: var(--text);
            margin-bottom: 8px;
        }

        .page-header p {
            color: var(--text-light);
            font-size: 1rem;
        }
        
        .message {
            padding: 10px 15px;
            margin-bottom: 20px;
            border-radius: var(--border-radius-sm);
            font-size: 0.9rem;
        }
        .message.error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .message.success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        /* Form Styling */
        .form-container {
            background: var(--card-bg);
            padding: 25px;
            border-radius: var(--border-radius-md);
            box-shadow: var(--shadow);
            margin-bottom: 30px;
        }

        .form-container h3 {
            font-size: 1.4rem;
            margin-bottom: 20px;
            color: var(--secondary);
            padding-bottom: 10px;
            border-bottom: 1px solid var(--border-color);
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
        }
        
        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group label {
            margin-bottom: 6px;
            font-weight: 500;
            font-size: 0.9rem;
            color: var(--text-light);
        }

        .form-group input[type="text"],
        .form-group input[type="number"],
        .form-group textarea {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid var(--border-color);
            border-radius: var(--border-radius-sm);
            font-size: 0.95rem;
            transition: var(--transition);
        }
        
        .form-group textarea {
            min-height: 80px;
            resize: vertical;
        }

        .form-group input:focus, .form-group textarea:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 2px rgba(52, 152, 219, 0.2);
        }
        
        .form-actions {
            margin-top: 20px;
            text-align: right;
        }

        /* Table Styling (similar to manage_users.jsp) */
        .content-table { /* Renamed from user-table for generic use */
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background-color: var(--card-bg);
            box-shadow: var(--shadow);
            border-radius: var(--border-radius-md);
            overflow: hidden;
        }

        .content-table th, .content-table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid var(--border-color);
        }

        .content-table th {
            background-color: #f7f9fa;
            color: var(--secondary);
            font-weight: 600;
            font-size: 0.9rem;
            text-transform: uppercase;
        }
        
        .content-table tr:last-child td {
            border-bottom: none;
        }

        .content-table tr:hover td {
            background-color: #fdfdfe;
        }

        .actions-cell {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        
        .actions-cell form {
            margin: 0;
            display: flex; /* For inline update form */
            gap: 8px;
            align-items: center;
        }
        
        .actions-cell .btn, .form-actions .btn {
            padding: 8px 12px;
            border: none;
            border-radius: var(--border-radius-sm);
            cursor: pointer;
            transition: var(--transition);
            text-decoration: none;
            font-size: 0.85rem;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            font-weight: 500;
            color: white; /* Default button text color */
        }

        .btn-primary {
            background-color: var(--primary);
        }
        .btn-primary:hover {
            background-color: var(--primary-dark);
        }
        
        .btn-danger {
            background-color: var(--accent);
        }
        .btn-danger:hover {
            background-color: #c0392b; /* Darker accent */
        }
        
        .btn i {
            font-size: 0.9em;
        }
        
        /* Specific for inline update form in table */
        .update-form-inline input[type="text"],
        .update-form-inline input[type="number"] {
            padding: 6px 8px;
            border: 1px solid #ccc;
            border-radius: var(--border-radius-sm);
            font-size: 0.85rem;
            margin-right: 5px; /* Space before update button */
        }
        .update-form-inline {
            display: contents; /* Allows form to behave as part of the flex layout of actions-cell */
        }


        .back-link {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 15px;
            background-color: var(--secondary);
            color: white;
            text-decoration: none;
            border-radius: var(--border-radius-sm);
            transition: background-color 0.3s ease;
        }
        .back-link:hover {
            background-color: #1f2b38;
        }
        
        .sort-links a {
            margin-right: 15px;
            color: var(--primary);
            text-decoration: none;
            font-weight: 500;
        }
        .sort-links a:hover {
            text-decoration: underline;
        }


        @media (max-width: 768px) {
            .navbar { padding: 15px 20px; }
            .nav-links { display: none; } 
            .page-container { padding: 15px; }
            .page-header h1 { font-size: 1.8rem; }
            .form-grid { grid-template-columns: 1fr; } /* Single column for forms */
            .actions-cell { flex-direction: column; align-items: flex-start; gap: 10px; }
            .actions-cell form { flex-direction: column; align-items: stretch; width: 100%;}
            .actions-cell .update-form-inline { display: flex; flex-direction: column; align-items: stretch; width: 100%;}
            .update-form-inline input[type="text"],
            .update-form-inline input[type="number"] {
                width: 100%; margin-bottom: 5px;
            }
            .actions-cell .btn { width: 100%; justify-content: center; }
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
            <a href="manage_services.jsp" class="active">Manage Services</a>
            <a href="manage_booking.jsp">Manage Bookings</a>
        </div>
        <div>
        <% User admin = (User) session.getAttribute("user"); %>
        <% if (admin != null) { %>
            <span class="admin-info">
                <i class="fas fa-user-shield"></i>
                Admin: <%= admin.getUsername() %>
            </span>
        <% } %>
        <a href="login.jsp" class="logout-link">Logout</a>
        </div>
    </div>

    <div class="page-container">
        <div class="page-header">
            <h1>Manage Services</h1>
            <p>Add, view, update, or remove available services.</p>
        </div>

        <% String error = (String) request.getAttribute("error"); %>
        <% String success = (String) request.getAttribute("success"); %>

        <% if (error != null && !error.isEmpty()) { %>
            <div class="message error"><%= error %></div>
        <% } %>
        <% if (success != null && !success.isEmpty()) { %>
            <div class="message success"><%= success %></div>
        <% } %>

        <div class="form-container">
            <h3>Add New Service</h3>
            <form action="service" method="post">
                <input type="hidden" name="action" value="addService">
                <div class="form-grid">
                    <div class="form-group">
                        <label for="name">Service Name:</label>
                        <input type="text" id="name" name="name" required>
                    </div>
                    <div class="form-group">
                        <label for="price">Price:</label>
                        <input type="number" id="price" name="price" step="0.01" required>
                    </div>
                    <div class="form-group">
                        <label for="description">Description:</label>
                        <textarea id="description" name="description" required></textarea>
                    </div>
                    <div class="form-group">
                        <label for="category">Category:</label> 
                        <input type="text" id="category" name="category" required>
                    </div>
                </div>
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary"><i class="fas fa-plus-circle"></i> Add Service</button>
                </div>
            </form>
        </div>

        <h3>Available Services</h3>
        <div class="sort-links">
            <a href="service?sortBy=name">Sort by Name</a> |
            <a href="service?sortBy=price">Sort by Price</a> |
            <a href="service?sortBy=category">Sort by Category</a> 
        </div>

        <% List<Service> services = (List<Service>) request.getAttribute("services"); %>
        <% if (services != null && !services.isEmpty()) { %>
        <table class="content-table">
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Price</th>
                    <th>Description</th>
                    <th>Category</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
            <% for (Service service : services) { %>
            <tr>
                <form action="service" method="post" class="update-form-inline">
                    <input type="hidden" name="action" value="updateService">
                    <input type="hidden" name="originalName" value="<%= service.getName() %>"> 
                    <td><input type="text" name="name" value="<%= service.getName() %>" required></td>
                    <td><input type="number" name="price" value="<%= service.getPrice() %>" step="0.01" required></td>
                    <td><input type="text" name="description" value="<%= service.getDescription() %>" required></td>
                    <td><input type="text" name="category" value="<%= service.getCategory() %>" required></td>
                    <td class="actions-cell">
                        <button type="submit" class="btn btn-primary"><i class="fas fa-edit"></i> Update</button>
                </form>
                <form action="service" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete the service: <%= service.getName() %>?');">
                    <input type="hidden" name="action" value="deleteService">
                    <input type="hidden" name="name" value="<%= service.getName() %>">
                    <button type="submit" class="btn btn-danger"><i class="fas fa-trash"></i> Delete</button>
                </form>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
        <% } else { %>
        <p>No services found. Add services using the form above.</p>
        <% } %>
        
        <a href="admin_dashboard.jsp" class="back-link"><i class="fas fa-arrow-left"></i> Back to Dashboard</a>
    </div>
</body>
</html>