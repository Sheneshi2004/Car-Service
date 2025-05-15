<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.carservice.model.User" %>
<html>
<head>
    <title>Our Services</title>
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

        .services-container {
            margin-top: 100px;
            padding: 40px 50px;
            max-width: 1200px;
            margin-left: auto;
            margin-right: auto;
        }

        .services-header {
            text-align: center;
            margin-bottom: 50px;
        }

        .services-header h1 {
            font-size: 2.5rem;
            color: var(--text);
            margin-bottom: 15px;
        }

        .services-header p {
            color: var(--text-light);
            font-size: 1.1rem;
            max-width: 600px;
            margin: 0 auto;
        }

        .services-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            margin-top: 40px;
        }

        .service-card {
            background: var(--card-bg);
            border-radius: 15px;
            padding: 30px;
            box-shadow: var(--shadow);
            transition: var(--transition);
            position: relative;
            overflow: hidden;
        }

        .service-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.15);
        }

        .service-icon {
            width: 60px;
            height: 60px;
            background: var(--primary);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
        }

        .service-icon i {
            font-size: 24px;
            color: white;
        }

        .service-card h3 {
            font-size: 1.5rem;
            color: var(--text);
            margin-bottom: 15px;
        }

        .service-card p {
            color: var(--text-light);
            margin-bottom: 20px;
            line-height: 1.6;
        }

        .service-price {
            font-size: 1.25rem;
            color: var(--primary);
            font-weight: 600;
            margin-bottom: 20px;
        }

        .book-btn {
            display: inline-block;
            padding: 10px 20px;
            background: var(--primary);
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-weight: 500;
            transition: var(--transition);
        }

        .book-btn:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
        }

        .service-features {
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid var(--background);
        }

        .feature-item {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 10px;
            color: var(--text-light);
        }

        .feature-item i {
            color: var(--primary);
            font-size: 14px;
        }

        @media (max-width: 768px) {
            .navbar {
                padding: 15px 20px;
            }

            .nav-links {
                display: none;
            }

            .services-container {
                padding: 20px;
                margin-top: 80px;
            }

            .services-header h1 {
                font-size: 2rem;
            }

            .services-grid {
                grid-template-columns: 1fr;
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

    <div class="services-container">
        <div class="services-header">
            <h1>Our Services</h1>
            <p>Choose from our comprehensive range of car services, performed by certified technicians using state-of-the-art equipment.</p>
        </div>

        <div class="services-grid">
            <div class="service-card">
                <div class="service-icon">
                    <i class="fas fa-oil-can"></i>
                </div>
                <h3>Oil Change</h3>
                <p>Regular oil changes are essential for maintaining your engine's performance and longevity.</p>
                <div class="service-price">$49.99</div>
                <div class="service-features">
                    <div class="feature-item">
                        <i class="fas fa-check"></i>
                        <span>Full-synthetic oil</span>
                    </div>
                    <div class="feature-item">
                        <i class="fas fa-check"></i>
                        <span>Oil filter replacement</span>
                    </div>
                    <div class="feature-item">
                        <i class="fas fa-check"></i>
                        <span>Multi-point inspection</span>
                    </div>
                </div>
                <a href="booking-form" class="book-btn">Book Now</a>
            </div>

            <div class="service-card">
                <div class="service-icon">
                    <i class="fas fa-car-battery"></i>
                </div>
                <h3>Battery Service</h3>
                <p>Keep your vehicle starting reliably with our comprehensive battery testing and replacement service.</p>
                <div class="service-price">$89.99</div>
                <div class="service-features">
                    <div class="feature-item">
                        <i class="fas fa-check"></i>
                        <span>Battery testing</span>
                    </div>
                    <div class="feature-item">
                        <i class="fas fa-check"></i>
                        <span>Terminal cleaning</span>
                    </div>
                    <div class="feature-item">
                        <i class="fas fa-check"></i>
                        <span>Installation included</span>
                    </div>
                </div>
                <a href="booking-form" class="book-btn">Book Now</a>
            </div>

            <div class="service-card">
                <div class="service-icon">
                    <i class="fas fa-tools"></i>
                </div>
                <h3>Brake Service</h3>
                <p>Ensure your safety with our thorough brake inspection and maintenance service.</p>
                <div class="service-price">$129.99</div>
                <div class="service-features">
                    <div class="feature-item">
                        <i class="fas fa-check"></i>
                        <span>Brake pad inspection</span>
                    </div>
                    <div class="feature-item">
                        <i class="fas fa-check"></i>
                        <span>Rotor assessment</span>
                    </div>
                    <div class="feature-item">
                        <i class="fas fa-check"></i>
                        <span>Fluid check</span>
                    </div>
                </div>
                <a href="booking-form" class="book-btn">Book Now</a>
            </div>

            <div class="service-card">
                <div class="service-icon">
                    <i class="fas fa-car-side"></i>
                </div>
                <h3>Tire Service</h3>
                <p>Keep your tires in optimal condition with our comprehensive tire service.</p>
                <div class="service-price">$79.99</div>
                <div class="service-features">
                    <div class="feature-item">
                        <i class="fas fa-check"></i>
                        <span>Rotation & balancing</span>
                    </div>
                    <div class="feature-item">
                        <i class="fas fa-check"></i>
                        <span>Pressure check</span>
                    </div>
                    <div class="feature-item">
                        <i class="fas fa-check"></i>
                        <span>Alignment check</span>
                    </div>
                </div>
                <a href="booking-form" class="book-btn">Book Now</a>
            </div>
        </div>
    </div>
</body>
</html> 