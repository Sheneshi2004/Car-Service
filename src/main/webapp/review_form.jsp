<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.carservice.model.User" %>
<html>
<head>
    <title>Car Service Tracker - Write Review</title>
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

        .review-container {
            margin-top: 100px;
            padding: 40px 50px;
            max-width: 800px;
            margin-left: auto;
            margin-right: auto;
        }

        .review-header {
            margin-bottom: 40px;
            text-align: center;
        }

        .review-header h1 {
            font-size: 2.5rem;
            color: var(--text);
            margin-bottom: 10px;
            background: var(--gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .review-header p {
            color: var(--text-light);
            font-size: 1.1rem;
        }

        .review-form {
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

        .rating-group {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }

        .rating-label {
            font-size: 14px;
            color: var(--text-light);
        }

        .rating-stars {
            display: flex;
            gap: 5px;
        }

        .rating-stars input {
            display: none;
        }

        .rating-stars label {
            cursor: pointer;
            font-size: 24px;
            color: #e2e8f0;
            transition: var(--transition);
        }

        .rating-stars label:hover,
        .rating-stars label:hover ~ label,
        .rating-stars input:checked ~ label {
            color: #fbbf24;
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

            .review-container {
                padding: 20px;
                margin-top: 80px;
            }

            .review-form {
                padding: 20px;
            }

            .review-header h1 {
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
            <a href="user_records.jsp">My Records</a>
            <a href="booking_form.jsp">Book Service</a>
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

    <div class="review-container">
        <div class="review-header">
            <h1>Write a Review</h1>
            <p>Share your experience with our service</p>
        </div>

        <form class="review-form" action="review" method="post">
            <div class="form-group">
                <label for="serviceType">Service Type</label>
                <select id="serviceType" name="serviceType" required>
                    <option value="">Select a service</option>
                    <option value="oil_change">Oil Change</option>
                    <option value="tire_rotation">Tire Rotation</option>
                    <option value="brake_service">Brake Service</option>
                    <option value="engine_tune">Engine Tune-up</option>
                    <option value="transmission">Transmission Service</option>
                </select>
            </div>

            <div class="form-group">
                <label>Rating</label>
                <div class="rating-group">
                    <div class="rating-stars">
                        <input type="radio" id="star5" name="rating" value="5" required>
                        <label for="star5"><i class="fas fa-star"></i></label>
                        <input type="radio" id="star4" name="rating" value="4">
                        <label for="star4"><i class="fas fa-star"></i></label>
                        <input type="radio" id="star3" name="rating" value="3">
                        <label for="star3"><i class="fas fa-star"></i></label>
                        <input type="radio" id="star2" name="rating" value="2">
                        <label for="star2"><i class="fas fa-star"></i></label>
                        <input type="radio" id="star1" name="rating" value="1">
                        <label for="star1"><i class="fas fa-star"></i></label>
                    </div>
                </div>
            </div>

            <div class="form-group">
                <label for="review">Your Review</label>
                <textarea id="review" name="review" required placeholder="Share your experience with our service..."></textarea>
            </div>

            <button type="submit" class="submit-btn">Submit Review</button>
        </form>
    </div>
</body>
</html>