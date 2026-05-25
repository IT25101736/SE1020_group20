<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.fitnesscenter.model.Admin" %>
<%@ page import="com.fitnesscenter.model.Member" %>
<%@ page import="com.fitnesscenter.model.MemberWorkout" %>
<%@ page import="com.fitnesscenter.model.WorkoutPlan" %>
<%
    Admin loggedAdmin = (Admin) session.getAttribute("loggedAdmin");
    if (loggedAdmin == null) { response.sendRedirect("/login"); return; }
    Member member   = (Member) request.getAttribute("member");
    MemberWorkout workout = (MemberWorkout) request.getAttribute("workout");
    String planType = (String) request.getAttribute("planType");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Assign Workout — Fitness Center</title>
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
        .member-info { background: rgba(201,168,76,0.06); border: 1px solid rgba(201,168,76,0.15); border-radius: 14px; padding: 20px 24px; margin-bottom: 28px; display: flex; align-items: center; gap: 16px; }
        .member-avatar { width: 48px; height: 48px; border-radius: 50%; background: linear-gradient(135deg, #c9a84c, #8b6914); display: flex; align-items: center; justify-content: center; font-size: 20px; font-weight: 700; color: #0a0a0a; font-family: 'Rajdhani', sans-serif; }
        .member-details strong { font-size: 16px; color: #e0e0e0; display: block; }
        .member-details span { font-size: 12px; color: #555; }
        .plan-type-badge { margin-left: auto; background: rgba(201,168,76,0.1); border: 1px solid rgba(201,168,76,0.3); color: #c9a84c; padding: 8px 16px; border-radius: 8px; font-family: 'Rajdhani', sans-serif; font-size: 16px; font-weight: 700; }
        .day-block { background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.06); border-radius: 16px; padding: 24px; margin-bottom: 20px; }
        .day-block-header { display: flex; align-items: center; gap: 12px; margin-bottom: 16px; }
        .day-label { font-family: 'Rajdhani', sans-serif; font-size: 18px; font-weight: 700; color: #c9a84c; min-width: 100px; }
        .focus-input { background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.1); border-radius: 8px; padding: 8px 12px; color: #e0e0e0; font-size: 13px; outline: none; transition: border 0.2s; font-family: 'Inter', sans-serif; flex: 1; }
        .focus-input:focus { border-color: #c9a84c; }
        .exercises-input { width: 100%; background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.1); border-radius: 8px; padding: 10px 14px; color: #e0e0e0; font-size: 13px; outline: none; transition: border 0.2s; font-family: 'Inter', sans-serif; min-height: 70px; resize: vertical; }
        .exercises-input:focus { border-color: #c9a84c; }
        .exercises-label { font-size: 11px; color: #444; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 6px; display: block; }
        .exercises-hint { font-size: 11px; color: #333; margin-top: 4px; }
        .btn-row { display: flex; gap: 12px; margin-top: 28px; }
        .btn { padding: 12px 28px; border-radius: 10px; font-size: 14px; font-weight: 600; cursor: pointer; border: none; transition: all 0.2s; font-family: 'Rajdhani', sans-serif; letter-spacing: 1px; text-transform: uppercase; text-decoration: none; }
        .btn-gold { background: linear-gradient(135deg, #c9a84c, #8b6914); color: #0a0a0a; }
        .btn-gold:hover { transform: translateY(-2px); box-shadow: 0 10px 20px rgba(201,168,76,0.3); }
        .btn-outline { background: transparent; color: #666; border: 1px solid rgba(255,255,255,0.1); }
        .btn-outline:hover { border-color: #c9a84c; color: #c9a84c; }
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
        <p>Admin Control Panel</p>
    </div>
    <div class="sidebar-user">
        <div class="user-avatar"><%= loggedAdmin.getUsername().substring(0,1).toUpperCase() %></div>
        <div class="user-info">
            <strong><%= loggedAdmin.getUsername() %></strong>
            <span><%= loggedAdmin.getRole().equals("superadmin") ? "Manager" : "Staff" %></span>
        </div>
    </div>
    <div class="nav-label">Main Menu</div>
    <a href="/dashboard">&#128187; &nbsp; Dashboard</a>
    <a href="/members">&#128101; &nbsp; Members</a>
    <a href="#">&#128179; &nbsp; Payments</a>
    <a href="/manage/workouts" class="active">&#127947; &nbsp; Workouts</a>
    <a href="#">&#128200; &nbsp; Reports</a>
    <div class="nav-label">System</div>
    <a href="#">&#9881; &nbsp; Settings</a>
    <div class="sidebar-footer">
        <a href="/logout">&#128275; &nbsp; Sign Out</a>
    </div>
</div>
<div class="main">
    <div class="hero">
        <div class="hero-bg"></div>
        <div class="hero-bg-gradient"></div>
        <div class="hero-content">
            <div class="hero-tag">Assign Workout</div>
            <h1>Customize <span>Workout Plan</span></h1>
            <p>Edit exercises, sets and reps for each day</p>
        </div>
    </div>
    <div class="content">

        <div class="member-info">
            <div class="member-avatar"><%= member.getName().substring(0,1).toUpperCase() %></div>
            <div class="member-details">
                <strong><%= member.getName() %></strong>
                <span><%= member.getId() %> &nbsp;|&nbsp; <%= member.getEmail() %></span>
            </div>
            <div class="plan-type-badge">&#127919; <%= planType %></div>
        </div>

        <form method="POST" action="/manage/workouts/save">
            <input type="hidden" name="memberId" value="<%= member.getId() %>">
            <input type="hidden" name="planType" value="<%= planType %>">

            <% for (WorkoutPlan day : workout.getDays()) { %>
            <div class="day-block">
                <div class="day-block-header">
                    <span class="day-label">&#128197; <%= day.getDay() %></span>
                    <input type="hidden" name="days" value="<%= day.getDay() %>">
                    <input type="text" name="focuses" value="<%= day.getFocus() %>"
                           class="focus-input" placeholder="Focus (e.g. Chest & Back)">
                </div>
                <span class="exercises-label">Exercises — format: Exercise SetsxReps (comma separated)</span>
                <textarea name="exercises" class="exercises-input"><%= day.getExercises() %></textarea>
                <div class="exercises-hint">Example: Bench Press 4x8, Incline DB Press 3x10, Cable Flyes 3x15</div>
            </div>
            <% } %>

            <div class="btn-row">
                <a href="/manage/workouts" class="btn btn-outline">&#8592; Back</a>
                <button type="submit" class="btn btn-gold">&#10003; Save Workout Plan</button>
            </div>
        </form>

    </div>
</div>
</body>
</html>