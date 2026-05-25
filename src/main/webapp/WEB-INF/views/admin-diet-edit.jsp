<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.fitnesscenter.model.Member" %>
<%@ page import="com.fitnesscenter.model.DietPlan" %>
<%@ page import="com.fitnesscenter.model.Admin" %>
<%
    Admin loggedAdmin = (Admin) session.getAttribute("loggedAdmin");
    if (loggedAdmin == null) { response.sendRedirect("/login"); return; }
    Member member     = (Member)   request.getAttribute("member");
    DietPlan dietPlan = (DietPlan) request.getAttribute("dietPlan");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Diet Plan — Admin</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Rajdhani:wght@500;600;700&family=Inter:wght@400;500;600&display=swap');
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { background: #0a0a0a; font-family: 'Inter', sans-serif; color: #e0e0e0; min-height: 100vh; }
        .sidebar { width: 260px; min-height: 100vh; background: #111; border-right: 1px solid #222; position: fixed; top: 0; left: 0; display: flex; flex-direction: column; }
        .sidebar-logo { padding: 28px 24px 24px; border-bottom: 1px solid #222; background: linear-gradient(135deg, #111 60%, #1a1400); }
        .logo-icon { font-size: 28px; margin-bottom: 8px; }
        .sidebar-logo h5 { font-family: 'Rajdhani', sans-serif; font-size: 22px; font-weight: 700; color: #c9a84c; letter-spacing: 1px; }
        .sidebar-logo p { font-size: 11px; color: #555; margin-top: 2px; letter-spacing: 2px; text-transform: uppercase; }
        .sidebar-user { padding: 16px 24px; border-bottom: 1px solid #1e1e1e; display: flex; align-items: center; gap: 12px; background: #0f0f0f; }
        .user-avatar { width: 38px; height: 38px; border-radius: 50%; background: linear-gradient(135deg, #c9a84c, #8b6914); display: flex; align-items: center; justify-content: center; font-size: 16px; font-weight: 700; color: #0a0a0a; font-family: 'Rajdhani', sans-serif; }
        .user-info strong { font-size: 14px; color: #e0e0e0; display: block; }
        .user-info span { font-size: 11px; color: #c9a84c; text-transform: uppercase; letter-spacing: 1px; }
        .nav-label { padding: 20px 24px 8px; font-size: 10px; color: #444; text-transform: uppercase; letter-spacing: 2px; font-weight: 600; }
        .sidebar a { display: flex; align-items: center; gap: 10px; padding: 12px 24px; color: #666; text-decoration: none; font-size: 14px; font-weight: 500; border-left: 3px solid transparent; transition: all 0.2s; }
        .sidebar a:hover { color: #c9a84c; background: rgba(201,168,76,0.05); border-left-color: #c9a84c; }
        .sidebar a.active { color: #c9a84c; background: rgba(201,168,76,0.08); border-left-color: #c9a84c; }
        .sidebar-footer { margin-top: auto; padding: 20px 24px; border-top: 1px solid #1e1e1e; }
        .sidebar-footer a { color: #444; font-size: 13px; text-decoration: none; display: flex; align-items: center; gap: 8px; transition: color 0.2s; }
        .sidebar-footer a:hover { color: #e05555; }
        .main { margin-left: 260px; min-height: 100vh; }
        .hero { position: relative; overflow: hidden; background: #0f0f0f; padding: 40px 40px 36px; border-bottom: 1px solid #1e1e1e; }
        .hero-bg { position: absolute; top: 0; right: 0; width: 50%; height: 100%; background: url('https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800&q=80') center/cover; opacity: 0.06; }
        .hero-bg-gradient { position: absolute; top: 0; right: 0; width: 55%; height: 100%; background: linear-gradient(to right, #0f0f0f 30%, transparent); }
        .hero-content { position: relative; z-index: 1; }
        .hero-tag { display: inline-block; background: rgba(201,168,76,0.15); color: #c9a84c; font-size: 11px; font-weight: 600; padding: 4px 12px; border-radius: 20px; text-transform: uppercase; letter-spacing: 2px; border: 1px solid rgba(201,168,76,0.3); margin-bottom: 12px; }
        .hero h1 { font-family: 'Rajdhani', sans-serif; font-size: 36px; font-weight: 700; color: #fff; line-height: 1.1; margin-bottom: 8px; }
        .hero h1 span { color: #c9a84c; }
        .hero p { font-size: 14px; color: #555; }
        .content { padding: 32px 40px; max-width: 800px; }
        .member-info { background: rgba(201,168,76,0.06); border: 1px solid rgba(201,168,76,0.15); border-radius: 12px; padding: 16px 20px; display: flex; gap: 20px; align-items: center; margin-bottom: 28px; }
        .member-info .mi-name { font-family: 'Rajdhani', sans-serif; font-size: 20px; font-weight: 700; color: #c9a84c; }
        .member-info .mi-id { font-size: 13px; color: #555; margin-top: 2px; }
        .card { background: #111; border: 1px solid #1e1e1e; border-radius: 14px; overflow: hidden; }
        .card-head { padding: 20px 24px; border-bottom: 1px solid #1e1e1e; background: #0f0f0f; }
        .card-head h5 { font-family: 'Rajdhani', sans-serif; font-size: 18px; font-weight: 700; color: #c9a84c; }
        .card-body { padding: 24px; }
        .form-group { margin-bottom: 18px; }
        .form-group label { display: block; font-size: 11px; font-weight: 600; color: #666; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 8px; }
        .form-group input, .form-group textarea { width: 100%; padding: 12px 14px; background: #0a0a0a; border: 1px solid #2a2a2a; border-radius: 10px; font-size: 14px; color: #e0e0e0; outline: none; transition: border 0.2s; font-family: 'Inter', sans-serif; }
        .form-group input:focus, .form-group textarea:focus { border-color: #c9a84c; }
        .form-group input::placeholder, .form-group textarea::placeholder { color: #333; }
        .form-group textarea { height: 90px; resize: vertical; }
        .form-hint { font-size: 11px; color: #444; margin-top: 5px; line-height: 1.5; }
        .btn { padding: 12px 22px; border-radius: 10px; font-size: 14px; font-weight: 600; cursor: pointer; border: none; transition: all 0.2s; font-family: 'Rajdhani', sans-serif; letter-spacing: 1px; text-transform: uppercase; text-decoration: none; display: inline-block; }
        .btn-gold { background: linear-gradient(135deg, #c9a84c, #8b6914); color: #0a0a0a; }
        .btn-gold:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(201,168,76,0.3); }
        .btn-outline { background: transparent; color: #666; border: 1px solid rgba(255,255,255,0.1); }
        .btn-outline:hover { border-color: #c9a84c; color: #c9a84c; }
        .btn-row { display: flex; gap: 12px; margin-top: 20px; }
    </style>
</head>
<body>

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
    <a href="/payments">&#128179; &nbsp; Payments</a>
    <a href="/renewals">&#128260; &nbsp; Renewal Queue</a>
    <a href="/manage/workouts">&#127947; &nbsp; Workouts</a>
    <a href="/admin/diet" class="active">&#127822; &nbsp; Diet Plans</a>
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
            <div class="hero-tag">Nutrition Management</div>
            <h1><%= dietPlan != null ? "Edit" : "Create" %> <span>Diet Plan</span></h1>
            <p>Set up a personalized nutrition plan for this member</p>
        </div>
    </div>

    <div class="content">

        <div class="member-info">
            <div>
                <div class="mi-name"><%= member != null ? member.getName() : "Unknown" %></div>
                <div class="mi-id"><%= member != null ? member.getId() : "" %> &nbsp;|&nbsp; <%= member != null ? member.getMembershipType() : "" %></div>
            </div>
        </div>

        <div class="card">
            <div class="card-head">
                <h5><%= dietPlan != null ? "&#9998; Edit Diet Plan" : "&#43; Create Diet Plan" %></h5>
            </div>
            <div class="card-body">
                <form method="POST" action="/admin/diet/save">
                    <input type="hidden" name="memberId" value="<%= member != null ? member.getId() : "" %>">
                    <div class="form-group">
                        <label>Diet Plan Name</label>
                        <input type="text" name="planName"
                               value="<%= dietPlan != null ? dietPlan.getPlanName() : "" %>"
                               placeholder="e.g. Keto Diet, High Protein, Balanced Diet" required>
                    </div>
                    <div class="form-group">
                        <label>&#9728; Breakfast Items</label>
                        <textarea name="breakfast" placeholder="e.g. 3 Eggs~200g Chicken Breast~100g Oats"><%= dietPlan != null ? dietPlan.getBreakfastItems() : "" %></textarea>
                        <div class="form-hint">&#9432; Separate food items with ~ (tilde). Use exact names: "3 Eggs", "200g Chicken Breast", "150g Rice", "1 Banana"</div>
                    </div>
                    <div class="form-group">
                        <label>&#9749; Lunch Items</label>
                        <textarea name="lunch" placeholder="e.g. 200g Chicken Breast~150g Rice~100g Broccoli"><%= dietPlan != null ? dietPlan.getLunchItems() : "" %></textarea>
                    </div>
                    <div class="form-group">
                        <label>&#127761; Dinner Items</label>
                        <textarea name="dinner" placeholder="e.g. 200g Beef~150g Sweet Potato~100g Spinach"><%= dietPlan != null ? dietPlan.getDinnerItems() : "" %></textarea>
                    </div>
                    <div class="form-group">
                        <label>&#127822; Snacks</label>
                        <textarea name="snacks" placeholder="e.g. 30g Almonds~1 Protein Shake"><%= dietPlan != null ? dietPlan.getSnackItems() : "" %></textarea>
                    </div>
                    <div class="form-group">
                        <label>Notes</label>
                        <input type="text" name="notes"
                               value="<%= dietPlan != null ? dietPlan.getNotes() : "" %>"
                               placeholder="e.g. High fat low carb diet for fat loss">
                    </div>
                    <div class="btn-row">
                        <a href="/admin/diet" class="btn btn-outline">&#8592; Back</a>
                        <button type="submit" class="btn btn-gold">&#128190; Save Diet Plan</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
</body>
</html>