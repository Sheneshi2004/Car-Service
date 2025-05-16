<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.carservice.model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.carservice.model.Booking" %>
<%@ page import="com.carservice.model.ServiceRecord" %>
<%@ page import="com.carservice.model.Service" %>
<%@ page import="java.io.*" %>
<%@ page import="com.carservice.DSA.SelectionSort" %>
<html>
<head>
    <title>User Dashboard</title>
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

        .service-history {
            background: var(--card-bg);
            border-radius: 15px;
            padding: 30px;
            box-shadow: var(--shadow);
            margin-top: 40px;
        }

        .service-history h2 {
            margin-bottom: 20px;
            color: var(--text);
        }

        .service-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        .service-table th,
        .service-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid var(--background);
        }

        .service-table th {
            background-color: var(--background);
            font-weight: 600;
        }

        .service-table tr:hover {
            background-color: var(--background);
        }

        .status-badge {
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 0.85rem;
            font-weight: 500;
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

        /* Review Form Styles */
        .review-form-container {
            margin-top: 15px;
            padding: 15px;
            background-color: #f0f0f0; /* Slightly different background for the form area */
            border-radius: 8px;
            border: 1px solid #ddd;
        }

        .review-form-container h4 {
            margin-bottom: 10px;
            color: var(--secondary);
        }

        .review-form-container .form-group {
            margin-bottom: 10px;
        }

        .review-form-container label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
            font-size: 0.9rem;
        }

        .review-form-container input[type="text"],
        .review-form-container input[type="number"],
        .review-form-container textarea {
            width: 100%;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 0.9rem;
        }
        
        .review-form-container textarea {
            min-height: 60px;
            resize: vertical;
        }
        
        .review-form-container .rating-stars {
            display: flex;
        }
        
        .review-form-container .rating-stars input[type="radio"] {
            display: none; /* Hide actual radio buttons */
        }

        .review-form-container .rating-stars label {
            font-size: 1.5rem; /* Star size */
            color: #ccc; /* Default star color */
            cursor: pointer;
            padding: 0 2px; /* Spacing between stars */
            transition: color 0.2s ease;
        }

        /* Logic for star highlighting: https://codepen.io/jamesbarnett/pen/vlpkh */
        .review-form-container .rating-stars input[type="radio"]:checked ~ label,
        .review-form-container .rating-stars label:hover,
        .review-form-container .rating-stars label:hover ~ label {
            color: var(--accent); /* Highlight color - using accent for now */
        }
        
        /* To make highlighting work on hover from left to right */
        .review-form-container .rating-stars {
            direction: rtl; /* Stars are visually LTR, but behave RTL for :hover ~ label */
        }
        .review-form-container .rating-stars label {
            direction: ltr; /* Reset direction for individual stars for text/icons inside */
        }


        .btn-review {
            background-color: var(--primary);
            color: white;
            padding: 6px 10px;
            border-radius: 4px;
            text-decoration: none;
            font-size: 0.8rem;
            border: none;
            cursor: pointer;
        }
        .btn-review:hover {
            background-color: var(--primary-dark);
        }

        .btn-submit-review {
            background-color: var(--success); /* Assuming success color is green */
            color: white;
            padding: 8px 15px;
            border-radius: 4px;
            border: none;
            cursor: pointer;
            font-weight: 500;
            margin-top: 10px;
        }
        .btn-submit-review:hover {
            background-color: #27ae60; /* Darker green */
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

            .service-table {
                display: block;
                overflow-x: auto;
            }
        }

        /* Added styles for the new records table for consistency */
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
        }

        .records-table tr:hover {
            background-color: #f1f1f1; /* Slightly different hover for visual distinction if needed */
        }
        /* End of added styles for records table */

        .service-table tbody tr:hover {
            background-color: #e8f4fd;
        }

        .sort-links {
            margin-bottom: 15px;
        }

        .sort-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 15px;
            background-color: var(--primary);
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-size: 0.9rem;
            transition: var(--transition);
        }

        .sort-btn:hover {
            background-color: var(--primary-dark);
            transform: translateY(-2px);
        }

        .sort-btn i {
            font-size: 0.9rem;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <div class="nav-links">
            <a href="index.jsp">Home</a>
            <a href="booking-form">Book Service</a>
            <a href="user-records">Service History</a>
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

    <div class="dashboard-container">
        <div class="dashboard-header">
            <h1>Welcome, <%= user != null ? user.getUsername() : "User" %></h1>
            <p>Manage your car services and view your service history</p>
        </div>

        <div class="dashboard-grid">
            <a href="booking-form" class="dashboard-card">
                <div class="card-header">
                    <div class="card-icon">
                        <i class="fas fa-car"></i>
                    </div>
                    <div class="card-title">Book New Service</div>
                </div>
                <div class="card-description">
                    Schedule a new service appointment for your vehicle
                </div>
                <div class="card-stats">
                    <i class="fas fa-arrow-right"></i>
                    Book Now
                </div>
            </a>

            <a href="user-records" class="dashboard-card">
                <div class="card-header">
                    <div class="card-icon">
                        <i class="fas fa-history"></i>
                    </div>
                    <div class="card-title">Service History</div>
                </div>
                <div class="card-description">
                    View your past service records and maintenance history
                </div>
                <div class="card-stats">
                    <i class="fas fa-arrow-right"></i>
                    View History
                </div>
            </a>

            <a href="profile.jsp" class="dashboard-card">
                <div class="card-header">
                    <div class="card-icon">
                        <i class="fas fa-user-cog"></i>
                    </div>
                    <div class="card-title">My Profile</div>
                </div>
                <div class="card-description">
                    Update your personal information and preferences
                </div>
                <div class="card-stats">
                    <i class="fas fa-arrow-right"></i>
                    Edit Profile
                </div>
            </a>
        </div>

        <div class="service-history">
            <h2>Your Booking History</h2>
            <% List<Booking> userBookings = (List<Booking>) request.getAttribute("userBookings"); %>
            <% String bookingError = (String) request.getAttribute("bookingError"); %>
            <%-- Check for general dashboard error first --%>
            <% String dashboardError = (String) request.getAttribute("dashboardError"); %>
            <% if (dashboardError != null) { %>
                <p class="error-message" style="color: var(--accent);"><%= dashboardError %></p>
            <% } else if (bookingError != null) { %>
                <p class="error-message" style="color: var(--accent);"><%= bookingError %></p>
            <% } else if (userBookings != null && !userBookings.isEmpty()) { %>
            <table class="service-table">
                <thead>
                    <tr>
                        <th>Booking ID</th>
                        <th>Service Name</th>
                        <th>Vehicle Number</th>
                        <th>Date</th>
                        <th>Time</th>
                        <th>Status</th>
                        <th>Review</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Booking booking : userBookings) { %>
                        <tr>
                            <td><%= booking.getBookingId() %></td>
                            <td><%= booking.getServiceName() %></td>
                            <td><%= booking.getVehicleNumber() %></td>
                            <td><%= booking.getDate() %></td>
                            <td><%= booking.getTime() %></td>
                            <td><span class="status-badge status-<%= booking.getStatus().toLowerCase() %>"><%= booking.getStatus() %></span></td>
                            <td>
                                <% if ("Completed".equalsIgnoreCase(booking.getStatus())) { %>
                                    <button class="btn-review" onclick="toggleReviewForm('reviewForm_<%= booking.getBookingId() %>')">Write Review</button>
                                    <div id="reviewForm_<%= booking.getBookingId() %>" style="display:none;" class="review-form-container">
                                        <h4>Review: <%= booking.getServiceName() %></h4>
                                        <form action="review" method="post">
                                            <input type="hidden" name="action" value="submit">
                                            <input type="hidden" name="serviceName" value="<%= booking.getServiceName() %>">
                                            <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>"> <!-- Optional: if you want to link review to booking -->
                                            
                                            <div class="form-group">
                                                <label for="rating_<%= booking.getBookingId() %>">Rating:</label>
                                                <div class="rating-stars">
                                                    <!-- 5 stars -->
                                                    <input type="radio" id="star5_<%= booking.getBookingId() %>" name="rating" value="5" required/><label for="star5_<%= booking.getBookingId() %>" title="5 stars">&#9733;</label>
                                                    <input type="radio" id="star4_<%= booking.getBookingId() %>" name="rating" value="4" /><label for="star4_<%= booking.getBookingId() %>" title="4 stars">&#9733;</label>
                                                    <input type="radio" id="star3_<%= booking.getBookingId() %>" name="rating" value="3" /><label for="star3_<%= booking.getBookingId() %>" title="3 stars">&#9733;</label>
                                                    <input type="radio" id="star2_<%= booking.getBookingId() %>" name="rating" value="2" /><label for="star2_<%= booking.getBookingId() %>" title="2 stars">&#9733;</label>
                                                    <input type="radio" id="star1_<%= booking.getBookingId() %>" name="rating" value="1" /><label for="star1_<%= booking.getBookingId() %>" title="1 star">&#9733;</label>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label for="comment_<%= booking.getBookingId() %>">Comment:</label>
                                                <textarea id="comment_<%= booking.getBookingId() %>" name="comment" rows="3" required></textarea>
                                            </div>
                                            <button type="submit" class="btn-submit-review">Submit Review</button>
                                        </form>
                                    </div>
                                <% } else { %>
                                    -
                                <% } %>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
            <% } else if (bookingError == null) { %>
                <p>You have no booking history yet. <a href="booking-form">Make a booking?</a></p>
            <% } %>
        </div>

        <%-- New Section for Detailed Service Records --%>
        <div class="service-history" style="margin-top: 40px;">
            <h2>Your Service Records</h2>
            <%
                List<ServiceRecord> userServiceRecords = new ArrayList<>();
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
                                    ServiceRecord record = new ServiceRecord();
                                    record.setRecordNo(Integer.parseInt(parts[0].trim()));
                                    record.setCarNo(parts[1].trim());
                                    record.setDate(parts[2].trim());
                                    record.setCurrentMileage(Integer.parseInt(parts[3].trim()));
                                    record.setCustomerUsername(parts[4].trim());
                                    record.setNextServiceMileage(Integer.parseInt(parts[5].trim()));
                                    
                                    // Only add records for the current user
                                    if (user != null && user.getUsername().equals(record.getCustomerUsername())) {
                                        userServiceRecords.add(record);
                                    }
                                }
                            }
                        }
                    }
                } catch (IOException e) {
                    System.err.println("Error reading service records: " + e.getMessage());
                }

                // Sort records by date if requested
                String sortBy = request.getParameter("sortBy");
                if ("date".equals(sortBy) && !userServiceRecords.isEmpty()) {
                    ServiceRecord[] recordsArray = userServiceRecords.toArray(new ServiceRecord[0]);
                    SelectionSort.sortByDate(recordsArray);
                    userServiceRecords.clear();
                    for (ServiceRecord record : recordsArray) {
                        userServiceRecords.add(record);
                    }
                }
            %>
            
            <% if (!userServiceRecords.isEmpty()) { %>
            <div class="sort-links" style="margin-bottom: 15px;">
                <a href="user_dashboard.jsp?sortBy=date" class="sort-btn">
                    <i class="fas fa-sort"></i> Sort by Date
                </a>
            </div>
            <table class="service-table"> 
                <thead>
                    <tr>
                        <th>Record No</th>
                        <th>Date</th>
                        <th>Car No</th>
                        <th>Current Mileage</th>
                        <th>Next Service Mileage</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (ServiceRecord record : userServiceRecords) { %>
                    <tr>
                        <td><%= record.getRecordNo() %></td>
                        <td><%= record.getDate() %></td>
                        <td><%= record.getCarNo() %></td>
                        <td><%= record.getCurrentMileage() %></td>
                        <td><%= record.getNextServiceMileage() %></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            <% } else { %>
                <p>No service records found for your account.</p>
            <% } %>
        </div>
        <%-- End of Service Records Section --%>

    </div>

    <script>
        function toggleReviewForm(formId) {
            var form = document.getElementById(formId);
            if (form.style.display === "none") {
                form.style.display = "block";
            } else {
                form.style.display = "none";
            }
        }
    </script>
</body>
</html>