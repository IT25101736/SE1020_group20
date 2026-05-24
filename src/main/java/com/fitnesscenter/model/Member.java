package com.fitnesscenter.model;

public class Member {
    private String id;
    private String name;
    private String email;
    private String phone;
    private String membershipType;
    private String workoutPlan;
    private String dietPlan;
    private String trainerName;
    private String joinDate;
    private String expiryDate;
    private String paymentStatus;
    private String password;

    public Member(String id, String name, String email, String phone,
                  String membershipType, String workoutPlan, String dietPlan,
                  String trainerName, String joinDate, String expiryDate,
                  String paymentStatus, String password) {
        this.id             = id;
        this.name           = name;
        this.email          = email;
        this.phone          = phone;
        this.membershipType = membershipType;
        this.workoutPlan    = workoutPlan;
        this.dietPlan       = dietPlan;
        this.trainerName    = trainerName;
        this.joinDate       = joinDate;
        this.expiryDate     = expiryDate;
        this.paymentStatus  = paymentStatus;
        this.password       = password;
    }

    public String getId()             { return id; }
    public String getName()           { return name; }
    public String getEmail()          { return email; }
    public String getPhone()          { return phone; }
    public String getMembershipType() { return membershipType; }
    public String getWorkoutPlan()    { return workoutPlan; }
    public String getDietPlan()       { return dietPlan; }
    public String getTrainerName()    { return trainerName; }
    public String getJoinDate()       { return joinDate; }
    public String getExpiryDate()     { return expiryDate; }
    public String getPaymentStatus()  { return paymentStatus; }
    public String getPassword()       { return password; }

    public void setName(String name)                     { this.name = name; }
    public void setEmail(String email)                   { this.email = email; }
    public void setPhone(String phone)                   { this.phone = phone; }
    public void setMembershipType(String membershipType) { this.membershipType = membershipType; }
    public void setWorkoutPlan(String workoutPlan)       { this.workoutPlan = workoutPlan; }
    public void setDietPlan(String dietPlan)             { this.dietPlan = dietPlan; }
    public void setTrainerName(String trainerName)       { this.trainerName = trainerName; }
    public void setExpiryDate(String expiryDate)         { this.expiryDate = expiryDate; }
    public void setPaymentStatus(String paymentStatus)   { this.paymentStatus = paymentStatus; }
    public void setPassword(String password)             { this.password = password; }

    public String toFileString() {
        return id + "|" + name + "|" + email + "|" + phone + "|" +
                membershipType + "|" + workoutPlan + "|" + dietPlan + "|" +
                trainerName + "|" + joinDate + "|" + expiryDate + "|" +
                paymentStatus + "|" + password;
    }
}
