<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment — FITNESS CENTER</title>
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
        .navbar { position: fixed; top: 0; left: 0; right: 0; z-index: 100; padding: 18px 60px; display: flex; justify-content: space-between; align-items: center; background: rgba(10,10,10,0.9); backdrop-filter: blur(10px); border-bottom: 1px solid rgba(201,168,76,0.15); }
        .nav-brand { font-family: 'Bebas Neue', sans-serif; font-size: 24px; color: #c9a84c; letter-spacing: 3px; text-decoration: none; }
        .nav-brand span { color: white; }
        .nav-back { color: #666; text-decoration: none; font-size: 14px; display: flex; align-items: center; gap: 8px; transition: color 0.2s; }
        .nav-back:hover { color: #c9a84c; }
        .page { padding: 100px 60px 60px; position: relative; z-index: 1; max-width: 1100px; margin: 0 auto; }

        /* Steps */
        .steps { display: flex; align-items: center; margin-bottom: 40px; }
        .step { display: flex; align-items: center; gap: 10px; }
        .step-num { width: 34px; height: 34px; border-radius: 50%; border: 1px solid rgba(255,255,255,0.1); display: flex; align-items: center; justify-content: center; font-size: 13px; font-weight: 700; color: #444; transition: all 0.3s; flex-shrink: 0; }
        .step.active .step-num { background: linear-gradient(135deg, #c9a84c, #8b6914); color: #0a0a0a; border-color: #c9a84c; }
        .step.done .step-num { background: rgba(74,222,128,0.15); color: #4ade80; border-color: #4ade80; }
        .step-label { font-size: 13px; color: #444; font-weight: 500; white-space: nowrap; }
        .step.active .step-label { color: #c9a84c; font-weight: 600; }
        .step.done .step-label { color: #4ade80; }
        .step-line { flex: 1; height: 1px; background: rgba(255,255,255,0.06); margin: 0 16px; }

        .two-col { display: grid; grid-template-columns: 1fr 360px; gap: 32px; align-items: start; }
        .section { display: none; }
        .section.active { display: block; }

        /* Glass Card */
        .glass-card { background: rgba(255,255,255,0.04); backdrop-filter: blur(15px); border: 1px solid rgba(255,255,255,0.08); border-radius: 20px; overflow: hidden; }
        .card-header { padding: 22px 26px; border-bottom: 1px solid rgba(255,255,255,0.06); background: rgba(0,0,0,0.2); }
        .card-header h3 { font-family: 'Rajdhani', sans-serif; font-size: 22px; font-weight: 700; color: #c9a84c; }
        .card-header p { font-size: 13px; color: #444; margin-top: 4px; }
        .card-body { padding: 26px; }

        /* Plan selected badge */
        .plan-selected-badge { background: rgba(201,168,76,0.1); border: 1px solid rgba(201,168,76,0.3); border-radius: 12px; padding: 16px 20px; display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
        .plan-selected-badge .ps-name { font-family: 'Rajdhani', sans-serif; font-size: 22px; font-weight: 700; color: #c9a84c; }
        .plan-selected-badge .ps-price { font-family: 'Rajdhani', sans-serif; font-size: 18px; color: #e0e0e0; }
        .change-plan { font-size: 12px; color: #555; text-decoration: none; transition: color 0.2s; }
        .change-plan:hover { color: #c9a84c; }

        /* Duration Cards */
        .duration-grid { display: grid; grid-template-columns: repeat(3,1fr); gap: 14px; margin-bottom: 24px; }
        .dur-card { background: rgba(255,255,255,0.03); border: 2px solid rgba(255,255,255,0.08); border-radius: 14px; padding: 20px 14px; text-align: center; cursor: pointer; transition: all 0.3s; position: relative; }
        .dur-card:hover { border-color: rgba(201,168,76,0.4); transform: translateY(-3px); }
        .dur-card.selected { border-color: #c9a84c; background: rgba(201,168,76,0.08); transform: translateY(-3px); box-shadow: 0 10px 24px rgba(201,168,76,0.15); }
        .dur-save-tag { position: absolute; top: -10px; left: 50%; transform: translateX(-50%); background: linear-gradient(135deg, #4ade80, #16a34a); color: #0a0a0a; font-size: 10px; font-weight: 700; padding: 3px 10px; border-radius: 20px; white-space: nowrap; }
        .dur-months { font-family: 'Bebas Neue', sans-serif; font-size: 36px; color: #fff; line-height: 1; margin-top: 6px; }
        .dur-label { font-size: 12px; color: #555; text-transform: uppercase; letter-spacing: 1px; margin-top: 4px; }
        .dur-price { font-family: 'Rajdhani', sans-serif; font-size: 20px; font-weight: 700; color: #c9a84c; margin-top: 10px; }
        .dur-per { font-size: 11px; color: #555; margin-top: 2px; }
        .dur-save { font-size: 11px; color: #4ade80; font-weight: 600; margin-top: 4px; }

        /* Member type toggle */
        .member-toggle { display: flex; background: rgba(0,0,0,0.3); border: 1px solid rgba(255,255,255,0.08); border-radius: 12px; padding: 4px; margin-bottom: 24px; }
        .toggle-btn { flex: 1; padding: 11px; border: none; border-radius: 9px; font-size: 13px; font-weight: 600; cursor: pointer; font-family: 'Inter', sans-serif; transition: all 0.2s; background: transparent; color: rgba(255,255,255,0.4); }
        .toggle-btn.active { background: linear-gradient(135deg, #c9a84c, #8b6914); color: #0a0a0a; }

        /* Payment Methods */
        .pay-methods { display: grid; grid-template-columns: repeat(3,1fr); gap: 12px; margin-bottom: 20px; }
        .pay-method { background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.08); border-radius: 12px; padding: 18px 10px; text-align: center; cursor: pointer; transition: all 0.3s; }
        .pay-method:hover { border-color: rgba(201,168,76,0.3); }
        .pay-method.selected { border-color: #c9a84c; background: rgba(201,168,76,0.08); }
        .pay-method .pm-icon { font-size: 26px; margin-bottom: 6px; }
        .pay-method .pm-name { font-family: 'Rajdhani', sans-serif; font-size: 14px; font-weight: 700; color: #e0e0e0; }
        .pay-method .pm-sub { font-size: 11px; color: #555; margin-top: 2px; }
        .pay-detail { display: none; margin-top: 16px; }
        .pay-detail.active { display: block; }

        /* Form */
        .form-group { margin-bottom: 16px; }
        .form-group label { display: block; font-size: 11px; font-weight: 600; color: #555; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 8px; }
        .form-group input { width: 100%; padding: 12px 14px; background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.1); border-radius: 10px; font-size: 14px; color: #e0e0e0; outline: none; transition: border 0.2s; font-family: 'Inter', sans-serif; }
        .form-group input:focus { border-color: #c9a84c; }
        .form-group input::placeholder { color: #333; }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }

        /* Bank & Cash */
        .bank-box { background: rgba(91,196,245,0.04); border: 1px solid rgba(91,196,245,0.15); border-radius: 12px; padding: 20px; }
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
        .order-card { background: rgba(201,168,76,0.06); border: 1px solid rgba(201,168,76,0.15); border-radius: 20px; padding: 24px; position: sticky; top: 100px; }
        .order-title { font-family: 'Rajdhani', sans-serif; font-size: 18px; font-weight: 700; color: #c9a84c; margin-bottom: 16px; }
        .order-plan { background: rgba(201,168,76,0.1); border: 1px solid rgba(201,168,76,0.2); border-radius: 10px; padding: 14px; text-align: center; margin-bottom: 16px; }
        .order-plan-name { font-family: 'Bebas Neue', sans-serif; font-size: 24px; color: #c9a84c; letter-spacing: 2px; }
        .order-plan-dur { font-size: 12px; color: #555; text-transform: uppercase; letter-spacing: 1px; margin-top: 2px; }
        .order-row { display: flex; justify-content: space-between; padding: 9px 0; font-size: 13px; border-bottom: 1px solid rgba(255,255,255,0.04); }
        .order-row:last-child { border-bottom: none; }
        .order-label { color: #555; }
        .order-value { color: #e0e0e0; font-weight: 500; }
        .order-total { display: flex; justify-content: space-between; align-items: center; padding: 14px 0 0; margin-top: 8px; border-top: 1px solid rgba(201,168,76,0.2); }
        .order-total .label { font-family: 'Rajdhani', sans-serif; font-size: 16px; color: #c9a84c; font-weight: 700; }
        .order-total .value { font-family: 'Rajdhani', sans-serif; font-size: 28px; color: #c9a84c; }

        /* Buttons */
        .btn { padding: 13px 24px; border-radius: 10px; font-size: 14px; font-weight: 600; cursor: pointer; border: none; transition: all 0.2s; font-family: 'Rajdhani', sans-serif; letter-spacing: 1px; text-transform: uppercase; }
        .btn-gold { background: linear-gradient(135deg, #c9a84c, #8b6914); color: #0a0a0a; }
        .btn-gold:hover { transform: translateY(-2px); box-shadow: 0 10px 20px rgba(201,168,76,0.3); }
        .btn-outline { background: transparent; color: #666; border: 1px solid rgba(255,255,255,0.1); }
        .btn-outline:hover { border-color: #c9a84c; color: #c9a84c; }
        .btn-row { display: flex; gap: 12px; margin-top: 20px; }

        /* Confirmation */
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
        .mid-box { background: rgba(201,168,76,0.1); border: 1px solid rgba(201,168,76,0.3); border-radius: 10px; padding: 14px; margin-bottom: 16px; }
        .mid-box .ml { font-size: 11px; color: #555; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 4px; }
        .mid-box .mv { font-family: 'Bebas Neue', sans-serif; font-size: 28px; color: #c9a84c; letter-spacing: 3px; }
        .mid-box .mh { font-size: 12px; color: #555; margin-top: 4px; }
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

<nav class="navbar">
    <a href="/home" class="nav-brand">PRIME <span>FITNESS</span></a>
    <a href="/home#plans" class="nav-back">&#8592; Back to Plans</a>
</nav>

<div class="page">

    <!-- Steps -->
    <div class="steps">
        <div class="step active" id="step1"><div class="step-num">1</div><div class="step-label">Duration & Details</div></div>
        <div class="step-line"></div>
        <div class="step" id="step2"><div class="step-num">2</div><div class="step-label">Payment</div></div>
        <div class="step-line"></div>
        <div class="step" id="step3"><div class="step-num">3</div><div class="step-label">Confirmation</div></div>
    </div>

    <div class="two-col">
        <div>

            <!-- STEP 1: Duration + Member Details -->
            <div class="section active" id="section1">
                <div class="glass-card">
                    <div class="card-header">
                        <h3>&#128197; Choose Duration</h3>
                        <p>Select how long you want your membership</p>
                    </div>
                    <div class="card-body">

                        <!-- Plan badge -->
                        <div class="plan-selected-badge">
                            <div>
                                <div class="ps-name" id="badgePlanName">—</div>
                                <div style="font-size:12px;color:#555;margin-top:2px">Selected Plan</div>
                            </div>
                            <div style="text-align:right">
                                <div class="ps-price" id="badgePlanPrice">Rs.0/mo</div>
                                <a href="/home#plans" class="change-plan">Change plan &#8250;</a>
                            </div>
                        </div>

                        <!-- Duration Cards -->
                        <div class="duration-grid">
                            <div class="dur-card selected" id="dur-1" onclick="selectDuration(1)">
                                <div class="dur-months">1</div>
                                <div class="dur-label">Month</div>
                                <div class="dur-price" id="dp-1">Rs.0</div>
                                <div class="dur-per">total</div>
                                <div class="dur-save" style="color:#555">Standard rate</div>
                            </div>
                            <div class="dur-card" id="dur-6" onclick="selectDuration(6)">
                                <div class="dur-save-tag">Save 10%</div>
                                <div class="dur-months">6</div>
                                <div class="dur-label">Months</div>
                                <div class="dur-price" id="dp-6">Rs.0</div>
                                <div class="dur-per">total</div>
                                <div class="dur-save">Save 10%</div>
                            </div>
                            <div class="dur-card" id="dur-12" onclick="selectDuration(12)">
                                <div class="dur-save-tag">Save 15%</div>
                                <div class="dur-months">12</div>
                                <div class="dur-label">Months</div>
                                <div class="dur-price" id="dp-12">Rs.0</div>
                                <div class="dur-per">total</div>
                                <div class="dur-save">Save 15%</div>
                            </div>
                        </div>

                        <!-- New or Existing Member Toggle -->
                        <div style="margin-bottom:16px;font-family:'Rajdhani',sans-serif;font-size:16px;font-weight:700;color:#c9a84c">
                            &#128100; Your Details
                        </div>
                        <div class="member-toggle">
                            <button class="toggle-btn active" id="newBtn" onclick="switchType('new')">&#127381; New Member</button>
                            <button class="toggle-btn" id="existingBtn" onclick="switchType('existing')">&#128100; Existing Member</button>
                        </div>

                        <!-- New Member Fields -->
                        <div id="newFields">
                            <div class="form-row">
                                <div class="form-group">
                                    <label>Full Name</label>
                                    <input type="text" id="newName" placeholder="Enter your full name">
                                </div>
                                <div class="form-group">
                                    <label>Phone</label>
                                    <input type="text" id="newPhone" placeholder="07X XXXXXXX">
                                </div>
                            </div>
                            <div class="form-group">
                                <label>Email Address</label>
                                <input type="email" id="newEmail" placeholder="your@email.com">
                            </div>
                            <div class="form-group">
                                <label>Create Password</label>
                                <input type="password" id="newPassword" placeholder="Create a login password">
                            </div>
                        </div>

                        <!-- Existing Member Fields -->
                        <div id="existingFields" style="display:none">
                            <div class="form-group">
                                <label>Member ID</label>
                                <input type="text" id="existingId" placeholder="e.g. M001">
                            </div>
                            <div class="form-group">
                                <label>Password</label>
                                <input type="password" id="existingPassword" placeholder="Enter your password">
                            </div>
                        </div>

                        <div class="btn-row">
                            <button class="btn btn-outline" onclick="window.location.href='/home#plans'">&#8592; Back</button>
                            <button class="btn btn-gold" onclick="goToStep(2)">Proceed to Payment &#8250;</button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- STEP 2: Payment Method -->
            <div class="section" id="section2">
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

                        <!-- Card -->
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
                                <button class="btn btn-outline" onclick="goToStep(1)">&#8592; Back</button>
                                <button class="btn btn-gold" onclick="processPayment('Card')">&#128274; Pay Now</button>
                            </div>
                        </div>

                        <!-- Bank -->
                        <div class="pay-detail" id="detail-bank">
                            <div class="bank-box">
                                <div style="font-family:'Rajdhani',sans-serif;font-size:17px;font-weight:700;color:#5bc4f5;margin-bottom:14px">&#127959; Bank Transfer Details</div>
                                <div class="bank-row"><span class="bank-label">Bank</span><span class="bank-value">Commercial Bank of Ceylon</span></div>
                                <div class="bank-row"><span class="bank-label">Account Name</span><span class="bank-value">Fitness Center Pvt Ltd</span></div>
                                <div class="bank-row"><span class="bank-label">Account Number</span><span class="bank-value">8012345678</span></div>
                                <div class="bank-row"><span class="bank-label">Branch</span><span class="bank-value">Colombo Main Branch</span></div>
                                <div class="bank-row"><span class="bank-label">Amount</span><span class="bank-value" id="bankAmt" style="color:#c9a84c">Rs.0</span></div>
                                <div class="bank-note">&#9432; Use your name as the payment reference. Bring the receipt to activate your membership.</div>
                            </div>
                            <div class="btn-row">
                                <button class="btn btn-outline" onclick="goToStep(1)">&#8592; Back</button>
                                <button class="btn btn-gold" onclick="processPayment('Bank Transfer')">Confirm Transfer &#8250;</button>
                            </div>
                        </div>

                        <!-- Cash -->
                        <div class="pay-detail" id="detail-cash">
                            <div class="cash-box">
                                <div class="ci">&#128181;</div>
                                <h4>Pay at Front Desk</h4>
                                <p>Visit our front desk and our staff will register you and collect your payment on the spot.</p>
                            </div>
                            <div class="btn-row">
                                <button class="btn btn-outline" onclick="goToStep(1)">&#8592; Back</button>
                                <button class="btn btn-gold" onclick="processPayment('Cash')">Confirm &#8250;</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>

        <!-- Order Summary -->
        <div class="order-card">
            <div class="order-title">&#128203; Order Summary</div>
            <div class="order-plan">
                <div class="order-plan-name" id="sumPlan">—</div>
                <div class="order-plan-dur" id="sumDurLabel">Select Duration</div>
            </div>
            <div class="order-row">
                <span class="order-label">Plan</span>
                <span class="order-value" id="sumPlanSm">—</span>
            </div>
            <div class="order-row">
                <span class="order-label">Monthly Price</span>
                <span class="order-value" id="sumMonthly">—</span>
            </div>
            <div class="order-row">
                <span class="order-label">Duration</span>
                <span class="order-value" id="sumDur">—</span>
            </div>
            <div class="order-row">
                <span class="order-label">Discount</span>
                <span class="order-value" id="sumDiscount" style="color:#4ade80">—</span>
            </div>
            <div class="order-total">
                <span class="label">Total</span>
                <span class="value" id="sumTotal">Rs.0</span>
            </div>
        </div>
    </div>
</div>

<!-- Confirmation Modal -->
<div class="confirm-overlay" id="confirmOverlay">
    <div class="confirm-box">
        <div class="confirm-icon">&#127881;</div>
        <h2>WELCOME!</h2>
        <p id="confMsg">Your membership is now active. Welcome to FITNESS CENTER!</p>
        <div class="mid-box">
            <div class="ml">Your Member ID</div>
            <div class="mv" id="confMemberId">—</div>
            <div class="mh">Save this ID — you'll need it to log in</div>
        </div>
        <div class="confirm-details">
            <div class="confirm-row"><span class="cl">Plan</span><span class="cv" id="confPlan">—</span></div>
            <div class="confirm-row"><span class="cl">Duration</span><span class="cv" id="confDur">—</span></div>
            <div class="confirm-row"><span class="cl">Amount</span><span class="cv" id="confTotal">—</span></div>
            <div class="confirm-row"><span class="cl">Payment</span><span class="cv" id="confPayment">—</span></div>
        </div>
        <button class="btn btn-gold" style="width:100%" onclick="window.location.href='/login'">Login to Dashboard &#8250;</button>
    </div>
</div>

<script>
    const params    = new URLSearchParams(window.location.search);
    const plan      = params.get('plan')  || 'Basic';
    const basePrice = parseInt(params.get('price') || '3000');

    let selMonths   = 1;
    let selTotal    = basePrice;
    let memberType  = 'new';
    let selPayment  = '';

    // Init page
    document.getElementById('badgePlanName').textContent  = plan;
    document.getElementById('badgePlanPrice').textContent = 'Rs.' + basePrice.toLocaleString() + '/mo';
    document.getElementById('sumPlan').textContent        = plan;
    document.getElementById('sumPlanSm').textContent      = plan;
    document.getElementById('sumMonthly').textContent     = 'Rs.' + basePrice.toLocaleString();

    updateDurationCards();
    selectDuration(1);

    function updateDurationCards() {
        document.getElementById('dp-1').textContent  = 'Rs.' + basePrice.toLocaleString();
        document.getElementById('dp-6').textContent  = 'Rs.' + Math.round(basePrice * 6 * 0.9).toLocaleString();
        document.getElementById('dp-12').textContent = 'Rs.' + Math.round(basePrice * 12 * 0.85).toLocaleString();
    }

    function selectDuration(months) {
        selMonths = months;
        let discount = months === 1 ? 0 : months === 6 ? 10 : 15;
        selTotal = Math.round(basePrice * months * (1 - discount / 100));

        document.querySelectorAll('.dur-card').forEach(c => c.classList.remove('selected'));
        document.getElementById('dur-' + months).classList.add('selected');

        const durLabel = months === 1 ? '1 Month' : months + ' Months';
        document.getElementById('sumDurLabel').textContent = durLabel;
        document.getElementById('sumDur').textContent      = durLabel;
        document.getElementById('sumDiscount').textContent = discount > 0 ? '-' + discount + '%' : 'None';
        document.getElementById('sumTotal').textContent    = 'Rs.' + selTotal.toLocaleString();
        document.getElementById('bankAmt').textContent     = 'Rs.' + selTotal.toLocaleString();
    }

    function switchType(type) {
        memberType = type;
        document.getElementById('newBtn').classList.toggle('active', type === 'new');
        document.getElementById('existingBtn').classList.toggle('active', type === 'existing');
        document.getElementById('newFields').style.display      = type === 'new' ? 'block' : 'none';
        document.getElementById('existingFields').style.display = type === 'existing' ? 'block' : 'none';
    }

    function goToStep(step) {
        if (step === 2) {
            if (memberType === 'new') {
                if (!document.getElementById('newName').value.trim())     { alert('Please enter your name.'); return; }
                if (!document.getElementById('newEmail').value.trim())    { alert('Please enter your email.'); return; }
                if (!document.getElementById('newPhone').value.trim())    { alert('Please enter your phone.'); return; }
                if (document.getElementById('newPassword').value.length < 6) { alert('Password must be at least 6 characters.'); return; }
            } else {
                if (!document.getElementById('existingId').value.trim())       { alert('Please enter your Member ID.'); return; }
                if (!document.getElementById('existingPassword').value.trim()) { alert('Please enter your password.'); return; }
            }
        }
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
        selPayment = method;
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
            if (document.getElementById('cardNumber').value.replace(/\s/g,'').length < 16) { alert('Enter a valid card number.'); return; }
            if (!document.getElementById('cardName').value.trim()) { alert('Enter cardholder name.'); return; }
            if (document.getElementById('cardExpiry').value.length < 5) { alert('Enter a valid expiry date.'); return; }
            if (document.getElementById('cardCvv').value.length < 3) { alert('Enter a valid CVV.'); return; }
        }

        const durLabel = selMonths === 1 ? '1 Month' : selMonths + ' Months';

        // Calculate expiry date
        const today = new Date();
        today.setMonth(today.getMonth() + selMonths);
        const expiry = today.toISOString().split('T')[0];

        // Get member details
        const name     = memberType === 'new' ? document.getElementById('newName').value.trim() : document.getElementById('existingId').value.trim();
        const email    = memberType === 'new' ? document.getElementById('newEmail').value.trim() : '';
        const phone    = memberType === 'new' ? document.getElementById('newPhone').value.trim() : '';
        const password = memberType === 'new' ? document.getElementById('newPassword').value : document.getElementById('existingPassword').value;

        if (memberType === 'new') {
            // Submit to backend to create real member account
            const form = document.getElementById('registerForm');
            document.getElementById('formName').value          = name;
            document.getElementById('formEmail').value         = email;
            document.getElementById('formPhone').value         = phone;
            document.getElementById('formPassword').value      = password;
            document.getElementById('formPlan').value          = plan;
            document.getElementById('formDuration').value      = durLabel;
            document.getElementById('formTotal').value         = selTotal;
            document.getElementById('formPaymentMethod').value = method;
            document.getElementById('formExpiry').value        = expiry;
            form.submit();
        } else {
            // Existing member — just redirect to login
            alert('Please log in with your existing Member ID and password to renew your membership.');
            window.location.href = '/login';
        }
    }


</script>
<form id="registerForm" method="POST" action="/member/register" style="display:none">
    <input type="hidden" name="name"          id="formName">
    <input type="hidden" name="email"         id="formEmail">
    <input type="hidden" name="phone"         id="formPhone">
    <input type="hidden" name="password"      id="formPassword">
    <input type="hidden" name="plan"          id="formPlan">
    <input type="hidden" name="duration"      id="formDuration">
    <input type="hidden" name="totalAmount"   id="formTotal">
    <input type="hidden" name="paymentMethod" id="formPaymentMethod">
    <input type="hidden" name="expiryDate"    id="formExpiry">
</form>
</body>
</html>