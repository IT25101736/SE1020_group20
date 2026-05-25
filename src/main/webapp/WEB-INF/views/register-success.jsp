<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Registration Successful — FITNESS CENTER</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Rajdhani:wght@500;600;700&family=Inter:wght@400;500;600&family=Bebas+Neue&display=swap');
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { background: radial-gradient(ellipse at bottom, #1a1400 0%, #0a0a0a 100%); font-family: 'Inter', sans-serif; color: #e0e0e0; min-height: 100vh; display: flex; align-items: center; justify-content: center; overflow: hidden; }
        .night { position: fixed; width: 100%; height: 100%; transform: rotateZ(45deg); z-index: 0; pointer-events: none; }
        .shooting_star { position: absolute; height: 2px; background: linear-gradient(-45deg, #c9a84c, rgba(201,168,76,0)); border-radius: 999px; filter: drop-shadow(0 0 6px #c9a84c); animation: tail 3000ms ease-in-out infinite, shooting 3000ms ease-in-out infinite; }
        @keyframes tail { 0%{width:0} 30%{width:100px} 100%{width:0} }
        @keyframes shooting { 0%{transform:translateX(0)} 100%{transform:translateX(300px)} }
        .shooting_star:nth-child(1){top:10%;left:5%;animation-delay:0ms}
        .shooting_star:nth-child(2){top:30%;left:20%;animation-delay:1000ms}
        .shooting_star:nth-child(3){top:50%;left:10%;animation-delay:2000ms}
        .shooting_star:nth-child(4){top:70%;left:30%;animation-delay:500ms}
        .shooting_star:nth-child(5){top:20%;left:60%;animation-delay:1500ms}
        .box { position: relative; z-index: 1; background: rgba(17,17,17,0.95); border: 1px solid rgba(74,222,128,0.3); border-radius: 24px; padding: 48px; text-align: center; max-width: 500px; width: 90%; box-shadow: 0 30px 80px rgba(0,0,0,0.6); }
        .icon { font-size: 72px; margin-bottom: 20px; animation: popIn 0.6s cubic-bezier(0.175,0.885,0.32,1.275); }
        @keyframes popIn { 0%{transform:scale(0)} 100%{transform:scale(1)} }
        h2 { font-family: 'Bebas Neue', sans-serif; font-size: 36px; color: #4ade80; letter-spacing: 3px; margin-bottom: 8px; }
        .sub { font-size: 14px; color: #555; margin-bottom: 28px; line-height: 1.6; }
        .mid-box { background: rgba(201,168,76,0.1); border: 1px solid rgba(201,168,76,0.3); border-radius: 14px; padding: 20px; margin-bottom: 24px; }
        .mid-label { font-size: 11px; color: #555; text-transform: uppercase; letter-spacing: 2px; margin-bottom: 8px; }
        .mid-id { font-family: 'Bebas Neue', sans-serif; font-size: 42px; color: #c9a84c; letter-spacing: 6px; }
        .mid-hint { font-size: 12px; color: #555; margin-top: 6px; }
        .details { background: rgba(74,222,128,0.04); border: 1px solid rgba(74,222,128,0.1); border-radius: 12px; padding: 16px; margin-bottom: 24px; text-align: left; }
        .det-row { display: flex; justify-content: space-between; padding: 7px 0; font-size: 13px; border-bottom: 1px solid rgba(255,255,255,0.04); }
        .det-row:last-child { border-bottom: none; }
        .det-row .dl { color: #555; }
        .det-row .dv { color: #4ade80; font-weight: 600; }
        .btn { width: 100%; padding: 14px; border: none; border-radius: 12px; background: linear-gradient(135deg, #c9a84c, #8b6914); color: #0a0a0a; font-size: 15px; font-weight: 700; cursor: pointer; font-family: 'Rajdhani', sans-serif; letter-spacing: 1px; text-transform: uppercase; transition: all 0.2s; text-decoration: none; display: block; }
        .btn:hover { transform: translateY(-2px); box-shadow: 0 10px 20px rgba(201,168,76,0.3); }
    </style>
</head>
<body>
<div class="night">
    <div class="shooting_star"></div><div class="shooting_star"></div>
    <div class="shooting_star"></div><div class="shooting_star"></div>
    <div class="shooting_star"></div>
</div>
<div class="box">
    <div class="icon">&#127881;</div>
    <h2>WELCOME!</h2>
    <p class="sub">Your account has been created successfully. Use your Member ID and password to log in!</p>

    <div class="mid-box">
        <div class="mid-label">Your Member ID</div>
        <div class="mid-id">${memberId}</div>
        <div class="mid-hint">&#128274; Save this — you need it to log in</div>
    </div>

    <div class="details">
        <div class="det-row"><span class="dl">Name</span><span class="dv">${memberName}</span></div>
        <div class="det-row"><span class="dl">Plan</span><span class="dv">${plan}</span></div>
        <div class="det-row"><span class="dl">Duration</span><span class="dv">${duration}</span></div>
        <div class="det-row"><span class="dl">Amount Paid</span><span class="dv">Rs.${total}</span></div>
        <div class="det-row"><span class="dl">Payment</span><span class="dv">${paymentMethod}</span></div>
    </div>

    <a href="/login" class="btn">Login to Your Dashboard &#8250;</a>
</div>
</body>
</html>
