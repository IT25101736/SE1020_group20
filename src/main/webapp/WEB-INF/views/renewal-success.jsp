<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.fitnesscenter.model.Member" %>
<%
    Member loggedMember = (Member) session.getAttribute("loggedMember");
    if (loggedMember == null) { response.sendRedirect("/login"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Renewal Submitted — Fitness Center</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Rajdhani:wght@500;600;700&family=Inter:wght@400;500;600&display=swap');
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { background: radial-gradient(ellipse at bottom, #1a1400 0%, #0a0a0a 100%); font-family: 'Inter', sans-serif; color: #e0e0e0; min-height: 100vh; display: flex; align-items: center; justify-content: center; overflow-x: hidden; }
        .night { position: fixed; width: 100%; height: 100%; transform: rotateZ(45deg); z-index: 0; pointer-events: none; }
        .shooting_star { position: absolute; height: 2px; background: linear-gradient(-45deg, #c9a84c, rgba(201,168,76,0)); border-radius: 999px; filter: drop-shadow(0 0 6px #c9a84c); animation: tail 3000ms ease-in-out infinite, shooting 3000ms ease-in-out infinite; }
        @keyframes tail { 0%{width:0} 30%{width:100px} 100%{width:0} }
        @keyframes shooting { 0%{transform:translateX(0)} 100%{transform:translateX(300px)} }
        .shooting_star:nth-child(1) { top:10%; left:5%; animation-delay:0ms; }
        .shooting_star:nth-child(2) { top:30%; left:20%; animation-delay:1000ms; }
        .shooting_star:nth-child(3) { top:50%; left:10%; animation-delay:2000ms; }
        .shooting_star:nth-child(4) { top:70%; left:30%; animation-delay:500ms; }
        .shooting_star:nth-child(5) { top:20%; left:60%; animation-delay:1500ms; }
        .card { position: relative; z-index: 1; background: rgba(17,17,17,0.95); border: 1px solid rgba(74,222,128,0.3); border-radius: 24px; padding: 56px 48px; text-align: center; max-width: 520px; width: 90%; box-shadow: 0 30px 60px rgba(0,0,0,0.6); backdrop-filter: blur(20px); }
        .icon { font-size: 72px; margin-bottom: 20px; animation: popIn 0.6s cubic-bezier(0.175,0.885,0.32,1.275); }
        @keyframes popIn { 0%{transform:scale(0)} 100%{transform:scale(1)} }
        h2 { font-family: 'Rajdhani', sans-serif; font-size: 36px; color: #4ade80; letter-spacing: 2px; margin-bottom: 12px; }
        p { font-size: 15px; color: #555; line-height: 1.7; margin-bottom: 28px; }
        .info-box { background: rgba(74,222,128,0.05); border: 1px solid rgba(74,222,128,0.15); border-radius: 12px; padding: 20px; margin-bottom: 28px; text-align: left; }
        .info-row { display: flex; justify-content: space-between; padding: 8px 0; font-size: 14px; border-bottom: 1px solid rgba(255,255,255,0.04); }
        .info-row:last-child { border-bottom: none; }
        .info-row .lbl { color: #555; }
        .info-row .val { color: #4ade80; font-weight: 600; }
        .queue-badge { display: inline-flex; align-items: center; gap: 8px; background: rgba(201,168,76,0.1); border: 1px solid rgba(201,168,76,0.3); color: #c9a84c; padding: 10px 20px; border-radius: 10px; font-size: 14px; font-weight: 600; margin-bottom: 28px; }
        .btn { display: inline-block; padding: 14px 32px; border-radius: 10px; font-size: 15px; font-weight: 700; cursor: pointer; border: none; transition: all 0.2s; font-family: 'Rajdhani', sans-serif; letter-spacing: 1px; text-transform: uppercase; text-decoration: none; background: linear-gradient(135deg, #c9a84c, #8b6914); color: #0a0a0a; }
        .btn:hover { transform: translateY(-2px); box-shadow: 0 10px 20px rgba(201,168,76,0.3); }
    </style>
</head>
<body>
<div class="night">
    <div class="shooting_star"></div><div class="shooting_star"></div>
    <div class="shooting_star"></div><div class="shooting_star"></div>
    <div class="shooting_star"></div>
</div>
<div class="card">
    <div class="icon">&#128203;</div>
    <h2>REQUEST SUBMITTED!</h2>
    <p>Your renewal request has been added to the admin queue. You will be notified once the admin confirms your payment.</p>
    <div class="queue-badge">
        &#9203; &nbsp; Your request is in the queue — FIFO processing
    </div>
    <div class="info-box">
        <div class="info-row"><span class="lbl">Member</span><span class="val"><%= loggedMember.getName() %></span></div>
        <div class="info-row"><span class="lbl">Member ID</span><span class="val"><%= loggedMember.getId() %></span></div>
        <div class="info-row"><span class="lbl">Status</span><span class="val">&#9203; Pending Admin Confirmation</span></div>
    </div>
    <a href="/member/dashboard" class="btn">Go to Dashboard &#8250;</a>
</div>
</body>
</html>