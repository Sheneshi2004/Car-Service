<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Car Service Tracker - Login</title>
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
            background: linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)), url('https://images.unsplash.com/photo-1583121274602-3e2820c69888?ixlib=rb-1.2.1&auto=format&fit=crop&w=1950&q=80');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .login-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            padding: 40px;
            border-radius: 15px;
            box-shadow: var(--shadow);
            width: 100%;
            max-width: 400px;
            transform: translateY(20px);
            animation: slideUp 0.8s ease forwards;
        }

        @keyframes slideUp {
            to {
                transform: translateY(0);
            }
        }

        .login-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .login-header h2 {
            font-size: 2rem;
            color: var(--text);
            margin-bottom: 10px;
            background: var(--gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .login-header p {
            color: var(--text-light);
            font-size: 0.9rem;
        }

        .form-group {
            margin-bottom: 20px;
            position: relative;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: var(--text);
            font-weight: 500;
        }

        .form-group input {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e1e1e1;
            border-radius: 8px;
            font-size: 1rem;
            transition: var(--transition);
            background: rgba(255, 255, 255, 0.9);
        }

        .form-group input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(227, 24, 55, 0.1);
        }

        .form-group i {
            position: absolute;
            right: 15px;
            top: 40px;
            color: var(--text-light);
        }

        .login-btn {
            width: 100%;
            padding: 14px;
            background: var(--gradient);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            position: relative;
            overflow: hidden;
        }

        .login-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: 0.5s;
        }

        .login-btn:hover::before {
            left: 100%;
        }

        .login-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(227, 24, 55, 0.3);
        }

        .register-link {
            text-align: center;
            margin-top: 20px;
            color: var(--text-light);
        }

        .register-link a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 500;
            transition: var(--transition);
        }

        .register-link a:hover {
            color: var(--primary-dark);
        }

        .error-message {
            background: rgba(227, 24, 55, 0.1);
            color: var(--primary);
            padding: 10px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 0.9rem;
            text-align: center;
        }

        @media (max-width: 480px) {
            .login-container {
                padding: 30px 20px;
            }

            .login-header h2 {
                font-size: 1.8rem;
            }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-header">
            <h2>Welcome Back</h2>
            <p>Please login to your account</p>
        </div>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="error-message">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <form action="login" method="post">
            <input type="hidden" name="action" value="login">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" required>
                <i class="fas fa-user"></i>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required>
                <i class="fas fa-lock"></i>
            </div>
            <button type="submit" class="login-btn">Login</button>
        </form>
        
        <div class="register-link">
            Don't have an account? <a href="register.jsp">Register here</a>
        </div>
    </div>
</body>
</html>