<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.fitnesscenter.model.Member" %>
<%@ page import="com.fitnesscenter.model.Admin" %>
<%
    Admin loggedAdmin = (Admin) session.getAttribute("loggedAdmin");
    if (loggedAdmin == null) {
        response.sendRedirect("/login");
        return;
    }
    List<Member> members = (List<Member>) request.getAttribute("members");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Members — Fitness Center</title>
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
        .hero-bg { position: absolute; top: 0; right: 0; width: 50%; height: 100%; background: url('https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=800&q=80') center/cover; opacity: 0.08; }
        .hero-bg-gradient { position: absolute; top: 0; right: 0; width: 55%; height: 100%; background: linear-gradient(to right, #0f0f0f 30%, transparent); }
        .hero-content { position: relative; z-index: 1; }
        .hero-tag { display: inline-block; background: rgba(201,168,76,0.15); color: #c9a84c; font-size: 11px; font-weight: 600; padding: 4px 12px; border-radius: 20px; text-transform: uppercase; letter-spacing: 2px; border: 1px solid rgba(201,168,76,0.3); margin-bottom: 12px; }
        .hero h1 { font-family: 'Rajdhani', sans-serif; font-size: 36px; font-weight: 700; color: #ffffff; line-height: 1.1; margin-bottom: 8px; }
        .hero h1 span { color: #c9a84c; }
        .hero p { font-size: 14px; color: #555; }
        .content { padding: 32px 40px; }
        .card { background: #111; border: 1px solid #1e1e1e; border-radius: 14px; overflow: hidden; }
        .card-head { display: flex; justify-content: space-between; align-items: center; padding: 20px 24px; border-bottom: 1px solid #1e1e1e; background: #0f0f0f; flex-wrap: wrap; gap: 12px; }
        .card-head h5 { font-family: 'Rajdhani', sans-serif; font-size: 18px; font-weight: 700; color: #c9a84c; }
        .card-head p { font-size: 12px; color: #444; margin-top: 2px; }
        .search-box { display: flex; align-items: center; background: #0a0a0a; border: 1px solid #2a2a2a; border-radius: 10px; padding: 0 14px; flex: 1; max-width: 400px; transition: border 0.2s; }
        .search-box:focus-within { border-color: #c9a84c; }
        .search-box input { background: transparent; border: none; outline: none; color: #e0e0e0; font-size: 14px; padding: 10px 8px; width: 100%; font-family: 'Inter', sans-serif; }
        .search-box input::placeholder { color: #333; }
        .filter-bar { display: flex; gap: 8px; padding: 12px 24px; border-bottom: 1px solid #1e1e1e; background: #0a0a0a; flex-wrap: wrap; align-items: center; }
        .filter-label { font-size: 11px; color: #444; text-transform: uppercase; letter-spacing: 1px; }
        .filter-pill { padding: 5px 14px; border-radius: 20px; font-size: 12px; font-weight: 500; cursor: pointer; border: 1px solid #222; background: transparent; color: #555; transition: all 0.2s; font-family: 'Inter', sans-serif; }
        .filter-pill:hover { border-color: #c9a84c; color: #c9a84c; }
        .filter-pill.active { background: rgba(201,168,76,0.1); border-color: #c9a84c; color: #c9a84c; }
        table { width: 100%; border-collapse: collapse; }
        thead th { padding: 14px 20px; text-align: left; font-size: 11px; font-weight: 600; color: #444; text-transform: uppercase; letter-spacing: 1px; background: #0d0d0d; border-bottom: 1px solid #1e1e1e; }
        tbody td { padding: 12px 20px; border-bottom: 1px solid #161616; color: #aaa; font-size: 13px; }
        tbody tr:hover { background: rgba(201,168,76,0.03); }
        tbody tr:last-child td { border-bottom: none; }
        code { background: rgba(201,168,76,0.1); color: #c9a84c; padding: 3px 8px; border-radius: 5px; font-size: 12px; border: 1px solid rgba(201,168,76,0.2); }
        .td-name { color: #e0e0e0; font-weight: 500; }
        .badge { padding: 4px 10px; border-radius: 20px; font-size: 11px; font-weight: 600; }
        .badge-paid { background: rgba(74,222,128,0.1); color: #4ade80; border: 1px solid rgba(74,222,128,0.2); }
        .badge-overdue { background: rgba(224,85,85,0.1); color: #e05555; border: 1px solid rgba(224,85,85,0.2); }
        .badge-monthly { background: rgba(201,168,76,0.1); color: #c9a84c; border: 1px solid rgba(201,168,76,0.2); }
        .badge-yearly { background: rgba(91,196,245,0.1); color: #5bc4f5; border: 1px solid rgba(91,196,245,0.2); }
        .no-results { text-align: center; padding: 48px; color: #333; display: none; }
        .btn { padding: 8px 18px; border-radius: 8px; font-size: 13px; font-weight: 500; cursor: pointer; border: none; transition: all 0.2s; font-family: 'Inter', sans-serif; }
        .btn-gold { background: linear-gradient(135deg, #c9a84c, #8b6914); color: #0a0a0a; font-weight: 600; }
        .btn-gold:hover { background: linear-gradient(135deg, #dbb85c, #9b7924); }
        .btn-outline { background: transparent; color: #666; border: 1px solid #2a2a2a; }
        .btn-outline:hover { border-color: #c9a84c; color: #c9a84c; }
        .btn-danger { background: transparent; color: #e05555; border: 1px solid #3a1515; }
        .btn-danger:hover { background: #e05555; color: white; }
        .btn-sm { padding: 6px 12px; font-size: 12px; }
        .overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.8); z-index: 1000; align-items: center; justify-content: center; backdrop-filter: blur(4px); }
        .overlay.show { display: flex; }
        .modal-box { background: #111; border: 1px solid #2a2a2a; border-radius: 16px; padding: 32px; width: 560px; box-shadow: 0 25px 60px rgba(0,0,0,0.5); max-height: 90vh; overflow-y: auto; }
        .modal-box h5 { font-family: 'Rajdhani', sans-serif; font-size: 22px; font-weight: 700; color: #c9a84c; margin-bottom: 4px; }
        .modal-box p { font-size: 13px; color: #444; margin-bottom: 24px; }
        .form-group { margin-bottom: 16px; }
        .form-group label { display: block; font-size: 12px; font-weight: 600; margin-bottom: 6px; color: #666; text-transform: uppercase; letter-spacing: 1px; }
        .form-group input, .form-group select, .form-group textarea { width: 100%; padding: 11px 14px; background: #0a0a0a; border: 1px solid #2a2a2a; border-radius: 8px; font-size: 14px; color: #e0e0e0; outline: none; transition: border 0.2s; font-family: 'Inter', sans-serif; }
        .form-group input:focus, .form-group select:focus, .form-group textarea:focus { border-color: #c9a84c; }
        .form-group select option { background: #111; }
        .form-group textarea { height: 70px; resize: vertical; }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
        .modal-footer { display: flex; justify-content: flex-end; gap: 10px; margin-top: 24px; padding-top: 20px; border-top: 1px solid #1e1e1e; }
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
    <a href="/members" class="active">&#128101; &nbsp; Members</a>
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
            <div class="hero-tag">Member Management</div>
            <h1>Manage <span>Members</span></h1>
            <p>Add, edit and manage all fitness center members</p>
        </div>
    </div>

    <div class="content">
        <div class="card">
            <div class="card-head">
                <div>
                    <h5>All Members</h5>
                    <p id="memberCount">Total: <%= members != null ? members.size() : 0 %> members registered</p>
                </div>
                <div style="display:flex;gap:12px;align-items:center;flex-wrap:wrap">
                    <div class="search-box">
                        <span>&#128269;</span>
                        <input type="text" id="searchInput"
                               placeholder="Search by name, ID, email or phone..."
                               oninput="searchMembers()">
                    </div>
                    <button class="btn btn-gold"
                            onclick="document.getElementById('addOverlay').classList.add('show')">
                        + Add New Member
                    </button>
                </div>
            </div>

            <div class="filter-bar">
                <span class="filter-label">Filter:</span>
                <button class="filter-pill active" onclick="filterMembers('all', this)">All</button>
                <button class="filter-pill" onclick="filterMembers('paid', this)">&#10003; Paid</button>
                <button class="filter-pill" onclick="filterMembers('overdue', this)">&#9888; Overdue</button>
                <button class="filter-pill" onclick="filterMembers('monthly', this)">Monthly</button>
                <button class="filter-pill" onclick="filterMembers('yearly', this)">Yearly</button>
            </div>

            <table id="membersTable">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Membership</th>
                        <th>Expiry Date</th>
                        <th>Payment</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody id="membersBody">
                <% if (members != null && !members.isEmpty()) {
                    for (Member m : members) { %>
                    <tr class="member-row"
                        data-name="<%= m.getName().toLowerCase() %>"
                        data-id="<%= m.getId().toLowerCase() %>"
                        data-email="<%= m.getEmail().toLowerCase() %>"
                        data-phone="<%= m.getPhone() %>"
                        data-payment="<%= m.getPaymentStatus().toLowerCase() %>"
                        data-membership="<%= m.getMembershipType().toLowerCase() %>">
                        <td><code><%= m.getId() %></code></td>
                        <td class="td-name"><%= m.getName() %></td>
                        <td><%= m.getEmail() %></td>
                        <td><%= m.getPhone() %></td>
                        <td>
                            <span class="badge <%= m.getMembershipType().equals("Monthly") ? "badge-monthly" : "badge-yearly" %>">
                                <%= m.getMembershipType() %>
                            </span>
                        </td>
                        <td><%= m.getExpiryDate() %></td>
                        <td>
                            <span class="badge <%= m.getPaymentStatus().equals("Paid") ? "badge-paid" : "badge-overdue" %>">
                                <%= m.getPaymentStatus() %>
                            </span>
                        </td>
                        <td>
                            <button class="btn btn-outline btn-sm"
                                    onclick="openEdit('<%= m.getId() %>','<%= m.getName() %>','<%= m.getEmail() %>','<%= m.getPhone() %>','<%= m.getMembershipType() %>','<%= m.getWorkoutPlan() %>','<%= m.getDietPlan() %>','<%= m.getExpiryDate() %>','<%= m.getPaymentStatus() %>')"
                                    style="margin-right:6px">
                                &#9998; Edit
                            </button>
                            <form method="POST" action="/member/delete" style="display:inline"
                                  onsubmit="return confirm('Delete this member?')">
                                <input type="hidden" name="id" value="<%= m.getId() %>">
                                <button class="btn btn-danger btn-sm">&#128465;</button>
                            </form>
                        </td>
                    </tr>
                <% } } else { %>
                    <tr>
                        <td colspan="8" style="text-align:center;padding:40px;color:#333">
                            No members found. Add your first member!
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
            <div class="no-results" id="noResults">
                <div>&#128269;</div>
                <p>No members found matching your search</p>
            </div>
        </div>
    </div>
</div>

<!-- Add Member Modal -->
<div class="overlay" id="addOverlay">
    <div class="modal-box">
        <h5>Add New Member</h5>
        <p>Register a new fitness center member</p>
        <form method="POST" action="/member/create">
            <div class="form-row">
                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" name="name" placeholder="Enter full name" required>
                </div>
                <div class="form-group">
                    <label>Phone</label>
                    <input type="text" name="phone" placeholder="Enter phone number" required>
                </div>
            </div>
            <div class="form-group">
                <label>Email</label>
                <input type="email" name="email" placeholder="Enter email address" required>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Membership Type</label>
                    <select name="membershipType">
                        <option value="Basic">Basic — Rs.3,000/mo</option>
                        <option value="Premium">Premium — Rs.5,000/mo</option>
                        <option value="VIP Elite">VIP Elite — Rs.8,500/mo</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Payment Status</label>
                    <select name="paymentStatus">
                        <option value="Paid">Paid</option>
                        <option value="Overdue">Overdue</option>
                        <option value="Pending">Pending</option>
                    </select>
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Join Date</label>
                    <input type="date" name="joinDate" required>
                </div>
                <div class="form-group">
                    <label>Expiry Date</label>
                    <input type="date" name="expiryDate" required>
                </div>
            </div>
            <div class="form-group">
                <label>Workout Plan</label>
                <textarea name="workoutPlan" placeholder="e.g. Full Body Workout..."></textarea>
            </div>
            <div class="form-group">
                <label>Diet Plan</label>
                <textarea name="dietPlan" placeholder="e.g. Keto Diet..."></textarea>
            </div>
            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" placeholder="Set member password" required>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline"
                        onclick="document.getElementById('addOverlay').classList.remove('show')">Cancel</button>
                <button type="submit" class="btn btn-gold">Add Member</button>
            </div>
        </form>
    </div>
</div>

<!-- Edit Member Modal -->
<div class="overlay" id="editOverlay">
    <div class="modal-box">
        <h5>Edit Member</h5>
        <p>Update member details</p>
        <form method="POST" action="/member/update">
            <input type="hidden" name="id" id="editId">
            <div class="form-row">
                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" name="name" id="editName" required>
                </div>
                <div class="form-group">
                    <label>Phone</label>
                    <input type="text" name="phone" id="editPhone" required>
                </div>
            </div>
            <div class="form-group">
                <label>Email</label>
                <input type="email" name="email" id="editEmail" required>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Membership Type</label>
                    <select name="membershipType" id="editMembershipType">
                        <option value="Basic">Basic — Rs.3,000/mo</option>
                        <option value="Premium">Premium — Rs.5,000/mo</option>
                        <option value="VIP Elite">VIP Elite — Rs.8,500/mo</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Payment Status</label>
                    <select name="paymentStatus" id="editPaymentStatus">
                        <option value="Paid">Paid</option>
                        <option value="Overdue">Overdue</option>
                        <option value="Pending">Pending</option>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label>Expiry Date</label>
                <input type="date" name="expiryDate" id="editExpiryDate" required>
            </div>
            <div class="form-group">
                <label>Workout Plan</label>
                <textarea name="workoutPlan" id="editWorkout"></textarea>
            </div>
            <div class="form-group">
                <label>Diet Plan</label>
                <textarea name="dietPlan" id="editDiet"></textarea>
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
    let currentFilter = 'all';

    function searchMembers() {
        const query = document.getElementById('searchInput').value.toLowerCase().trim();
        const rows = document.querySelectorAll('.member-row');
        let visibleCount = 0;
        rows.forEach(row => {
            const matchesSearch = !query ||
                row.getAttribute('data-name').includes(query) ||
                row.getAttribute('data-id').includes(query) ||
                row.getAttribute('data-email').includes(query) ||
                row.getAttribute('data-phone').includes(query);
            const matchesFilter = currentFilter === 'all' ||
                row.getAttribute('data-payment').includes(currentFilter) ||
                row.getAttribute('data-membership').includes(currentFilter);
            if (matchesSearch && matchesFilter) { row.style.display = ''; visibleCount++; }
            else { row.style.display = 'none'; }
        });
        document.getElementById('noResults').style.display = visibleCount === 0 ? 'block' : 'none';
        document.getElementById('memberCount').textContent = 'Showing: ' + visibleCount + ' member' + (visibleCount !== 1 ? 's' : '');
    }

    function filterMembers(filter, btn) {
        currentFilter = filter;
        document.querySelectorAll('.filter-pill').forEach(p => p.classList.remove('active'));
        btn.classList.add('active');
        searchMembers();
    }

    function openEdit(id, name, email, phone, membershipType, workout, diet, expiryDate, paymentStatus) {
        document.getElementById('editId').value             = id;
        document.getElementById('editName').value           = name;
        document.getElementById('editEmail').value          = email;
        document.getElementById('editPhone').value          = phone;
        document.getElementById('editMembershipType').value = membershipType;
        document.getElementById('editWorkout').value        = workout;
        document.getElementById('editDiet').value           = diet;
        document.getElementById('editExpiryDate').value     = expiryDate;
        document.getElementById('editPaymentStatus').value  = paymentStatus;
        document.getElementById('editOverlay').classList.add('show');
    }
</script>
</body>
</html>