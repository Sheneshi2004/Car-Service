<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.carservice.model.Booking" %>
<%@ page import="com.carservice.model.User" %>
<%@ page import="java.util.List" %>
<html>
<head>
    <title>Manage Bookings</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary: #3498db; /* Example primary color */
            --primary-dark: #2980b9;
            --secondary: #2c3e50;
            --accent: #e74c3c;
            --background: #f9f9f9;
            --card-bg: #ffffff;
            --text: #333333;
            --text-light: #666666;
            --shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            --transition: all 0.3s ease;
            --status-pending: #f1c40f;
            --status-confirmed: #2ecc71;
            --status-completed: #3498db;
            --status-cancelled: #e74c3c;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', sans-serif; }
        body { background-color: var(--background); color: var(--text); line-height: 1.6; min-height: 100vh; }
        .navbar { background: var(--card-bg); padding: 15px 50px; position: fixed; width: 100%; top: 0; z-index: 1000; box-shadow: var(--shadow); display: flex; justify-content: space-between; align-items: center; }
        .nav-links { display: flex; gap: 20px; }
        .navbar a { color: var(--text); text-decoration: none; font-size: 15px; font-weight: 500; padding: 8px 15px; border-radius: 4px; transition: var(--transition); }
        .navbar a:hover { color: var(--primary); }
        .admin-info { display: flex; align-items: center; gap: 8px; padding: 8px 15px; border-radius: 25px; background: var(--card-bg); font-size: 15px; }
        .admin-info i { color: var(--primary); }
        .container { margin-top: 100px; padding: 40px 50px; max-width: 1400px; margin-left: auto; margin-right: auto; }
        .header { margin-bottom: 40px; }
        .header h1 { font-size: 2.5rem; margin-bottom: 10px; }
        .header p { color: var(--text-light); font-size: 1.1rem; }
        .bookings-table { width: 100%; border-collapse: collapse; background: var(--card-bg); border-radius: 8px; box-shadow: var(--shadow); overflow: hidden; }
        .bookings-table th, .bookings-table td { padding: 15px; text-align: left; border-bottom: 1px solid var(--background); }
        .bookings-table th { background-color: var(--background); font-weight: 600; }
        .bookings-table tr:last-child td { border-bottom: none; }
        .bookings-table tr:hover { background-color: #f1f1f1; }
        .status-badge { padding: 5px 10px; border-radius: 15px; font-size: 0.85rem; font-weight: 500; color: #fff; text-transform: capitalize; }
        .status-pending { background-color: var(--status-pending); }
        .status-confirmed { background-color: var(--status-confirmed); }
        .status-completed { background-color: var(--status-completed); }
        .status-cancelled { background-color: var(--status-cancelled); }
        .action-form select, .action-form input[type=submit] { padding: 8px 12px; margin-left: 5px; border: 1px solid #ccc; border-radius: 4px; font-size: 14px; }
        .action-form input[type=submit] { background-color: var(--primary); color: white; cursor: pointer; transition: var(--transition); }
        .action-form input[type=submit]:hover { background-color: var(--primary-dark); }
        .back-link { display: inline-block; margin-top: 30px; color: var(--primary); text-decoration: none; font-weight: 500; }
        .back-link:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="navbar">
        <div class="nav-links">
            <a href="index.jsp">Home</a>
            <a href="manage_records.jsp">Service Logs</a>
            <a href="manage_users.jsp">Manage Users</a>
            <a href="manage_services.jsp">Manage Services</a>
            <a href="manage_booking.jsp">Manage Bookings</a> <%-- Added link --%>
            <a href="manage_employees.jsp">Manage Employees</a> <%-- Added link --%>
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
            <h1>Manage All Bookings</h1>
            <p>View and update the status of all customer bookings.</p>
        </div>

        <% List<Booking> bookings = (List<Booking>) request.getAttribute("bookings"); %>
        <% if (bookings != null && !bookings.isEmpty()) { %>
        <table class="bookings-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Username</th>
                    <th>Service</th>
                    <th>Vehicle</th>
                    <th>Date</th>
                    <th>Time</th>
                    <th>Status</th>
                    <th>Update Status</th>
                </tr>
            </thead>
            <tbody>
                <% for (Booking booking : bookings) { %>
                <tr>
                    <td><%= booking.getBookingId() %></td>
                    <td><%= booking.getUsername() %></td>
                    <td><%= booking.getServiceName() %></td>
                    <td><%= booking.getVehicleNumber() %></td>
                    <td><%= booking.getDate() %></td>
                    <td><%= booking.getTime() %></td>
                    <td>
                        <span class="status-badge status-<%= booking.getStatus().toLowerCase() %>">
                            <%= booking.getStatus() %>
                        </span>
                    </td>
                    <td>
                        <form class="action-form" action="booking" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>">
                            <select name="status">
                                <option value="Pending" <%= "Pending".equals(booking.getStatus()) ? "selected" : "" %>>Pending</option>
                                <option value="Confirmed" <%= "Confirmed".equals(booking.getStatus()) ? "selected" : "" %>>Confirmed</option>
                                <option value="Completed" <%= "Completed".equals(booking.getStatus()) ? "selected" : "" %>>Completed</option>
                                <option value="Cancelled" <%= "Cancelled".equals(booking.getStatus()) ? "selected" : "" %>>Cancelled</option>
                            </select>
                            <input type="submit" value="Update">
                        </form>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <% } else { %>
        <p>No bookings found.</p>
        <% } %>

        <a href="admin_dashboard.jsp" class="back-link"><i class="fas fa-arrow-left"></i> Back to Admin Dashboard</a>
    </div>
</body>
</html> 