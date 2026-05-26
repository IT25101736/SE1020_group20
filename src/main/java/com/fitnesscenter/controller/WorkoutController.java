package com.fitnesscenter.controller;

import com.fitnesscenter.model.Member;
import com.fitnesscenter.model.MemberWorkout;
import com.fitnesscenter.model.WorkoutPlan;
import com.fitnesscenter.service.MemberService;
import com.fitnesscenter.service.WorkoutService;
// importing other classes we need to use

import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;


@Controller
public class WorkoutController {

    @Autowired  //Inheritance - Spring injects service automatically , DEPENDENCY INJECTION
    private WorkoutService workoutService;


    @Autowired
    private MemberService memberService;




    // ---- GET /member/workout — member view ----

    @GetMapping("/member/workout") //just view

    public String memberWorkout(HttpSession session, Model model) throws IOException {
        //check who is logged in , send data to HTML page , file reading might have errors

        Member loggedMember = (Member) session.getAttribute("loggedMember"); //Like asking who is currently using the system

        if (loggedMember == null) return "redirect:/login";

        //Abstraction -  Controller just CALLS the method — doesn't know HOW it works
        MemberWorkout workout = workoutService.getMemberWorkout(loggedMember.getId());
        //Service reads the file & returns the workout object


        model.addAttribute("loggedMember", loggedMember);
        model.addAttribute("workout", workout);
        //Send member info and workout to HTML page to display

        return "my-workout";
    }




    // ---- GET /manage/workouts — admin view ----

    //POLYMORPHISM

    @GetMapping("/manage/workouts")

    public String manageWorkouts(HttpSession session, Model model) throws IOException {
        //send data to HTML page , file reading might have errors

        Admin loggedAdmin = (Admin) session.getAttribute("loggedAdmin"); //Get the logged in admin from session

        if (loggedAdmin == null) return "redirect:/login";

        List<Member> members = memberService.getAllMembers(); //get all members

        model.addAttribute("loggedAdmin", loggedAdmin);
        model.addAttribute("members", members);
        //Send admin info and members list to HTML page to display

        return "manage-workouts";
    }




    // ---- GET /manage/workouts/assign?memberId=X — load template ----

    @GetMapping("/manage/workouts/assign")

    public String assignWorkout(@RequestParam String memberId, //Get memberId from the URL — which member to assign
                                @RequestParam String planType, //ppl,fullBody

                                HttpSession session,
                                Model model) throws IOException {

        Admin loggedAdmin = (Admin) session.getAttribute("loggedAdmin");

        if (loggedAdmin == null) return "redirect:/login";

        Member member = memberService.findById(memberId);

        MemberWorkout template = workoutService.getTemplate(planType);

        template.setMemberId(memberId); // Attach this member's ID to the template

        model.addAttribute("loggedAdmin", loggedAdmin);
        model.addAttribute("member", member);
        model.addAttribute("workout", template);
        model.addAttribute("planType", planType);
        // Send all data to HTML page


        return "assign-workout";
    }




    // ---- POST /manage/workouts/save — save customized workout ----

    @PostMapping("/manage/workouts/save")

    //submitting form data , click save button

    public String saveWorkout(@RequestParam String memberId, // Which member this plan is for
                              @RequestParam String planType,
                              @RequestParam List<String> days,
                              @RequestParam List<String> focuses,//push , pull
                              @RequestParam List<String> exercises,

                              HttpSession session) throws IOException {
        Admin loggedAdmin = (Admin) session.getAttribute("loggedAdmin");

        if (loggedAdmin == null) return "redirect:/login";

        MemberWorkout workout = new MemberWorkout(memberId, planType);

        for (int i = 0; i < days.size(); i++) {

            workout.addDay(new WorkoutPlan(

                    days.get(i), //Get day name from list — "Monday"

                    focuses.get(i),

                    exercises.get(i) //Get exercises — "Bench Press 4x8"

                    //for all 7 days, Create one WorkoutPlan for each day
            ));
        }


        workoutService.saveMemberWorkout(workout);

        return "redirect:/manage/workouts";
    }




    // ---- POST /manage/workouts/delete ----

    @PostMapping("/manage/workouts/delete")

    public String deleteWorkout(@RequestParam String memberId, //Which member's workout to delete
                                HttpSession session) throws IOException {

        Admin loggedAdmin = (Admin) session.getAttribute("loggedAdmin");

        if (loggedAdmin == null) return "redirect:/login";

        workoutService.deleteMemberWorkout(memberId);

        return "redirect:/manage/workouts";
    }
}
