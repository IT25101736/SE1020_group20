package com.fitnesscenter.controller;

import com.fitnesscenter.model.DietPlan;
import com.fitnesscenter.model.Member;
import com.fitnesscenter.service.DietPlanService;
import com.fitnesscenter.service.MemberService;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;



@Controller //Inheritance
public class DietController {

    @Autowired  // Spring injects service automatically
    private DietPlanService dietPlanService;

    @Autowired
    private MemberService memberService;




    // ---- GET /member/diet — member views their diet plan ----

    @GetMapping("/member/diet") // when user opens a page

    public String memberDiet(HttpSession session, Model model) throws IOException { // check if member logging using http

        Member loggedMember = (Member) session.getAttribute("loggedMember");

        if (loggedMember == null) return "redirect:/login";

        DietPlan dietPlan = dietPlanService.findByMemberId(loggedMember.getId());

        model.addAttribute("loggedMember", loggedMember);

        model.addAttribute("dietPlan", dietPlan);

        return "member-diet";

        // from the service and sends it to the HTML page to display
    }





    // ---- POST /member/diet/save — member saves their own diet plan ----
    @PostMapping("/member/diet/save") //when user submits a form

    public String memberDietSave(@RequestParam String planName,
                                 @RequestParam String breakfast,
                                 @RequestParam String lunch,
                                 @RequestParam String dinner,
                                 @RequestParam String snacks,
                                 @RequestParam String notes,
                                 HttpSession session) throws IOException {

        Member loggedMember = (Member) session.getAttribute("loggedMember");

        if (loggedMember == null) return "redirect:/login";

        dietPlanService.createOrUpdate(loggedMember.getId(), planName,
                breakfast, lunch, dinner, snacks, notes);

        return "redirect:/member/diet?saved=true"; //Goes  another page after action

        //fills the diet form and clicks Save

        //using @RequestParam-gets all form values , save
    }







    // ---- POST /member/diet/delete — member deletes their diet plan ----
    @PostMapping("/member/diet/delete")

    public String memberDietDelete(HttpSession session) throws IOException {

        Member loggedMember = (Member) session.getAttribute("loggedMember");

        if (loggedMember == null) return "redirect:/login";

        dietPlanService.deleteDietPlan(loggedMember.getId()); //call

        //delete from file

        return "redirect:/member/diet";
    }




    // ---- GET /admin/diet — admin views all member diet plans ----
    @GetMapping("/admin/diet")

    public String adminDiet(HttpSession session, Model model) throws IOException {

        Admin loggedAdmin = (Admin) session.getAttribute("loggedAdmin");

        if (loggedAdmin == null) return "redirect:/login";

        List<Member> members     = memberService.getAllMembers(); // get all mem lists from memberService

        List<DietPlan> dietPlans = dietPlanService.getAllDietPlans();

        model.addAttribute("members", members);

        model.addAttribute("dietPlans", dietPlans);

        model.addAttribute("loggedAdmin", loggedAdmin);

        return "admin-diet";

        //from service sends them to HTML , so admin can see it
    }




    // ---- GET /admin/diet/edit — admin edits a specific member's diet plan ----
    @GetMapping("/admin/diet/edit")

    public String adminDietEdit(@RequestParam String memberId, //@RequestParam gets memberId from URL
                                HttpSession session, Model model) throws IOException {

        Admin loggedAdmin = (Admin) session.getAttribute("loggedAdmin");

        if (loggedAdmin == null) return "redirect:/login";

        Member member     = memberService.findById(memberId);

        DietPlan dietPlan = dietPlanService.findByMemberId(memberId);

        model.addAttribute("member", member);

        model.addAttribute("dietPlan", dietPlan);

        model.addAttribute("loggedAdmin", loggedAdmin);

        return "admin-diet-edit"; //sends  to the edit form page so admin can change


        //Get member details from memberService
        //Get existing diet plan from dietPlanService

        //Send both to HTML edit form , Show admin-diet-edit page with pre-filled form

    }




    // ---- POST /admin/diet/save — admin saves diet plan for a member ----
    @PostMapping("/admin/diet/save")

    public String adminDietSave(@RequestParam String memberId, //get all form values
                                @RequestParam String planName,
                                @RequestParam String breakfast,
                                @RequestParam String lunch,
                                @RequestParam String dinner,
                                @RequestParam String snacks,
                                @RequestParam String notes,

                                HttpSession session) throws IOException {
        if (session.getAttribute("loggedAdmin") == null) return "redirect:/login";

        dietPlanService.createOrUpdate(memberId, planName, breakfast, lunch, dinner, snacks, notes);
        // call and save or update the diet plan file

        return "redirect:/admin/diet?saved=true";

    }




    // ---- POST /admin/diet/delete — admin deletes a member's diet plan ----
    @PostMapping("/admin/diet/delete")

    public String adminDietDelete(@RequestParam String memberId, //@RequestParam gets memberId
                                  HttpSession session) throws IOException {

        if (session.getAttribute("loggedAdmin") == null) return "redirect:/login";

        dietPlanService.deleteDietPlan(memberId); //call

        return "redirect:/admin/diet";

    }
}