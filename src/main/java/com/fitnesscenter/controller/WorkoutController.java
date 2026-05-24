package com.fitnesscenter.controller;

import com.fitnesscenter.model.Member;
import com.fitnesscenter.model.MemberWorkout;
import com.fitnesscenter.model.WorkoutPlan;
import com.fitnesscenter.service.MemberService;
import com.fitnesscenter.service.WorkoutService;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;


@Controller
public class WorkoutController {

    @Autowired
    private WorkoutService workoutService;

    @Autowired
    private MemberService memberService;




    // ---- GET /member/workout — member view ----
    @GetMapping("/member/workout")
    public String memberWorkout(HttpSession session, Model model) throws IOException {
        Member loggedMember = (Member) session.getAttribute("loggedMember");
        if (loggedMember == null) return "redirect:/login";

        MemberWorkout workout = workoutService.getMemberWorkout(loggedMember.getId());
        model.addAttribute("loggedMember", loggedMember);
        model.addAttribute("workout", workout);
        return "my-workout";
    }




    // ---- GET /manage/workouts — admin view ----
    @GetMapping("/manage/workouts")
    public String manageWorkouts(HttpSession session, Model model) throws IOException {
        Admin loggedAdmin = (Admin) session.getAttribute("loggedAdmin");
        if (loggedAdmin == null) return "redirect:/login";

        List<Member> members = memberService.getAllMembers();
        model.addAttribute("loggedAdmin", loggedAdmin);
        model.addAttribute("members", members);
        return "manage-workouts";
    }




    // ---- GET /manage/workouts/assign?memberId=X — load template ----
    @GetMapping("/manage/workouts/assign")
    public String assignWorkout(@RequestParam String memberId,
                                @RequestParam String planType,
                                HttpSession session,
                                Model model) throws IOException {
        Admin loggedAdmin = (Admin) session.getAttribute("loggedAdmin");
        if (loggedAdmin == null) return "redirect:/login";

        Member member = memberService.findById(memberId);
        MemberWorkout template = workoutService.getTemplate(planType);
        template.setMemberId(memberId);

        model.addAttribute("loggedAdmin", loggedAdmin);
        model.addAttribute("member", member);
        model.addAttribute("workout", template);
        model.addAttribute("planType", planType);
        return "assign-workout";
    }




    // ---- POST /manage/workouts/save — save customized workout ----
    @PostMapping("/manage/workouts/save")
    public String saveWorkout(@RequestParam String memberId,
                              @RequestParam String planType,
                              @RequestParam List<String> days,
                              @RequestParam List<String> focuses,
                              @RequestParam List<String> exercises,
                              HttpSession session) throws IOException {
        Admin loggedAdmin = (Admin) session.getAttribute("loggedAdmin");
        if (loggedAdmin == null) return "redirect:/login";

        MemberWorkout workout = new MemberWorkout(memberId, planType);
        for (int i = 0; i < days.size(); i++) {
            workout.addDay(new WorkoutPlan(
                    days.get(i),
                    focuses.get(i),
                    exercises.get(i)
            ));
        }
        workoutService.saveMemberWorkout(workout);
        return "redirect:/manage/workouts";
    }


    

    // ---- POST /manage/workouts/delete ----
    @PostMapping("/manage/workouts/delete")
    public String deleteWorkout(@RequestParam String memberId,
                                HttpSession session) throws IOException {
        Admin loggedAdmin = (Admin) session.getAttribute("loggedAdmin");
        if (loggedAdmin == null) return "redirect:/login";
        workoutService.deleteMemberWorkout(memberId);
        return "redirect:/manage/workouts";
    }
}
