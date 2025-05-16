<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.carservice.model.User" %>
<html>
<head>
    <title>My Profile</title>
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

        .profile-container {
            margin-top: 100px;
            padding: 40px 50px;
            max-width: 800px;
            margin-left: auto;
            margin-right: auto;
        }

        .profile-header {
            margin-bottom: 40px;
        }

        .profile-header h1 {
            font-size: 2.5rem;
            color: var(--text);
            margin-bottom: 10px;
        }

        .profile-header p {
            color: var(--text-light);
            font-size: 1.1rem;
        }

        .profile-form {
            background: var(--card-bg);
            border-radius: 15px;
            padding: 30px;
            box-shadow: var(--shadow);
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: var(--text);
            font-weight: 500;
        }

        .form-group input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 15px;
            transition: var(--transition);
        }

        .form-group input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 2px rgba(52, 152, 219, 0.2);
        }

        .submit-btn {
            background: var(--primary);
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
        }

        .submit-btn:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
        }

        .profile-info {
            background: var(--card-bg);
            border-radius: 15px;
            padding: 30px;
            box-shadow: var(--shadow);
            margin-bottom: 30px;
        }

        .info-group {
            margin-bottom: 20px;
        }

        .info-label {
            color: var(--text-light);
            font-size: 0.9rem;
            margin-bottom: 5px;
        }

        .info-value {
            color: var(--text);
            font-size: 1.1rem;
            font-weight: 500;
        }

        @media (max-width: 768px) {
            .navbar {
                padding: 15px 20px;
            }

            .nav-links {
                display: none;
            }

            .profile-container {
                padding: 20px;
                margin-top: 80px;
            }

            .profile-header h1 {
                font-size: 2rem;
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

    <div class="profile-container">
        <div class="profile-header">
            <h1>My Profile</h1>
            <p>View and update your personal information</p>
        </div>

        <div class="profile-info">
            <div class="info-group">
                <div class="info-label">Username</div>
                <div class="info-value"><%= user != null ? user.getUsername() : "" %></div>
            </div>
            <div class="info-group">
                <div class="info-label">Email</div>
                <div class="info-value"><%= user != null ? user.getEmail() : "" %></div>
            </div>
        </div>

        <form class="profile-form" action="user" method="post">
            <input type="hidden" name="action" value="updateUser">
            <input type="hidden" name="username" value="<%= user != null ? user.getUsername() : "" %>">
            
            <div class="form-group">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email" value="<%= user != null ? user.getEmail() : "" %>" required>
            </div>

            <div class="form-group">
                <label for="password">New Password</label>
                <input type="password" id="password" name="password" placeholder="Enter new password">
            </div>

            <div class="form-group">
                <label for="confirmPassword">Confirm New Password</label>
                <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm new password">
            </div>

            <button type="submit" class="submit-btn">Update Profile</button>
        </form>
    </div>

    <script>
        document.querySelector('.profile-form').addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (password && confirmPassword && password !== confirmPassword) {
                e.preventDefault();
                alert('Passwords do not match!');
            }
        });
    </script>
</body>
</html> 