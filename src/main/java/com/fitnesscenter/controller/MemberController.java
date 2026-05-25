package com.fitnesscenter.controller;

import com.fitnesscenter.model.Admin;
import com.fitnesscenter.model.Member;
import com.fitnesscenter.service.MemberService;
import javax.servlet.http.HttpSession;//Storing logged sessions
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;//Spring MVC Controller
import org.springframework.ui.Model;//Used to send data from backend to jsp pages
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;

// Controller class handling member-related web requests and page navigation
@Controller
public class MemberController {

    // Dependancy inverrsion principle
    @Autowired
    private MemberService memberService;

    // Display public home page
    @GetMapping("/home")
    public String home() {
        return "home";
    }

    // Display payment page
    @GetMapping("/payment")
    public String payment() {
        return "payment";
    }

    // Display available membership plans
    @GetMapping("/membership-plans")
    public String membershipPlans(HttpSession session, Model model) {
        Member loggedMember = (Member) session.getAttribute("loggedMember");
        model.addAttribute("loggedMember", loggedMember);
        return "membership-plans";
    }

    // Display member dashboard after login
    @GetMapping("/member/dashboard")
    public String memberDashboard(HttpSession session, Model model) throws IOException {
        Member loggedMember = (Member) session.getAttribute("loggedMember");
        if (loggedMember == null) {
            return "redirect:/login";
        }
        model.addAttribute("loggedMember", loggedMember);
        return "member-dashboard";
    }

    // Admin-only member management page
    @GetMapping("/members")
    public String manageMembers(HttpSession session, Model model) throws IOException {
        //Only admins allowed
        Admin loggedAdmin = (Admin) session.getAttribute("loggedAdmin");
        if (loggedAdmin == null) {
            return "redirect:/login";
        }
        // Display all members for admin management
        List<Member> members = memberService.getAllMembers();
        model.addAttribute("members", members);
        model.addAttribute("loggedAdmin", loggedAdmin);
        return "manage-members";
    }

    // Display payment page for logged member
    @GetMapping("/member/payment")
    public String memberPayment(HttpSession session, Model model) {
        Member loggedMember = (Member) session.getAttribute("loggedMember");
        if (loggedMember == null) {
            return "redirect:/login";
        }
        model.addAttribute("loggedMember", loggedMember);
        return "member-payment";
    }

    // ---- POST /member/update-membership ----
    @PostMapping("/member/update-membership")
    public String updateMembership(@RequestParam String membershipType,
                                   @RequestParam String expiryDate,
                                   @RequestParam String paymentStatus,
                                   HttpSession session) throws IOException {
        Member loggedMember = (Member) session.getAttribute("loggedMember");
        if (loggedMember == null) return "redirect:/login";

        memberService.updateMember(
                loggedMember.getId(),
                loggedMember.getName(),
                loggedMember.getEmail(),
                loggedMember.getPhone(),
                membershipType,
                loggedMember.getWorkoutPlan(),
                loggedMember.getDietPlan(),
                loggedMember.getTrainerName(),
                expiryDate,
                paymentStatus
        );

        Member updated = memberService.findById(loggedMember.getId());
        // Update membership details of logged member
        session.setAttribute("loggedMember", updated);
        return "redirect:/member/dashboard";
    }

    // Admin creates new member
    @PostMapping("/member/create")
    public String createMember(@RequestParam String name,
                               @RequestParam String email,
                               @RequestParam String phone,
                               @RequestParam String membershipType,
                               @RequestParam String workoutPlan,
                               @RequestParam String dietPlan,
                               @RequestParam String trainerName,
                               @RequestParam String joinDate,
                               @RequestParam String expiryDate,
                               @RequestParam String paymentStatus,
                               @RequestParam String password,
                               HttpSession session) throws IOException {

        if (session.getAttribute("loggedAdmin") == null) return "redirect:/login";
        memberService.createMember(name, email, phone, membershipType,
                workoutPlan, dietPlan, trainerName,
                joinDate, expiryDate, paymentStatus, password);
        return "redirect:/members";
    }

    // Update existing member details by admin
    @PostMapping("/member/update")
    public String updateMember(@RequestParam String id,
                               @RequestParam String name,
                               @RequestParam String email,
                               @RequestParam String phone,
                               @RequestParam String membershipType,
                               @RequestParam String workoutPlan,
                               @RequestParam String dietPlan,
                               @RequestParam String trainerName,
                               @RequestParam String expiryDate,
                               @RequestParam String paymentStatus,
                               HttpSession session) throws IOException {

        if (session.getAttribute("loggedAdmin") == null) return "redirect:/login";
        memberService.updateMember(id, name, email, phone, membershipType,
                workoutPlan, dietPlan, trainerName,
                expiryDate, paymentStatus);
        return "redirect:/members";
    }

    // Delete member from system
    @PostMapping("/member/delete")
    public String deleteMember(@RequestParam String id,
                               HttpSession session) throws IOException {

        if (session.getAttribute("loggedAdmin") == null) return "redirect:/login";
        memberService.deleteMember(id);
        return "redirect:/members";
    }

    // Logout member and clear session
    @GetMapping("/member/logout")
    public String memberLogout(HttpSession session) {
        session.removeAttribute("loggedMember");
        return "redirect:/login";
    }
    // ---- POST /member/register — new member registers from home page ----
    @PostMapping("/member/register")
    public String registerMember(@RequestParam String name,
                                 @RequestParam String email,
                                 @RequestParam String phone,
                                 @RequestParam String password,
                                 @RequestParam String plan,
                                 @RequestParam String duration,
                                 @RequestParam String totalAmount,
                                 @RequestParam String paymentMethod,
                                 @RequestParam String expiryDate,
                                 HttpSession session) throws IOException {

        // Create the member account
        memberService.createMember(
                name, email, phone, plan,
                "To be assigned", "To be assigned", "To be assigned",
                java.time.LocalDate.now().toString(),
                expiryDate, "Paid", password
        );

        // Get the newly created member to log them in
        java.util.List<com.fitnesscenter.model.Member> all = memberService.getAllMembers();
        com.fitnesscenter.model.Member newMember = all.get(all.size() - 1);

        // Store in session so confirmation page can show the real ID
        session.setAttribute("newMemberId", newMember.getId());
        session.setAttribute("newMemberName", name);
        session.setAttribute("newMemberPlan", plan);
        session.setAttribute("newMemberDuration", duration);
        session.setAttribute("newMemberTotal", totalAmount);
        session.setAttribute("newMemberPayment", paymentMethod);

        return "redirect:/register-success";
    }

    // Display successful registration details
    @GetMapping("/register-success")
    public String registerSuccess(HttpSession session, org.springframework.ui.Model model) {
        String memberId = (String) session.getAttribute("newMemberId");
        if (memberId == null) return "redirect:/home";
        model.addAttribute("memberId",      memberId);
        model.addAttribute("memberName",    session.getAttribute("newMemberName"));
        model.addAttribute("plan",          session.getAttribute("newMemberPlan"));
        model.addAttribute("duration",      session.getAttribute("newMemberDuration"));
        model.addAttribute("total",         session.getAttribute("newMemberTotal"));
        model.addAttribute("paymentMethod", session.getAttribute("newMemberPayment"));
        // Clear session
        session.removeAttribute("newMemberId");
        session.removeAttribute("newMemberName");
        session.removeAttribute("newMemberPlan");
        session.removeAttribute("newMemberDuration");
        session.removeAttribute("newMemberTotal");
        session.removeAttribute("newMemberPayment");
        return "register-success";
    }


}
