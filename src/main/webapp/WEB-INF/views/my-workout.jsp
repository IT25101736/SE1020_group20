<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.fitnesscenter.model.Member" %>
<%@ page import="com.fitnesscenter.model.MemberWorkout" %>
<%@ page import="com.fitnesscenter.model.WorkoutPlan" %>
<%
    Member loggedMember = (Member) session.getAttribute("loggedMember");
    if (loggedMember == null) { response.sendRedirect("/login"); return; }
    MemberWorkout workout = (MemberWorkout) request.getAttribute("workout");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Workout — Fitness Center</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Rajdhani:wght@500;600;700&family=Inter:wght@400;500;600&display=swap');
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { background: radial-gradient(ellipse at bottom, #1a1400 0%, #0a0a0a 100%); font-family: 'Inter', sans-serif; color: #e0e0e0; min-height: 100vh; overflow-x: hidden; }
        .night { position: fixed; width: 100%; height: 100%; transform: rotateZ(45deg); z-index: 0; pointer-events: none; }
        .shooting_star { position: absolute; height: 2px; background: linear-gradient(-45deg, #c9a84c, rgba(201,168,76,0)); border-radius: 999px; filter: drop-shadow(0 0 6px #c9a84c); animation: tail 3000ms ease-in-out infinite, shooting 3000ms ease-in-out infinite; }
        @keyframes tail { 0%{width:0} 30%{width:100px} 100%{width:0} }
        @keyframes shooting { 0%{transform:translateX(0)} 100%{transform:translateX(300px)} }
        .shooting_star:nth-child(1) { top:10%; left:5%; animation-delay:0ms; }
        .shooting_star:nth-child(2) { top:30%; left:20%; animation-delay:1000ms; }
        .shooting_star:nth-child(3) { top:50%; left:10%; animation-delay:2000ms; }
        .shooting_star:nth-child(4) { top:70%; left:30%; animation-delay:500ms; }
        .shooting_star:nth-child(5) { top:20%; left:60%; animation-delay:1500ms; }
        .sidebar { width: 260px; min-height: 100vh; background: rgba(17,17,17,0.85); backdrop-filter: blur(20px); border-right: 1px solid rgba(201,168,76,0.15); position: fixed; top: 0; left: 0; display: flex; flex-direction: column; z-index: 10; }
        .sidebar-logo { padding: 28px 24px 24px; border-bottom: 1px solid rgba(201,168,76,0.15); background: linear-gradient(135deg, rgba(17,17,17,0.9) 60%, rgba(26,20,0,0.9)); }
        .logo-icon { font-size: 28px; margin-bottom: 8px; }
        .sidebar-logo h5 { font-family: 'Rajdhani', sans-serif; font-size: 22px; font-weight: 700; color: #c9a84c; letter-spacing: 1px; }
        .sidebar-logo p { font-size: 11px; color: #555; margin-top: 2px; letter-spacing: 2px; text-transform: uppercase; }
        .sidebar-user { padding: 16px 24px; border-bottom: 1px solid rgba(255,255,255,0.05); display: flex; align-items: center; gap: 12px; background: rgba(0,0,0,0.2); }
        .user-avatar { width: 38px; height: 38px; border-radius: 50%; background: linear-gradient(135deg, #c9a84c, #8b6914); display: flex; align-items: center; justify-content: center; font-size: 16px; font-weight: 700; color: #0a0a0a; font-family: 'Rajdhani', sans-serif; }
        .user-info strong { font-size: 14px; color: #e0e0e0; display: block; }
        .user-info span { font-size: 11px; color: #c9a84c; text-transform: uppercase; letter-spacing: 1px; }
        .nav-label { padding: 20px 24px 8px; font-size: 10px; color: #444; text-transform: uppercase; letter-spacing: 2px; font-weight: 600; }
        .sidebar a { display: flex; align-items: center; gap: 10px; padding: 12px 24px; color: #666; text-decoration: none; font-size: 14px; font-weight: 500; border-left: 3px solid transparent; transition: all 0.2s; }
        .sidebar a:hover { color: #c9a84c; background: rgba(201,168,76,0.05); border-left-color: #c9a84c; }
        .sidebar a.active { color: #c9a84c; background: rgba(201,168,76,0.08); border-left-color: #c9a84c; }
        .sidebar-footer { margin-top: auto; padding: 20px 24px; border-top: 1px solid rgba(255,255,255,0.05); }
        .sidebar-footer a { color: #444; font-size: 13px; text-decoration: none; display: flex; align-items: center; gap: 8px; transition: color 0.2s; }
        .sidebar-footer a:hover { color: #e05555; }
        .main { margin-left: 260px; min-height: 100vh; position: relative; z-index: 1; }
        .hero { position: relative; overflow: hidden; background: rgba(15,15,15,0.7); backdrop-filter: blur(10px); padding: 40px 40px 36px; border-bottom: 1px solid rgba(201,168,76,0.15); }
        .hero-bg { position: absolute; top: 0; right: 0; width: 50%; height: 100%; background: url('https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800&q=80') center/cover; opacity: 0.06; }
        .hero-bg-gradient { position: absolute; top: 0; right: 0; width: 55%; height: 100%; background: linear-gradient(to right, #0f0f0f 30%, transparent); }
        .hero-content { position: relative; z-index: 1; }
        .hero-tag { display: inline-block; background: rgba(201,168,76,0.15); color: #c9a84c; font-size: 11px; font-weight: 600; padding: 4px 12px; border-radius: 20px; text-transform: uppercase; letter-spacing: 2px; border: 1px solid rgba(201,168,76,0.3); margin-bottom: 12px; }
        .hero h1 { font-family: 'Rajdhani', sans-serif; font-size: 36px; font-weight: 700; color: #ffffff; line-height: 1.1; margin-bottom: 8px; }
        .hero h1 span { color: #c9a84c; }
        .hero p { font-size: 14px; color: #555; }
        .content { padding: 32px 40px; }
        .plan-badge { display: inline-flex; align-items: center; gap: 10px; background: rgba(201,168,76,0.1); border: 1px solid rgba(201,168,76,0.3); color: #c9a84c; padding: 10px 20px; border-radius: 10px; font-family: 'Rajdhani', sans-serif; font-size: 18px; font-weight: 700; margin-bottom: 28px; letter-spacing: 1px; }
        .days-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(340px, 1fr)); gap: 20px; }
        .day-card { background: rgba(255,255,255,0.04); backdrop-filter: blur(15px); border: 1px solid rgba(255,255,255,0.08); border-radius: 18px; overflow: hidden; transition: all 0.3s; }
        .day-card:hover { border-color: rgba(201,168,76,0.3); transform: translateY(-4px); box-shadow: 0 16px 32px rgba(0,0,0,0.3); }
        .day-card.rest { opacity: 0.5; }
        .day-card.rest:hover { transform: none; }
        .day-header { padding: 16px 20px; background: rgba(0,0,0,0.2); border-bottom: 1px solid rgba(255,255,255,0.06); display: flex; justify-content: space-between; align-items: center; }
        .day-name { font-family: 'Rajdhani', sans-serif; font-size: 18px; font-weight: 700; color: #c9a84c; }
        .day-focus { font-size: 12px; color: #555; font-weight: 500; background: rgba(255,255,255,0.04); padding: 4px 10px; border-radius: 20px; border: 1px solid rgba(255,255,255,0.08); }
        .day-body { padding: 16px 20px; }
        .exercise-row { display: flex; justify-content: space-between; align-items: center; padding: 10px 0; border-bottom: 1px solid rgba(255,255,255,0.04); }
        .exercise-row:last-child { border-bottom: none; }
        .exercise-name { font-size: 14px; color: #e0e0e0; font-weight: 500; display: flex; align-items: center; gap: 8px; }
        .exercise-name::before { content: ''; width: 6px; height: 6px; border-radius: 50%; background: #c9a84c; flex-shrink: 0; }
        .exercise-sets { font-family: 'Rajdhani', sans-serif; font-size: 15px; font-weight: 700; color: #c9a84c; background: rgba(201,168,76,0.1); padding: 3px 10px; border-radius: 6px; border: 1px solid rgba(201,168,76,0.2); white-space: nowrap; }
        .rest-text { text-align: center; padding: 20px; font-size: 14px; color: #333; }
        .no-workout { background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.06); border-radius: 20px; padding: 60px; text-align: center; }
        .no-workout .icon { font-size: 56px; margin-bottom: 16px; }
        .no-workout h3 { font-family: 'Rajdhani', sans-serif; font-size: 24px; color: #c9a84c; margin-bottom: 8px; }
        .no-workout p { font-size: 14px; color: #555; line-height: 1.7; }
    </style>
</head>
<body>
<div class="night">
    <div class="shooting_star"></div><div class="shooting_star"></div>
    <div class="shooting_star"></div><div class="shooting_star"></div>
    <div class="shooting_star"></div>
</div>
<div class="sidebar">
    <div class="sidebar-logo">
        <div class="logo-icon">&#127947;</div>
        <h5>FITNESS CENTER</h5>
        <p>Member Portal</p>
    </div>
    <div class="sidebar-user">
        <div class="user-avatar"><%= loggedMember.getName().substring(0,1).toUpperCase() %></div>
        <div class="user-info">
            <strong><%= loggedMember.getName() %></strong>
            <span>Member</span>
        </div>
    </div>
    <div class="nav-label">My Account</div>
    <a href="/member/dashboard">&#128187; &nbsp; Dashboard</a>
    <a href="/member/workout" class="active">&#127947; &nbsp; My Workout</a>
    <a href="#">&#127822; &nbsp; My Diet Plan</a>
    <a href="#">&#128100; &nbsp; My Trainer</a>
    <a href="/member/payment">&#128179; &nbsp; Payment & Membership</a>
    <div class="sidebar-footer">
        <a href="/member/logout">&#128275; &nbsp; Sign Out</a>
    </div>
</div>
<div class="main">
    <div class="hero">
        <div class="hero-bg"></div>
        <div class="hero-bg-gradient"></div>
        <div class="hero-content">
            <div class="hero-tag">My Workout</div>
            <h1>Your <span>Training Plan</span></h1>
            <p>Follow your personalized workout schedule assigned by your trainer</p>
        </div>
    </div>
    <div class="content">
        <% if (workout == null) { %>
            <div class="no-workout">
                <div class="icon">&#127947;</div>
                <h3>No Workout Plan Assigned Yet</h3>
                <p>Your trainer hasn't assigned a workout plan yet.<br>Please contact the front desk or your personal trainer.</p>
            </div>
        <% } else { %>
            <div class="plan-badge">
                &#127919; &nbsp; <%= workout.getPlanType() %> Plan
            </div>
            <div class="days-grid">
                <% for (WorkoutPlan day : workout.getDays()) {
                    boolean isRest = day.getExercises().equals("Recovery Day");
                %>
                <div class="day-card <%= isRest ? "rest" : "" %>">
                    <div class="day-header">
                        <span class="day-name">&#128197; <%= day.getDay() %></span>
                        <span class="day-focus"><%= day.getFocus() %></span>
                    </div>
                    <div class="day-body">
                        <% if (isRest) { %>
                            <div class="rest-text">&#128564; Rest & Recovery Day</div>
                        <% } else {
                            String[] exercises = day.getExercises().split(",");
                            for (String ex : exercises) {
                                ex = ex.trim();
                                // Split exercise name from sets/reps (last token with x)
                                int lastSpace = ex.lastIndexOf(" ");
                                String exName = lastSpace > 0 ? ex.substring(0, lastSpace) : ex;
                                String exSets = lastSpace > 0 ? ex.substring(lastSpace + 1) : "";
                        %>
                            <div class="exercise-row">
                                <span class="exercise-name"><%= exName %></span>
                                <span class="exercise-sets"><%= exSets %></span>
                            </div>
                        <% } } %>
                    </div>
                </div>
                <% } %>
            </div>
        <% } %>
    </div>
</div>
</body>
</html>