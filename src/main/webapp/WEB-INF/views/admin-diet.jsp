<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.fitnesscenter.model.Member" %>
<%@ page import="com.fitnesscenter.model.DietPlan" %>
<%@ page import="com.fitnesscenter.model.Admin" %>
<%
    Admin loggedAdmin = (Admin) session.getAttribute("loggedAdmin");
    if (loggedAdmin == null) { response.sendRedirect("/login"); return; }
    List<Member> members     = (List<Member>) request.getAttribute("members");
    List<DietPlan> dietPlans = (List<DietPlan>) request.getAttribute("dietPlans");
    boolean saved = "true".equals(request.getParameter("saved"));

    java.util.Map<String, DietPlan> dietMap = new java.util.HashMap<>();
    if (dietPlans != null) {
        for (DietPlan dp : dietPlans) {
            dietMap.put(dp.getMemberId(), dp);
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Diet Plans — Admin</title>
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
        .content { padding: 32px 40px; }
        .success-toast { background: rgba(74,222,128,0.1); border: 1px solid rgba(74,222,128,0.3); border-radius: 10px; padding: 12px 20px; margin-bottom: 24px; color: #4ade80; font-size: 14px; }
        .card { background: #111; border: 1px solid #1e1e1e; border-radius: 14px; overflow: hidden; }
        .card-head { display: flex; justify-content: space-between; align-items: center; padding: 20px 24px; border-bottom: 1px solid #1e1e1e; background: #0f0f0f; }
        .card-head h5 { font-family: 'Rajdhani', sans-serif; font-size: 18px; font-weight: 700; color: #c9a84c; }
        .card-head p { font-size: 12px; color: #444; margin-top: 2px; }
        table { width: 100%; border-collapse: collapse; }
        thead th { padding: 14px 20px; text-align: left; font-size: 11px; font-weight: 600; color: #444; text-transform: uppercase; letter-spacing: 1px; background: #0d0d0d; border-bottom: 1px solid #1e1e1e; }
        tbody td { padding: 13px 20px; border-bottom: 1px solid #161616; color: #aaa; font-size: 13px; }
        tbody tr:hover { background: rgba(201,168,76,0.03); }
        tbody tr:last-child td { border-bottom: none; }
        code { background: rgba(201,168,76,0.1); color: #c9a84c; padding: 3px 8px; border-radius: 5px; font-size: 12px; border: 1px solid rgba(201,168,76,0.2); }
        .td-name { color: #e0e0e0; font-weight: 500; }
        .badge-assigned { background: rgba(74,222,128,0.1); color: #4ade80; border: 1px solid rgba(74,222,128,0.2); padding: 4px 10px; border-radius: 20px; font-size: 11px; font-weight: 600; }
        .badge-none { background: rgba(255,255,255,0.04); color: #555; border: 1px solid rgba(255,255,255,0.08); padding: 4px 10px; border-radius: 20px; font-size: 11px; }
        .btn { padding: 7px 16px; border-radius: 8px; font-size: 13px; font-weight: 500; cursor: pointer; border: none; transition: all 0.2s; font-family: 'Inter', sans-serif; text-decoration: none; display: inline-block; }
        .btn-gold { background: linear-gradient(135deg, #c9a84c, #8b6914); color: #0a0a0a; font-weight: 600; }
        .btn-gold:hover { transform: translateY(-1px); }
        .btn-danger { background: transparent; color: #e05555; border: 1px solid rgba(224,85,85,0.3); }
        .btn-danger:hover { background: #e05555; color: white; }
        .btn-sm { padding: 6px 12px; font-size: 12px; }
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
            <h1>Member <span>Diet Plans</span></h1>
            <p>View and manage nutrition plans for all members</p>
        </div>
    </div>

    <div class="content">
        <% if (saved) { %>
        <div class="success-toast">&#10003; Diet plan saved successfully!</div>
        <% } %>

        <div class="card">
            <div class="card-head">
                <div>
                    <h5>All Member Diet Plans</h5>
                    <p>Total: <%= members != null ? members.size() : 0 %> members</p>
                </div>
            </div>
            <table>
                <thead>
                    <tr>
                        <th>Member ID</th>
                        <th>Name</th>
                        <th>Membership</th>
                        <th>Diet Plan</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                <% if (members != null) {
                    for (Member m : members) {
                        DietPlan dp = dietMap.get(m.getId()); %>
                    <tr>
                        <td><code><%= m.getId() %></code></td>
                        <td class="td-name"><%= m.getName() %></td>
                        <td><%= m.getMembershipType() %></td>
                        <td>
                            <% if (dp != null) { %>
                            <span class="badge-assigned">&#127822; <%= dp.getPlanName() %></span>
                            <% } else { %>
                            <span class="badge-none">No Plan</span>
                            <% } %>
                        </td>
                        <td style="display:flex;gap:8px;align-items:center">
                            <a href="/admin/diet/edit?memberId=<%= m.getId() %>" class="btn btn-gold btn-sm">
                                &#9998; <%= dp != null ? "Edit" : "Create" %> Plan
                            </a>
                            <% if (dp != null) { %>
                            <form method="POST" action="/admin/diet/delete" style="display:inline"
                                  onsubmit="return confirm('Delete diet plan for <%= m.getName() %>?')">
                                <input type="hidden" name="memberId" value="<%= m.getId() %>">
                                <button class="btn btn-danger btn-sm">&#128465;</button>
                            </form>
                            <% } %>
                        </td>
                    </tr>
                <% } } %>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>