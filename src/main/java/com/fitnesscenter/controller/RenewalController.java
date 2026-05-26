package com.fitnesscenter.controller;

import com.fitnesscenter.model.Admin;
import com.fitnesscenter.model.Member;
import com.fitnesscenter.model.RenewalRequest;
import com.fitnesscenter.service.MemberService;
import com.fitnesscenter.service.RenewalQueueService;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;
import java.util.Queue;

@Controller
public class RenewalController {

    @Autowired
    private RenewalQueueService renewalQueueService;

    @Autowired
    private MemberService memberService;

    // ---- GET /renewals — admin view of queue ----
    @GetMapping("/renewals")
    public String renewalQueue(HttpSession session, Model model) throws IOException {
        Admin loggedAdmin = (Admin) session.getAttribute("loggedAdmin");
        if (loggedAdmin == null) return "redirect:/login";

        Queue<RenewalRequest> pendingQueue = renewalQueueService.getPendingQueue();
        List<RenewalRequest> allRequests = renewalQueueService.getAllRequests();
        List<Member> members = memberService.getAllMembers();
        List<Member> sortedMembers = renewalQueueService.sortMembersByRenewalDate(members);

        model.addAttribute("pendingQueue", pendingQueue);
        model.addAttribute("allRequests", allRequests);
        model.addAttribute("sortedMembers", sortedMembers);
        model.addAttribute("loggedAdmin", loggedAdmin);
        model.addAttribute("pendingCount", renewalQueueService.getPendingCount());
        return "renewal-queue";
    }

    // ---- POST /renewal/request — member submits renewal request ----
    @PostMapping("/renewal/request")
    public String submitRequest(@RequestParam String requestedPlan,
                                HttpSession session) throws IOException {
        Member loggedMember = (Member) session.getAttribute("loggedMember");
        if (loggedMember == null) return "redirect:/login";

        String today = java.time.LocalDate.now().toString();
        renewalQueueService.enqueue(
                loggedMember.getId(),
                loggedMember.getName(),
                loggedMember.getMembershipType(),
                requestedPlan,
                today
        );
        return "redirect:/member/dashboard?renewed=true";
    }

    // ---- POST /renewal/dequeue — admin processes next request ----
    @PostMapping("/renewal/dequeue")
    public String processNext(HttpSession session) throws IOException {
        if (session.getAttribute("loggedAdmin") == null) return "redirect:/login";
        renewalQueueService.dequeue();
        return "redirect:/renewals";
    }

    // ---- POST /renewal/process — admin processes specific request ----
    @PostMapping("/renewal/process")
    public String processRequest(@RequestParam String requestId,
                                 HttpSession session) throws IOException {
        if (session.getAttribute("loggedAdmin") == null) return "redirect:/login";

        List<RenewalRequest> list = renewalQueueService.getAllRequests();
        for (RenewalRequest r : list) {
            if (r.getRequestId().equals(requestId)) {
                r.setStatus("PROCESSED");
                break;
            }
        }
        renewalQueueService.saveAllRequests(list);
        return "redirect:/renewals";
    }

    // ---- POST /renewal/request-with-payment — member submits renewal after payment ----
    @PostMapping("/renewal/request-with-payment")
    public String requestWithPayment(@RequestParam String requestedPlan,
                                     @RequestParam String duration,
                                     @RequestParam String totalAmount,
                                     @RequestParam String paymentMethod,
                                     @RequestParam String expiryDate,
                                     HttpSession session) throws IOException {
        Member loggedMember = (Member) session.getAttribute("loggedMember");
        if (loggedMember == null) return "redirect:/login";

        String today = java.time.LocalDate.now().toString();
        renewalQueueService.enqueue(
                loggedMember.getId(),
                loggedMember.getName(),
                loggedMember.getMembershipType(),
                requestedPlan,
                today
        );
        return "redirect:/member/dashboard?renewed=true";
    }

    // ---- POST /renewal/confirm-and-update — admin confirms, updates member, runs insertion sort ----
    @PostMapping("/renewal/confirm-and-update")
    public String confirmAndUpdate(@RequestParam String requestId,
                                   @RequestParam String memberId,
                                   @RequestParam String requestedPlan,
                                   HttpSession session) throws IOException {
        if (session.getAttribute("loggedAdmin") == null) return "redirect:/login";

        // 1. Mark request as PROCESSED
        List<RenewalRequest> list = renewalQueueService.getAllRequests();
        for (RenewalRequest r : list) {
            if (r.getRequestId().equals(requestId)) {
                r.setStatus("PROCESSED");
                break;
            }
        }
        renewalQueueService.saveAllRequests(list);

        // 2. Update member's plan and expiry date in members.txt
        Member member = memberService.findById(memberId);
        if (member != null) {
            String newExpiry = java.time.LocalDate.now().plusMonths(1).toString();
            memberService.updateMember(
                    member.getId(),
                    member.getName(),
                    member.getEmail(),
                    member.getPhone(),
                    requestedPlan,
                    member.getWorkoutPlan(),
                    member.getDietPlan(),
                    member.getTrainerName(),
                    newExpiry,
                    "Paid"
            );
        }

        // 3. Insertion Sort runs automatically on /renewals page load
        return "redirect:/renewals";
    }

    // ---- POST /renewal/delete — admin deletes a renewal request ----
    @PostMapping("/renewal/delete")
    public String deleteRequest(@RequestParam String requestId,
                                HttpSession session) throws IOException {
        if (session.getAttribute("loggedAdmin") == null) return "redirect:/login";
        List<RenewalRequest> list = renewalQueueService.getAllRequests();
        list.removeIf(r -> r.getRequestId().equals(requestId));
        renewalQueueService.saveAllRequests(list);
        return "redirect:/renewals";
    }
}
