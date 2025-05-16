<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.carservice.model.Review" %>
<%@ page import="com.carservice.model.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>All Reviews - Car Service</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary: #e31837;
            --primary-dark: #c41230;
            --secondary: #1a1a1a;
            --accent: #e31837;
            --star-color: #f39c12;
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
            overflow-x: hidden;
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
            transition: var(--transition);
        }

        .navbar.scrolled {
            padding: 10px 50px;
            background: rgba(255, 255, 255, 0.98);
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

        .book-now {
            background: var(--gradient);
            color: white;
            padding: 12px 25px;
            border-radius: 25px;
            font-weight: 600;
            transition: var(--transition);
            box-shadow: 0 4px 15px rgba(227, 24, 55, 0.2);
        }

        .book-now:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(227, 24, 55, 0.3);
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

        .reviews-container {
            max-width: 1200px;
            margin: 100px auto 2rem;
            padding: 0 1rem;
        }

        .reviews-header {
            text-align: center;
            margin-bottom: 3rem;
            position: relative;
        }

        .reviews-header h1 {
            font-size: 2.8rem;
            color: var(--text);
            margin-bottom: 15px;
            position: relative;
            display: inline-block;
        }

        .reviews-header h1::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 3px;
            background: var(--gradient);
            border-radius: 2px;
        }

        .reviews-header p {
            color: var(--text-light);
            font-size: 1.1rem;
            margin-top: 20px;
        }

        .reviews-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 2rem;
            padding: 1rem;
        }

        .review-card {
            background: var(--card-bg);
            border-radius: 15px;
            padding: 1.5rem;
            box-shadow: var(--shadow);
            transition: var(--transition);
            position: relative;
            border: 1px solid rgba(0, 0, 0, 0.05);
        }

        .review-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
        }

        .review-card-header {
            display: flex;
            align-items: center;
            margin-bottom: 1rem;
        }

        .review-card-avatar {
            width: 50px;
            height: 50px;
            background: var(--gradient);
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 1.5rem;
            margin-right: 1rem;
            box-shadow: 0 4px 15px rgba(227, 24, 55, 0.2);
        }

        .review-card-user h4 {
            margin: 0;
            color: var(--text);
            font-size: 1.1rem;
        }

        .review-card-user p {
            margin: 5px 0 0;
            color: var(--text-light);
            font-size: 0.9rem;
        }

        .review-card-rating {
            color: var(--star-color);
            margin-bottom: 1rem;
            font-size: 1.1rem;
        }

        .review-card-comment {
            color: var(--text);
            line-height: 1.6;
            font-size: 0.95rem;
            position: relative;
            padding: 0 1rem;
        }

        .review-card-comment::before {
            content: '"';
            position: absolute;
            left: 0;
            top: -10px;
            font-size: 2rem;
            color: var(--primary);
            opacity: 0.2;
        }

        .no-reviews {
            text-align: center;
            color: var(--text-light);
            padding: 3rem;
            background: var(--card-bg);
            border-radius: 15px;
            box-shadow: var(--shadow);
            margin: 2rem auto;
            max-width: 600px;
        }

        .no-reviews p {
            font-size: 1.1rem;
            margin-bottom: 1rem;
        }

        .scroll-progress {
            position: fixed;
            top: 0;
            left: 0;
            width: 0;
            height: 3px;
            background: var(--gradient);
            z-index: 1001;
            transition: width 0.1s ease;
        }

        .write-review-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 24px;
            background: var(--gradient);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 500;
            text-decoration: none;
            transition: var(--transition);
            margin-top: 20px;
        }

        .write-review-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(227, 24, 55, 0.3);
        }

        .write-review-btn i {
            font-size: 14px;
        }

        @media (max-width: 768px) {
            .navbar {
                padding: 15px 20px;
            }

            .reviews-container {
                margin-top: 80px;
            }

            .reviews-header h1 {
                font-size: 2.2rem;
            }

            .reviews-grid {
                grid-template-columns: 1fr;
            }

            .write-review-btn {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <div class="scroll-progress"></div>
    <div class="navbar">
        <div class="nav-links">
            <a href="index.jsp">Home</a>
            <a href="user_dashboard.jsp">Dashboard</a>
            <a href="user_records.jsp">My Records</a>
            <a href="booking_form.jsp">Book Service</a>
        </div>
        <a href="booking-form" class="book-now">Book Now</a>
        <% User user = (User) session.getAttribute("user"); %>
        <% if (user != null) { %>
        <div class="user-info">
            <i class="fas fa-user"></i>
            Welcome, <%= user.getUsername() %>
        </div>
        <% } %>
    </div>

    <div class="reviews-container">
        <div class="reviews-header">
            <h1>Customer Reviews</h1>
            <p>See what our customers are saying about our services</p>
            <a href="review" class="write-review-btn">
                <i class="fas fa-pen"></i> Write a Review
            </a>
        </div>

        <% 
        List<Review> reviews = (List<Review>) request.getAttribute("allReviews");
        if (reviews != null && !reviews.isEmpty()) { 
        %>
            <div class="reviews-grid">
                <% for (Review review : reviews) { %>
                    <div class="review-card">
                        <div class="review-card-header">
                            <div class="review-card-avatar">
                                <%= review.getUsername().substring(0, 1).toUpperCase() %>
                            </div>
                            <div class="review-card-user">
                                <h4><%= review.getUsername() %></h4>
                                <p>Service: <%= review.getServiceName() %></p>
                            </div>
                        </div>
                        <div class="review-card-rating">
                            <% for (int i = 1; i <= 5; i++) { %>
                                <i class="fa fa-star<%= (i <= review.getRating()) ? "" : "-o" %>"></i>
                            <% } %>
                        </div>
                        <p class="review-card-comment"><%= review.getComment() %></p>
                    </div>
                <% } %>
            </div>
        <% } else { %>
            <div class="no-reviews">
                <p>No reviews available yet. Be the first to share your experience!</p>
                <a href="review_form.jsp" class="book-now">Write a Review</a>
            </div>
        <% } %>
    </div>

    <script>
        // Navbar scroll effect
        window.addEventListener('scroll', function() {
            const navbar = document.querySelector('.navbar');
            if (window.scrollY > 50) {
                navbar.classList.add('scrolled');
            } else {
                navbar.classList.remove('scrolled');
            }
        });

        // Scroll progress indicator
        window.addEventListener('scroll', function() {
            const scrollProgress = document.querySelector('.scroll-progress');
            const scrollable = document.documentElement.scrollHeight - window.innerHeight;
            const scrolled = window.scrollY;
            const progress = (scrolled / scrollable) * 100;
            scrollProgress.style.width = progress + '%';
        });
    </script>
</body>
</html> 