<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Queue" %>
<%@ page import="com.fitnesscenter.model.RenewalRequest" %>
<%@ page import="com.fitnesscenter.model.Member" %>
<%@ page import="com.fitnesscenter.model.Admin" %>
<%
    Admin loggedAdmin = (Admin) session.getAttribute("loggedAdmin");
    if (loggedAdmin == null) { response.sendRedirect("/login"); return; }
    Queue<RenewalRequest> pendingQueue = (Queue<RenewalRequest>) request.getAttribute("pendingQueue");
    List<RenewalRequest> allRequests   = (List<RenewalRequest>) request.getAttribute("allRequests");
    List<Member> sortedMembers         = (List<Member>) request.getAttribute("sortedMembers");
    int pendingCount = (int) request.getAttribute("pendingCount");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Renewal Queue — Fitness Center</title>
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
        .badge-count { background: #e05555; color: white; font-size: 10px; font-weight: 700; padding: 2px 6px; border-radius: 10px; margin-left: auto; }
        .sidebar-footer { margin-top: auto; padding: 20px 24px; border-top: 1px solid #1e1e1e; }
        .sidebar-footer a { color: #444; font-size: 13px; text-decoration: none; display: flex; align-items: center; gap: 8px; }
        .sidebar-footer a:hover { color: #e05555; }
        .main { margin-left: 260px; min-height: 100vh; }
        .hero { position: relative; overflow: hidden; background: #0f0f0f; padding: 40px 40px 36px; border-bottom: 1px solid #1e1e1e; }
        .hero-bg { position: absolute; top: 0; right: 0; width: 50%; height: 100%; background: url('https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800&q=80') center/cover; opacity: 0.06; }
        .hero-bg-gradient { position: absolute; top: 0; right: 0; width: 55%; height: 100%; background: linear-gradient(to right, #0f0f0f 30%, transparent); }
        .hero-content { position: relative; z-index: 1; }
        .hero-tag { display: inline-block; background: rgba(201,168,76,0.15); color: #c9a84c; font-size: 11px; font-weight: 600; padding: 4px 12px; border-radius: 20px; text-transform: uppercase; letter-spacing: 2px; border: 1px solid rgba(201,168,76,0.3); margin-bottom: 12px; }
        .hero h1 { font-family: 'Rajdhani', sans-serif; font-size: 36px; font-weight: 700; color: #fff; line-height: 1.1; margin-bottom: 8px; }
        .hero h1 span { color: #c9a84c; }
        .hero p { font-size: 14px; color: #555; }
        .content { padding: 32px 40px; }
        .stats { display: grid; grid-template-columns: repeat(3,1fr); gap: 16px; margin-bottom: 28px; }
        .stat { background: #111; border: 1px solid #1e1e1e; border-radius: 12px; padding: 20px 22px; position: relative; overflow: hidden; transition: all 0.2s; }
        .stat:hover { border-color: #c9a84c; transform: translateY(-2px); }
        .stat::before { content:''; position:absolute; top:0; left:0; width:3px; height:100%; background:#c9a84c; }
        .stat:nth-child(2)::before { background: #4ade80; }
        .stat:nth-child(3)::before { background: #5bc4f5; }
        .stat .num { font-family:'Rajdhani',sans-serif; font-size:36px; font-weight:700; color:#c9a84c; }
        .stat:nth-child(2) .num { color: #4ade80; }
        .stat:nth-child(3) .num { color: #5bc4f5; }
        .stat .lbl { font-size:12px; color:#555; margin-top:4px; text-transform:uppercase; letter-spacing:1px; }
        .two-col { display: grid; grid-template-columns: 1fr 1fr; gap: 24px; margin-bottom: 28px; }
        .card { background: #111; border: 1px solid #1e1e1e; border-radius: 14px; overflow: hidden; }
        .card-head { padding: 18px 22px; border-bottom: 1px solid #1e1e1e; background: #0f0f0f; display: flex; justify-content: space-between; align-items: center; }
        .card-head h5 { font-family: 'Rajdhani', sans-serif; font-size: 17px; font-weight: 700; color: #c9a84c; }
        .card-head p { font-size: 12px; color: #444; margin-top: 2px; }
        .card-body { padding: 16px; }
        .queue-visual { padding: 16px 20px; background: rgba(201,168,76,0.04); border-bottom: 1px solid #1e1e1e; display: flex; align-items: center; gap: 8px; overflow-x: auto; }
        .queue-label { font-size: 11px; color: #444; text-transform: uppercase; letter-spacing: 1px; white-space: nowrap; }
        .queue-item { background: rgba(201,168,76,0.1); border: 1px solid rgba(201,168,76,0.3); border-radius: 8px; padding: 6px 12px; font-size: 12px; color: #c9a84c; font-weight: 600; white-space: nowrap; flex-shrink: 0; }
        .queue-item.first { background: rgba(74,222,128,0.1); border-color: rgba(74,222,128,0.3); color: #4ade80; }
        .queue-empty { font-size: 13px; color: #333; }
        .btn-process { background: linear-gradient(135deg, #4ade80, #16a34a); color: #0a0a0a; border: none; padding: 10px 20px; border-radius: 8px; font-size: 13px; font-weight: 700; cursor: pointer; font-family: 'Rajdhani', sans-serif; letter-spacing: 1px; text-transform: uppercase; transition: all 0.2s; }
        .btn-process:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(74,222,128,0.3); }
        .btn-process:disabled { opacity: 0.3; cursor: not-allowed; transform: none; }
        .request-card { background: rgba(255,255,255,0.03); border: 1px solid #1e1e1e; border-radius: 10px; padding: 14px; margin-bottom: 10px; display: flex; justify-content: space-between; align-items: center; transition: all 0.2s; }
        .request-card:hover { border-color: rgba(201,168,76,0.3); }
        .request-card.first-item { border-color: rgba(74,222,128,0.3); background: rgba(74,222,128,0.04); }
        .request-info .name { font-size: 14px; font-weight: 600; color: #e0e0e0; }
        .request-info .details { font-size: 12px; color: #555; margin-top: 3px; }
        .request-info .plan-change { display: flex; align-items: center; gap: 6px; margin-top: 6px; font-size: 12px; }
        .plan-from { color: #555; }
        .plan-arrow { color: #c9a84c; }
        .plan-to { color: #c9a84c; font-weight: 600; }
        .badge-pending { background: rgba(249,115,22,0.1); color: #f97316; border: 1px solid rgba(249,115,22,0.2); padding: 3px 10px; border-radius: 20px; font-size: 11px; font-weight: 600; }
        .badge-processed { background: rgba(74,222,128,0.1); color: #4ade80; border: 1px solid rgba(74,222,128,0.2); padding: 3px 10px; border-radius: 20px; font-size: 11px; font-weight: 600; }
        .fifo-tag { background: rgba(91,196,245,0.1); color: #5bc4f5; border: 1px solid rgba(91,196,245,0.2); padding: 2px 8px; border-radius: 6px; font-size: 10px; font-weight: 700; letter-spacing: 1px; }
        .algo-tag { display: inline-flex; align-items: center; gap: 6px; background: rgba(91,196,245,0.1); border: 1px solid rgba(91,196,245,0.2); color: #5bc4f5; padding: 4px 12px; border-radius: 20px; font-size: 11px; font-weight: 600; margin-left: 10px; }
        .dsa-note { background: rgba(91,196,245,0.04); border: 1px solid rgba(91,196,245,0.15); border-radius: 10px; padding: 12px 16px; margin-bottom: 16px; font-size: 12px; color: #5bc4f5; line-height: 1.6; }
        .empty-queue { text-align: center; padding: 32px; color: #333; }
        table { width: 100%; border-collapse: collapse; }
        thead th { padding: 12px 18px; text-align: left; font-size: 11px; font-weight: 600; color: #444; text-transform: uppercase; letter-spacing: 1px; background: #0d0d0d; border-bottom: 1px solid #1e1e1e; }
        tbody td { padding: 11px 18px; border-bottom: 1px solid #161616; color: #aaa; font-size: 13px; }
        tbody tr:hover { background: rgba(201,168,76,0.03); }
        tbody tr:last-child td { border-bottom: none; }
        .rank { font-family: 'Rajdhani', sans-serif; font-size: 16px; font-weight: 700; color: #c9a84c; }
        .rank.urgent { color: #e05555; }
        .rank.warning { color: #f97316; }
        code { background: rgba(201,168,76,0.1); color: #c9a84c; padding: 3px 8px; border-radius: 5px; font-size: 12px; border: 1px solid rgba(201,168,76,0.2); }
        .td-name { color: #e0e0e0; font-weight: 500; }
        .expiry-soon { color: #e05555; font-weight: 600; }
        .expiry-ok { color: #4ade80; }
        .btn { padding: 8px 16px; border-radius: 8px; font-size: 13px; font-weight: 500; cursor: pointer; border: none; transition: all 0.2s; font-family: 'Inter', sans-serif; }
        .btn-outline { background: transparent; color: #666; border: 1px solid #2a2a2a; }
        .btn-outline:hover { border-color: #c9a84c; color: #c9a84c; }
        .btn-sm { padding: 5px 10px; font-size: 11px; }
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
    <a href="/renewals" class="active">
        &#128260; &nbsp; Renewal Queue
        <% if (pendingCount > 0) { %>
        <span class="badge-count"><%= pendingCount %></span>
        <% } %>
    </a>
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
            <div class="hero-tag">DSA Feature</div>
            <h1>Renewal <span>Queue</span></h1>
            <p>Queue (FIFO) for renewal requests + Insertion Sort by renewal date</p>
        </div>
    </div>

    <div class="content">

        <div class="stats">
            <div class="stat">
                <div class="num"><%= pendingCount %></div>
                <div class="lbl">Pending in Queue</div>
            </div>
            <div class="stat">
                <div class="num">
                    <%= allRequests != null ? allRequests.stream().filter(r -> r.getStatus().equals("PROCESSED")).count() : 0 %>
                </div>
                <div class="lbl">Processed</div>
            </div>
            <div class="stat">
                <div class="num"><%= allRequests != null ? allRequests.size() : 0 %></div>
                <div class="lbl">Total Requests</div>
            </div>
        </div>

        <div class="two-col">

            <!-- Queue Panel -->
            <div class="card">
                <div class="card-head">
                    <div>
                        <h5>&#128260; Renewal Queue <span class="fifo-tag">FIFO</span></h5>
                        <p>First request received = first to be processed</p>
                    </div>
                    <form method="POST" action="/renewal/dequeue">
                        <button class="btn-process" <%= pendingCount == 0 ? "disabled" : "" %>>
                            &#9654; Process Next
                        </button>
                    </form>
                </div>

                <div class="queue-visual">
                    <span class="queue-label">FRONT &#8594;</span>
                    <% if (pendingQueue != null && !pendingQueue.isEmpty()) {
                        boolean isFirst = true;
                        for (RenewalRequest r : pendingQueue) { %>
                        <span class="queue-item <%= isFirst ? "first" : "" %>"><%= r.getMemberId() %></span>
                        <% if (isFirst) { %><span style="color:#c9a84c;font-size:12px">&#8592; Next</span><% } %>
                        <% isFirst = false; } %>
                    <% } else { %>
                        <span class="queue-empty">Queue is empty</span>
                    <% } %>
                    <span class="queue-label">&#8592; REAR</span>
                </div>

                <div class="card-body">
                    <div class="dsa-note">
                        &#128161; <strong>Queue (FIFO):</strong> New requests added to rear, processed from front. First come, first served!
                    </div>
                    <% if (pendingQueue != null && !pendingQueue.isEmpty()) {
                        boolean isFirst = true;
                        for (RenewalRequest r : pendingQueue) { %>
                        <div class="request-card <%= isFirst ? "first-item" : "" %>">
                            <div class="request-info">
                                <div class="name">
                                    <%= r.getMemberName() %>
                                    <% if (isFirst) { %><span style="font-size:11px;color:#4ade80;margin-left:6px">&#9654; Next</span><% } %>
                                </div>
                                <div class="details"><%= r.getMemberId() %> &nbsp;|&nbsp; <%= r.getRequestDate() %></div>
                                <div class="plan-change">
                                    <span class="plan-from"><%= r.getCurrentPlan() %></span>
                                    <span class="plan-arrow">&#8594;</span>
                                    <span class="plan-to"><%= r.getRequestedPlan() %></span>
                                </div>
                            </div>
                            <div style="display:flex;flex-direction:column;align-items:flex-end;gap:8px">
                                <span class="badge-pending">PENDING</span>
                                <form method="POST" action="/renewal/confirm-and-update">
                                    <input type="hidden" name="requestId"     value="<%= r.getRequestId() %>">
                                    <input type="hidden" name="memberId"      value="<%= r.getMemberId() %>">
                                    <input type="hidden" name="requestedPlan" value="<%= r.getRequestedPlan() %>">
                                    <button class="btn-process" style="font-size:12px;padding:8px 14px">&#10003; Confirm & Accept</button>
                                </form>
                                <form method="POST" action="/renewal/delete"
                                      onsubmit="return confirm('Delete this renewal request?')">
                                    <input type="hidden" name="requestId" value="<%= r.getRequestId() %>">
                                    <button style="background:transparent;color:#e05555;border:1px solid rgba(224,85,85,0.3);padding:6px 12px;border-radius:8px;font-size:12px;cursor:pointer;font-family:'Inter',sans-serif;transition:all 0.2s"
                                            onmouseover="this.style.background='#e05555';this.style.color='white'"
                                            onmouseout="this.style.background='transparent';this.style.color='#e05555'">
                                        &#128465; Delete
                                    </button>
                                </form>
                            </div>
                        </div>
                        <% isFirst = false; } %>
                    <% } else { %>
                        <div class="empty-queue">
                            <div style="font-size:36px;margin-bottom:10px">&#9989;</div>
                            <p>Queue is empty — all requests processed!</p>
                        </div>
                    <% } %>
                </div>
            </div>

            <!-- Processed History -->
            <div class="card">
                <div class="card-head">
                    <div>
                        <h5>&#9989; Processed Requests</h5>
                        <p>Completed renewal requests</p>
                    </div>
                </div>
                <div class="card-body">
                    <% if (allRequests != null) {
                        boolean hasProcessed = false;
                        for (RenewalRequest r : allRequests) {
                            if (r.getStatus().equals("PROCESSED")) {
                                hasProcessed = true; %>
                        <div class="request-card">
                            <div class="request-info">
                                <div class="name"><%= r.getMemberName() %></div>
                                <div class="details"><%= r.getMemberId() %> &nbsp;|&nbsp; <%= r.getRequestDate() %></div>
                                <div class="plan-change">
                                    <span class="plan-from"><%= r.getCurrentPlan() %></span>
                                    <span class="plan-arrow">&#8594;</span>
                                    <span class="plan-to"><%= r.getRequestedPlan() %></span>
                                </div>
                            </div>
                            <span class="badge-processed">&#10003; DONE</span>
                        </div>
                        <% } }
                        if (!hasProcessed) { %>
                        <div class="empty-queue">
                            <div style="font-size:36px;margin-bottom:10px">&#128203;</div>
                            <p>No processed requests yet</p>
                        </div>
                    <% } } %>
                </div>
            </div>
        </div>

        <!-- Insertion Sort Table -->
        <div class="card">
            <div class="card-head">
                <div>
                    <h5>
                        &#128197; Members by Renewal Date
                        <span class="algo-tag">&#128200; Insertion Sort</span>
                    </h5>
                    <p>Sorted by expiry date — members needing renewal soonest appear at top</p>
                </div>
            </div>
            <div style="padding:12px 20px;background:rgba(91,196,245,0.04);border-bottom:1px solid #1e1e1e">
                <p style="font-size:12px;color:#5bc4f5;line-height:1.6">
                    &#128161; <strong>Insertion Sort:</strong> Each member inserted in correct position by expiry date. Time complexity O(n²).
                </p>
            </div>
            <table>
                <thead>
                    <tr>
                        <th>#</th><th>Member ID</th><th>Name</th><th>Plan</th><th>Expiry Date</th><th>Payment</th><th>Status</th>
                    </tr>
                </thead>
                <tbody>
                <% if (sortedMembers != null && !sortedMembers.isEmpty()) {
                    int rank = 1;
                    String today = java.time.LocalDate.now().toString();
                    for (Member m : sortedMembers) {
                        boolean isUrgent  = m.getExpiryDate().compareTo(today) <= 0;
                        boolean isWarning = !isUrgent && m.getExpiryDate().compareTo(java.time.LocalDate.now().plusDays(30).toString()) <= 0;
                    %>
                    <tr>
                        <td><span class="rank <%= isUrgent ? "urgent" : isWarning ? "warning" : "" %>">
                            <%= isUrgent ? "⚠" : isWarning ? "●" : "" %> <%= rank++ %>
                        </span></td>
                        <td><code><%= m.getId() %></code></td>
                        <td class="td-name"><%= m.getName() %></td>
                        <td><%= m.getMembershipType() %></td>
                        <td class="<%= isUrgent ? "expiry-soon" : isWarning ? "" : "expiry-ok" %>">
                            <%= m.getExpiryDate() %>
                            <% if (isUrgent) { %><span style="font-size:11px"> &#9888; EXPIRED</span><% } %>
                            <% if (isWarning) { %><span style="font-size:11px;color:#f97316"> &#9888; Soon</span><% } %>
                        </td>
                        <td><%= m.getPaymentStatus() %></td>
                        <td>
                            <% if (isUrgent) { %>
                                <span style="background:rgba(224,85,85,0.1);color:#e05555;border:1px solid rgba(224,85,85,0.2);padding:3px 10px;border-radius:20px;font-size:11px;font-weight:600">Needs Renewal</span>
                            <% } else if (isWarning) { %>
                                <span style="background:rgba(249,115,22,0.1);color:#f97316;border:1px solid rgba(249,115,22,0.2);padding:3px 10px;border-radius:20px;font-size:11px;font-weight:600">Renew Soon</span>
                            <% } else { %>
                                <span style="background:rgba(74,222,128,0.1);color:#4ade80;border:1px solid rgba(74,222,128,0.2);padding:3px 10px;border-radius:20px;font-size:11px;font-weight:600">Active</span>
                            <% } %>
                        </td>
                    </tr>
                <% } } else { %>
                    <tr><td colspan="7" style="text-align:center;padding:32px;color:#333">No members found.</td></tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

</body>
</html>
