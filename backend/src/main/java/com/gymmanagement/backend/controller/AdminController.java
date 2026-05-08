package com.fitnesscenter.controller;

import com.fitnesscenter.model.Admin;
import com.fitnesscenter.model.Member;
import com.fitnesscenter.service.AdminService;
import com.fitnesscenter.service.MemberService;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;

@Controller
public class AdminController {

    @Autowired
    private AdminService adminService;

    @Autowired
    private MemberService memberService;

    // ---- GET /login ----
    @GetMapping("/login")
    public String showLogin() {
        return "login";
    }

    // ---- POST /login — handles both member and staff login ----
    @PostMapping("/login")
    public String handleLogin(@RequestParam String username,
                              @RequestParam String password,
                              @RequestParam String userType,
                              HttpSession session,
                              Model model) throws IOException {

        if (userType.equals("member")) {
            // Member login — check members.txt
            Member found = memberService.findByIdAndPassword(username, password);
            if (found != null) {
                session.setAttribute("loggedMember", found);
                return "redirect:/member/dashboard";
            } else {
                model.addAttribute("error", "Invalid Member ID or password.");
                model.addAttribute("userType", "member");
                return "login";
            }

        } else {
            // Staff login — check admins.txt
            Admin found = adminService.findByUsernameAndPassword(username, password);
            if (found != null) {
                session.setAttribute("loggedAdmin", found);
                return "redirect:/dashboard";
            } else {
                model.addAttribute("error", "Invalid username or password.");
                model.addAttribute("userType", "staff");
                return "login";
            }
        }
    }

    // ---- GET /dashboard — staff dashboard ----
    @GetMapping("/dashboard")
    public String showDashboard(HttpSession session, Model model) throws IOException {
        if (session.getAttribute("loggedAdmin") == null) {
            return "redirect:/login";
        }
        List<Admin> admins = adminService.getAllAdmins();
        System.out.println("Number of admins loaded: " + admins.size());
        System.out.println("File path working!");
        model.addAttribute("admins", admins);
        model.addAttribute("loggedAdmin", session.getAttribute("loggedAdmin"));
        return "dashboard";
    }

    // ---- POST /admin/create ----
    @PostMapping("/admin/create")
    public String createAdmin(@RequestParam String username,
                              @RequestParam String password,
                              @RequestParam String role,
                              HttpSession session) throws IOException {

        if (session.getAttribute("loggedAdmin") == null) return "redirect:/login";
        adminService.createAdmin(username, password, role);
        return "redirect:/dashboard";
    }

    // ---- POST /admin/update ----
    @PostMapping("/admin/update")
    public String updateAdmin(@RequestParam String id,
                              @RequestParam String password,
                              @RequestParam String role,
                              HttpSession session) throws IOException {

        if (session.getAttribute("loggedAdmin") == null) return "redirect:/login";
        adminService.updateAdmin(id, password, role);
        return "redirect:/dashboard";
    }

    // ---- POST /admin/delete ----
    @PostMapping("/admin/delete")
    public String deleteAdmin(@RequestParam String id,
                              HttpSession session) throws IOException {

        if (session.getAttribute("loggedAdmin") == null) return "redirect:/login";
        adminService.deleteAdmin(id);
        return "redirect:/dashboard";
    }

    // ---- GET /logout ----
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}