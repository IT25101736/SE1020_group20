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
    <title>Payment & Membership — Fitness Center</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Rajdhani:wght@500;600;700&family=Inter:wght@400;500;600&family=Bebas+Neue&display=swap');
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { background: radial-gradient(ellipse at bottom, #1a1400 0%, #0a0a0a 100%); font-family: 'Inter', sans-serif; color: #e0e0e0; min-height: 100vh; overflow-x: hidden; }
        .night { position: fixed; width: 100%; height: 100%; transform: rotateZ(45deg); z-index: 0; pointer-events: none; }
        .shooting_star { position: absolute; height: 2px; background: linear-gradient(-45deg, #c9a84c, rgba(201,168,76,0)); border-radius: 999px; filter: drop-shadow(0 0 6px #c9a84c); animation: tail 3000ms ease-in-out infinite, shooting 3000ms ease-in-out infinite; }
        @keyframes tail { 0%{width:0} 30%{width:100px} 100%{width:0} }
        @keyframes shooting { 0%{transform:translateX(0)} 100%{transform:translateX(300px)} }
        .shooting_star:nth-child(1){top:10%;left:5%;animation-delay:0ms}
        .shooting_star:nth-child(2){top:30%;left:20%;animation-delay:1000ms}
        .shooting_star:nth-child(3){top:50%;left:10%;animation-delay:2000ms}
        .shooting_star:nth-child(4){top:70%;left:30%;animation-delay:500ms}
        .shooting_star:nth-child(5){top:20%;left:60%;animation-delay:1500ms}
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
        .hero h1 { font-family: 'Rajdhani', sans-serif; font-size: 36px; font-weight: 700; color: #fff; line-height: 1.1; margin-bottom: 8px; }
        .hero h1 span { color: #c9a84c; }
        .hero p { font-size: 14px; color: #555; }
        .content { padding: 32px 40px; }

        /* Current membership status bar */
        .status-bar { background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.08); border-radius: 14px; padding: 20px 24px; display: flex; justify-content: space-between; align-items: center; margin-bottom: 32px; flex-wrap: wrap; gap: 16px; }
        .status-item .s-label { font-size: 11px; color: #444; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 4px; }
        .status-item .s-value { font-size: 16px; font-weight: 600; color: #c9a84c; font-family: 'Rajdhani', sans-serif; }

        /* Steps */
        .steps { display: flex; align-items: center; margin-bottom: 32px; }
        .step { display: flex; align-items: center; gap: 10px; }
        .step-num { width: 34px; height: 34px; border-radius: 50%; border: 1px solid rgba(255,255,255,0.1); display: flex; align-items: center; justify-content: center; font-size: 13px; font-weight: 700; color: #444; transition: all 0.3s; flex-shrink: 0; }
        .step.active .step-num { background: linear-gradient(135deg, #c9a84c, #8b6914); color: #0a0a0a; border-color: #c9a84c; }
        .step.done .step-num { background: rgba(74,222,128,0.15); color: #4ade80; border-color: #4ade80; }
        .step-label { font-size: 13px; color: #444; font-weight: 500; white-space: nowrap; }
        .step.active .step-label { color: #c9a84c; font-weight: 600; }
        .step.done .step-label { color: #4ade80; }
        .step-line { flex: 1; height: 1px; background: rgba(255,255,255,0.06); margin: 0 16px; }

        /* Two col */
        .two-col { display: grid; grid-template-columns: 1fr 340px; gap: 28px; align-items: start; }
        .section { display: none; }
        .section.active { display: block; }

        /* Glass Card */
        .glass-card { background: rgba(255,255,255,0.04); backdrop-filter: blur(15px); border: 1px solid rgba(255,255,255,0.08); border-radius: 20px; overflow: hidden; }
        .card-header { padding: 20px 24px; border-bottom: 1px solid rgba(255,255,255,0.06); background: rgba(0,0,0,0.2); }
        .card-header h3 { font-family: 'Rajdhani', sans-serif; font-size: 20px; font-weight: 700; color: #c9a84c; }
        .card-header p { font-size: 13px; color: #444; margin-top: 4px; }
        .card-body { padding: 24px; }

        /* Plan Cards */
        .plans-grid { display: grid; grid-template-columns: repeat(3,1fr); gap: 14px; }
        .plan-card { background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.08); border-radius: 14px; padding: 20px 14px; text-align: center; cursor: pointer; transition: all 0.3s; position: relative; }
        .plan-card:hover { border-color: rgba(201,168,76,0.3); transform: translateY(-4px); }
        .plan-card.selected { border-color: #c9a84c; background: rgba(201,168,76,0.08); transform: translateY(-4px); }
        .popular-tag { position: absolute; top: -10px; left: 50%; transform: translateX(-50%); background: linear-gradient(135deg, #c9a84c, #8b6914); color: #0a0a0a; font-size: 10px; font-weight: 700; padding: 3px 10px; border-radius: 20px; white-space: nowrap; }
        .plan-icon { font-size: 28px; margin-bottom: 8px; margin-top: 6px; }
        .plan-name { font-family: 'Rajdhani', sans-serif; font-size: 18px; font-weight: 700; color: #fff; margin-bottom: 4px; }
        .plan-price { font-family: 'Rajdhani', sans-serif; font-size: 28px; font-weight: 700; color: #c9a84c; }
        .plan-price span { font-size: 12px; color: #555; font-family: 'Inter', sans-serif; font-weight: 400; }
        .plan-features { list-style: none; margin: 12px 0 0; text-align: left; }
        .plan-features li { padding: 5px 0; font-size: 12px; color: #666; display: flex; align-items: center; gap: 6px; }
        .check { color: #4ade80; } .cross { color: #2a2a2a; }

        /* Duration */
        .duration-grid { display: grid; grid-template-columns: repeat(3,1fr); gap: 14px; }
        .duration-card { background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.08); border-radius: 12px; padding: 18px; text-align: center; cursor: pointer; transition: all 0.3s; }
        .duration-card:hover { border-color: rgba(201,168,76,0.3); }
        .duration-card.selected { border-color: #c9a84c; background: rgba(201,168,76,0.08); }
        .dur-name { font-family: 'Rajdhani', sans-serif; font-size: 17px; font-weight: 700; color: #fff; }
        .dur-price { font-size: 20px; font-weight: 700; color: #c9a84c; font-family: 'Rajdhani', sans-serif; margin-top: 6px; }
        .dur-price span { font-size: 11px; color: #555; font-family: 'Inter', sans-serif; }
        .dur-save { font-size: 11px; color: #4ade80; margin-top: 4px; font-weight: 600; }

        /* Payment Methods */
        .pay-methods { display: grid; grid-template-columns: repeat(3,1fr); gap: 12px; }
        .pay-method { background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.08); border-radius: 12px; padding: 18px 10px; text-align: center; cursor: pointer; transition: all 0.3s; }
        .pay-method:hover { border-color: rgba(201,168,76,0.3); }
        .pay-method.selected { border-color: #c9a84c; background: rgba(201,168,76,0.08); }
        .pay-method .pm-icon { font-size: 26px; margin-bottom: 6px; }
        .pay-method .pm-name { font-family: 'Rajdhani', sans-serif; font-size: 14px; font-weight: 700; color: #e0e0e0; }
        .pay-method .pm-sub { font-size: 11px; color: #555; margin-top: 2px; }
        .pay-detail { display: none; margin-top: 20px; }
        .pay-detail.active { display: block; }

        /* Form */
        .form-group { margin-bottom: 16px; }
        .form-group label { display: block; font-size: 11px; font-weight: 600; color: #555; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 8px; }
        .form-group input { width: 100%; padding: 12px 14px; background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.1); border-radius: 10px; font-size: 14px; color: #e0e0e0; outline: none; transition: border 0.2s; font-family: 'Inter', sans-serif; }
        .form-group input:focus { border-color: #c9a84c; }
        .form-group input::placeholder { color: #333; }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }

        /* Bank & Cash */
        .bank-box { background: rgba(91,196,245,0.04); border: 1px solid rgba(91,196,245,0.15); border-radius: 12px; padding: 22px; }
        .bank-row { display: flex; justify-content: space-between; padding: 9px 0; border-bottom: 1px solid rgba(255,255,255,0.04); font-size: 14px; }
        .bank-row:last-child { border-bottom: none; }
        .bank-label { color: #555; }
        .bank-value { color: #5bc4f5; font-weight: 600; }
        .bank-note { margin-top: 12px; padding: 10px; background: rgba(91,196,245,0.04); border-radius: 8px; font-size: 12px; color: #555; line-height: 1.7; }
        .cash-box { background: rgba(74,222,128,0.04); border: 1px solid rgba(74,222,128,0.15); border-radius: 12px; padding: 24px; text-align: center; }
        .cash-box .ci { font-size: 44px; margin-bottom: 12px; }
        .cash-box h4 { font-family: 'Rajdhani', sans-serif; font-size: 18px; color: #4ade80; margin-bottom: 8px; }
        .cash-box p { font-size: 13px; color: #555; line-height: 1.7; }

        /* Order Summary */
        .order-card { background: rgba(201,168,76,0.06); border: 1px solid rgba(201,168,76,0.15); border-radius: 20px; padding: 24px; position: sticky; top: 24px; }
        .order-title { font-family: 'Rajdhani', sans-serif; font-size: 18px; font-weight: 700; color: #c9a84c; margin-bottom: 16px; }
        .member-box { background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.06); border-radius: 10px; padding: 12px; margin-bottom: 14px; }
        .member-box .mb-name { font-size: 14px; font-weight: 600; color: #e0e0e0; }
        .member-box .mb-id { font-family: 'Rajdhani', sans-serif; font-size: 16px; color: #c9a84c; font-weight: 700; margin-top: 2px; }
        .order-plan { background: rgba(201,168,76,0.1); border: 1px solid rgba(201,168,76,0.2); border-radius: 10px; padding: 12px; text-align: center; margin-bottom: 14px; }
        .order-plan-name { font-family: 'Rajdhani', sans-serif; font-size: 22px; color: #c9a84c; font-weight: 700; }
        .order-plan-dur { font-size: 12px; color: #555; text-transform: uppercase; letter-spacing: 1px; margin-top: 2px; }
        .order-row { display: flex; justify-content: space-between; padding: 8px 0; font-size: 13px; border-bottom: 1px solid rgba(255,255,255,0.04); }
        .order-row:last-child { border-bottom: none; }
        .order-label { color: #555; }
        .order-value { color: #e0e0e0; font-weight: 500; }
        .order-total { display: flex; justify-content: space-between; align-items: center; padding: 14px 0 0; margin-top: 8px; border-top: 1px solid rgba(201,168,76,0.2); }
        .order-total .label { font-family: 'Rajdhani', sans-serif; font-size: 16px; color: #c9a84c; font-weight: 700; }
        .order-total .value { font-family: 'Rajdhani', sans-serif; font-size: 26px; color: #c9a84c; }

        /* Buttons */
        .btn { padding: 12px 22px; border-radius: 10px; font-size: 14px; font-weight: 600; cursor: pointer; border: none; transition: all 0.2s; font-family: 'Rajdhani', sans-serif; letter-spacing: 1px; text-transform: uppercase; }
        .btn-gold { background: linear-gradient(135deg, #c9a84c, #8b6914); color: #0a0a0a; }
        .btn-gold:hover { transform: translateY(-2px); box-shadow: 0 10px 20px rgba(201,168,76,0.3); }
        .btn-outline { background: transparent; color: #666; border: 1px solid rgba(255,255,255,0.1); }
        .btn-outline:hover { border-color: #c9a84c; color: #c9a84c; }
        .btn-row { display: flex; gap: 12px; margin-top: 20px; }

        /* Confirmation overlay */
        .confirm-overlay { display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.9); z-index: 1000; align-items: center; justify-content: center; backdrop-filter: blur(10px); }
        .confirm-overlay.show { display: flex; }
        .confirm-box { background: rgba(17,17,17,0.98); border: 1px solid rgba(74,222,128,0.3); border-radius: 20px; padding: 40px; text-align: center; max-width: 460px; width: 90%; }
        .confirm-icon { font-size: 60px; margin-bottom: 16px; animation: popIn 0.5s cubic-bezier(0.175,0.885,0.32,1.275); }
        @keyframes popIn { 0%{transform:scale(0)} 100%{transform:scale(1)} }
        .confirm-box h2 { font-family: 'Rajdhani', sans-serif; font-size: 28px; color: #4ade80; letter-spacing: 2px; margin-bottom: 10px; }
        .confirm-box p { font-size: 14px; color: #555; line-height: 1.7; margin-bottom: 20px; }
        .confirm-details { background: rgba(74,222,128,0.04); border: 1px solid rgba(74,222,128,0.1); border-radius: 10px; padding: 16px; margin-bottom: 20px; text-align: left; }
        .confirm-row { display: flex; justify-content: space-between; padding: 6px 0; font-size: 13px; border-bottom: 1px solid rgba(255,255,255,0.04); }
        .confirm-row:last-child { border-bottom: none; }
        .confirm-row .cl { color: #555; }
        .confirm-row .cv { color: #4ade80; font-weight: 600; }
        .queue-note { background: rgba(201,168,76,0.08); border: 1px solid rgba(201,168,76,0.2); border-radius: 10px; padding: 14px; margin-bottom: 20px; font-size: 13px; color: #c9a84c; line-height: 1.6; text-align: left; }
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
    <a href="/member/dashboard">&#128187; &nbsp; Dashboard</a>
    <a href="/member/workout">&#127947; &nbsp; My Workout</a>
    <a href="#">&#127822; &nbsp; My Diet Plan</a>
    <a href="#">&#128100; &nbsp; My Trainer</a>
    <a href="/member/payment" class="active">&#128179; &nbsp; Payment & Membership</a>
    <div class="sidebar-footer">
        <a href="/member/logout">&#128275; &nbsp; Sign Out</a>
    </div>
</div>

<div class="main">
    <div class="hero">
        <div class="hero-bg"></div>
        <div class="hero-bg-gradient"></div>
        <div class="hero-content">
            <div class="hero-tag">Payment & Membership</div>
            <h1>Renew Your <span>Membership</span></h1>
            <p>Choose a plan, complete payment — your renewal request joins the queue</p>
        </div>
    </div>

    <div class="content">

        <!-- Current Status Bar -->
        <div class="status-bar">
            <div class="status-item">
                <div class="s-label">Member ID</div>
                <div class="s-value"><%= loggedMember.getId() %></div>
            </div>
            <div class="status-item">
                <div class="s-label">Current Plan</div>
                <div class="s-value"><%= loggedMember.getMembershipType() %></div>
            </div>
            <div class="status-item">
                <div class="s-label">Expiry Date</div>
                <div class="s-value" style="color:#e05555"><%= loggedMember.getExpiryDate() %></div>
            </div>
            <div class="status-item">
                <div class="s-label">Payment Status</div>
                <div class="s-value" style="color:<%= loggedMember.getPaymentStatus().equals("Paid") ? "#4ade80" : "#e05555" %>">
                    <%= loggedMember.getPaymentStatus() %>
                </div>
            </div>
        </div>

        <!-- Steps -->
        <div class="steps">
            <div class="step active" id="step1"><div class="step-num">1</div><div class="step-label">Choose Plan</div></div>
            <div class="step-line"></div>
            <div class="step" id="step2"><div class="step-num">2</div><div class="step-label">Duration</div></div>
            <div class="step-line"></div>
            <div class="step" id="step3"><div class="step-num">3</div><div class="step-label">Payment</div></div>
        </div>

        <div class="two-col">
            <div>

                <!-- Step 1: Plan -->
                <div class="section active" id="section1">
                    <div class="glass-card">
                        <div class="card-header">
                            <h3>&#11088; Choose Your Plan</h3>
                            <p>Select the plan you want to renew with</p>
                        </div>
                        <div class="card-body">
                            <div class="plans-grid">
                                <div class="plan-card" id="plan-Basic" onclick="selectPlan('Basic',2500)">
                                    <div class="plan-icon">&#127947;</div>
                                    <div class="plan-name">Basic</div>
                                    <div class="plan-price">Rs.2,500<span>/mo</span></div>
                                    <ul class="plan-features">
                                        <li><span class="check">✓</span> Gym Equipment</li>
                                        <li><span class="check">✓</span> Locker Access</li>
                                        <li><span class="cross">✗</span> Trainer</li>
                                        <li><span class="cross">✗</span> Diet Plan</li>
                                    </ul>
                                </div>
                                <div class="plan-card" id="plan-Premium" onclick="selectPlan('Premium',5000)" style="border-color:rgba(201,168,76,0.25)">
                                    <div class="popular-tag">Most Popular</div>
                                    <div class="plan-icon">&#11088;</div>
                                    <div class="plan-name">Premium</div>
                                    <div class="plan-price">Rs.5,000<span>/mo</span></div>
                                    <ul class="plan-features">
                                        <li><span class="check">✓</span> All Basic</li>
                                        <li><span class="check">✓</span> Trainer Guidance</li>
                                        <li><span class="check">✓</span> Group Classes</li>
                                        <li><span class="cross">✗</span> Diet Plan</li>
                                    </ul>
                                </div>
                                <div class="plan-card" id="plan-VIP Elite" onclick="selectPlan('VIP Elite',8500)">
                                    <div class="plan-icon">&#128081;</div>
                                    <div class="plan-name">VIP Elite</div>
                                    <div class="plan-price">Rs.8,500<span>/mo</span></div>
                                    <ul class="plan-features">
                                        <li><span class="check">✓</span> All Premium</li>
                                        <li><span class="check">✓</span> Personal Trainer</li>
                                        <li><span class="check">✓</span> Diet Plan</li>
                                        <li><span class="check">✓</span> Pool & Sauna</li>
                                    </ul>
                                </div>
                            </div>
                            <div class="btn-row">
                                <button class="btn btn-outline" onclick="window.location.href='/member/dashboard'">&#8592; Back</button>
                                <button class="btn btn-gold" onclick="goToStep(2)">Next &#8250;</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Step 2: Duration -->
                <div class="section" id="section2">
                    <div class="glass-card">
                        <div class="card-header">
                            <h3>&#128197; Choose Duration</h3>
                            <p>Longer plans save you more money</p>
                        </div>
                        <div class="card-body">
                            <div class="duration-grid">
                                <div class="duration-card" id="dur-Monthly" onclick="selectDuration('Monthly',1,0)">
                                    <div class="dur-name">Monthly</div>
                                    <div class="dur-price" id="dp-Monthly">Rs.0<span>/mo</span></div>
                                    <div class="dur-save" style="color:#555">Standard rate</div>
                                </div>
                                <div class="duration-card" id="dur-6Months" onclick="selectDuration('6 Months',6,10)">
                                    <div class="dur-name">6 Months</div>
                                    <div class="dur-price" id="dp-6Months">Rs.0<span> total</span></div>
                                    <div class="dur-save">Save 10%</div>
                                </div>
                                <div class="duration-card" id="dur-Yearly" onclick="selectDuration('Yearly',12,15)">
                                    <div class="dur-name">Yearly</div>
                                    <div class="dur-price" id="dp-Yearly">Rs.0<span> total</span></div>
                                    <div class="dur-save">Save 15%</div>
                                </div>
                            </div>
                            <div class="btn-row">
                                <button class="btn btn-outline" onclick="goToStep(1)">&#8592; Back</button>
                                <button class="btn btn-gold" onclick="goToStep(3)">Next &#8250;</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Step 3: Payment -->
                <div class="section" id="section3">
                    <div class="glass-card">
                        <div class="card-header">
                            <h3>&#128179; Payment Method</h3>
                            <p>Choose how you would like to pay</p>
                        </div>
                        <div class="card-body">
                            <div class="pay-methods">
                                <div class="pay-method" id="pm-card" onclick="selectPayment('card')">
                                    <div class="pm-icon">&#128179;</div>
                                    <div class="pm-name">Card</div>
                                    <div class="pm-sub">Credit / Debit</div>
                                </div>
                                <div class="pay-method" id="pm-bank" onclick="selectPayment('bank')">
                                    <div class="pm-icon">&#127959;</div>
                                    <div class="pm-name">Bank Transfer</div>
                                    <div class="pm-sub">Direct deposit</div>
                                </div>
                                <div class="pay-method" id="pm-cash" onclick="selectPayment('cash')">
                                    <div class="pm-icon">&#128181;</div>
                                    <div class="pm-name">Cash</div>
                                    <div class="pm-sub">Pay at counter</div>
                                </div>
                            </div>

                            <!-- Card Details -->
                            <div class="pay-detail" id="detail-card">
                                <div class="form-group">
                                    <label>Card Number</label>
                                    <input type="text" id="cardNumber" placeholder="1234 5678 9012 3456" maxlength="19" oninput="formatCard(this)">
                                </div>
                                <div class="form-group">
                                    <label>Cardholder Name</label>
                                    <input type="text" id="cardName" placeholder="Name as on card">
                                </div>
                                <div class="form-row">
                                    <div class="form-group">
                                        <label>Expiry Date</label>
                                        <input type="text" id="cardExpiry" placeholder="MM/YY" maxlength="5" oninput="formatExpiry(this)">
                                    </div>
                                    <div class="form-group">
                                        <label>CVV</label>
                                        <input type="password" id="cardCvv" placeholder="•••" maxlength="3">
                                    </div>
                                </div>
                                <div class="btn-row">
                                    <button class="btn btn-outline" onclick="goToStep(2)">&#8592; Back</button>
                                    <button class="btn btn-gold" onclick="processPayment('Card')">&#128274; Pay Now</button>
                                </div>
                            </div>

                            <!-- Bank Transfer -->
                            <div class="pay-detail" id="detail-bank">
                                <div class="bank-box">
                                    <div style="font-family:'Rajdhani',sans-serif;font-size:17px;font-weight:700;color:#5bc4f5;margin-bottom:14px">&#127959; Bank Transfer Details</div>
                                    <div class="bank-row"><span class="bank-label">Bank</span><span class="bank-value">Commercial Bank of Ceylon</span></div>
                                    <div class="bank-row"><span class="bank-label">Account Name</span><span class="bank-value">Fitness Center Pvt Ltd</span></div>
                                    <div class="bank-row"><span class="bank-label">Account Number</span><span class="bank-value">8012345678</span></div>
                                    <div class="bank-row"><span class="bank-label">Reference</span><span class="bank-value"><%= loggedMember.getId() %></span></div>
                                    <div class="bank-row"><span class="bank-label">Amount</span><span class="bank-value" id="bankAmount" style="color:#c9a84c">Rs.0</span></div>
                                    <div class="bank-note">&#9432; Use your Member ID as the reference. After transfer, click confirm below to join the renewal queue.</div>
                                </div>
                                <div class="btn-row">
                                    <button class="btn btn-outline" onclick="goToStep(2)">&#8592; Back</button>
                                    <button class="btn btn-gold" onclick="processPayment('Bank Transfer')">Confirm Transfer &#8250;</button>
                                </div>
                            </div>

                            <!-- Cash -->
                            <div class="pay-detail" id="detail-cash">
                                <div class="cash-box">
                                    <div class="ci">&#128181;</div>
                                    <h4>Pay at Front Desk</h4>
                                    <p>Visit our front desk with your Member ID <strong style="color:#4ade80"><%= loggedMember.getId() %></strong>. Your renewal request will be added to the queue and processed by staff after cash payment is received.</p>
                                </div>
                                <div class="btn-row">
                                    <button class="btn btn-outline" onclick="goToStep(2)">&#8592; Back</button>
                                    <button class="btn btn-gold" onclick="processPayment('Cash')">Submit Request &#8250;</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>

            <!-- Order Summary -->
            <div class="order-card">
                <div class="order-title">&#128203; Renewal Summary</div>
                <div class="member-box">
                    <div class="mb-name"><%= loggedMember.getName() %></div>
                    <div class="mb-id"><%= loggedMember.getId() %></div>
                </div>
                <div class="order-plan">
                    <div class="order-plan-name" id="summaryPlan">— Select Plan —</div>
                    <div class="order-plan-dur" id="summaryDurLabel">—</div>
                </div>
                <div class="order-row">
                    <span class="order-label">Current Plan</span>
                    <span class="order-value"><%= loggedMember.getMembershipType() %></span>
                </div>
                <div class="order-row">
                    <span class="order-label">New Plan</span>
                    <span class="order-value" id="summaryNewPlan">—</span>
                </div>
                <div class="order-row">
                    <span class="order-label">Duration</span>
                    <span class="order-value" id="summaryDuration">—</span>
                </div>
                <div class="order-row">
                    <span class="order-label">New Expiry</span>
                    <span class="order-value" id="summaryExpiry">—</span>
                </div>
                <div class="order-total">
                    <span class="label">Total</span>
                    <span class="value" id="summaryTotal">—</span>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Hidden form to submit renewal request to backend -->
<form id="renewalForm" method="POST" action="/renewal/request-with-payment" style="display:none">
    <input type="hidden" name="requestedPlan"  id="formPlan">
    <input type="hidden" name="duration"       id="formDuration">
    <input type="hidden" name="totalAmount"    id="formAmount">
    <input type="hidden" name="paymentMethod"  id="formPaymentMethod">
    <input type="hidden" name="expiryDate"     id="formExpiryDate">
</form>

<!-- Confirmation Modal -->
<div class="confirm-overlay" id="confirmOverlay">
    <div class="confirm-box">
        <div class="confirm-icon">&#128260;</div>
        <h2>REQUEST SUBMITTED!</h2>
        <p>Your renewal request has been added to the queue. Staff will process it shortly.</p>
        <div class="queue-note">
            &#128260; <strong>Queue System (FIFO):</strong> Your request will be processed in the order it was received. First come, first served!
        </div>
        <div class="confirm-details">
            <div class="confirm-row"><span class="cl">Member</span><span class="cv"><%= loggedMember.getName() %></span></div>
            <div class="confirm-row"><span class="cl">New Plan</span><span class="cv" id="confPlan">—</span></div>
            <div class="confirm-row"><span class="cl">Duration</span><span class="cv" id="confDuration">—</span></div>
            <div class="confirm-row"><span class="cl">Amount</span><span class="cv" id="confAmount">—</span></div>
            <div class="confirm-row"><span class="cl">Payment</span><span class="cv" id="confPayment">—</span></div>
            <div class="confirm-row"><span class="cl">New Expiry</span><span class="cv" id="confExpiry">—</span></div>
        </div>
        <button class="btn btn-gold" style="width:100%" onclick="submitRenewal()">Go to Dashboard &#8250;</button>
    </div>
</div>

<script>
    let selPlan = '', selPrice = 0, selDuration = '', selMonths = 0, selTotal = 0, selExpiry = '';
    const prices = {
        'Basic':    {'Monthly':2500, '6 Months':13500, 'Yearly':25500},
        'Premium':  {'Monthly':5000, '6 Months':27000, 'Yearly':51000},
        'VIP Elite':{'Monthly':8500, '6 Months':45900, 'Yearly':86700}
    };

    function selectPlan(plan, price) {
        selPlan = plan; selPrice = price;
        document.querySelectorAll('.plan-card').forEach(c => c.classList.remove('selected'));
        document.getElementById('plan-' + plan).classList.add('selected');
        updateDurationPrices();
        updateSummary();
    }

    function updateDurationPrices() {
        if (!selPlan) return;
        document.getElementById('dp-Monthly').innerHTML  = 'Rs.' + prices[selPlan]['Monthly'].toLocaleString() + '<span>/mo</span>';
        document.getElementById('dp-6Months').innerHTML  = 'Rs.' + prices[selPlan]['6 Months'].toLocaleString() + '<span> total</span>';
        document.getElementById('dp-Yearly').innerHTML   = 'Rs.' + prices[selPlan]['Yearly'].toLocaleString() + '<span> total</span>';
    }

    function selectDuration(dur, months, discPct) {
        selDuration = dur; selMonths = months;
        selTotal = prices[selPlan] ? prices[selPlan][dur] : Math.round(selPrice * months * (1 - discPct/100));
        document.querySelectorAll('.duration-card').forEach(c => c.classList.remove('selected'));
        document.getElementById('dur-' + dur.replace(' ','')).classList.add('selected');
        const today = new Date();
        today.setMonth(today.getMonth() + months);
        selExpiry = today.toISOString().split('T')[0];
        updateSummary();
    }

    function updateSummary() {
        if (selPlan) {
            document.getElementById('summaryPlan').textContent    = selPlan;
            document.getElementById('summaryNewPlan').textContent = selPlan;
        }
        if (selDuration) {
            document.getElementById('summaryDurLabel').textContent = selDuration + ' Plan';
            document.getElementById('summaryDuration').textContent = selDuration;
            document.getElementById('summaryExpiry').textContent   = selExpiry;
            document.getElementById('summaryTotal').textContent    = 'Rs.' + selTotal.toLocaleString();
            document.getElementById('bankAmount').textContent      = 'Rs.' + selTotal.toLocaleString();
        }
    }

    function goToStep(step) {
        if (step === 2 && !selPlan)     { alert('Please select a plan first!'); return; }
        if (step === 3 && !selDuration) { alert('Please select a duration first!'); return; }
        document.querySelectorAll('.section').forEach(s => s.classList.remove('active'));
        document.getElementById('section' + step).classList.add('active');
        for (let i = 1; i <= 3; i++) {
            const el = document.getElementById('step' + i);
            el.classList.remove('active','done');
            if (i < step) el.classList.add('done');
            if (i === step) el.classList.add('active');
        }
    }

    function selectPayment(method) {
        document.querySelectorAll('.pay-method').forEach(m => m.classList.remove('selected'));
        document.getElementById('pm-' + method).classList.add('selected');
        document.querySelectorAll('.pay-detail').forEach(d => d.classList.remove('active'));
        document.getElementById('detail-' + method).classList.add('active');
    }

    function formatCard(input) {
        let v = input.value.replace(/\D/g,'').substring(0,16);
        input.value = v.replace(/(.{4})/g,'$1 ').trim();
    }

    function formatExpiry(input) {
        let v = input.value.replace(/\D/g,'').substring(0,4);
        if (v.length >= 2) v = v.substring(0,2) + '/' + v.substring(2);
        input.value = v;
    }

    function processPayment(method) {
        if (method === 'Card') {
            const num  = document.getElementById('cardNumber').value.replace(/\s/g,'');
            const name = document.getElementById('cardName').value.trim();
            const exp  = document.getElementById('cardExpiry').value.trim();
            const cvv  = document.getElementById('cardCvv').value.trim();
            if (num.length < 16) { alert('Please enter a valid card number.'); return; }
            if (!name)           { alert('Please enter the cardholder name.'); return; }
            if (exp.length < 5)  { alert('Please enter a valid expiry date.'); return; }
            if (cvv.length < 3)  { alert('Please enter a valid CVV.'); return; }
        }
        // Fill confirmation modal
        document.getElementById('confPlan').textContent    = selPlan;
        document.getElementById('confDuration').textContent = selDuration;
        document.getElementById('confAmount').textContent  = 'Rs.' + selTotal.toLocaleString();
        document.getElementById('confPayment').textContent = method;
        document.getElementById('confExpiry').textContent  = selExpiry;
        document.getElementById('confirmOverlay').classList.add('show');
    }

    function submitRenewal() {
        document.getElementById('formPlan').value          = selPlan;
        document.getElementById('formDuration').value      = selDuration;
        document.getElementById('formAmount').value        = selTotal;
        document.getElementById('formPaymentMethod').value = document.querySelector('.pay-method.selected .pm-name')?.textContent || 'Card';
        document.getElementById('formExpiryDate').value    = selExpiry;
        document.getElementById('renewalForm').submit();
    }
</script>
</body>
</html>