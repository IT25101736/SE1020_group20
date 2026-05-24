<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.fitnesscenter.model.Admin" %>
<%
    Admin loggedAdmin = (Admin) session.getAttribute("loggedAdmin");
    if (loggedAdmin == null) {
        response.sendRedirect("/login");
        return;
    }
    List<Admin> admins = (List<Admin>) request.getAttribute("admins");
    int superCount = 0;
    if (admins != null) {
        for (Admin a : admins) {
            if (a.getRole().equals("superadmin")) superCount++;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard — Fitness Center</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Rajdhani:wght@500;600;700&family=Inter:wght@400;500;600&display=swap');
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { background: radial-gradient(ellipse at bottom, #1a1400 0%, #0a0a0a 100%); font-family: 'Inter', sans-serif; color: #e0e0e0; min-height: 100vh; display: flex; flex-direction: column; overflow-x: hidden; }
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
        .badge-count { background: #e05555; color: white; font-size: 10px; font-weight: 700; padding: 2px 6px; border-radius: 10px; margin-left: auto; }
        .main { margin-left: 260px; min-height: 100vh; position: relative; z-index: 1; }
        .hero { position: relative; overflow: hidden; background: rgba(15,15,15,0.7); backdrop-filter: blur(10px); padding: 40px 40px 36px; border-bottom: 1px solid rgba(201,168,76,0.15); }
        .hero-bg { position: absolute; top: 0; right: 0; width: 50%; height: 100%; background: url('https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800&q=80') center/cover; opacity: 0.06; }
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
        .stats { display: grid; grid-template-columns: repeat(4,1fr); gap: 16px; margin-bottom: 32px; }
        .stat { background: rgba(255,255,255,0.04); backdrop-filter: blur(15px); border: 1px solid rgba(255,255,255,0.08); border-radius: 20px; padding: 24px; position: relative; overflow: hidden; transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275); }
        .stat:hover { transform: translateY(-8px); background: rgba(255,255,255,0.07); border-color: #c9a84c; box-shadow: 0 20px 40px rgba(0,0,0,0.4); }
        .stat-icon { width: 52px; height: 52px; border-radius: 14px; display: flex; align-items: center; justify-content: center; font-size: 22px; margin-bottom: 16px; transition: all 0.3s; }
        .stat:hover .stat-icon { transform: scale(1.1) rotate(-5deg); }
        .stat-icon-gold   { background: linear-gradient(135deg, rgba(201,168,76,0.25), rgba(201,168,76,0.1)); color: #c9a84c; }
        .stat-icon-blue   { background: linear-gradient(135deg, rgba(91,196,245,0.25), rgba(91,196,245,0.1)); color: #5bc4f5; }
        .stat-icon-green  { background: linear-gradient(135deg, rgba(74,222,128,0.25), rgba(74,222,128,0.1)); color: #4ade80; }
        .stat-icon-orange { background: linear-gradient(135deg, rgba(249,115,22,0.25), rgba(249,115,22,0.1)); color: #f97316; }
        .stat .num { font-family: 'Rajdhani', sans-serif; font-size: 36px; font-weight: 700; color: #fff; line-height: 1; }
        .stat .lbl { font-size: 12px; color: #555; margin-top: 6px; text-transform: uppercase; letter-spacing: 1px; }
        .two-col { display: grid; grid-template-columns: 1fr 340px; gap: 24px; }
        .glass-card { background: rgba(255,255,255,0.03); backdrop-filter: blur(15px); border: 1px solid rgba(255,255,255,0.06); border-radius: 20px; overflow: hidden; }
        .card-head { display: flex; justify-content: space-between; align-items: center; padding: 20px 24px; border-bottom: 1px solid rgba(255,255,255,0.06); background: rgba(0,0,0,0.2); }
        .card-head h5 { font-family: 'Rajdhani', sans-serif; font-size: 18px; font-weight: 700; color: #c9a84c; }
        .card-head p { font-size: 12px; color: #444; margin-top: 2px; }
        .live-badge { background: rgba(74,222,128,0.1); color: #4ade80; font-size: 10px; font-weight: 700; padding: 4px 10px; border-radius: 20px; border: 1px solid rgba(74,222,128,0.2); text-transform: uppercase; letter-spacing: 1px; }
        table { width: 100%; border-collapse: collapse; }
        thead th { padding: 14px 24px; text-align: left; font-size: 11px; font-weight: 600; color: #444; text-transform: uppercase; letter-spacing: 1px; background: rgba(0,0,0,0.2); border-bottom: 1px solid rgba(255,255,255,0.05); }
        tbody td { padding: 14px 24px; border-bottom: 1px solid rgba(255,255,255,0.04); color: #aaa; }
        tbody tr:hover { background: rgba(201,168,76,0.04); }
        tbody tr:last-child td { border-bottom: none; }
        code { background: rgba(201,168,76,0.1); color: #c9a84c; padding: 3px 8px; border-radius: 5px; font-size: 12px; border: 1px solid rgba(201,168,76,0.2); }
        .td-name { color: #e0e0e0; font-weight: 500; }
        .badge { padding: 4px 12px; border-radius: 20px; font-size: 11px; font-weight: 600; text-transform: uppercase; letter-spacing: 1px; }
        .badge-super   { background: rgba(201,168,76,0.15); color: #c9a84c; border: 1px solid rgba(201,168,76,0.3); }
        .badge-regular { background: rgba(255,255,255,0.05); color: #666; border: 1px solid rgba(255,255,255,0.1); }
        .log-entry { border-left: 3px solid #c9a84c; padding: 14px 16px; margin: 0 16px 10px; border-radius: 0 12px 12px 0; background: rgba(255,255,255,0.02); display: flex; justify-content: space-between; align-items: center; transition: all 0.3s; }
        .log-entry:hover { background: rgba(201,168,76,0.05); transform: translateX(4px); }
        .log-entry:nth-child(even) { border-left-color: #5bc4f5; }
        .log-entry:nth-child(3) { border-left-color: #4ade80; }
        .log-user { font-weight: 700; color: #fff; font-size: 13px; display: block; margin-bottom: 2px; }
        .log-action { font-size: 10px; padding: 2px 8px; border-radius: 6px; background: rgba(201,168,76,0.15); color: #c9a84c; font-weight: 600; margin-left: 6px; }
        .log-details { color: rgba(255,255,255,0.4); font-size: 12px; margin: 0; }
        .log-time { color: rgba(255,255,255,0.25); font-size: 11px; white-space: nowrap; margin-left: 12px; }
        .logs-body { padding: 16px 0; }
        .quick-action-btn { background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.08); border-radius: 14px; padding: 16px; color: white; text-decoration: none; display: flex; align-items: center; transition: all 0.3s; margin: 0 16px 12px; }
        .quick-action-btn:hover { background: linear-gradient(135deg, rgba(201,168,76,0.2), rgba(139,105,20,0.2)); border-color: #c9a84c; transform: scale(1.02); color: white; }
        .quick-action-icon { font-size: 20px; margin-right: 14px; width: 28px; text-align: center; }
        .quick-action-title { font-weight: 600; font-size: 14px; color: #e0e0e0; }
        .quick-action-sub { font-size: 11px; color: #555; margin-top: 2px; }
        .quick-actions-body { padding: 16px 0; }
        .btn { padding: 8px 18px; border-radius: 8px; font-size: 13px; font-weight: 500; cursor: pointer; border: none; transition: all 0.2s; font-family: 'Inter', sans-serif; }
        .btn-gold { background: linear-gradient(135deg, #c9a84c, #8b6914); color: #0a0a0a; font-weight: 600; }
        .btn-gold:hover { background: linear-gradient(135deg, #dbb85c, #9b7924); transform: translateY(-1px); }
        .btn-outline { background: transparent; color: #666; border: 1px solid rgba(255,255,255,0.1); }
        .btn-outline:hover { border-color: #c9a84c; color: #c9a84c; }
        .btn-danger { background: transparent; color: #e05555; border: 1px solid rgba(224,85,85,0.3); }
        .btn-danger:hover { background: #e05555; color: white; }
        .btn-sm { padding: 6px 12px; font-size: 12px; }
        .overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.85); z-index: 1000; align-items: center; justify-content: center; backdrop-filter: blur(8px); }
        .overlay.show { display: flex; }
        .modal-box { background: rgba(17,17,17,0.95); backdrop-filter: blur(20px); border: 1px solid rgba(201,168,76,0.2); border-radius: 20px; padding: 32px; width: 460px; box-shadow: 0 25px 60px rgba(0,0,0,0.6); }
        .modal-box h5 { font-family: 'Rajdhani', sans-serif; font-size: 22px; font-weight: 700; color: #c9a84c; margin-bottom: 4px; }
        .modal-box p { font-size: 13px; color: #444; margin-bottom: 24px; }
        .form-group { margin-bottom: 16px; }
        .form-group label { display: block; font-size: 12px; font-weight: 600; margin-bottom: 6px; color: #666; text-transform: uppercase; letter-spacing: 1px; }
        .form-group input, .form-group select { width: 100%; padding: 11px 14px; background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.1); border-radius: 10px; font-size: 14px; color: #e0e0e0; outline: none; transition: border 0.2s; font-family: 'Inter', sans-serif; }
        .form-group input:focus, .form-group select:focus { border-color: #c9a84c; background: rgba(201,168,76,0.05); }
        .form-group select option { background: #111; }
        .modal-footer { display: flex; justify-content: flex-end; gap: 10px; margin-top: 24px; padding-top: 20px; border-top: 1px solid rgba(255,255,255,0.06); }
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
    <a href="/dashboard" class="active">&#128187; &nbsp; Dashboard</a>
    <a href="/members">&#128101; &nbsp; Members</a>
    <a href="/payments">&#128179; &nbsp; Payments</a>
    <a href="/renewals">&#128260; &nbsp; Renewal Queue</a>
    <a href="/manage/workouts">&#127947; &nbsp; Workouts</a>
    <a href="/admin/diet">&#127822; &nbsp; Diet Plans</a>
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
            <div class="hero-tag">Admin Panel</div>
            <h1>Welcome Back, <span><%= loggedAdmin.getUsername() %></span></h1>
            <p>Manage your fitness center operations from one place</p>
            <div class="status-pill">
                <div class="status-dot"></div>
                All Systems Operational
            </div>
        </div>
    </div>

    <div class="content">
        <div class="stats">
            <div class="stat">
                <div class="stat-icon stat-icon-gold">&#127947;</div>
                <div class="num"><%= admins != null ? admins.size() : 0 %></div>
                <div class="lbl">Total Admins</div>
            </div>
            <div class="stat">
                <div class="stat-icon stat-icon-blue">&#11088;</div>
                <div class="num"><%= superCount %></div>
                <div class="lbl">Managers</div>
            </div>
            <div class="stat">
                <div class="stat-icon stat-icon-green">&#128101;</div>
                <div class="num"><%= admins != null ? admins.size() - superCount : 0 %></div>
                <div class="lbl">Staff</div>
            </div>
            <div class="stat">
                <div class="stat-icon stat-icon-orange">&#128200;</div>
                <div class="num">98%</div>
                <div class="lbl">System Uptime</div>
            </div>
        </div>

        <div class="two-col">
            <div class="glass-card">
                <div class="card-head">
                    <div>
                        <h5>Admin Accounts</h5>
                        <p>Manage system administrator accounts</p>
                    </div>
                    <button class="btn btn-gold"
                            onclick="document.getElementById('addOverlay').classList.add('show')">
                        + Add New Admin
                    </button>
                </div>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th><th>Username</th><th>Role</th><th>Access</th><th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% if (admins != null && !admins.isEmpty()) {
                        for (Admin a : admins) { %>
                        <tr>
                            <td><code><%= a.getId() %></code></td>
                            <td class="td-name"><%= a.getUsername() %></td>
                            <td>
                                <span class="badge <%= a.getRole().equals("superadmin") ? "badge-super" : "badge-regular" %>">
                                    <%= a.getRole().equals("superadmin") ? "Manager" : "Staff" %>
                                </span>
                            </td>
                            <td style="color:#666;font-size:13px"><%= a.getAccessLevel() %></td>
                            <td>
                                <button class="btn btn-outline btn-sm"
                                        onclick="openEdit('<%= a.getId() %>','<%= a.getRole() %>')"
                                        style="margin-right:6px">&#9998; Edit</button>
                                <% if (!a.getId().equals(loggedAdmin.getId())) { %>
                                <form method="POST" action="/admin/delete" style="display:inline"
                                      onsubmit="return confirm('Delete this admin?')">
                                    <input type="hidden" name="id" value="<%= a.getId() %>">
                                    <button class="btn btn-danger btn-sm">&#128465;</button>
                                </form>
                                <% } else { %>
                                <button class="btn btn-danger btn-sm" disabled style="opacity:0.3">&#128465;</button>
                                <% } %>
                            </td>
                        </tr>
                    <% } } else { %>
                        <tr><td colspan="5" style="text-align:center;padding:40px;color:#333">No admins found.</td></tr>
                    <% } %>
                    </tbody>
                </table>
            </div>

            <div style="display:flex;flex-direction:column;gap:24px;">
                <div class="glass-card">
                    <div class="card-head">
                        <div><h5>Activity Logs</h5><p>Recent system activity</p></div>
                        <span class="live-badge">&#9679; Live</span>
                    </div>
                    <div class="logs-body">
                        <div class="log-entry">
                            <div>
                                <span class="log-user">@<%= loggedAdmin.getUsername() %> <span class="log-action">LOGIN</span></span>
                                <p class="log-details">Admin logged into the system</p>
                            </div>
                            <span class="log-time">Just now</span>
                        </div>
                        <div class="log-entry">
                            <div>
                                <span class="log-user">@system <span class="log-action" style="background:rgba(91,196,245,0.15);color:#5bc4f5">BACKUP</span></span>
                                <p class="log-details">Daily data backup completed</p>
                            </div>
                            <span class="log-time">1h ago</span>
                        </div>
                        <div class="log-entry">
                            <div>
                                <span class="log-user">@system <span class="log-action" style="background:rgba(74,222,128,0.15);color:#4ade80">ONLINE</span></span>
                                <p class="log-details">All systems operational</p>
                            </div>
                            <span class="log-time">Today</span>
                        </div>
                    </div>
                </div>

                <div class="glass-card">
                    <div class="card-head"><div><h5>Quick Actions</h5></div></div>
                    <div class="quick-actions-body">
                        <a href="#" class="quick-action-btn"
                           onclick="document.getElementById('addOverlay').classList.add('show'); return false;">
                            <span class="quick-action-icon">&#128100;</span>
                            <div>
                                <div class="quick-action-title">Add New Admin</div>
                                <div class="quick-action-sub">Create a new admin account</div>
                            </div>
                        </a>
                        <a href="/members" class="quick-action-btn">
                            <span class="quick-action-icon">&#128101;</span>
                            <div>
                                <div class="quick-action-title">Manage Members</div>
                                <div class="quick-action-sub">View and edit members</div>
                            </div>
                        </a>
                        <a href="/renewals" class="quick-action-btn">
                            <span class="quick-action-icon">&#128260;</span>
                            <div>
                                <div class="quick-action-title">Renewal Queue</div>
                                <div class="quick-action-sub">Process member renewals (FIFO)</div>
                            </div>
                        </a>
                        <a href="/logout" class="quick-action-btn">
                            <span class="quick-action-icon">&#128275;</span>
                            <div>
                                <div class="quick-action-title">Sign Out</div>
                                <div class="quick-action-sub">End your session</div>
                            </div>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Add Admin Modal -->
<div class="overlay" id="addOverlay">
    <div class="modal-box">
        <h5>Add New Admin</h5>
        <p>Create a new administrator account</p>
        <form method="POST" action="/admin/create">
            <div class="form-group">
                <label>Username</label>
                <input type="text" name="username" placeholder="Enter username" required>
            </div>
            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" placeholder="Enter password" required>
            </div>
            <div class="form-group">
                <label>Role</label>
                <select name="role">
                    <option value="regular">Staff</option>
                    <option value="superadmin">Manager</option>
                </select>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline"
                        onclick="document.getElementById('addOverlay').classList.remove('show')">Cancel</button>
                <button type="submit" class="btn btn-gold">Create Admin</button>
            </div>
        </form>
    </div>
</div>

<!-- Edit Admin Modal -->
<div class="overlay" id="editOverlay">
    <div class="modal-box">
        <h5>Edit Admin</h5>
        <p>Update admin credentials or role</p>
        <form method="POST" action="/admin/update">
            <input type="hidden" name="id" id="editId">
            <div class="form-group">
                <label>New Password</label>
                <input type="password" name="password" placeholder="Leave blank to keep current">
            </div>
            <div class="form-group">
                <label>Role</label>
                <select name="role" id="editRole">
                    <option value="regular">Staff</option>
                    <option value="superadmin">Manager</option>
                </select>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline"
                        onclick="document.getElementById('editOverlay').classList.remove('show')">Cancel</button>
                <button type="submit" class="btn btn-gold">Save Changes</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openEdit(id, role) {
        document.getElementById('editId').value = id;
        document.getElementById('editRole').value = role;
        document.getElementById('editOverlay').classList.add('show');
    }
</script>
</body>
</html>