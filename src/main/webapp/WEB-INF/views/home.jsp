<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PRIME FITNESS — Push Your Limits</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Rajdhani:wght@500;600;700&family=Inter:wght@400;500;600&family=Bebas+Neue&display=swap');
        * { box-sizing: border-box; margin: 0; padding: 0; }
        html { scroll-behavior: smooth; }
        body { background: #0a0a0a; font-family: 'Inter', sans-serif; color: #e0e0e0; overflow-x: hidden; }

        /* Shooting Stars */
        .night { position: fixed; width: 100%; height: 100%; transform: rotateZ(45deg); z-index: 0; pointer-events: none; }
        .shooting_star { position: absolute; height: 2px; background: linear-gradient(-45deg, #c9a84c, rgba(201,168,76,0)); border-radius: 999px; filter: drop-shadow(0 0 6px #c9a84c); animation: tail 3000ms ease-in-out infinite, shooting 3000ms ease-in-out infinite; }
        @keyframes tail { 0%{width:0} 30%{width:100px} 100%{width:0} }
        @keyframes shooting { 0%{transform:translateX(0)} 100%{transform:translateX(300px)} }
        .shooting_star:nth-child(1) { top:10%; left:5%;  animation-delay:0ms; }
        .shooting_star:nth-child(2) { top:30%; left:20%; animation-delay:1000ms; }
        .shooting_star:nth-child(3) { top:50%; left:10%; animation-delay:2000ms; }
        .shooting_star:nth-child(4) { top:70%; left:30%; animation-delay:500ms; }
        .shooting_star:nth-child(5) { top:20%; left:60%; animation-delay:1500ms; }

        /* Navbar */
        .navbar { position: fixed; top: 0; left: 0; right: 0; z-index: 100; padding: 20px 60px; display: flex; justify-content: space-between; align-items: center; background: linear-gradient(to bottom, rgba(0,0,0,0.8), transparent); backdrop-filter: blur(10px); border-bottom: 1px solid rgba(201,168,76,0.1); transition: all 0.3s; }
        .navbar.scrolled { background: rgba(10,10,10,0.95); border-bottom-color: rgba(201,168,76,0.2); }
        .nav-brand { font-family: 'Bebas Neue', sans-serif; font-size: 28px; color: #c9a84c; letter-spacing: 3px; text-decoration: none; }
        .nav-brand span { color: white; }
        .nav-links { display: flex; align-items: center; gap: 32px; }
        .nav-links a { color: rgba(255,255,255,0.6); text-decoration: none; font-size: 14px; font-weight: 500; transition: color 0.2s; }
        .nav-links a:hover { color: #c9a84c; }
        .nav-btn { background: linear-gradient(135deg, #c9a84c, #8b6914); color: #0a0a0a !important; padding: 10px 24px; border-radius: 8px; font-weight: 700 !important; transition: all 0.2s !important; }
        .nav-btn:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(201,168,76,0.3); }

        /* Hero */
        .hero { position: relative; min-height: 100vh; display: flex; align-items: center; overflow: hidden; }
        .hero-bg { position: absolute; inset: 0; background: url('https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=1600&q=80') center/cover; opacity: 0.3; }
        .hero-overlay { position: absolute; inset: 0; background: linear-gradient(135deg, rgba(10,10,10,0.95) 40%, rgba(10,10,10,0.6) 100%); }
        .hero-content { position: relative; z-index: 1; padding: 0 60px; max-width: 800px; }
        .hero-tag { display: inline-block; background: rgba(201,168,76,0.15); color: #c9a84c; font-size: 12px; font-weight: 600; padding: 6px 16px; border-radius: 20px; text-transform: uppercase; letter-spacing: 3px; border: 1px solid rgba(201,168,76,0.3); margin-bottom: 24px; }
        .hero-title { font-family: 'Bebas Neue', sans-serif; font-size: 120px; line-height: 0.9; color: white; margin-bottom: 8px; }
        .hero-title span { color: #c9a84c; }
        .hero-subtitle { font-size: 18px; color: rgba(255,255,255,0.5); margin-bottom: 16px; font-weight: 400; max-width: 500px; line-height: 1.7; }
        .hero-quote { font-size: 15px; color: #c9a84c; font-style: italic; margin-bottom: 40px; padding-left: 16px; border-left: 3px solid #c9a84c; }
        .hero-btns { display: flex; gap: 16px; align-items: center; }
        .btn-primary-hero { background: linear-gradient(135deg, #c9a84c, #8b6914); color: #0a0a0a; padding: 16px 40px; border-radius: 10px; font-size: 16px; font-weight: 700; text-decoration: none; font-family: 'Rajdhani', sans-serif; letter-spacing: 1px; text-transform: uppercase; transition: all 0.3s; display: inline-block; }
        .btn-primary-hero:hover { transform: translateY(-3px); box-shadow: 0 15px 30px rgba(201,168,76,0.3); }
        .btn-secondary-hero { background: transparent; color: white; padding: 16px 40px; border-radius: 10px; font-size: 16px; font-weight: 700; text-decoration: none; font-family: 'Rajdhani', sans-serif; letter-spacing: 1px; text-transform: uppercase; transition: all 0.3s; display: inline-block; border: 1px solid rgba(255,255,255,0.2); }
        .btn-secondary-hero:hover { border-color: #c9a84c; color: #c9a84c; transform: translateY(-3px); }

        /* Stats Bar */
        .stats-bar { position: relative; z-index: 1; background: rgba(201,168,76,0.08); border-top: 1px solid rgba(201,168,76,0.15); border-bottom: 1px solid rgba(201,168,76,0.15); padding: 28px 60px; display: grid; grid-template-columns: repeat(4,1fr); }
        .stat-item { text-align: center; padding: 0 20px; border-right: 1px solid rgba(255,255,255,0.06); }
        .stat-item:last-child { border-right: none; }
        .stat-num { font-family: 'Bebas Neue', sans-serif; font-size: 48px; color: #c9a84c; line-height: 1; }
        .stat-lbl { font-size: 12px; color: #555; text-transform: uppercase; letter-spacing: 2px; margin-top: 4px; }

        /* About Section */
        .about { padding: 100px 60px; position: relative; z-index: 1; display: grid; grid-template-columns: 1fr 1fr; gap: 80px; align-items: center; }
        .about-img { position: relative; border-radius: 20px; overflow: hidden; }
        .about-img img { width: 100%; height: 500px; object-fit: cover; border-radius: 20px; opacity: 0.8; }
        .about-img-overlay { position: absolute; inset: 0; background: linear-gradient(135deg, rgba(201,168,76,0.1), transparent); border-radius: 20px; border: 1px solid rgba(201,168,76,0.2); }
        .about-badge { position: absolute; bottom: 24px; left: 24px; background: rgba(10,10,10,0.9); backdrop-filter: blur(10px); border: 1px solid rgba(201,168,76,0.3); border-radius: 12px; padding: 16px 20px; }
        .about-badge .num { font-family: 'Bebas Neue', sans-serif; font-size: 36px; color: #c9a84c; line-height: 1; }
        .about-badge .lbl { font-size: 11px; color: #555; text-transform: uppercase; letter-spacing: 1px; }
        .about-tag { display: inline-block; background: rgba(201,168,76,0.1); color: #c9a84c; font-size: 11px; font-weight: 600; padding: 4px 14px; border-radius: 20px; text-transform: uppercase; letter-spacing: 2px; border: 1px solid rgba(201,168,76,0.2); margin-bottom: 16px; }
        .about-title { font-family: 'Bebas Neue', sans-serif; font-size: 56px; color: white; line-height: 1; margin-bottom: 20px; }
        .about-title span { color: #c9a84c; }
        .about-text { font-size: 15px; color: #666; line-height: 1.8; margin-bottom: 32px; }
        .about-values { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 40px; }
        .value-item { background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.06); border-radius: 12px; padding: 16px; }
        .value-icon { font-size: 24px; margin-bottom: 8px; }
        .value-title { font-family: 'Rajdhani', sans-serif; font-size: 16px; font-weight: 700; color: #c9a84c; margin-bottom: 4px; }
        .value-text { font-size: 12px; color: #555; line-height: 1.5; }

        /* Plans */
        .plans { padding: 100px 60px; position: relative; z-index: 1; }
        .section-header { text-align: center; margin-bottom: 60px; }
        .section-tag { display: inline-block; background: rgba(201,168,76,0.1); color: #c9a84c; font-size: 11px; font-weight: 600; padding: 4px 14px; border-radius: 20px; text-transform: uppercase; letter-spacing: 2px; border: 1px solid rgba(201,168,76,0.2); margin-bottom: 16px; }
        .section-title { font-family: 'Bebas Neue', sans-serif; font-size: 56px; color: white; margin-bottom: 12px; }
        .section-title span { color: #c9a84c; }
        .section-sub { font-size: 15px; color: #555; max-width: 500px; margin: 0 auto; }
        .plans-grid { display: grid; grid-template-columns: repeat(3,1fr); gap: 24px; }
        .plan-card { background: rgba(255,255,255,0.04); backdrop-filter: blur(15px); border: 1px solid rgba(255,255,255,0.08); border-radius: 24px; padding: 40px 32px; text-align: center; transition: all 0.4s cubic-bezier(0.175,0.885,0.32,1.275); position: relative; overflow: hidden; }
        .plan-card:hover { transform: translateY(-12px); border-color: rgba(201,168,76,0.4); box-shadow: 0 30px 60px rgba(0,0,0,0.5); }
        .plan-card.featured { border-color: rgba(201,168,76,0.4); background: rgba(201,168,76,0.06); }
        .plan-badge { position: absolute; top: 20px; right: 20px; background: linear-gradient(135deg,#c9a84c,#8b6914); color: #0a0a0a; font-size: 10px; font-weight: 700; padding: 4px 12px; border-radius: 20px; text-transform: uppercase; letter-spacing: 1px; }
        .plan-icon { font-size: 40px; margin-bottom: 16px; }
        .plan-name { font-family: 'Bebas Neue', sans-serif; font-size: 28px; color: white; margin-bottom: 8px; letter-spacing: 2px; }
        .plan-duration { font-size: 12px; color: #555; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 20px; }
        .plan-price { font-family: 'Bebas Neue', sans-serif; font-size: 64px; color: #c9a84c; line-height: 1; margin-bottom: 4px; }
        .plan-price span { font-size: 18px; color: #555; font-family: 'Inter', sans-serif; font-weight: 400; }
        .plan-divider { height: 1px; background: rgba(255,255,255,0.06); margin: 24px 0; }
        .plan-features { list-style: none; text-align: left; margin-bottom: 32px; }
        .plan-features li { padding: 8px 0; font-size: 14px; color: #888; display: flex; align-items: center; gap: 10px; border-bottom: 1px solid rgba(255,255,255,0.04); }
        .plan-features li:last-child { border-bottom: none; }
        .check { color: #4ade80; }
        .cross { color: #333; }
        .btn-plan { display: block; width: 100%; padding: 14px; border-radius: 10px; font-family: 'Rajdhani', sans-serif; font-size: 16px; font-weight: 700; letter-spacing: 1px; text-transform: uppercase; text-decoration: none; transition: all 0.3s; border: none; cursor: pointer; }
        .btn-plan-gold { background: linear-gradient(135deg,#c9a84c,#8b6914); color: #0a0a0a; }
        .btn-plan-gold:hover { transform: translateY(-2px); box-shadow: 0 10px 20px rgba(201,168,76,0.3); }
        .btn-plan-outline { background: transparent; color: #c9a84c; border: 1px solid rgba(201,168,76,0.3); }
        .btn-plan-outline:hover { background: rgba(201,168,76,0.1); transform: translateY(-2px); }

        /* Features */
        .features { padding: 100px 60px; position: relative; z-index: 1; background: rgba(255,255,255,0.01); border-top: 1px solid rgba(255,255,255,0.04); border-bottom: 1px solid rgba(255,255,255,0.04); }
        .features-grid { display: grid; grid-template-columns: repeat(3,1fr); gap: 32px; margin-top: 60px; }
        .feature-item { background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.06); border-radius: 20px; padding: 32px; transition: all 0.3s; }
        .feature-item:hover { border-color: rgba(201,168,76,0.3); transform: translateY(-4px); background: rgba(255,255,255,0.05); }
        .feature-icon-wrap { width: 56px; height: 56px; border-radius: 14px; background: linear-gradient(135deg,rgba(201,168,76,0.2),rgba(201,168,76,0.05)); display: flex; align-items: center; justify-content: center; font-size: 24px; margin-bottom: 20px; }
        .feature-title { font-family: 'Rajdhani', sans-serif; font-size: 20px; font-weight: 700; color: #c9a84c; margin-bottom: 10px; }
        .feature-text { font-size: 14px; color: #555; line-height: 1.7; }

        /* CTA */
        .cta { padding: 100px 60px; position: relative; z-index: 1; text-align: center; overflow: hidden; }
        .cta-bg { position: absolute; inset: 0; background: url('https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=1600&q=80') center/cover; opacity: 0.08; }
        .cta-overlay { position: absolute; inset: 0; background: radial-gradient(ellipse at center, rgba(201,168,76,0.05) 0%, transparent 70%); }
        .cta-content { position: relative; z-index: 1; max-width: 700px; margin: 0 auto; }
        .cta-title { font-family: 'Bebas Neue', sans-serif; font-size: 72px; color: white; line-height: 1; margin-bottom: 16px; }
        .cta-title span { color: #c9a84c; }
        .cta-sub { font-size: 16px; color: #555; margin-bottom: 40px; line-height: 1.7; }
        .cta-btns { display: flex; gap: 16px; justify-content: center; }

        /* Footer */
        footer { position: relative; z-index: 1; background: rgba(0,0,0,0.5); border-top: 1px solid rgba(255,255,255,0.04); padding: 40px 60px; display: flex; justify-content: space-between; align-items: center; }
        .footer-brand { font-family: 'Bebas Neue', sans-serif; font-size: 24px; color: #c9a84c; letter-spacing: 3px; }
        .footer-text { font-size: 13px; color: #333; }
        .footer-links { display: flex; gap: 24px; }
        .footer-links a { font-size: 13px; color: #333; text-decoration: none; transition: color 0.2s; }
        .footer-links a:hover { color: #c9a84c; }
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

<!-- Navbar -->
<nav class="navbar" id="navbar">
    <a href="/home" class="nav-brand">PRIME <span>FITNESS</span></a>
    <div class="nav-links">
        <a href="#about">About</a>
        <a href="#plans">Plans</a>
        <a href="#features">Facilities</a>
        <a href="/login">Login</a>
        <a href="#plans" class="nav-btn">Join Now</a>
    </div>
</nav>

<!-- Hero -->
<section class="hero">
    <div class="hero-bg"></div>
    <div class="hero-overlay"></div>
    <div class="hero-content">
        <div class="hero-tag">&#127947; Est. 2020 — Elite Fitness</div>
        <div class="hero-title">PRIME<br><span>FITNESS</span></div>
        <p class="hero-subtitle">Where champions are made. Transform your body, elevate your mind, and unlock your true potential.</p>
        <p class="hero-quote">"Push yourself, because no one else is going to do it for you."</p>
        <div class="hero-btns">
            <a href="#plans" class="btn-primary-hero">Join Us Today</a>
            <a href="/login" class="btn-secondary-hero">Member Login</a>
        </div>
    </div>
</section>

<!-- Stats Bar -->
<div class="stats-bar">
    <div class="stat-item">
        <div class="stat-num">500+</div>
        <div class="stat-lbl">Active Members</div>
    </div>
    <div class="stat-item">
        <div class="stat-num">20+</div>
        <div class="stat-lbl">Expert Trainers</div>
    </div>
    <div class="stat-item">
        <div class="stat-num">15+</div>
        <div class="stat-lbl">Fitness Classes</div>
    </div>
    <div class="stat-item">
        <div class="stat-num">5&#11088;</div>
        <div class="stat-lbl">Member Rating</div>
    </div>
</div>

<!-- About -->
<section class="about" id="about">
    <div class="about-img">
        <img src="https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=800&q=80" alt="Prime Fitness">
        <div class="about-img-overlay"></div>
        <div class="about-badge">
            <div class="num">5+</div>
            <div class="lbl">Years of Excellence</div>
        </div>
    </div>
    <div class="about-text-content">
        <div class="about-tag">About Us</div>
        <div class="about-title">WE ARE <span>PRIME</span><br>FITNESS</div>
        <p class="about-text">At PRIME FITNESS, we believe that every person has the potential to achieve greatness. Our state-of-the-art facility, expert trainers, and supportive community are here to help you reach your fitness goals — whatever they may be.</p>
        <p class="about-text">From beginners to elite athletes, we provide personalized workout plans, nutrition guidance, and the motivation you need to push beyond your limits every single day.</p>
        <div class="about-values">
            <div class="value-item">
                <div class="value-icon">&#127919;</div>
                <div class="value-title">Goal-Driven</div>
                <div class="value-text">Every plan is tailored to your personal fitness goals</div>
            </div>
            <div class="value-item">
                <div class="value-icon">&#128170;</div>
                <div class="value-title">Expert Coaches</div>
                <div class="value-text">Certified trainers with years of real experience</div>
            </div>
            <div class="value-item">
                <div class="value-icon">&#127775;</div>
                <div class="value-title">Premium Facility</div>
                <div class="value-text">Top-of-the-line equipment and clean environment</div>
            </div>
            <div class="value-item">
                <div class="value-icon">&#129309;</div>
                <div class="value-title">Community</div>
                <div class="value-text">A supportive family that pushes you to be better</div>
            </div>
        </div>
        <a href="#plans" class="btn-primary-hero" style="display:inline-block">Explore Plans</a>
    </div>
</section>

<!-- Plans -->
<section class="plans" id="plans">
    <div class="section-header">
        <div class="section-tag">Membership Plans</div>
        <div class="section-title">CHOOSE YOUR <span>PLAN</span></div>
        <p class="section-sub">Flexible membership options designed to fit your lifestyle and budget</p>
    </div>
    <div class="plans-grid">
        <!-- Basic -->
        <div class="plan-card">
            <div class="plan-icon">&#127947;</div>
            <div class="plan-name">Basic</div>
            <div class="plan-duration">Starting from</div>
            <div class="plan-price">Rs.3,000<span>/mo</span></div>
            <div class="plan-divider"></div>
            <ul class="plan-features">
                <li><span class="check">✓</span> Access to Gym Equipment</li>
                <li><span class="check">✓</span> Locker Room Access</li>
                <li><span class="check">✓</span> 1 Free Orientation</li>
                <li><span class="check">✓</span> Basic Workout Plan</li>
                <li><span class="cross">✗</span> Trainer Guidance</li>
                <li><span class="cross">✗</span> Diet Plan</li>
                <li><span class="cross">✗</span> Pool & Sauna</li>
            </ul>
            <a href="/payment?plan=Basic&price=3000" class="btn-plan btn-plan-outline">Get Started</a>
        </div>
        <!-- Premium -->
        <div class="plan-card featured">
            <div class="plan-badge">Most Popular</div>
            <div class="plan-icon">&#11088;</div>
            <div class="plan-name">Premium</div>
            <div class="plan-duration">Starting from</div>
            <div class="plan-price">Rs.5,000<span>/mo</span></div>
            <div class="plan-divider"></div>
            <ul class="plan-features">
                <li><span class="check">✓</span> All Basic Features</li>
                <li><span class="check">✓</span> Trainer Guidance</li>
                <li><span class="check">✓</span> Customized Workout Plan</li>
                <li><span class="check">✓</span> Group Classes</li>
                <li><span class="check">✓</span> Progress Tracking</li>
                <li><span class="cross">✗</span> Diet Plan</li>
                <li><span class="cross">✗</span> Pool & Sauna</li>
            </ul>
            <a href="/payment?plan=Premium&price=5000" class="btn-plan btn-plan-gold">Join Premium</a>
        </div>
        <!-- VIP Elite -->
        <div class="plan-card">
            <div class="plan-icon">&#128081;</div>
            <div class="plan-name">VIP Elite</div>
            <div class="plan-duration">Starting from</div>
            <div class="plan-price">Rs.8,500<span>/mo</span></div>
            <div class="plan-divider"></div>
            <ul class="plan-features">
                <li><span class="check">✓</span> All Premium Features</li>
                <li><span class="check">✓</span> Personal Trainer</li>
                <li><span class="check">✓</span> Custom Diet Plan</li>
                <li><span class="check">✓</span> Workout Tracking</li>
                <li><span class="check">✓</span> Pool & Sauna Access</li>
                <li><span class="check">✓</span> VIP Lounge Access</li>
                <li><span class="check">✓</span> Nutrition Consultation</li>
            </ul>
            <a href="/payment?plan=VIP Elite&price=8500" class="btn-plan btn-plan-outline">Go VIP Elite</a>
        </div>
    </div>
</section>

<!-- Features -->
<section class="features" id="features">
    <div class="section-header">
        <div class="section-tag">Our Facilities</div>
        <div class="section-title">WORLD CLASS <span>FACILITIES</span></div>
        <p class="section-sub">Everything you need to achieve your fitness goals under one roof</p>
    </div>
    <div class="features-grid">
        <div class="feature-item">
            <div class="feature-icon-wrap">&#127947;</div>
            <div class="feature-title">Free Weights & Machines</div>
            <p class="feature-text">State-of-the-art equipment including barbells, dumbbells, cable machines, and more — all maintained daily.</p>
        </div>
        <div class="feature-item">
            <div class="feature-icon-wrap">&#128170;</div>
            <div class="feature-title">Personal Training</div>
            <p class="feature-text">Work one-on-one with our certified personal trainers to build a custom plan that delivers real results.</p>
        </div>
        <div class="feature-item">
            <div class="feature-icon-wrap">&#127822;</div>
            <div class="feature-title">Nutrition Guidance</div>
            <p class="feature-text">Get expert nutrition advice and personalized diet plans designed to complement your training program.</p>
        </div>
        <div class="feature-item">
            <div class="feature-icon-wrap">&#128200;</div>
            <div class="feature-title">Progress Tracking</div>
            <p class="feature-text">Monitor your fitness journey with detailed progress reports, BMI tracking, and goal setting tools.</p>
        </div>
        <div class="feature-item">
            <div class="feature-icon-wrap">&#127946;</div>
            <div class="feature-title">Pool & Sauna</div>
            <p class="feature-text">Recover and relax in our premium swimming pool and sauna facilities — available for Standard and above.</p>
        </div>
        <div class="feature-item">
            <div class="feature-icon-wrap">&#128101;</div>
            <div class="feature-title">Group Classes</div>
            <p class="feature-text">Join high-energy group fitness classes including yoga, HIIT, spinning, and more — 15+ classes per week.</p>
        </div>
    </div>
</section>

<!-- CTA -->
<section class="cta">
    <div class="cta-bg"></div>
    <div class="cta-overlay"></div>
    <div class="cta-content">
        <div class="cta-title">READY TO <span>START?</span></div>
        <p class="cta-sub">Join hundreds of members who have already transformed their lives at PRIME FITNESS. Your journey starts today.</p>
        <div class="cta-btns">
            <a href="#plans" class="btn-primary-hero">Join Us Now</a>
            <a href="/login" class="btn-secondary-hero">Member Login</a>
        </div>
    </div>
</section>

<!-- Footer -->
<footer>
    <div class="footer-brand">PRIME FITNESS</div>
    <div class="footer-text">&copy; 2026 Prime Fitness. All rights reserved.</div>
    <div class="footer-links">
        <a href="#about">About</a>
        <a href="#plans">Plans</a>
        <a href="#features">Facilities</a>
        <a href="/login">Login</a>
    </div>
</footer>

<script>
    window.addEventListener('scroll', () => {
        const navbar = document.getElementById('navbar');
        if (window.scrollY > 50) navbar.classList.add('scrolled');
        else navbar.classList.remove('scrolled');
    });
</script>
</body>
</html>