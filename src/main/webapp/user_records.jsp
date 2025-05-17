<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.carservice.model.User" %>
<%@ page import="com.carservice.model.Booking" %>
<%@ page import="com.carservice.model.Review" %>
<%@ page import="java.util.List" %>
<html>
<head>
    <title>My Service Records</title>
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

        .user-info {
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

        .user-info:hover {
            background: var(--primary);
            color: white;
        }

        .user-info i {
            color: var(--primary);
            transition: var(--transition);
        }

        .user-info:hover i {
            color: white;
        }

        .records-container {
            margin-top: 100px;
            padding: 40px 50px;
            max-width: 1200px;
            margin-left: auto;
            margin-right: auto;
        }

        .records-header {
            margin-bottom: 40px;
        }

        .records-header h1 {
            font-size: 2.5rem;
            color: var(--text);
            margin-bottom: 10px;
        }

        .records-header p {
            color: var(--text-light);
            font-size: 1.1rem;
        }

        .records-section {
            background: var(--card-bg);
            border-radius: 15px;
            padding: 30px;
            box-shadow: var(--shadow);
            margin-bottom: 30px;
        }

        .section-title {
            font-size: 1.5rem;
            color: var(--text);
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-title i {
            color: var(--primary);
        }

        .records-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        .records-table th,
        .records-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid var(--background);
        }

        .records-table th {
            background-color: var(--background);
            font-weight: 600;
            color: var(--text);
        }

        .records-table tr:hover {
            background-color: var(--background);
        }

        .status-badge {
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 0.85rem;
            font-weight: 500;
            display: inline-block;
        }

        .status-pending {
            background-color: #f1c40f;
            color: #fff;
        }

        .status-completed {
            background-color: #2ecc71;
            color: #fff;
        }

        .status-cancelled {
            background-color: #e74c3c;
            color: #fff;
        }

        .review-btn {
            display: inline-block;
            padding: 8px 15px;
            background: var(--primary);
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-size: 0.9rem;
            transition: var(--transition);
        }

        .review-btn:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
        }

        .no-records {
            text-align: center;
            padding: 30px;
            color: var(--text-light);
            font-size: 1.1rem;
        }

        @media (max-width: 768px) {
            .navbar {
                padding: 15px 20px;
            }

            .nav-links {
                display: none;
            }

            .records-container {
                padding: 20px;
                margin-top: 80px;
            }

            .records-header h1 {
                font-size: 2rem;
            }

            .records-table {
                display: block;
                overflow-x: auto;
            }
        }
    </style>
</head>
<body>
    <div class="navbar">
        <div class="nav-links">
            <a href="index.jsp">Home</a>
            <a href="booking_form.jsp">Book Service</a>
            <a href="user_records.jsp">Service History</a>
            <a href="profile.jsp">My Profile</a>
        </div>
        <a href="login.jsp">Logout</a>
        <% User user = (User) session.getAttribute("user"); %>
        <% if (user != null) { %>
        <div class="user-info">
            <i class="fas fa-user"></i>
            <%= user.getUsername() %>
        </div>
        <% } %>
    </div>

    <div class="records-container">
        <div class="records-header">
            <h1>My Service Records</h1>
            <p>View your service history and reviews</p>
        </div>

        <div class="records-section">
            <h2 class="section-title">
                <i class="fas fa-history"></i>
                Service Bookings
            </h2>
            <% List<Booking> bookings = (List<Booking>) request.getAttribute("bookings"); %>
            <% if (bookings != null && !bookings.isEmpty()) { %>
            <table class="records-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Service</th>
                        <th>Vehicle</th>
                        <th>Date & Time</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Booking booking : bookings) { %>
                    <tr>
                        <td><%= booking.getBookingId() %></td>
                        <td><%= booking.getServiceName() %></td>
                        <td><%= booking.getCarDetails() %></td>
                        <td><%= booking.getTime() %></td>
                        <td>
                            <span class="status-badge status-<%= booking.getStatus().toLowerCase() %>">
                                <%= booking.getStatus() %>
                            </span>
                        </td>
                        <td>
                            <% if ("Completed".equals(booking.getStatus())) { %>
                            <a href="review_form.jsp?serviceName=<%= booking.getServiceName() %>" class="review-btn">
                                <i class="fas fa-star"></i> Review
                            </a>
                            <% } %>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            <% } else { %>
            <div class="no-records">
                <i class="fas fa-clipboard-list fa-3x" style="color: var(--text-light); margin-bottom: 15px;"></i>
                <p>No service bookings found.</p>
            </div>
            <% } %>
        </div>

        <div class="records-section">
            <h2 class="section-title">
                <i class="fas fa-star"></i>
                My Reviews
            </h2>
            <% List<Review> reviews = (List<Review>) request.getAttribute("reviews"); %>
            <% if (reviews != null && !reviews.isEmpty()) { %>
            <table class="records-table">
                <thead>
                    <tr>
                        <th>Service</th>
                        <th>Rating</th>
                        <th>Comment</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Review review : reviews) { %>
                    <tr>
                        <td><%= review.getServiceName() %></td>
                        <td>
                            <% for (int i = 0; i < review.getRating(); i++) { %>
                            <i class="fas fa-star" style="color: #f1c40f;"></i>
                            <% } %>
                        </td>
                        <td><%= review.getComment() %></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            <% } else { %>
            <div class="no-records">
                <i class="fas fa-star fa-3x" style="color: var(--text-light); margin-bottom: 15px;"></i>
                <p>No reviews found.</p>
            </div>
            <% } %>
        </div>
    </div>
</body>
</html>