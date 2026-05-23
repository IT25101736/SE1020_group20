<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.fitnesscenter.model.Payment" %>
<%@ page import="com.fitnesscenter.model.Admin" %>
<%
    Admin loggedAdmin = (Admin) session.getAttribute("loggedAdmin");
    if (loggedAdmin == null) { response.sendRedirect("/login"); return; }
    List<Payment> payments = (List<Payment>) request.getAttribute("payments");
    Long totalRevenue = (Long) request.getAttribute("totalRevenue");
    int paidCount = 0, overdueCount = 0, pendingCount = 0;
    if (payments != null) {
        for (Payment p : payments) {
            if (p.getStatus().equals("Paid")) paidCount++;
            else if (p.getStatus().equals("Overdue")) overdueCount++;
            else pendingCount++;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Payments — Fitness Center</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Rajdhani:wght@500;600;700&family=Inter:wght@400;500;600&display=swap');
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { background: #0a0a0a; font-family: 'Inter', sans-serif; color: #e0e0e0; min-height: 100vh; }
        .sidebar { width: 260px; min-height: 100vh; background: #111111; border-right: 1px solid #222; position: fixed; top: 0; left: 0; display: flex; flex-direction: column; }
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
        .hero-bg { position: absolute; top: 0; right: 0; width: 50%; height: 100%; background: url('https://images.unsplash.com/photo-1554224155-6726b3ff858f?w=800&q=80') center/cover; opacity: 0.06; }
        .hero-bg-gradient { position: absolute; top: 0; right: 0; width: 55%; height: 100%; background: linear-gradient(to right, #0f0f0f 30%, transparent); }
        .hero-content { position: relative; z-index: 1; }
        .hero-tag { display: inline-block; background: rgba(201,168,76,0.15); color: #c9a84c; font-size: 11px; font-weight: 600; padding: 4px 12px; border-radius: 20px; text-transform: uppercase; letter-spacing: 2px; border: 1px solid rgba(201,168,76,0.3); margin-bottom: 12px; }
        .hero h1 { font-family: 'Rajdhani', sans-serif; font-size: 36px; font-weight: 700; color: #ffffff; line-height: 1.1; margin-bottom: 8px; }
        .hero h1 span { color: #c9a84c; }
        .hero p { font-size: 14px; color: #555; }
        .content { padding: 32px 40px; }
        .stats { display: grid; grid-template-columns: repeat(4,1fr); gap: 16px; margin-bottom: 28px; }
        .stat { background: #111; border: 1px solid #1e1e1e; border-radius: 12px; padding: 20px 22px; position: relative; overflow: hidden; transition: all 0.2s; }
        .stat:hover { border-color: #c9a84c; transform: translateY(-2px); }
        .stat::before { content:''; position:absolute; top:0; left:0; width:3px; height:100%; background:#c9a84c; }
        .stat:nth-child(2)::before { background: #4ade80; }
        .stat:nth-child(3)::before { background: #e05555; }
        .stat:nth-child(4)::before { background: #f97316; }
        .stat .num { font-family:'Rajdhani',sans-serif; font-size:28px; font-weight:700; color:#c9a84c; line-height:1; }
        .stat:nth-child(2) .num { color: #4ade80; }
        .stat:nth-child(3) .num { color: #e05555; }
        .stat:nth-child(4) .num { color: #f97316; }
        .stat .lbl { font-size:12px; color:#555; margin-top:6px; text-transform:uppercase; letter-spacing:1px; }
        .card { background:#111; border:1px solid #1e1e1e; border-radius:14px; overflow:hidden; }
        .card-head { display:flex; justify-content:space-between; align-items:center; padding:20px 24px; border-bottom:1px solid #1e1e1e; background:#0f0f0f; flex-wrap:wrap; gap:12px; }
        .card-head h5 { font-family:'Rajdhani',sans-serif; font-size:18px; font-weight:700; color:#c9a84c; }
        .card-head p { font-size:12px; color:#444; margin-top:2px; }
        .search-box { display:flex; align-items:center; background:#0a0a0a; border:1px solid #2a2a2a; border-radius:10px; padding:0 14px; flex:1; max-width:350px; transition:border 0.2s; }
        .search-box:focus-within { border-color:#c9a84c; }
        .search-box input { background:transparent; border:none; outline:none; color:#e0e0e0; font-size:14px; padding:10px 8px; width:100%; font-family:'Inter',sans-serif; }
        .search-box input::placeholder { color:#333; }
        .filter-bar { display:flex; gap:8px; padding:12px 24px; border-bottom:1px solid #1e1e1e; background:#0a0a0a; flex-wrap:wrap; align-items:center; }
        .filter-label { font-size:11px; color:#444; text-transform:uppercase; letter-spacing:1px; }
        .filter-pill { padding:5px 14px; border-radius:20px; font-size:12px; font-weight:500; cursor:pointer; border:1px solid #222; background:transparent; color:#555; transition:all 0.2s; font-family:'Inter',sans-serif; }
        .filter-pill:hover { border-color:#c9a84c; color:#c9a84c; }
        .filter-pill.active { background:rgba(201,168,76,0.1); border-color:#c9a84c; color:#c9a84c; }
        table { width:100%; border-collapse:collapse; }
        thead th { padding:14px 20px; text-align:left; font-size:11px; font-weight:600; color:#444; text-transform:uppercase; letter-spacing:1px; background:#0d0d0d; border-bottom:1px solid #1e1e1e; }
        tbody td { padding:12px 20px; border-bottom:1px solid #161616; color:#aaa; font-size:13px; }
        tbody tr:hover { background:rgba(201,168,76,0.03); }
        tbody tr:last-child td { border-bottom:none; }
        code { background:rgba(201,168,76,0.1); color:#c9a84c; padding:3px 8px; border-radius:5px; font-size:12px; border:1px solid rgba(201,168,76,0.2); }
        .td-name { color:#e0e0e0; font-weight:500; }
        .badge { padding:4px 10px; border-radius:20px; font-size:11px; font-weight:600; }
        .badge-paid { background:rgba(74,222,128,0.1); color:#4ade80; border:1px solid rgba(74,222,128,0.2); }
        .badge-overdue { background:rgba(224,85,85,0.1); color:#e05555; border:1px solid rgba(224,85,85,0.2); }
        .badge-pending { background:rgba(249,115,22,0.1); color:#f97316; border:1px solid rgba(249,115,22,0.2); }
        .badge-card { background:rgba(91,196,245,0.1); color:#5bc4f5; border:1px solid rgba(91,196,245,0.2); }
        .badge-cash { background:rgba(74,222,128,0.1); color:#4ade80; border:1px solid rgba(74,222,128,0.2); }
        .badge-bank { background:rgba(201,168,76,0.1); color:#c9a84c; border:1px solid rgba(201,168,76,0.2); }
        .no-results { text-align:center; padding:48px; color:#333; display:none; }
        .btn { padding:8px 18px; border-radius:8px; font-size:13px; font-weight:500; cursor:pointer; border:none; transition:all 0.2s; font-family:'Inter',sans-serif; }
        .btn-gold { background:linear-gradient(135deg,#c9a84c,#8b6914); color:#0a0a0a; font-weight:600; }
        .btn-gold:hover { background:linear-gradient(135deg,#dbb85c,#9b7924); }
        .btn-outline { background:transparent; color:#666; border:1px solid #2a2a2a; }
        .btn-outline:hover { border-color:#c9a84c; color:#c9a84c; }
        .btn-green { background:transparent; color:#4ade80; border:1px solid rgba(74,222,128,0.3); }
        .btn-green:hover { background:#4ade80; color:#0a0a0a; }
        .btn-danger { background:transparent; color:#e05555; border:1px solid #3a1515; }
        .btn-danger:hover { background:#e05555; color:white; }
        .btn-sm { padding:5px 10px; font-size:11px; }
        .overlay { display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.8); z-index:1000; align-items:center; justify-content:center; backdrop-filter:blur(4px); }
        .overlay.show { display:flex; }
        .modal-box { background:#111; border:1px solid #2a2a2a; border-radius:16px; padding:32px; width:500px; box-shadow:0 25px 60px rgba(0,0,0,0.5); max-height:90vh; overflow-y:auto; }
        .modal-box h5 { font-family:'Rajdhani',sans-serif; font-size:22px; font-weight:700; color:#c9a84c; margin-bottom:4px; }
        .modal-box p { font-size:13px; color:#444; margin-bottom:24px; }
        .form-group { margin-bottom:16px; }
        .form-group label { display:block; font-size:12px; font-weight:600; margin-bottom:6px; color:#666; text-transform:uppercase; letter-spacing:1px; }
        .form-group input, .form-group select { width:100%; padding:11px 14px; background:#0a0a0a; border:1px solid #2a2a2a; border-radius:8px; font-size:14px; color:#e0e0e0; outline:none; transition:border 0.2s; font-family:'Inter',sans-serif; }
        .form-group input:focus, .form-group select:focus { border-color:#c9a84c; }
        .form-group select option { background:#111; }
        .form-row { display:grid; grid-template-columns:1fr 1fr; gap:12px; }
        .modal-footer { display:flex; justify-content:flex-end; gap:10px; margin-top:24px; padding-top:20px; border-top:1px solid #1e1e1e; }
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
    <a href="/payments" class="active">&#128179; &nbsp; Payments</a>
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
            <div class="hero-tag">Payments & Membership</div>
            <h1>Payment <span>Management</span></h1>
            <p>Track and manage all member payments and membership fees</p>
        </div>
    </div>

    <div class="content">
        <div class="stats">
            <div class="stat">
                <div class="num">Rs.<%= totalRevenue != null ? String.format("%,d", totalRevenue) : "0" %></div>
                <div class="lbl">Total Revenue</div>
            </div>
            <div class="stat">
                <div class="num"><%= paidCount %></div>
                <div class="lbl">Paid</div>
            </div>
            <div class="stat">
                <div class="num"><%= overdueCount %></div>
                <div class="lbl">Overdue</div>
            </div>
            <div class="stat">
                <div class="num"><%= pendingCount %></div>
                <div class="lbl">Pending</div>
            </div>
        </div>

        <div class="card">
            <div class="card-head">
                <div>
                    <h5>All Payments</h5>
                    <p id="paymentCount">Total: <%= payments != null ? payments.size() : 0 %> records</p>
                </div>
                <div style="display:flex;gap:12px;align-items:center;flex-wrap:wrap">
                    <div class="search-box">
                        <span>&#128269;</span>
                        <input type="text" id="searchInput" placeholder="Search by name, ID, plan..." oninput="searchPayments()">
                    </div>
                    <button class="btn btn-gold" onclick="document.getElementById('addOverlay').classList.add('show')">
                        + Record Payment
                    </button>
                </div>
            </div>

            <div class="filter-bar">
                <span class="filter-label">Filter:</span>
                <button class="filter-pill active" onclick="filterPayments('all', this)">All</button>
                <button class="filter-pill" onclick="filterPayments('paid', this)">&#10003; Paid</button>
                <button class="filter-pill" onclick="filterPayments('overdue', this)">&#9888; Overdue</button>
                <button class="filter-pill" onclick="filterPayments('pending', this)">&#9679; Pending</button>
                <button class="filter-pill" onclick="filterPayments('card', this)">&#128179; Card</button>
                <button class="filter-pill" onclick="filterPayments('cash', this)">&#128181; Cash</button>
                <button class="filter-pill" onclick="filterPayments('bank', this)">&#127959; Bank</button>
            </div>

            <table>
                <thead>
                    <tr>
                        <th>Payment ID</th>
                        <th>Member ID</th>
                        <th>Member Name</th>
                        <th>Plan</th>
                        <th>Amount</th>
                        <th>Method</th>
                        <th>Date</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody id="paymentsBody">
                <% if (payments != null && !payments.isEmpty()) {
                    for (Payment p : payments) { %>
                    <tr class="payment-row"
                        data-name="<%= p.getMemberName().toLowerCase() %>"
                        data-id="<%= p.getMemberId().toLowerCase() %>"
                        data-plan="<%= p.getPlan().toLowerCase() %>"
                        data-status="<%= p.getStatus().toLowerCase() %>"
                        data-method="<%= p.getPaymentMethod().toLowerCase() %>">
                        <td><code><%= p.getPaymentId() %></code></td>
                        <td><code><%= p.getMemberId() %></code></td>
                        <td class="td-name"><%= p.getMemberName() %></td>
                        <td><%= p.getPlan() %></td>
                        <td style="color:#c9a84c;font-weight:600">Rs.<%= p.getAmount() %></td>
                        <td>
                            <span class="badge <%=
                                p.getPaymentMethod().toLowerCase().contains("card") ? "badge-card" :
                                p.getPaymentMethod().toLowerCase().contains("cash") ? "badge-cash" : "badge-bank"
                            %>"><%= p.getPaymentMethod() %></span>
                        </td>
                        <td><%= p.getPaymentDate() %></td>
                        <td>
                            <span class="badge <%=
                                p.getStatus().equals("Paid") ? "badge-paid" :
                                p.getStatus().equals("Overdue") ? "badge-overdue" : "badge-pending"
                            %>"><%= p.getStatus() %></span>
                        </td>
                        <td style="display:flex;gap:6px;align-items:center">
                            <% if (!p.getStatus().equals("Paid")) { %>
                            <form method="POST" action="/payment/update-status" style="display:inline">
                                <input type="hidden" name="paymentId" value="<%= p.getPaymentId() %>">
                                <input type="hidden" name="status" value="Paid">
                                <button class="btn btn-green btn-sm">&#10003; Mark Paid</button>
                            </form>
                            <% } %>
                            <form method="POST" action="/payment/delete" style="display:inline"
                                  onsubmit="return confirm('Delete this payment record?')">
                                <input type="hidden" name="paymentId" value="<%= p.getPaymentId() %>">
                                <button class="btn btn-danger btn-sm">&#128465;</button>
                            </form>
                        </td>
                    </tr>
                <% } } else { %>
                    <tr><td colspan="9" style="text-align:center;padding:40px;color:#333">No payment records found.</td></tr>
                <% } %>
                </tbody>
            </table>
            <div class="no-results" id="noResults">
                <div>&#128269;</div>
                <p>No payments found matching your search</p>
            </div>
        </div>
    </div>
</div>

<!-- Add Payment Modal -->
<div class="overlay" id="addOverlay">
    <div class="modal-box">
        <h5>Record New Payment</h5>
        <p>Manually record a member payment</p>
        <form method="POST" action="/payment/create">
            <div class="form-row">
                <div class="form-group">
                    <label>Member ID</label>
                    <input type="text" name="memberId" placeholder="e.g. M001" required>
                </div>
                <div class="form-group">
                    <label>Member Name</label>
                    <input type="text" name="memberName" placeholder="Full name" required>
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Plan</label>
                    <select name="plan">
                        <option value="Basic">Basic — Rs.3,000</option>
                        <option value="Premium">Premium — Rs.5,000</option>
                        <option value="VIP Elite">VIP Elite — Rs.8,500</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Amount (Rs.)</label>
                    <input type="number" name="amount" placeholder="e.g. 3000" required>
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Payment Method</label>
                    <select name="paymentMethod">
                        <option value="Cash">Cash</option>
                        <option value="Card">Card</option>
                        <option value="Bank Transfer">Bank Transfer</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Payment Date</label>
                    <input type="date" name="paymentDate" required>
                </div>
            </div>
            <div class="form-group">
                <label>Status</label>
                <select name="status">
                    <option value="Paid">Paid</option>
                    <option value="Pending">Pending</option>
                    <option value="Overdue">Overdue</option>
                </select>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline"
                        onclick="document.getElementById('addOverlay').classList.remove('show')">Cancel</button>
                <button type="submit" class="btn btn-gold">Record Payment</button>
            </div>
        </form>
    </div>
</div>

<script>
    let currentFilter = 'all';
    function searchPayments() {
        const query = document.getElementById('searchInput').value.toLowerCase().trim();
        const rows = document.querySelectorAll('.payment-row');
        let visibleCount = 0;
        rows.forEach(row => {
            const matchesSearch = !query ||
                row.getAttribute('data-name').includes(query) ||
                row.getAttribute('data-id').includes(query) ||
                row.getAttribute('data-plan').includes(query);
            const matchesFilter = currentFilter === 'all' ||
                row.getAttribute('data-status').includes(currentFilter) ||
                row.getAttribute('data-method').includes(currentFilter);
            if (matchesSearch && matchesFilter) { row.style.display = ''; visibleCount++; }
            else { row.style.display = 'none'; }
        });
        document.getElementById('noResults').style.display = visibleCount === 0 ? 'block' : 'none';
        document.getElementById('paymentCount').textContent = 'Showing: ' + visibleCount + ' records';
    }
    function filterPayments(filter, btn) {
        currentFilter = filter;
        document.querySelectorAll('.filter-pill').forEach(p => p.classList.remove('active'));
        btn.classList.add('active');
        searchPayments();
    }
</script>
</body>
</html>