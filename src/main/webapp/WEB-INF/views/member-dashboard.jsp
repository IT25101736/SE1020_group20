<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.fitnesscenter.model.Member" %>
<%
    Member loggedMember = (Member) session.getAttribute("loggedMember");
    if (loggedMember == null) {
        response.sendRedirect("/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Member Dashboard — Fitness Center</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Rajdhani:wght@500;600;700&family=Inter:wght@400;500;600&display=swap');
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { background: radial-gradient(ellipse at bottom, #1a1400 0%, #0a0a0a 100%); font-family: 'Inter', sans-serif; color: #e0e0e0; min-height: 100vh; overflow-x: hidden; }
        .night { position: fixed; width: 100%; height: 100%; transform: rotateZ(45deg); z-index: 0; pointer-events: none; }
        .shooting_star { position: absolute; left: 50%; top: 50%; height: 2px; background: linear-gradient(-45deg, #c9a84c, rgba(201,168,76,0)); border-radius: 999px; filter: drop-shadow(0 0 6px #c9a84c); animation: tail 3000ms ease-in-out infinite, shooting 3000ms ease-in-out infinite; }
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
        .hero-bg { position: absolute; top: 0; right: 0; width: 50%; height: 100%; background: url('https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=800&q=80') center/cover; opacity: 0.06; }
        .hero-bg-gradient { position: absolute; top: 0; right: 0; width: 55%; height: 100%; background: linear-gradient(to right, #0f0f0f 30%, transparent); }
        .hero-content { position: relative; z-index: 1; }
        .hero-tag { display: inline-block; background: rgba(201,168,76,0.15); color: #c9a84c; font-size: 11px; font-weight: 600; padding: 4px 12px; border-radius: 20px; text-transform: uppercase; letter-spacing: 2px; border: 1px solid rgba(201,168,76,0.3); margin-bottom: 12px; }
        .hero h1 { font-family: 'Rajdhani', sans-serif; font-size: 36px; font-weight: 700; color: #ffffff; line-height: 1.1; margin-bottom: 8px; }
        .hero h1 span { color: #c9a84c; }
        .hero p { font-size: 14px; color: #555; }
        .status-pill { display: inline-flex; align-items: center; gap: 6px; background: rgba(74,222,128,0.1); color: #4ade80; font-size: 12px; font-weight: 600; padding: 6px 14px; border-radius: 20px; border: 1px solid rgba(74,222,128,0.2); margin-top: 16px; }
        .status-dot { width: 7px; height: 7px; border-radius: 50%; background: #4ade80; animation: pulse 2s infinite; }
        @keyframes pulse { 0%,100%{opacity:1} 50%{opacity:0.4} }
        .content { padding: 32px 40px; }
        .member-id-badge { display: inline-flex; align-items: center; gap: 8px; background: rgba(201,168,76,0.1); border: 1px solid rgba(201,168,76,0.3); color: #c9a84c; padding: 8px 16px; border-radius: 8px; font-family: 'Rajdhani', sans-serif; font-size: 16px; font-weight: 700; margin-bottom: 24px; }
        .stats-row { display: grid; grid-template-columns: repeat(3,1fr); gap: 16px; margin-bottom: 24px; }
        .stat-mini { background: rgba(255,255,255,0.04); backdrop-filter: blur(15px); border: 1px solid rgba(255,255,255,0.08); border-radius: 16px; padding: 20px; transition: all 0.3s; }
        .stat-mini:hover { transform: translateY(-4px); border-color: rgba(201,168,76,0.3); }
        .stat-mini .icon { font-size: 24px; margin-bottom: 10px; }
        .stat-mini .num { font-family: 'Rajdhani', sans-serif; font-size: 28px; font-weight: 700; color: #c9a84c; }
        .stat-mini .lbl { font-size: 11px; color: #555; text-transform: uppercase; letter-spacing: 1px; margin-top: 4px; }
        .cards-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px; }
        .glass-card { background: rgba(255,255,255,0.04); backdrop-filter: blur(15px); border: 1px solid rgba(255,255,255,0.08); border-radius: 20px; overflow: hidden; transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275); }
        .glass-card:hover { transform: translateY(-6px); background: rgba(255,255,255,0.06); border-color: rgba(201,168,76,0.4); box-shadow: 0 20px 40px rgba(0,0,0,0.4); }
        .card-header { padding: 18px 20px; border-bottom: 1px solid rgba(255,255,255,0.06); background: rgba(0,0,0,0.2); display: flex; align-items: center; gap: 10px; }
        .card-header .icon { font-size: 20px; }
        .card-header h5 { font-family: 'Rajdhani', sans-serif; font-size: 16px; font-weight: 700; color: #c9a84c; }
        .card-body { padding: 20px; }
        .info-row { display: flex; justify-content: space-between; align-items: center; padding: 11px 0; border-bottom: 1px solid rgba(255,255,255,0.04); }
        .info-row:last-child { border-bottom: none; }
        .info-label { font-size: 12px; color: #444; text-transform: uppercase; letter-spacing: 1px; }
        .info-value { font-size: 14px; color: #e0e0e0; font-weight: 500; }
        .info-value.gold { color: #c9a84c; }
        .trainer-badge { display: inline-flex; align-items: center; gap: 6px; background: rgba(91,196,245,0.1); border: 1px solid rgba(91,196,245,0.2); color: #5bc4f5; padding: 4px 12px; border-radius: 20px; font-size: 13px; font-weight: 600; }
        .plan-card { grid-column: span 2; background: rgba(255,255,255,0.04); backdrop-filter: blur(15px); border: 1px solid rgba(255,255,255,0.08); border-radius: 20px; overflow: hidden; transition: all 0.4s; }
        .plan-card:hover { border-color: rgba(201,168,76,0.4); box-shadow: 0 20px 40px rgba(0,0,0,0.4); }
        .plan-grid { display: grid; grid-template-columns: 1fr 1fr 1fr; }
        .plan-section { padding: 24px; }
        .plan-section:not(:last-child) { border-right: 1px solid rgba(255,255,255,0.05); }
        .plan-section h6 { font-family: 'Rajdhani', sans-serif; font-size: 14px; font-weight: 700; color: #c9a84c; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 12px; display: flex; align-items: center; gap: 8px; }
        .plan-text { font-size: 14px; color: #666; line-height: 1.7; }
        .quick-links { grid-column: span 2; display: grid; grid-template-columns: repeat(3,1fr); gap: 16px; margin-top: 4px; }
        .quick-link { background: rgba(255,255,255,0.04); backdrop-filter: blur(15px); border: 1px solid rgba(255,255,255,0.08); border-radius: 16px; padding: 20px; text-decoration: none; display: flex; align-items: center; gap: 14px; transition: all 0.3s; }
        .quick-link:hover { border-color: rgba(201,168,76,0.3); transform: translateY(-4px); background: rgba(255,255,255,0.06); }
        .quick-link .ql-icon { font-size: 28px; }
        .quick-link .ql-title { font-family: 'Rajdhani', sans-serif; font-size: 16px; font-weight: 700; color: #c9a84c; }
        .quick-link .ql-sub { font-size: 12px; color: #555; margin-top: 2px; }
        .renewal-card { grid-column: span 2; background: rgba(74,222,128,0.06); border: 1px solid rgba(74,222,128,0.2); border-radius: 20px; padding: 28px; display: flex; justify-content: space-between; align-items: center; transition: all 0.3s; }
        .renewal-card:hover { border-color: rgba(74,222,128,0.4); box-shadow: 0 16px 32px rgba(74,222,128,0.1); }
        .renewal-card h4 { font-family: 'Rajdhani', sans-serif; font-size: 20px; font-weight: 700; color: #4ade80; margin-bottom: 4px; }
        .renewal-card p { font-size: 13px; color: #555; }
        .renewal-select { background: rgba(0,0,0,0.4); border: 1px solid rgba(74,222,128,0.3); color: #e0e0e0; padding: 10px 14px; border-radius: 8px; font-size: 13px; margin-right: 10px; outline: none; font-family: 'Inter', sans-serif; }
        .renewal-select:focus { border-color: #4ade80; }
        .renewal-select option { background: #111; }
        .btn-green { background: linear-gradient(135deg, #4ade80, #16a34a); color: #0a0a0a; border: none; padding: 11px 22px; border-radius: 8px; font-size: 13px; font-weight: 700; cursor: pointer; font-family: 'Rajdhani', sans-serif; letter-spacing: 1px; text-transform: uppercase; transition: all 0.2s; }
        .btn-green:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(74,222,128,0.3); }
    </style>
</head>
<body>

<div class="night">
    <div class="shooting_star"></div>
    <div class="shooting_star"></div>
    <div class="shooting_star"></div>
    <div class="shooting_star"></div>
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
    <a href="/member/dashboard" class="active">&#128187; &nbsp; Dashboard</a>
    <a href="/member/workout">&#127947; &nbsp; My Workout</a>
    <a href="/member/diet">&#127822; &nbsp; My Diet Plan</a>
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
            <div class="hero-tag">Member Portal</div>
            <h1>Welcome, <span><%= loggedMember.getName() %></span></h1>
            <p>Track your fitness journey and stay on top of your goals</p>
            <div class="status-pill">
                <div class="status-dot"></div>
                Active Member
            </div>
        </div>
    </div>

    <div class="content">
        <div class="member-id-badge">
            &#127915; &nbsp; Member ID: &nbsp;<%= loggedMember.getId() %>
        </div>

        <div class="stats-row">
            <div class="stat-mini">
                <div class="icon">&#11088;</div>
                <div class="num"><%= loggedMember.getMembershipType() %></div>
                <div class="lbl">Membership Type</div>
            </div>
            <div class="stat-mini">
                <div class="icon">&#128197;</div>
                <div class="num" style="font-size:20px"><%= loggedMember.getExpiryDate() %></div>
                <div class="lbl">Expiry Date</div>
            </div>
            <div class="stat-mini">
                <div class="icon">&#128179;</div>
                <div class="num" style="color:<%= loggedMember.getPaymentStatus().equals("Paid") ? "#4ade80" : "#e05555" %>; font-size:22px">
                    <%= loggedMember.getPaymentStatus().equals("Paid") ? "✓ Paid" : "⚠ " + loggedMember.getPaymentStatus() %>
                </div>
                <div class="lbl">Payment Status</div>
            </div>
        </div>

        <div class="cards-grid">

            <div class="glass-card">
                <div class="card-header">
                    <span class="icon">&#128100;</span>
                    <h5>My Profile</h5>
                </div>
                <div class="card-body">
                    <div class="info-row">
                        <span class="info-label">Full Name</span>
                        <span class="info-value"><%= loggedMember.getName() %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Email</span>
                        <span class="info-value"><%= loggedMember.getEmail() %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Phone</span>
                        <span class="info-value"><%= loggedMember.getPhone() %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Assigned Trainer</span>
                        <span class="trainer-badge">&#127947; <%= loggedMember.getTrainerName() %></span>
                    </div>
                </div>
            </div>

            <div class="glass-card">
                <div class="card-header">
                    <span class="icon">&#11088;</span>
                    <h5>Membership Status</h5>
                </div>
                <div class="card-body">
                    <div class="info-row">
                        <span class="info-label">Member ID</span>
                        <span class="info-value gold"><%= loggedMember.getId() %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Membership Type</span>
                        <span class="info-value gold"><%= loggedMember.getMembershipType() %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Join Date</span>
                        <span class="info-value"><%= loggedMember.getJoinDate() %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Expiry Date</span>
                        <span class="info-value" style="color:#e05555"><%= loggedMember.getExpiryDate() %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Payment Status</span>
                        <span class="info-value" style="color:<%= loggedMember.getPaymentStatus().equals("Paid") ? "#4ade80" : "#e05555" %>">
                            <%= loggedMember.getPaymentStatus().equals("Paid") ? "✓ Paid" : "⚠ " + loggedMember.getPaymentStatus() %>
                        </span>
                    </div>
                </div>
            </div>

            <div class="plan-card">
                <div class="card-header">
                    <span class="icon">&#128200;</span>
                    <h5>My Fitness Plans</h5>
                </div>
                <div class="plan-grid">
                    <div class="plan-section">
                        <h6>&#127947; Workout Plan</h6>
                        <p class="plan-text"><%= loggedMember.getWorkoutPlan() %></p>
                    </div>
                    <div class="plan-section">
                        <h6>&#127822; Diet Plan</h6>
                        <p class="plan-text"><%= loggedMember.getDietPlan() %></p>
                    </div>
                    <div class="plan-section">
                        <h6>&#128100; My Trainer</h6>
                        <p class="plan-text"><%= loggedMember.getTrainerName() %></p>
                    </div>
                </div>
            </div>

            <!-- Quick Links -->
            <div class="quick-links">
                <a href="/member/workout" class="quick-link">
                    <span class="ql-icon">&#127947;</span>
                    <div>
                        <div class="ql-title">My Workout</div>
                        <div class="ql-sub">View your training plan</div>
                    </div>
                </a>
                <a href="#" class="quick-link">
                    <span class="ql-icon">&#127822;</span>
                    <div>
                        <div class="ql-title">My Diet Plan</div>
                        <div class="ql-sub">View nutrition guide</div>
                    </div>
                </a>
                <a href="/member/payment" class="quick-link">
                    <span class="ql-icon">&#128179;</span>
                    <div>
                        <div class="ql-title">Payment</div>
                        <div class="ql-sub">Manage membership</div>
                    </div>
                </a>
            </div>

            <!-- Renewal Request Card -->
            <div class="renewal-card">
                <div>
                    <h4>&#128260; Request Membership Renewal</h4>
                    <p>Submit a renewal request — staff will process it in queue order (FIFO)</p>
                </div>
                <form method="POST" action="/renewal/request" style="display:flex;align-items:center;gap:10px">
                    <select name="requestedPlan" class="renewal-select">
                        <option value="Basic">Basic Plan</option>
                        <option value="Premium">Premium Plan</option>
                        <option value="VIP Elite">VIP Elite Plan</option>
                    </select>
                    <button type="submit" class="btn-green">&#128260; Submit Request</button>
                </form>
            </div>

        </div>
    </div>
</div>

</body>
</html>