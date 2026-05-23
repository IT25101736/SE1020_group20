package com.fitnesscenter.model;

public class WorkoutPlan {
    private String day;
    private String focus;
    private String exercises; // comma separated "Bench Press 4x8, Incline DB 3x10"

    public WorkoutPlan(String day, String focus, String exercises) {
        this.day = day;
        this.focus = focus;
        this.exercises = exercises;
    }

    public String getDay()       { return day; }
    public String getFocus()     { return focus; }
    public String getExercises() { return exercises; }

    public void setDay(String day)             { this.day = day; }
    public void setFocus(String focus)         { this.focus = focus; }
    public void setExercises(String exercises) { this.exercises = exercises; }

    public String toFileString() {
        return day + "|" + focus + "|" + exercises;
    }
}