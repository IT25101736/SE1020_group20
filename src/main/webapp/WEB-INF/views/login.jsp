<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login — Fitness Center</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Rajdhani:wght@500;600;700&family=Inter:wght@400;500;600&display=swap');
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { min-height: 100vh; font-family: 'Inter', sans-serif; display: flex; background: #0a0a0a; }
        .left { flex: 1; position: relative; overflow: hidden; }
        .left-bg {
            position: absolute; inset: 0;
            background: url('https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=1200&q=80') center/cover;
        }
        .left-overlay {
            position: absolute; inset: 0;
            background: linear-gradient(135deg, rgba(0,0,0,0.75) 0%, rgba(10,10,10,0.4) 100%);
        }
        .left-content {
            position: relative; z-index: 1; height: 100%;
            display: flex; flex-direction: column;
            justify-content: flex-end; padding: 48px;
        }
        .left-tag {
            display: inline-block; background: rgba(201,168,76,0.2); color: #c9a84c;
            font-size: 11px; font-weight: 600; padding: 5px 14px; border-radius: 20px;
            text-transform: uppercase; letter-spacing: 2px;
            border: 1px solid rgba(201,168,76,0.4); margin-bottom: 16px; width: fit-content;
        }
        .left-content h1 {
            font-family: 'Rajdhani', sans-serif; font-size: 48px;
            font-weight: 700; color: white; line-height: 1.1; margin-bottom: 12px;
        }
        .left-content h1 span { color: #c9a84c; }
        .left-content p { font-size: 15px; color: rgba(255,255,255,0.5); max-width: 380px; line-height: 1.6; }
        .left-stats { display: flex; gap: 32px; margin-top: 32px; padding-top: 32px; border-top: 1px solid rgba(255,255,255,0.1); }
        .left-stat .num { font-family: 'Rajdhani', sans-serif; font-size: 28px; font-weight: 700; color: #c9a84c; }
        .left-stat .lbl { font-size: 12px; color: rgba(255,255,255,0.4); text-transform: uppercase; letter-spacing: 1px; margin-top: 2px; }
        .right {
            width: 480px; flex-shrink: 0; background: #0f0f0f;
            border-left: 1px solid #1e1e1e;
            display: flex; flex-direction: column;
            justify-content: center; padding: 56px 48px;
        }
        .right-logo { margin-bottom: 36px; }
        .right-logo .icon { font-size: 32px; margin-bottom: 10px; }
        .right-logo h5 { font-family: 'Rajdhani', sans-serif; font-size: 24px; font-weight: 700; color: #c9a84c; letter-spacing: 1px; }
        .right-logo p { font-size: 12px; color: #444; letter-spacing: 2px; text-transform: uppercase; margin-top: 3px; }

        /* Toggle */
        .toggle-wrapper { display: flex; background: #0a0a0a; border: 1px solid #222; border-radius: 10px; padding: 4px; margin-bottom: 28px; }
        .toggle-btn {
            flex: 1; padding: 10px; border: none; border-radius: 8px;
            font-size: 13px; font-weight: 600; cursor: pointer;
            font-family: 'Inter', sans-serif; transition: all 0.2s;
            background: transparent; color: #444;
            text-transform: uppercase; letter-spacing: 1px;
        }
        .toggle-btn.active { background: linear-gradient(135deg, #c9a84c, #8b6914); color: #0a0a0a; }

        .form-title { font-size: 22px; font-weight: 600; color: #e0e0e0; margin-bottom: 6px; }
        .form-sub   { font-size: 13px; color: #444; margin-bottom: 28px; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; font-size: 11px; font-weight: 600; color: #555; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 8px; }
        .form-group input {
            width: 100%; padding: 13px 16px; background: #0a0a0a;
            border: 1px solid #222; border-radius: 10px;
            font-size: 14px; color: #e0e0e0; outline: none; transition: border 0.2s;
            font-family: 'Inter', sans-serif;
        }
        .form-group input:focus { border-color: #c9a84c; }
        .form-group input::placeholder { color: #333; }
        .member-hint {
            background: rgba(201,168,76,0.08); border: 1px solid rgba(201,168,76,0.2);
            border-radius: 8px; padding: 10px 14px;
            font-size: 12px; color: #c9a84c; margin-bottom: 20px;
            display: none;
        }
        .member-hint.show { display: block; }
        .btn-login {
            width: 100%; padding: 14px; border: none; border-radius: 10px;
            font-size: 15px; font-weight: 700; cursor: pointer;
            font-family: 'Rajdhani', sans-serif; letter-spacing: 1px;
            text-transform: uppercase; transition: all 0.2s; margin-top: 8px;
            background: linear-gradient(135deg, #c9a84c, #8b6914); color: #0a0a0a;
        }
        .btn-login:hover { background: linear-gradient(135deg, #dbb85c, #9b7924); transform: translateY(-1px); }
        .error-box {
            background: rgba(224,85,85,0.1); border: 1px solid rgba(224,85,85,0.3);
            color: #e05555; padding: 12px 16px; border-radius: 10px;
            font-size: 13px; margin-bottom: 20px; display: flex; align-items: center; gap: 8px;
        }
        .divider { height: 1px; background: #1a1a1a; margin: 28px 0; }
        .hint { text-align: center; font-size: 12px; color: #333; }
        .hint span { color: #c9a84c; }
        .footer-text { font-size: 11px; color: #2a2a2a; text-align: center; margin-top: 16px; }
    </style>
</head>
<body>

<!-- Left side -->
<div class="left">
    <div class="left-bg"></div>
    <div class="left-overlay"></div>
    <div class="left-content">
        <div class="left-tag">&#127947; Elite Fitness</div>
        <h1>Power Your <span>Performance</span></h1>
        <p>Manage your fitness center with a powerful system built for results.</p>
        <div class="left-stats">
            <div class="left-stat">
                <div class="num">500+</div>
                <div class="lbl">Members</div>
            </div>
            <div class="left-stat">
                <div class="num">20+</div>
                <div class="lbl">Trainers</div>
            </div>
            <div class="left-stat">
                <div class="num">15+</div>
                <div class="lbl">Classes</div>
            </div>
        </div>
    </div>
</div>

<!-- Right side -->
<div class="right">
    <div class="right-logo">
        <div class="icon">&#127947;</div>
        <h5>FITNESS CENTER</h5>
        <p>Management System</p>
    </div>

    <!-- Toggle -->
    <div class="toggle-wrapper">
        <button class="toggle-btn active" id="memberBtn" onclick="switchType('member')">
            &#128100; Member
        </button>
        <button class="toggle-btn" id="staffBtn" onclick="switchType('staff')">
            &#128188; Staff
        </button>
    </div>

    <div class="form-title" id="formTitle">Member Login</div>
    <div class="form-sub" id="formSub">Enter your Member ID and password</div>

    <% if (request.getAttribute("error") != null) { %>
    <div class="error-box">&#9888; ${error}</div>
    <% } %>

    <div class="member-hint show" id="memberHint">
        &#128274; Use your Member ID (e.g. M001) as your username
    </div>

    <form method="POST" action="/login">
        <input type="hidden" name="userType" id="userType" value="member">

        <div class="form-group">
            <label id="usernameLabel">Member ID</label>
            <input type="text" name="username" id="usernameInput"
                   placeholder="Enter your Member ID" required autofocus
                   value="${param.username}">
        </div>
        <div class="form-group">
            <label>Password</label>
            <input type="password" name="password" placeholder="Enter your password" required>
        </div>
        <button type="submit" class="btn-login" id="loginBtn">Sign In as Member</button>
    </form>

    <div class="divider"></div>
    <p class="hint" id="hintText">
        Member default &nbsp;|&nbsp; <span>M001 / member123</span>
    </p>
    <p class="footer-text">Fitness Center Management System &copy; 2026</p>
</div>

<script>
    <% if (request.getAttribute("userType") != null) { %>
        switchType('${userType}');
    <% } %>

    function switchType(type) {
        const memberBtn    = document.getElementById('memberBtn');
        const staffBtn     = document.getElementById('staffBtn');
        const userType     = document.getElementById('userType');
        const formTitle    = document.getElementById('formTitle');
        const formSub      = document.getElementById('formSub');
        const usernameLabel = document.getElementById('usernameLabel');
        const usernameInput = document.getElementById('usernameInput');
        const memberHint   = document.getElementById('memberHint');
        const loginBtn     = document.getElementById('loginBtn');
        const hintText     = document.getElementById('hintText');

        if (type === 'member') {
            memberBtn.classList.add('active');
            staffBtn.classList.remove('active');
            userType.value        = 'member';
            formTitle.textContent = 'Member Login';
            formSub.textContent   = 'Enter your Member ID and password';
            usernameLabel.textContent = 'Member ID';
            usernameInput.placeholder = 'Enter your Member ID e.g. M001';
            memberHint.classList.add('show');
            loginBtn.textContent  = 'Sign In as Member';
            hintText.innerHTML    = 'Member default &nbsp;|&nbsp; <span style="color:#c9a84c">M001 / member123</span>';
        } else {
            staffBtn.classList.add('active');
            memberBtn.classList.remove('active');
            userType.value        = 'staff';
            formTitle.textContent = 'Staff Login';
            formSub.textContent   = 'Enter your staff username and password';
            usernameLabel.textContent = 'Username';
            usernameInput.placeholder = 'Enter your username';
            memberHint.classList.remove('show');
            loginBtn.textContent  = 'Sign In as Staff';
            hintText.innerHTML    = 'Staff default &nbsp;|&nbsp; <span style="color:#c9a84c">admin / admin123</span>';
        }
    }
</script>
</body>
</html>