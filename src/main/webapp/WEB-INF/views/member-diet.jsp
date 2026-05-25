<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.fitnesscenter.model.Member" %>
<%@ page import="com.fitnesscenter.model.DietPlan" %>
<%
    Member loggedMember = (Member) session.getAttribute("loggedMember");
    if (loggedMember == null) { response.sendRedirect("/login"); return; }
    DietPlan dietPlan = (DietPlan) request.getAttribute("dietPlan");
    boolean saved = "true".equals(request.getParameter("saved"));

    // Nutrition data per food item (cal, protein, fat)
    java.util.Map<String, int[]> nutrition = new java.util.HashMap<>();
    nutrition.put("3 eggs",                new int[]{210, 18, 15});
    nutrition.put("2 eggs",                new int[]{140, 12, 10});
    nutrition.put("1 egg",                 new int[]{70,  6,  5});
    nutrition.put("200g chicken breast",   new int[]{330, 62,  7});
    nutrition.put("150g chicken breast",   new int[]{248, 46,  5});
    nutrition.put("100g chicken breast",   new int[]{165, 31,  4});
    nutrition.put("200g beef",             new int[]{400, 42, 24});
    nutrition.put("150g beef",             new int[]{300, 32, 18});
    nutrition.put("150g rice",             new int[]{195,  4,  0});
    nutrition.put("100g rice",             new int[]{130,  3,  0});
    nutrition.put("150g sweet potato",     new int[]{130,  3,  0});
    nutrition.put("100g broccoli",         new int[]{34,   3,  0});
    nutrition.put("100g spinach",          new int[]{23,   3,  0});
    nutrition.put("100g cauliflower",      new int[]{25,   2,  0});
    nutrition.put("100g green beans",      new int[]{31,   2,  0});
    nutrition.put("200g salmon",           new int[]{412, 40, 26});
    nutrition.put("150g tuna",             new int[]{180, 40,  1});
    nutrition.put("100g oats",             new int[]{380, 13,  7});
    nutrition.put("1 avocado",             new int[]{234,  3, 21});
    nutrition.put("1 banana",              new int[]{89,   1,  0});
    nutrition.put("1 tbsp olive oil",      new int[]{119,  0, 14});
    nutrition.put("30g almonds",           new int[]{174,  6, 15});
    nutrition.put("1 protein shake",       new int[]{120, 25,  2});
    nutrition.put("greek yogurt",          new int[]{100, 10,  0});
    nutrition.put("1 protein bar",         new int[]{200, 20,  8});
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Diet Plan — Fitness Center</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Rajdhani:wght@500;600;700&family=Inter:wght@400;500;600&display=swap');
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
        .hero-bg { position: absolute; top: 0; right: 0; width: 50%; height: 100%; background: url('https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800&q=80') center/cover; opacity: 0.08; }
        .hero-bg-gradient { position: absolute; top: 0; right: 0; width: 55%; height: 100%; background: linear-gradient(to right, #0f0f0f 30%, transparent); }
        .hero-content { position: relative; z-index: 1; }
        .hero-tag { display: inline-block; background: rgba(201,168,76,0.15); color: #c9a84c; font-size: 11px; font-weight: 600; padding: 4px 12px; border-radius: 20px; text-transform: uppercase; letter-spacing: 2px; border: 1px solid rgba(201,168,76,0.3); margin-bottom: 12px; }
        .hero h1 { font-family: 'Rajdhani', sans-serif; font-size: 36px; font-weight: 700; color: #fff; line-height: 1.1; margin-bottom: 8px; }
        .hero h1 span { color: #c9a84c; }
        .hero p { font-size: 14px; color: #555; }
        .content { padding: 32px 40px; }
        .success-toast { background: rgba(74,222,128,0.1); border: 1px solid rgba(74,222,128,0.3); border-radius: 10px; padding: 12px 20px; margin-bottom: 24px; color: #4ade80; font-size: 14px; display: flex; align-items: center; gap: 10px; }

        /* Daily totals */
        .totals-bar { display: grid; grid-template-columns: repeat(3,1fr); gap: 16px; margin-bottom: 28px; }
        .total-card { background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.08); border-radius: 16px; padding: 20px; text-align: center; transition: all 0.3s; }
        .total-card:hover { border-color: rgba(201,168,76,0.3); transform: translateY(-3px); }
        .total-icon { font-size: 28px; margin-bottom: 8px; }
        .total-num { font-family: 'Rajdhani', sans-serif; font-size: 32px; font-weight: 700; color: #c9a84c; }
        .total-num.protein { color: #5bc4f5; }
        .total-num.fat { color: #f97316; }
        .total-lbl { font-size: 12px; color: #555; text-transform: uppercase; letter-spacing: 1px; margin-top: 4px; }

        /* Meal sections */
        .meals-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 24px; }
        .meal-card { background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.08); border-radius: 20px; overflow: hidden; transition: all 0.3s; }
        .meal-card:hover { border-color: rgba(201,168,76,0.3); box-shadow: 0 10px 30px rgba(0,0,0,0.3); }
        .meal-header { padding: 16px 20px; border-bottom: 1px solid rgba(255,255,255,0.06); background: rgba(0,0,0,0.2); display: flex; align-items: center; gap: 10px; }
        .meal-icon { font-size: 22px; }
        .meal-title { font-family: 'Rajdhani', sans-serif; font-size: 16px; font-weight: 700; color: #c9a84c; }
        .meal-body { padding: 16px; }
        .food-item { display: flex; justify-content: space-between; align-items: center; padding: 10px 0; border-bottom: 1px solid rgba(255,255,255,0.04); }
        .food-item:last-child { border-bottom: none; }
        .food-name { font-size: 14px; color: #e0e0e0; font-weight: 500; }
        .food-macros { display: flex; gap: 10px; }
        .macro { font-size: 11px; padding: 3px 8px; border-radius: 6px; font-weight: 600; }
        .macro-cal { background: rgba(201,168,76,0.1); color: #c9a84c; border: 1px solid rgba(201,168,76,0.2); }
        .macro-pro { background: rgba(91,196,245,0.1); color: #5bc4f5; border: 1px solid rgba(91,196,245,0.2); }
        .macro-fat { background: rgba(249,115,22,0.1); color: #f97316; border: 1px solid rgba(249,115,22,0.2); }
        .no-food { font-size: 13px; color: #333; padding: 12px 0; text-align: center; }

        /* Edit form */
        .edit-card { background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.08); border-radius: 20px; overflow: hidden; }
        .edit-header { padding: 20px 24px; border-bottom: 1px solid rgba(255,255,255,0.06); background: rgba(0,0,0,0.2); display: flex; justify-content: space-between; align-items: center; }
        .edit-header h5 { font-family: 'Rajdhani', sans-serif; font-size: 18px; font-weight: 700; color: #c9a84c; }
        .edit-body { padding: 24px; }
        .form-group { margin-bottom: 16px; }
        .form-group label { display: block; font-size: 11px; font-weight: 600; color: #555; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 8px; }
        .form-group input, .form-group textarea { width: 100%; padding: 12px 14px; background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.1); border-radius: 10px; font-size: 14px; color: #e0e0e0; outline: none; transition: border 0.2s; font-family: 'Inter', sans-serif; }
        .form-group input:focus, .form-group textarea:focus { border-color: #c9a84c; }
        .form-group input::placeholder, .form-group textarea::placeholder { color: #333; }
        .form-group textarea { height: 80px; resize: vertical; }
        .form-hint { font-size: 11px; color: #444; margin-top: 5px; line-height: 1.5; }
        .btn { padding: 12px 22px; border-radius: 10px; font-size: 14px; font-weight: 600; cursor: pointer; border: none; transition: all 0.2s; font-family: 'Rajdhani', sans-serif; letter-spacing: 1px; text-transform: uppercase; }
        .btn-gold { background: linear-gradient(135deg, #c9a84c, #8b6914); color: #0a0a0a; }
        .btn-gold:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(201,168,76,0.3); }
        .btn-danger { background: transparent; color: #e05555; border: 1px solid rgba(224,85,85,0.3); }
        .btn-danger:hover { background: #e05555; color: white; }
        .btn-row { display: flex; gap: 12px; margin-top: 20px; }
        .plan-name-badge { display: inline-flex; align-items: center; gap: 8px; background: rgba(201,168,76,0.1); border: 1px solid rgba(201,168,76,0.3); color: #c9a84c; padding: 8px 16px; border-radius: 8px; font-family: 'Rajdhani', sans-serif; font-size: 18px; font-weight: 700; margin-bottom: 24px; }
        .no-plan { text-align: center; padding: 48px; background: rgba(255,255,255,0.02); border: 1px solid rgba(255,255,255,0.06); border-radius: 20px; margin-bottom: 24px; }
        .no-plan .ni { font-size: 48px; margin-bottom: 16px; }
        .no-plan h4 { font-family: 'Rajdhani', sans-serif; font-size: 22px; color: #c9a84c; margin-bottom: 8px; }
        .no-plan p { font-size: 14px; color: #555; }
    </style>
</head>
<body>
<div class="night">
    <div class="shooting_star"></div><div class="shooting_star"></div>
    <div class="shooting_star"></div><div class="shooting_star"></div>
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
    <a href="/member/diet" class="active">&#127822; &nbsp; My Diet Plan</a>
    <a href="#">&#128100; &nbsp; My Trainer</a>
    <a href="/member/payment">&#128179; &nbsp; Payment & Membership</a>
    <div class="sidebar-footer">
        <a href="/member/logout">&#128275; &nbsp; Sign Out</a>
    </div>
</div>

<div class="main">
    <div class="hero">
        <div class="hero-bg"></div>
        <div class="hero-bg-gradient"></div>
        <div class="hero-content">
            <div class="hero-tag">Nutrition</div>
            <h1>My <span>Diet Plan</span></h1>
            <p>Track your daily nutrition and reach your fitness goals</p>
        </div>
    </div>

    <div class="content">

        <% if (saved) { %>
        <div class="success-toast">&#10003; Diet plan saved successfully!</div>
        <% } %>

        <% if (dietPlan != null) { %>

        <div class="plan-name-badge">&#127822; &nbsp; <%= dietPlan.getPlanName() %></div>

        <%
        // Calculate totals
        int totalCal = 0, totalPro = 0, totalFat = 0;
        String[] allMeals = {
            dietPlan.getBreakfastItems(),
            dietPlan.getLunchItems(),
            dietPlan.getDinnerItems(),
            dietPlan.getSnackItems()
        };
        for (String meal : allMeals) {
            if (meal != null && !meal.isEmpty()) {
                for (String item : meal.split("~")) {
                    String key = item.trim().toLowerCase();
                    if (nutrition.containsKey(key)) {
                        int[] n = nutrition.get(key);
                        totalCal += n[0]; totalPro += n[1]; totalFat += n[2];
                    }
                }
            }
        }
        %>

        <!-- Daily Totals -->
        <div class="totals-bar">
            <div class="total-card">
                <div class="total-icon">&#128293;</div>
                <div class="total-num"><%= totalCal %></div>
                <div class="total-lbl">Total Calories</div>
            </div>
            <div class="total-card">
                <div class="total-icon">&#128170;</div>
                <div class="total-num protein"><%= totalPro %>g</div>
                <div class="total-lbl">Total Protein</div>
            </div>
            <div class="total-card">
                <div class="total-icon">&#129393;</div>
                <div class="total-num fat"><%= totalFat %>g</div>
                <div class="total-lbl">Total Fat</div>
            </div>
        </div>

        <!-- Meal Cards -->
        <div class="meals-grid">

            <%
            String[][] mealData = {
                {"&#9728;", "Breakfast",  dietPlan.getBreakfastItems()},
                {"&#9749;", "Lunch",      dietPlan.getLunchItems()},
                {"&#127761;","Dinner",    dietPlan.getDinnerItems()},
                {"&#127822;","Snacks",    dietPlan.getSnackItems()}
            };
            for (String[] meal : mealData) {
            %>
            <div class="meal-card">
                <div class="meal-header">
                    <span class="meal-icon"><%= meal[0] %></span>
                    <span class="meal-title"><%= meal[1] %></span>
                </div>
                <div class="meal-body">
                    <% if (meal[2] != null && !meal[2].isEmpty()) {
                        for (String item : meal[2].split("~")) {
                            String key = item.trim().toLowerCase();
                            int[] n = nutrition.getOrDefault(key, new int[]{0,0,0});
                    %>
                    <div class="food-item">
                        <span class="food-name"><%= item.trim() %></span>
                        <div class="food-macros">
                            <span class="macro macro-cal"><%= n[0] %> cal</span>
                            <span class="macro macro-pro"><%= n[1] %>g P</span>
                            <span class="macro macro-fat"><%= n[2] %>g F</span>
                        </div>
                    </div>
                    <% } } else { %>
                    <div class="no-food">No items added</div>
                    <% } %>
                </div>
            </div>
            <% } %>

        </div>

        <% } else { %>
        <div class="no-plan">
            <div class="ni">&#127822;</div>
            <h4>No Diet Plan Yet</h4>
            <p>Create your personalized diet plan below to start tracking your nutrition</p>
        </div>
        <% } %>

        <!-- Edit / Create Form -->
        <div class="edit-card">
            <div class="edit-header">
                <h5><%= dietPlan != null ? "&#9998; Edit Diet Plan" : "&#43; Create Diet Plan" %></h5>
                <% if (dietPlan != null) { %>
                <form method="POST" action="/member/diet/delete"
                      onsubmit="return confirm('Delete your diet plan?')">
                    <button class="btn btn-danger" style="padding:8px 16px;font-size:12px">&#128465; Delete Plan</button>
                </form>
                <% } %>
            </div>
            <div class="edit-body">
                <form method="POST" action="/member/diet/save">
                    <div class="form-group">
                        <label>Diet Plan Name</label>
                        <input type="text" name="planName"
                               value="<%= dietPlan != null ? dietPlan.getPlanName() : "" %>"
                               placeholder="e.g. Keto Diet, High Protein, Balanced Diet">
                    </div>
                    <div class="form-group">
                        <label>&#9728; Breakfast Items</label>
                        <textarea name="breakfast"
                                  placeholder="e.g. 3 Eggs~200g Chicken Breast~100g Oats"><%= dietPlan != null ? dietPlan.getBreakfastItems() : "" %></textarea>
                        <div class="form-hint">&#9432; Separate items with ~ (tilde). Use exact names for nutrition tracking: "3 Eggs", "200g Chicken Breast", "150g Rice"</div>
                    </div>
                    <div class="form-group">
                        <label>&#9749; Lunch Items</label>
                        <textarea name="lunch"
                                  placeholder="e.g. 200g Chicken Breast~150g Rice~100g Broccoli"><%= dietPlan != null ? dietPlan.getLunchItems() : "" %></textarea>
                    </div>
                    <div class="form-group">
                        <label>&#127761; Dinner Items</label>
                        <textarea name="dinner"
                                  placeholder="e.g. 200g Beef~150g Sweet Potato~100g Spinach"><%= dietPlan != null ? dietPlan.getDinnerItems() : "" %></textarea>
                    </div>
                    <div class="form-group">
                        <label>&#127822; Snacks</label>
                        <textarea name="snacks"
                                  placeholder="e.g. 30g Almonds~1 Protein Shake"><%= dietPlan != null ? dietPlan.getSnackItems() : "" %></textarea>
                    </div>
                    <div class="form-group">
                        <label>Notes</label>
                        <input type="text" name="notes"
                               value="<%= dietPlan != null ? dietPlan.getNotes() : "" %>"
                               placeholder="e.g. High fat low carb diet for fat loss">
                    </div>
                    <div class="btn-row">
                        <button type="submit" class="btn btn-gold">&#128190; Save Diet Plan</button>
                    </div>
                </form>
            </div>
        </div>

    </div>
</div>
</body>
</html>