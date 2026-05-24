package com.fitnesscenter.model;

import java.util.List;
import java.util.ArrayList;

public class MemberWorkout {
    private String memberId;
    private String planType; // PPL, Full Body, Arnold, Upper Lower
    private List<WorkoutPlan> days; //LIST of WorkoutPlan



    public MemberWorkout(String memberId, String planType) {
        this.memberId = memberId;
        this.planType = planType;
        this.days = new ArrayList<>();
    }



    public String getMemberId()          { return memberId; }
    public String getPlanType()          { return planType; }
    public List<WorkoutPlan> getDays()   { return days; }// Returns the entire multi-day list



    public void setMemberId(String memberId) { this.memberId = memberId; }
    public void setPlanType(String planType) { this.planType = planType; }
    public void setDays(List<WorkoutPlan> days) { this.days = days; }



    public void addDay(WorkoutPlan day) { this.days.add(day); }
}