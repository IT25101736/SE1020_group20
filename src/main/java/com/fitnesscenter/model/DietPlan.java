package com.fitnesscenter.model;

public class DietPlan {

    private String memberId;
    private String planName;
    private String breakfastItems;   // format: "3 Eggs,200g Chicken,150g Rice"
    private String lunchItems;
    private String dinnerItems;
    private String snackItems;
    private String notes;



    public DietPlan(String memberId, String planName, String breakfastItems,
                    String lunchItems, String dinnerItems, String snackItems, String notes) {
        this.memberId       = memberId;
        this.planName       = planName;
        this.breakfastItems = breakfastItems;
        this.lunchItems     = lunchItems;
        this.dinnerItems    = dinnerItems;
        this.snackItems     = snackItems;
        this.notes          = notes;
    }



    public String getMemberId()       { return memberId; }
    public String getPlanName()       { return planName; }
    public String getBreakfastItems() { return breakfastItems; }
    public String getLunchItems()     { return lunchItems; }
    public String getDinnerItems()    { return dinnerItems; }
    public String getSnackItems()     { return snackItems; }
    public String getNotes()          { return notes; }



    public void setPlanName(String planName)             { this.planName = planName; }
    public void setBreakfastItems(String breakfastItems) { this.breakfastItems = breakfastItems; }
    public void setLunchItems(String lunchItems)         { this.lunchItems = lunchItems; }
    public void setDinnerItems(String dinnerItems)       { this.dinnerItems = dinnerItems; }
    public void setSnackItems(String snackItems)         { this.snackItems = snackItems; }
    public void setNotes(String notes)                   { this.notes = notes; }




    public String toFileString() {
        return memberId + "|" + planName + "|" + breakfastItems + "|" +
                lunchItems + "|" + dinnerItems + "|" + snackItems + "|" + notes;
    }
}