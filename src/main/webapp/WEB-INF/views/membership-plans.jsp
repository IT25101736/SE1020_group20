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
    <title>Membership Plans — Fitness Center</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Rajdhani:wght@500;600;700&family=Inter:wght@400;500;600&display=swap');
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { background: radial-gradient(ellipse at bottom, #1a1400 0%, #0a0a0a 100%); font-family: 'Inter', sans-serif; color: #e0e0e0; min-height: 100vh; overflow-x: hidden; }

        /* Shooting Stars */
        .night { position: fixed; width: 100%; height: 100%; transform: rotateZ(45deg); z-index: 0; pointer-events: none; }
        .shooting_star { position: absolute; left: 50%; top: 50%; height: 2px; background: linear-gradient(-45deg, #c9a84c, rgba(201,168,76,0)); border-radius: 999px; filter: drop-shadow(0 0 6px #c9a84c); animation: tail 3000ms ease-in-out infinite, shooting 3000ms ease-in-out infinite; }
        @keyframes tail { 0% { width: 0; } 30% { width: 100px; } 100% { width: 0; } }
        @keyframes shooting { 0% { transform: translateX(0); } 100% { transform: translateX(300px); } }
        .shooting_star:nth-child(1) { top: 10%; left: 5%;  animation-delay: 0ms; }
        .shooting_star:nth-child(2) { top: 30%; left: 20%; animation-delay: 1000ms; }
        .shooting_star:nth-child(3) { top: 50%; left: 10%; animation-delay: 2000ms; }
        .shooting_star:nth-child(4) { top: 70%; left: 30%; animation-delay: 500ms; }
        .shooting_star:nth-child(5) { top: 20%; left: 60%; animation-delay: 1500ms; }

        /* Sidebar */
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

        /* Main */
        .main { margin-left: 260px; min-height: 100vh; position: relative; z-index: 1; }

        /* Hero */
        .hero { position: relative; overflow: hidden; background: rgba(15,15,15,0.7); backdrop-filter: blur(10px); padding: 40px 40px 36px; border-bottom: 1px solid rgba(201,168,76,0.15); }
        .hero-bg { position: absolute; top: 0; right: 0; width: 50%; height: 100%; background: url('https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800&q=80') center/cover; opacity: 0.06; }
        .hero-bg-gradient { position: absolute; top: 0; right: 0; width: 55%; height: 100%; background: linear-gradient(to right, #0f0f0f 30%, transparent); }
        .hero-content { position: relative; z-index: 1; }
        .hero-tag { display: inline-block; background: rgba(201,168,76,0.15); color: #c9a84c; font-size: 11px; font-weight: 600; padding: 4px 12px; border-radius: 20px; text-transform: uppercase; letter-spacing: 2px; border: 1px solid rgba(201,168,76,0.3); margin-bottom: 12px; }
        .hero h1 { font-family: 'Rajdhani', sans-serif; font-size: 36px; font-weight: 700; color: #ffffff; line-height: 1.1; margin-bottom: 8px; }
        .hero h1 span { color: #c9a84c; }
        .hero p { font-size: 14px; color: #555; }

        /* Content */
        .content { padding: 40px; }

        /* Steps */
        .steps { display: flex; align-items: center; gap: 0; margin-bottom: 40px; }
        .step { display: flex; align-items: center; gap: 10px; }
        .step-num { width: 32px; height: 32px; border-radius: 50%; background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); display: flex; align-items: center; justify-content: center; font-size: 13px; font-weight: 700; color: #444; transition: all 0.3s; }
        .step.active .step-num { background: linear-gradient(135deg, #c9a84c, #8b6914); color: #0a0a0a; border-color: #c9a84c; }
        .step.done .step-num { background: rgba(74,222,128,0.2); color: #4ade80; border-color: #4ade80; }
        .step-label { font-size: 13px; color: #444; font-weight: 500; }
        .step.active .step-label { color: #c9a84c; }
        .step.done .step-label { color: #4ade80; }
        .step-line { flex: 1; height: 1px; background: rgba(255,255,255,0.08); margin: 0 16px; min-width: 40px; }

        /* Section */
        .section { display: none; }
        .section.active { display: block; }
        .section-title { font-family: 'Rajdhani', sans-serif; font-size: 24px; font-weight: 700; color: #fff; margin-bottom: 8px; }
        .section-sub { font-size: 14px; color: #555; margin-bottom: 32px; }

        /* Plan Cards */
        .plans-grid { display: grid; grid-template-columns: repeat(3,1fr); gap: 24px; margin-bottom: 32px; }
        .plan-card { background: rgba(255,255,255,0.04); backdrop-filter: blur(15px); border: 1px solid rgba(255,255,255,0.08); border-radius: 20px; padding: 32px 24px; text-align: center; cursor: pointer; transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275); position: relative; overflow: hidden; }
        .plan-card:hover { transform: translateY(-8px); border-color: rgba(201,168,76,0.4); box-shadow: 0 20px 40px rgba(0,0,0,0.4); }
        .plan-card.selected { border-color: #c9a84c; background: rgba(201,168,76,0.08); transform: translateY(-8px); box-shadow: 0 20px 40px rgba(201,168,76,0.15); }
        .plan-card.popular { border-color: rgba(201,168,76,0.3); }
        .popular-badge { position: absolute; top: 16px; left: 50%; transform: translateX(-50%); background: linear-gradient(135deg, #c9a84c, #8b6914); color: #0a0a0a; font-size: 10px; font-weight: 700; padding: 4px 14px; border-radius: 20px; text-transform: uppercase; letter-spacing: 1px; white-space: nowrap; }
        .plan-name { font-family: 'Rajdhani', sans-serif; font-size: 22px; font-weight: 700; color: #fff; margin-bottom: 16px; margin-top: 8px; }
        .plan-price { font-family: 'Rajdhani', sans-serif; font-size: 48px; font-weight: 700; color: #c9a84c; line-height: 1; }
        .plan-price span { font-size: 16px; color: #555; font-family: 'Inter', sans-serif; font-weight: 400; }
        .plan-features { list-style: none; margin: 20px 0; text-align: left; }
        .plan-features li { padding: 8px 0; font-size: 13px; color: #888; border-bottom: 1px solid rgba(255,255,255,0.04); display: flex; align-items: center; gap: 8px; }
        .plan-features li:last-child { border-bottom: none; }
        .plan-features li .check { color: #4ade80; }
        .plan-features li .cross { color: #333; }
        .plan-card.selected .plan-features li { color: #aaa; }

        /* Duration Cards */
        .duration-grid { display: grid; grid-template-columns: repeat(3,1fr); gap: 20px; margin-bottom: 32px; }
        .duration-card { background: rgba(255,255,255,0.04); backdrop-filter: blur(15px); border: 1px solid rgba(255,255,255,0.08); border-radius: 16px; padding: 24px; text-align: center; cursor: pointer; transition: all 0.3s; }
        .duration-card:hover { border-color: rgba(201,168,76,0.3); transform: translateY(-4px); }
        .duration-card.selected { border-color: #c9a84c; background: rgba(201,168,76,0.08); }
        .duration-name { font-family: 'Rajdhani', sans-serif; font-size: 20px; font-weight: 700; color: #fff; margin-bottom: 8px; }
        .duration-price { font-size: 24px; font-weight: 700; color: #c9a84c; font-family: 'Rajdhani', sans-serif; }
        .duration-price span { font-size: 13px; color: #555; font-family: 'Inter', sans-serif; font-weight: 400; }
        .duration-save { font-size: 11px; color: #4ade80; margin-top: 6px; font-weight: 600; }

        /* Member Details Form */
        .glass-form { background: rgba(255,255,255,0.03); backdrop-filter: blur(15px); border: 1px solid rgba(255,255,255,0.06); border-radius: 20px; padding: 32px; max-width: 560px; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; font-size: 12px; font-weight: 600; margin-bottom: 8px; color: #666; text-transform: uppercase; letter-spacing: 1px; }
        .form-group input { width: 100%; padding: 13px 16px; background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.1); border-radius: 10px; font-size: 14px; color: #e0e0e0; outline: none; transition: border 0.2s; font-family: 'Inter', sans-serif; }
        .form-group input:focus { border-color: #c9a84c; background: rgba(201,168,76,0.05); }
        .order-summary { background: rgba(201,168,76,0.08); border: 1px solid rgba(201,168,76,0.2); border-radius: 12px; padding: 20px; margin-bottom: 24px; }
        .order-row { display: flex; justify-content: space-between; align-items: center; padding: 6px 0; font-size: 14px; color: #888; }
        .order-row.total { color: #c9a84c; font-weight: 700; font-size: 18px; border-top: 1px solid rgba(201,168,76,0.2); margin-top: 8px; padding-top: 12px; font-family: 'Rajdhani', sans-serif; }

        /* Payment Methods */
        .payment-grid { display: grid; grid-template-columns: repeat(3,1fr); gap: 20px; margin-bottom: 32px; }
        .payment-card { background: rgba(255,255,255,0.04); backdrop-filter: blur(15px); border: 1px solid rgba(255,255,255,0.08); border-radius: 16px; padding: 28px 20px; text-align: center; cursor: pointer; transition: all 0.3s; }
        .payment-card:hover { border-color: rgba(201,168,76,0.3); transform: translateY(-4px); }
        .payment-card.selected { border-color: #c9a84c; background: rgba(201,168,76,0.08); }
        .payment-icon { font-size: 36px; margin-bottom: 12px; }
        .payment-name { font-family: 'Rajdhani', sans-serif; font-size: 18px; font-weight: 700; color: #fff; margin-bottom: 4px; }
        .payment-sub { font-size: 12px; color: #555; }

        /* Payment Details */
        .payment-detail { display: none; }
        .payment-detail.active { display: block; }
        .bank-detail-box { background: rgba(91,196,245,0.05); border: 1px solid rgba(91,196,245,0.2); border-radius: 12px; padding: 24px; }
        .bank-row { display: flex; justify-content: space-between; padding: 10px 0; border-bottom: 1px solid rgba(255,255,255,0.04); font-size: 14px; }
        .bank-row:last-child { border-bottom: none; }
        .bank-label { color: #555; }
        .bank-value { color: #5bc4f5; font-weight: 600; }
        .cash-box { background: rgba(74,222,128,0.05); border: 1px solid rgba(74,222,128,0.2); border-radius: 12px; padding: 32px; text-align: center; }
        .cash-box .icon { font-size: 48px; margin-bottom: 16px; }
        .cash-box h4 { font-family: 'Rajdhani', sans-serif; font-size: 22px; color: #4ade80; margin-bottom: 8px; }
        .cash-box p { font-size: 14px; color: #555; line-height: 1.7; }

        /* Buttons */
        .btn { padding: 12px 28px; border-radius: 10px; font-size: 14px; font-weight: 600; cursor: pointer; border: none; transition: all 0.2s; font-family: 'Inter', sans-serif; }
        .btn-gold { background: linear-gradient(135deg, #c9a84c, #8b6914); color: #0a0a0a; }
        .btn-gold:hover { background: linear-gradient(135deg, #dbb85c, #9b7924); transform: translateY(-1px); }
        .btn-outline { background: transparent; color: #666; border: 1px solid rgba(255,255,255,0.1); }
        .btn-outline:hover { border-color: #c9a84c; color: #c9a84c; }
        .btn-row { display: flex; gap: 12px; align-items: center; margin-top: 24px; }

        /* Confirmation Overlay */
        .confirm-overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.85); z-index: 1000; align-items: center; justify-content: center; backdrop-filter: blur(8px); }
        .confirm-overlay.show { display: flex; }
        .confirm-box { background: rgba(17,17,17,0.95); border: 1px solid rgba(74,222,128,0.3); border-radius: 24px; padding: 48px; text-align: center; max-width: 440px; box-shadow: 0 25px 60px rgba(0,0,0,0.6); }
        .confirm-icon { font-size: 64px; margin-bottom: 20px; animation: popIn 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275); }
        @keyframes popIn { 0% { transform: scale(0); } 100% { transform: scale(1); } }
        .confirm-box h3 { font-family: 'Rajdhani', sans-serif; font-size: 28px; font-weight: 700; color: #4ade80; margin-bottom: 12px; }
        .confirm-box p { font-size: 14px; color: #666; line-height: 1.7; margin-bottom: 24px; }
        .confirm-details { background: rgba(74,222,128,0.05); border: 1px solid rgba(74,222,128,0.15); border-radius: 12px; padding: 16px; margin-bottom: 24px; text-align: left; }
        .confirm-row { display: flex; justify-content: space-between; padding: 6px 0; font-size: 13px; }
        .confirm-row .lbl { color: #555; }
        .confirm-row .val { color: #4ade80; font-weight: 600; }
    </style>
</head>
<body>

<!-- Shooting Stars -->
<div class="night">
    <div class="shooting_star"></div>
    <div class="shooting_star"></div>
    <div class="shooting_star"></div>
    <div class="shooting_star"></div>
    <div class="shooting_star"></div>
</div>

<!-- Sidebar -->
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
    <a href="#">&#127947; &nbsp; My Workout</a>
    <a href="#">&#127822; &nbsp; My Diet Plan</a>
    <a href="#">&#128100; &nbsp; My Trainer</a>
    <a href="/membership-plans" class="active">&#128179; &nbsp; Payment & Membership</a>
    <div class="sidebar-footer">
        <a href="/member/logout">&#128275; &nbsp; Sign Out</a>
    </div>
</div>

<!-- Main -->
<div class="main">
    <div class="hero">
        <div class="hero-bg"></div>
        <div class="hero-bg-gradient"></div>
        <div class="hero-content">
            <div class="hero-tag">Membership</div>
            <h1>Payment & <span>Membership</span></h1>
            <p>Choose your plan and complete your membership payment</p>
        </div>
    </div>

    <div class="content">

        <!-- Steps -->
        <div class="steps">
            <div class="step active" id="step1">
                <div class="step-num">1</div>
                <div class="step-label">Choose Plan</div>
            </div>
            <div class="step-line"></div>
            <div class="step" id="step2">
                <div class="step-num">2</div>
                <div class="step-label">Duration</div>
            </div>
            <div class="step-line"></div>
            <div class="step" id="step3">
                <div class="step-num">3</div>
                <div class="step-label">Your Details</div>
            </div>
            <div class="step-line"></div>
            <div class="step" id="step4">
                <div class="step-num">4</div>
                <div class="step-label">Payment</div>
            </div>
        </div>

        <!-- Step 1: Choose Plan -->
        <div class="section active" id="section1">
            <div class="section-title">Choose Your Plan</div>
            <div class="section-sub">Select the membership plan that fits your goals</div>
            <div class="plans-grid">
                <div class="plan-card" onclick="selectPlan('Basic', 29)" id="plan-Basic">
                    <div class="plan-name">Basic</div>
                    <div class="plan-price">$29<span>/mo</span></div>
                    <ul class="plan-features">
                        <li><span class="check">✓</span> Access to Gym Floor</li>
                        <li><span class="check">✓</span> Locker Room Access</li>
                        <li><span class="check">✓</span> 1 Free Orientation</li>
                        <li><span class="cross">✗</span> Group Classes</li>
                        <li><span class="cross">✗</span> Personal Trainer</li>
                    </ul>
                </div>
                <div class="plan-card popular" onclick="selectPlan('Premium', 59)" id="plan-Premium">
                    <div class="popular-badge">Most Popular</div>
                    <div class="plan-name">Premium</div>
                    <div class="plan-price">$59<span>/mo</span></div>
                    <ul class="plan-features">
                        <li><span class="check">✓</span> All Basic Features</li>
                        <li><span class="check">✓</span> Unlimited Group Classes</li>
                        <li><span class="check">✓</span> Pool & Sauna Access</li>
                        <li><span class="check">✓</span> Guest Passes (2/mo)</li>
                        <li><span class="cross">✗</span> Personal Trainer</li>
                    </ul>
                </div>
                <div class="plan-card" onclick="selectPlan('VIP Elite', 99)" id="plan-VIP Elite">
                    <div class="plan-name">VIP Elite</div>
                    <div class="plan-price">$99<span>/mo</span></div>
                    <ul class="plan-features">
                        <li><span class="check">✓</span> All Premium Features</li>
                        <li><span class="check">✓</span> 4 Personal Training Sessions</li>
                        <li><span class="check">✓</span> Nutrition Consultation</li>
                        <li><span class="check">✓</span> VIP Lounge Access</li>
                        <li><span class="check">✓</span> Unlimited Guest Passes</li>
                    </ul>
                </div>
            </div>
            <div class="btn-row">
                <button class="btn btn-gold" onclick="goToStep(2)">Next — Choose Duration ›</button>
            </div>
        </div>

        <!-- Step 2: Duration -->
        <div class="section" id="section2">
            <div class="section-title">Choose Duration</div>
            <div class="section-sub">Longer plans save you more money</div>
            <div class="duration-grid">
                <div class="duration-card" onclick="selectDuration('Monthly', 1)" id="dur-Monthly">
                    <div class="duration-name">Monthly</div>
                    <div class="duration-price" id="price-Monthly">$29<span>/mo</span></div>
                    <div class="duration-save" style="color:#555">Standard rate</div>
                </div>
                <div class="duration-card" onclick="selectDuration('6 Months', 6)" id="dur-6 Months">
                    <div class="duration-name">6 Months</div>
                    <div class="duration-price" id="price-6 Months">$159<span> total</span></div>
                    <div class="duration-save">Save ~9%</div>
                </div>
                <div class="duration-card" onclick="selectDuration('Yearly', 12)" id="dur-Yearly">
                    <div class="duration-name">Yearly</div>
                    <div class="duration-price" id="price-Yearly">$299<span> total</span></div>
                    <div class="duration-save">Save ~14%</div>
                </div>
            </div>
            <div class="btn-row">
                <button class="btn btn-outline" onclick="goToStep(1)">‹ Back</button>
                <button class="btn btn-gold" onclick="goToStep(3)">Next — Your Details ›</button>
            </div>
        </div>

        <!-- Step 3: Member Details -->
        <div class="section" id="section3">
            <div class="section-title">Your Details</div>
            <div class="section-sub">Confirm your information before proceeding to payment</div>
            <div class="order-summary">
                <div class="order-row"><span>Plan</span><span id="summary-plan" style="color:#c9a84c;font-weight:600">—</span></div>
                <div class="order-row"><span>Duration</span><span id="summary-duration" style="color:#c9a84c;font-weight:600">—</span></div>
                <div class="order-row total"><span>Total</span><span id="summary-total">—</span></div>
            </div>
            <div class="glass-form">
                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" id="det-name" value="<%= loggedMember.getName() %>" placeholder="Your full name">
                </div>
                <div class="form-group">
                    <label>Member ID</label>
                    <input type="text" id="det-id" value="<%= loggedMember.getId() %>" readonly style="opacity:0.6;cursor:not-allowed">
                </div>
                <div class="form-group">
                    <label>Phone Number</label>
                    <input type="text" id="det-phone" value="<%= loggedMember.getPhone() %>" placeholder="Your phone number">
                </div>
            </div>
            <div class="btn-row">
                <button class="btn btn-outline" onclick="goToStep(2)">‹ Back</button>
                <button class="btn btn-gold" onclick="goToStep(4)">Proceed to Payment ›</button>
            </div>
        </div>

        <!-- Step 4: Payment -->
        <div class="section" id="section4">
            <div class="section-title">Payment Method</div>
            <div class="section-sub">Choose how you would like to pay</div>

            <div class="payment-grid">
                <div class="payment-card" onclick="selectPayment('card')" id="pay-card">
                    <div class="payment-icon">💳</div>
                    <div class="payment-name">Card</div>
                    <div class="payment-sub">Credit or Debit Card</div>
                </div>
                <div class="payment-card" onclick="selectPayment('bank')" id="pay-bank">
                    <div class="payment-icon">🏦</div>
                    <div class="payment-name">Bank Transfer</div>
                    <div class="payment-sub">Direct bank deposit</div>
                </div>
                <div class="payment-card" onclick="selectPayment('cash')" id="pay-cash">
                    <div class="payment-icon">💵</div>
                    <div class="payment-name">Cash to Cashier</div>
                    <div class="payment-sub">Pay at the counter</div>
                </div>
            </div>

            <!-- Card Details -->
            <div class="payment-detail" id="detail-card">
                <div class="glass-form">
                    <div class="form-group">
                        <label>Card Number</label>
                        <input type="text" id="card-number" placeholder="1234 5678 9012 3456" maxlength="19" oninput="formatCard(this)">
                    </div>
                    <div class="form-group">
                        <label>Cardholder Name</label>
                        <input type="text" id="card-name" placeholder="Name on card">
                    </div>
                    <div style="display:grid;grid-template-columns:1fr 1fr;gap:16px">
                        <div class="form-group">
                            <label>Expiry Date</label>
                            <input type="text" id="card-expiry" placeholder="MM/YY" maxlength="5" oninput="formatExpiry(this)">
                        </div>
                        <div class="form-group">
                            <label>CVV</label>
                            <input type="password" id="card-cvv" placeholder="•••" maxlength="3">
                        </div>
                    </div>
                    <div class="btn-row">
                        <button class="btn btn-outline" onclick="goToStep(4); resetPayment()">‹ Back</button>
                        <button class="btn btn-gold" onclick="processPayment()">Pay Now ›</button>
                    </div>
                </div>
            </div>

            <!-- Bank Transfer Details -->
            <div class="payment-detail" id="detail-bank">
                <div class="bank-detail-box" style="max-width:500px">
                    <div style="font-family:'Rajdhani',sans-serif;font-size:18px;font-weight:700;color:#5bc4f5;margin-bottom:16px">&#127959; Bank Transfer Details</div>
                    <div class="bank-row"><span class="bank-label">Bank Name</span><span class="bank-value">Commercial Bank of Ceylon</span></div>
                    <div class="bank-row"><span class="bank-label">Account Name</span><span class="bank-value">Fitness Center (Pvt) Ltd</span></div>
                    <div class="bank-row"><span class="bank-label">Account Number</span><span class="bank-value">1234 5678 9012</span></div>
                    <div class="bank-row"><span class="bank-label">Branch</span><span class="bank-value">Colombo Main Branch</span></div>
                    <div class="bank-row"><span class="bank-label">Reference</span><span class="bank-value" id="bank-ref">—</span></div>
                    <div class="bank-row"><span class="bank-label">Amount</span><span class="bank-value" id="bank-amount">—</span></div>
                    <div style="margin-top:16px;padding:12px;background:rgba(91,196,245,0.05);border-radius:8px;font-size:12px;color:#555;line-height:1.7">
                        &#9432; Please use your Member ID as the payment reference. Send the payment receipt to the front desk to activate your membership.
                    </div>
                </div>
                <div class="btn-row" style="margin-top:24px">
                    <button class="btn btn-outline" onclick="goToStep(4); resetPayment()">‹ Back</button>
                </div>
            </div>

            <!-- Cash to Cashier -->
            <div class="payment-detail" id="detail-cash">
                <div class="cash-box" style="max-width:500px">
                    <div class="icon">💵</div>
                    <h4>Visit the Cashier</h4>
                    <p>Please visit our front desk with your Member ID <strong style="color:#4ade80"><%= loggedMember.getId() %></strong> to complete your payment in cash.<br><br>Our staff will update your membership in the system once payment is received.</p>
                    <div style="margin-top:24px;padding:16px;background:rgba(74,222,128,0.05);border:1px solid rgba(74,222,128,0.15);border-radius:10px;font-size:13px;color:#555">
                        &#128205; Front Desk Hours: Mon–Sat, 6:00 AM – 10:00 PM
                    </div>
                </div>
                <div class="btn-row" style="margin-top:24px">
                    <button class="btn btn-outline" onclick="goToStep(4); resetPayment()">‹ Back</button>
                </div>
            </div>

            <div class="btn-row" id="back-btn-row">
                <button class="btn btn-outline" onclick="goToStep(3)">‹ Back</button>
            </div>
        </div>

    </div>
</div>

<!-- Confirmation Popup -->
<div class="confirm-overlay" id="confirmOverlay">
    <div class="confirm-box">
        <div class="confirm-icon">🎉</div>
        <h3>Payment Successful!</h3>
        <p>Your membership has been activated. Welcome to the Fitness Center family!</p>
        <div class="confirm-details">
            <div class="confirm-row"><span class="lbl">Member</span><span class="val" id="conf-name">—</span></div>
            <div class="confirm-row"><span class="lbl">Plan</span><span class="val" id="conf-plan">—</span></div>
            <div class="confirm-row"><span class="lbl">Duration</span><span class="val" id="conf-duration">—</span></div>
            <div class="confirm-row"><span class="lbl">Amount Paid</span><span class="val" id="conf-total">—</span></div>
        </div>
        <button class="btn btn-gold" style="width:100%" onclick="window.location.href='/member/dashboard'">Go to Dashboard</button>
    </div>
</div>

<script>
    let selectedPlan = null;
    let selectedPlanPrice = 0;
    let selectedDuration = null;
    let selectedTotal = 0;

    const prices = {
        Basic:    { Monthly: 29,  '6 Months': 159, Yearly: 299 },
        Premium:  { Monthly: 59,  '6 Months': 329, Yearly: 599 },
        'VIP Elite': { Monthly: 99, '6 Months': 549, Yearly: 999 }
    };

    function selectPlan(plan, price) {
        selectedPlan = plan;
        selectedPlanPrice = price;
        document.querySelectorAll('.plan-card').forEach(c => c.classList.remove('selected'));
        document.getElementById('plan-' + plan).classList.add('selected');
        updateDurationPrices();
    }

    function updateDurationPrices() {
        if (!selectedPlan) return;
        document.getElementById('price-Monthly').innerHTML  = '$' + prices[selectedPlan].Monthly + '<span>/mo</span>';
        document.getElementById('price-6 Months').innerHTML = '$' + prices[selectedPlan]['6 Months'] + '<span> total</span>';
        document.getElementById('price-Yearly').innerHTML   = '$' + prices[selectedPlan].Yearly + '<span> total</span>';
    }

    function selectDuration(duration, months) {
        selectedDuration = duration;
        document.querySelectorAll('.duration-card').forEach(c => c.classList.remove('selected'));
        document.getElementById('dur-' + duration).classList.add('selected');
        if (selectedPlan) {
            selectedTotal = prices[selectedPlan][duration];
        }
    }

    function selectPayment(method) {
        document.querySelectorAll('.payment-card').forEach(c => c.classList.remove('selected'));
        document.getElementById('pay-' + method).classList.add('selected');
        document.querySelectorAll('.payment-detail').forEach(d => d.classList.remove('active'));
        document.getElementById('detail-' + method).classList.add('active');
        document.getElementById('back-btn-row').style.display = 'none';

        if (method === 'bank') {
            document.getElementById('bank-ref').textContent  = '<%= loggedMember.getId() %>';
            document.getElementById('bank-amount').textContent = '$' + selectedTotal;
        }
    }

    function resetPayment() {
        document.querySelectorAll('.payment-card').forEach(c => c.classList.remove('selected'));
        document.querySelectorAll('.payment-detail').forEach(d => d.classList.remove('active'));
        document.getElementById('back-btn-row').style.display = 'flex';
    }

    function goToStep(step) {
        if (step === 2 && !selectedPlan) { alert('Please select a plan first!'); return; }
        if (step === 3 && !selectedDuration) { alert('Please select a duration first!'); return; }

        document.querySelectorAll('.section').forEach(s => s.classList.remove('active'));
        document.getElementById('section' + step).classList.add('active');

        for (let i = 1; i <= 4; i++) {
            const el = document.getElementById('step' + i);
            el.classList.remove('active', 'done');
            if (i < step) el.classList.add('done');
            if (i === step) el.classList.add('active');
        }

        if (step === 3) {
            document.getElementById('summary-plan').textContent     = selectedPlan;
            document.getElementById('summary-duration').textContent = selectedDuration;
            document.getElementById('summary-total').textContent    = '$' + selectedTotal;
        }

        if (step === 4) resetPayment();
    }

    function formatCard(input) {
        let v = input.value.replace(/\D/g, '').substring(0, 16);
        input.value = v.replace(/(.{4})/g, '$1 ').trim();
    }

    function formatExpiry(input) {
        let v = input.value.replace(/\D/g, '').substring(0, 4);
        if (v.length >= 2) v = v.substring(0,2) + '/' + v.substring(2);
        input.value = v;
    }

    function processPayment() {
        const num  = document.getElementById('card-number').value.replace(/\s/g,'');
        const name = document.getElementById('card-name').value.trim();
        const exp  = document.getElementById('card-expiry').value.trim();
        const cvv  = document.getElementById('card-cvv').value.trim();

        if (num.length < 16) { alert('Please enter a valid 16-digit card number.'); return; }
        if (!name)           { alert('Please enter the cardholder name.'); return; }
        if (exp.length < 5)  { alert('Please enter a valid expiry date.'); return; }
        if (cvv.length < 3)  { alert('Please enter a valid CVV.'); return; }

        document.getElementById('conf-name').textContent     = document.getElementById('det-name').value;
        document.getElementById('conf-plan').textContent     = selectedPlan;
        document.getElementById('conf-duration').textContent = selectedDuration;
        document.getElementById('conf-total').textContent    = '$' + selectedTotal;

        document.getElementById('confirmOverlay').classList.add('show');
    }
</script>
</body>
</html>