<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.carservice.model.User" %>
<%@ page import="java.util.List" %>
<html>
<head>
    <title>Car Service Tracker - Book Service</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary: #e31837;
            --primary-dark: #c41230;
            --secondary: #1a1a1a;
            --accent: #e31837;
            --background: #ffffff;
            --card-bg: #f8f9fa;
            --text: #333333;
            --text-light: #666666;
            --gradient: linear-gradient(135deg, #e31837, #c41230);
            --shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
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
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
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
            position: relative;
        }

        .navbar a::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            width: 0;
            height: 2px;
            background: var(--gradient);
            transition: var(--transition);
            transform: translateX(-50%);
        }

        .navbar a:hover::after {
            width: 80%;
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
            background: var(--gradient);
            color: white;
        }

        .user-info i {
            color: var(--primary);
            transition: var(--transition);
        }

        .user-info:hover i {
            color: white;
        }

        .booking-container {
            margin-top: 100px;
            padding: 40px 50px;
            max-width: 800px;
            margin-left: auto;
            margin-right: auto;
        }

        .booking-header {
            margin-bottom: 40px;
            text-align: center;
        }

        .booking-header h1 {
            font-size: 2.5rem;
            color: var(--text);
            margin-bottom: 10px;
            background: var(--gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .booking-header p {
            color: var(--text-light);
            font-size: 1.1rem;
        }

        .booking-form {
            background: white;
            border-radius: 15px;
            padding: 40px;
            box-shadow: var(--shadow);
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: var(--text);
            font-weight: 500;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            font-size: 15px;
            transition: var(--transition);
            background: var(--card-bg);
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(227, 24, 55, 0.1);
        }

        .form-group textarea {
            min-height: 120px;
            resize: vertical;
        }

        .submit-btn {
            display: inline-block;
            padding: 12px 30px;
            background: var(--gradient);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
            width: 100%;
        }

        .submit-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(227, 24, 55, 0.3);
        }

        .error-message {
            color: var(--primary);
            font-size: 14px;
            margin-top: 5px;
        }

        @media (max-width: 768px) {
            .navbar {
                padding: 15px 20px;
            }

            .nav-links {
                display: none;
            }

            .booking-container {
                padding: 20px;
                margin-top: 80px;
            }

            .booking-form {
                padding: 20px;
            }

            .booking-header h1 {
                font-size: 2rem;
            }
        }
    </style>
</head>
<body>
    <div class="navbar">
        <div class="nav-links">
            <a href="index.jsp">Home</a>
            <a href="user_dashboard.jsp">Dashboard</a>
            <a href="user_dashboard.jsp">My Records</a>
            <a href="review_form.jsp">Write Review</a>
        </div>
        <a href="login.jsp">Logout</a>
        <% User user = (User) session.getAttribute("user"); %>
        <% if (user != null) { %>
        <div class="user-info">
            <i class="fas fa-user"></i>
            Welcome, <%= user.getUsername() %>
        </div>
        <% } %>
    </div>

    <div class="booking-container">
        <div class="booking-header">
            <h1>Book a Service</h1>
            <p>Schedule your vehicle service appointment with us</p>
        </div>

        <form class="booking-form" action="booking" method="post">
            <input type="hidden" name="action" value="book">
            <div class="form-group">
                <label for="serviceName">Service Type</label>
                <select id="serviceName" name="serviceName" required>
                    <option value="">Select a service</option>
                    <% 
                        List<com.carservice.model.Service> services = (List<com.carservice.model.Service>) request.getAttribute("services");
                        if (services != null) {
                            for (com.carservice.model.Service service : services) {
                    %>
                        <option value="<%= service.getName() %>"><%= service.getName() %></option>
                    <%
                            }
                        }
                    %>
                </select>
            </div>

            <!-- Employee Selection Dropdown -->
            <div class="form-group">
                <label for="employeeId">Assign Employee (Optional)</label>
                <select id="employeeId" name="employeeId">
                    <option value="">-- Select Employee --</option> <!-- Optional: Allow unassigned -->
                    <% 
                        @SuppressWarnings("unchecked")
                        List<com.carservice.model.Employee> employees = (List<com.carservice.model.Employee>) request.getAttribute("employees");
                        if (employees != null) {
                            for (com.carservice.model.Employee employee : employees) {
                    %>
                        <option value="<%= employee.getEmployeeId() %>">
                            <%= employee.getName() %> (<%= employee.getSpecialization() %>)
                        </option>
                    <% 
                            }
                        }
                    %>
                </select>
            </div>
            <!-- End Employee Selection -->

            <div class="form-group">
                <label for="vehicleNumber">Vehicle Number</label>
                <input type="text" id="vehicleNumber" name="vehicleNumber" required placeholder="Enter your vehicle number">
            </div>

            <div class="form-group">
                <label for="date">Preferred Date</label>
                <input type="date" id="date" name="date" required>
            </div>

            <div class="form-group">
                <label for="time">Preferred Time</label>
                <select id="time" name="time" required>
                    <option value="">Select a time slot</option>
                    <option value="09:00">Morning (9:00 AM)</option>
                    <option value="10:00">Morning (10:00 AM)</option>
                    <option value="11:00">Morning (11:00 AM)</option>
                    <option value="13:00">Afternoon (1:00 PM)</option>
                    <option value="14:00">Afternoon (2:00 PM)</option>
                    <option value="15:00">Afternoon (3:00 PM)</option>
                    <option value="16:00">Evening (4:00 PM)</option>
                    <option value="17:00">Evening (5:00 PM)</option>
                </select>
            </div>

            <button type="submit" class="submit-btn">Book Appointment</button>
        </form>
    </div>
</body>
</html>