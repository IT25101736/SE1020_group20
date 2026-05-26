package com.fitnesscenter.controller;

import com.fitnesscenter.model.Admin;
import com.fitnesscenter.model.Payment;
import com.fitnesscenter.service.PaymentService;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;

@Controller
public class PaymentController {

    @Autowired
    private PaymentService paymentService;

    // ---- GET /payments — admin view ----
    @GetMapping("/payments")
    public String managePayments(HttpSession session, Model model) throws IOException {
        Admin loggedAdmin = (Admin) session.getAttribute("loggedAdmin");
        if (loggedAdmin == null) return "redirect:/login";

        List<Payment> payments = paymentService.getAllPayments();
        long totalRevenue = payments.stream()
                .filter(p -> p.getStatus().equals("Paid"))
                .mapToLong(p -> {
                    try { return Long.parseLong(p.getAmount()); }
                    catch (Exception e) { return 0; }
                }).sum();

        model.addAttribute("payments", payments);
        model.addAttribute("loggedAdmin", loggedAdmin);
        model.addAttribute("totalRevenue", totalRevenue);
        return "manage-payments";
    }

    // ---- POST /payment/create ----
    @PostMapping("/payment/create")
    public String createPayment(@RequestParam String memberId,
                                @RequestParam String memberName,
                                @RequestParam String plan,
                                @RequestParam String amount,
                                @RequestParam String paymentMethod,
                                @RequestParam String paymentDate,
                                @RequestParam String status,
                                HttpSession session) throws IOException {
        if (session.getAttribute("loggedAdmin") == null) return "redirect:/login";
        paymentService.createPayment(memberId, memberName, plan,
                amount, paymentMethod, paymentDate, status);
        return "redirect:/payments";
    }

    // ---- POST /payment/update-status ----
    @PostMapping("/payment/update-status")
    public String updateStatus(@RequestParam String paymentId,
                               @RequestParam String status,
                               HttpSession session) throws IOException {
        if (session.getAttribute("loggedAdmin") == null) return "redirect:/login";
        paymentService.updateStatus(paymentId, status);
        return "redirect:/payments";
    }

    // ---- POST /payment/delete ----
    @PostMapping("/payment/delete")
    public String deletePayment(@RequestParam String paymentId,
                                HttpSession session) throws IOException {
        if (session.getAttribute("loggedAdmin") == null) return "redirect:/login";
        paymentService.deletePayment(paymentId);
        return "redirect:/payments";
    }
}