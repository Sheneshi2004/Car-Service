<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.carservice.model.User" %>
<%@ page import="com.carservice.model.Review" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<html>
<head>
    <title>Car Service Tracker - Home</title>
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

        .hero-slider {
            margin-top: 80px;
            position: relative;
            height: 80vh;
            overflow: hidden;
        }

        .slide {
            position: absolute;
            width: 100%;
            height: 100%;
            background-size: cover;
            background-position: center;
            display: flex;
            align-items: center;
            padding: 0 100px;
            color: white;
            opacity: 0;
            transition: opacity 0.5s ease;
        }

        .slide.active {
            opacity: 1;
        }

        .slide-content {
            max-width: 600px;
            background: rgba(0, 0, 0, 0.7);
            padding: 40px;
            border-radius: 15px;
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            transform: translateY(20px);
            animation: slideUp 0.8s ease forwards;
        }

        @keyframes slideUp {
            to {
                transform: translateY(0);
            }
        }

        .slide-content h2 {
            font-size: 3rem;
            margin-bottom: 20px;
            font-weight: 700;
            background: var(--gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .slide-content p {
            font-size: 1.2rem;
            margin-bottom: 30px;
            opacity: 0.9;
        }

        .inquiry-btn {
            background: var(--gradient);
            color: white;
            padding: 15px 35px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 600;
            display: inline-block;
            transition: var(--transition);
            box-shadow: 0 4px 15px rgba(227, 24, 55, 0.2);
            position: relative;
            overflow: hidden;
        }

        .inquiry-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: 0.5s;
        }

        .inquiry-btn:hover::before {
            left: 100%;
        }

        .inquiry-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(227, 24, 55, 0.3);
        }

        .services {
            padding: 100px 50px;
            background: var(--card-bg);
            position: relative;
        }

        .section-title {
            text-align: center;
            margin-bottom: 60px;
            position: relative;
        }

        .section-title h2 {
            font-size: 2.8rem;
            color: var(--text);
            margin-bottom: 15px;
            position: relative;
            display: inline-block;
        }

        .section-title h2::after {
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

        .services-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            max-width: 1200px;
            margin: 0 auto;
        }

        .service-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: var(--shadow);
            transition: var(--transition);
            position: relative;
        }

        .service-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
        }

        .service-image {
            height: 250px;
            background-size: cover;
            background-position: center;
            position: relative;
            overflow: hidden;
        }

        .service-image::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: var(--gradient);
            opacity: 0;
            transition: var(--transition);
        }

        .service-card:hover .service-image::after {
            opacity: 0.3;
        }

        .service-content {
            padding: 30px;
        }

        .service-content h3 {
            font-size: 1.8rem;
            margin-bottom: 15px;
            color: var(--text);
            transition: var(--transition);
        }

        .service-card:hover .service-content h3 {
            color: var(--primary);
        }

        .service-content p {
            color: var(--text-light);
            margin-bottom: 25px;
            line-height: 1.7;
        }

        .read-more {
            color: var(--primary);
            text-decoration: none;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: var(--transition);
        }

        .read-more i {
            transition: var(--transition);
        }

        .read-more:hover {
            color: var(--primary-dark);
        }

        .read-more:hover i {
            transform: translateX(5px);
        }

        .pricing {
            padding: 100px 50px;
            background: white;
            position: relative;
        }

        .pricing-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            max-width: 1200px;
            margin: 0 auto;
        }

        .price-card {
            background: white;
            border-radius: 15px;
            padding: 40px 30px;
            text-align: center;
            box-shadow: var(--shadow);
            transition: var(--transition);
            border: 2px solid transparent;
        }

        .price-card:hover {
            transform: translateY(-10px);
            border-color: var(--primary);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
        }

        .price-card h3 {
            font-size: 1.8rem;
            margin-bottom: 20px;
            color: var(--text);
        }

        .price {
            font-size: 2.5rem;
            color: var(--primary);
            font-weight: 700;
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 5px;
        }

        .price::before {
            content: 'LKR';
            font-size: 1rem;
            color: var(--text-light);
        }

        .testimonials {
            padding: 100px 50px;
            background: var(--card-bg);
            position: relative;
        }

        .testimonials-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            max-width: 1200px;
            margin: 0 auto;
        }

        .testimonial-card {
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: var(--shadow);
            transition: var(--transition);
            position: relative;
        }

        .testimonial-card::before {
            content: '"';
            position: absolute;
            top: 20px;
            left: 20px;
            font-size: 4rem;
            color: var(--primary);
            opacity: 0.1;
            font-family: serif;
        }

        .testimonial-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
        }

        .testimonial-text {
            font-size: 1.1rem;
            color: var(--text);
            margin-bottom: 30px;
            font-style: italic;
            line-height: 1.8;
        }

        .testimonial-author {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .author-avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: var(--gradient);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
            box-shadow: 0 4px 15px rgba(227, 24, 55, 0.2);
        }

        .author-info h4 {
            font-size: 1.2rem;
            color: var(--text);
            margin-bottom: 5px;
        }

        .author-info p {
            font-size: 0.9rem;
            color: var(--text-light);
        }

        @media (max-width: 768px) {
            .navbar {
                padding: 15px 20px;
            }

            .nav-links {
                display: none;
            }

            .slide {
                padding: 0 20px;
            }

            .slide-content {
                padding: 30px;
            }

            .slide-content h2 {
                font-size: 2.2rem;
            }

            .services, .pricing, .testimonials {
                padding: 60px 20px;
            }

            .section-title h2 {
                font-size: 2.2rem;
            }
        }

        /* Add smooth scroll behavior */
        html {
            scroll-behavior: smooth;
        }

        /* Add scroll progress indicator */
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

        .reviews-section {
            padding: 80px 50px;
            background-color: var(--background);
        }

        .reviews-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            margin-top: 30px;
        }

        .review-card {
            background: var(--card-bg);
            border: 1px solid #e0e0e0;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.07);
            display: flex;
            flex-direction: column;
            transition: var(--transition);
        }
        
        .review-card:hover {
             transform: translateY(-5px);
             box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }

        .review-card-header {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }

        .review-card-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background-color: var(--primary);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            font-weight: 600;
            margin-right: 15px;
        }
        
        .review-card-user h4 {
            font-size: 1.1rem;
            color: var(--text);
            margin: 0;
        }
        .review-card-user p {
            font-size: 0.85rem;
            color: var(--text-light);
            margin: 0;
        }

        .review-card-rating {
            margin-bottom: 10px;
            color: var(--star-color);
        }
        
        .review-card-rating .fa-star {
        }
        .review-card-rating .fa-star-o {
            color: #e0e0e0; 
        }

        .review-card-comment {
            font-size: 0.95rem;
            color: var(--text-light);
            line-height: 1.5;
            flex-grow: 1;
            margin-bottom: 15px;
        }
        
        .review-card-comment::before {
            content: '\"';
            font-size: 1.5em;
            color: var(--primary);
            margin-right: 5px;
            position: relative;
            top: 5px;
        }
        .review-card-comment::after {
            content: '\"';
            font-size: 1.5em;
            color: var(--primary);
            margin-left: 5px;
            position: relative;
            top: 5px;
        }
        
        .review-card-date {
            font-size: 0.8rem;
            color: #aaa;
            text-align: right;
            margin-top: auto;
        }
        
        .no-reviews-message {
            text-align: center;
            font-size: 1.1rem;
            color: var(--text-light);
            padding: 40px;
            background: var(--card-bg);
            border-radius: 8px;
        }

        .home-page-error {
            text-align: center;
            font-size: 1.1rem;
            color: var(--accent);
            padding: 20px;
            background: #ffebee;
            border: 1px solid var(--accent);
            border-radius: 8px;
            margin: 20px auto;
            max-width: 800px;
        }

        .footer {
            background: var(--secondary);
            color: white;
            padding: 50px 0;
            text-align: center;
        }

        .footer-content p {
            margin-bottom: 10px;
            font-size: 0.9rem;
        }

        .footer-socials a {
            color: white;
            margin: 0 10px;
            font-size: 1.2rem;
            transition: var(--transition);
        }

        .footer-socials a:hover {
            color: var(--primary);
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
        <a href="review?action=viewAll">Reviews</a>
        <% User user = (User) session.getAttribute("user"); %>
        <% if (user == null) { %>
        <a href="login.jsp">Login</a>
        <a href="register.jsp">Register</a>
        <% } else if (user.getUsername().equals("admin")) { %>
        <a href="admin_dashboard.jsp">Admin Dashboard</a>
        <a href="login.jsp">Logout</a>
        <% } else { %>
        <a href="user-dashboard">Dashboard</a>
        <a href="login.jsp">Logout</a>
        <% } %>
    </div>
    <a href="booking-form" class="book-now">Book Now</a>
    <% if (user != null) { %>
    <div class="user-info">
        <i class="fas fa-user"></i>
        Welcome, <%= user.getUsername() %>
    </div>
    <% } %>
</div>

<div class="hero-slider">
    <div class="slide active" style="background-image: linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)), url('https://images.unsplash.com/photo-1583121274602-3e2820c69888?ixlib=rb-1.2.1&auto=format&fit=crop&w=1950&q=80');">
        <div class="slide-content">
            <h2>Mechanical Repair Services</h2>
            <p>We understand your car and it's technology</p>
            <% if (user == null) { %>
                <a href="login.jsp" class="inquiry-btn">Get Started</a>
            <% } else { %>
                <a href="booking-form" class="inquiry-btn">Get Started</a>
            <% } %>
        </div>
    </div>
</div>

<div class="services" id="services">
    <div class="section-title">
        <h2>Our Services</h2>
    </div>
    <div class="services-grid">
        <div class="service-card">
            <div class="service-image" style="background-image: url('https://images.unsplash.com/photo-1583121274602-3e2820c69888?ixlib=rb-1.2.1&auto=format&fit=crop&w=1950&q=80');"></div>
            <div class="service-content">
                <h3>Vehicle Repair</h3>
                <p>Our experts are skilled to handle any major mechanical repair. We are armed with the best of tools and expertise.</p>
                <a href="#" class="read-more">Read more <i class="fas fa-arrow-right"></i></a>
            </div>
        </div>
        <div class="service-card">
            <div class="service-image" style="background-image: url('https://images.unsplash.com/photo-1583121274602-3e2820c69888?ixlib=rb-1.2.1&auto=format&fit=crop&w=1950&q=80');"></div>
            <div class="service-content">
                <h3>Vehicle Servicing</h3>
                <p>Regular maintenance is key to keeping your vehicle in top condition. Our comprehensive service packages ensure your car stays in perfect shape.</p>
                <a href="#" class="read-more">Read more <i class="fas fa-arrow-right"></i></a>
            </div>
        </div>
        <div class="service-card">
            <div class="service-image" style="background-image: url('https://images.unsplash.com/photo-1583121274602-3e2820c69888?ixlib=rb-1.2.1&auto=format&fit=crop&w=1950&q=80');"></div>
            <div class="service-content">
                <h3>Collision Repair</h3>
                <p>We rebuild your vehicle to its original condition with cutting-edge technology and expert craftsmanship.</p>
                <a href="#" class="read-more">Read more <i class="fas fa-arrow-right"></i></a>
            </div>
        </div>
    </div>
</div>

<div class="testimonials" id="testimonials">
    <div class="section-title">
        <h2>What Our Customers Say</h2>
    </div>
    <div class="testimonials-grid">
        <div class="testimonial-card">
            <div class="testimonial-text">
                "Got the battery of my car replaced at the service center. Thank you for the fast and friendly service. A reliable place that can be recommended to anyone."
            </div>
            <div class="testimonial-author">
                <div class="author-avatar">
                    <i class="fas fa-user"></i>
                </div>
                <div class="author-info">
                    <h4>John Smith</h4>
                    <p>Regular Customer</p>
                </div>
            </div>
        </div>
        <div class="testimonial-card">
            <div class="testimonial-text">
                "They provided an excellent service for my vehicle. The staff is very friendly and I am highly satisfied with their services."
            </div>
            <div class="testimonial-author">
                <div class="author-avatar">
                    <i class="fas fa-user"></i>
                </div>
                <div class="author-info">
                    <h4>Sarah Johnson</h4>
                    <p>Premium Member</p>
                </div>
            </div>
        </div>
        <div class="testimonial-card">
            <div class="testimonial-text">
                "Excellent service and wonderful staff. They're really helpful and very reliable to get your vehicle serviced."
            </div>
            <div class="testimonial-author">
                <div class="author-avatar">
                    <i class="fas fa-user"></i>
                </div>
                <div class="author-info">
                    <h4>Mike Brown</h4>
                    <p>Business Customer</p>
                </div>
            </div>
        </div>
    </div>
</div>

<% 
    List<Review> topReviews = (List<Review>) request.getAttribute("topReviews");
    String homePageError = (String) request.getAttribute("homePageError");
%>

<% if (homePageError != null && !homePageError.isEmpty()) { %>
    <p class="home-page-error"><i class="fas fa-exclamation-circle"></i> <%= homePageError %></p>
<% } %>

<% if (topReviews != null && !topReviews.isEmpty()) { %>
    <div class="reviews-grid">
        <% for (Review review : topReviews) { %>
            <div class="review-card">
                <div class="review-card-header">
                    <div class="review-card-avatar">
                        <%= review.getUsername().substring(0, 1).toUpperCase() %>
                    </div>
                    <div class="review-card-user">
                        <h4><%= review.getUsername() %></h4>
                        <p>Reviewed: <%= review.getServiceName() %></p>
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
<% } else if (homePageError == null) { %>
    <p class="no-reviews-message">No customer reviews available yet. Be the first to share your experience!</p>
<% } %>

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