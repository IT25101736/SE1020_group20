package com.gymmanagement.backend.model;

public class member {

    private String memberId;
    private String name;
    private String email;
    private String password;
    private int  Weight;
    private int height;
    private String role; //user or admin

    public member(){}

    public member(String memberId,String name, String email,String password,String role){
        this.memberId=memberId;
        this.name=name;
        this.email=email;
        this.password=password;
        this.role=role;

    }

    public String getMemberId() {
        return memberId;
    }

    public void setMemberId(String memberId) {
        this.memberId = memberId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public int getWeight() {
        return Weight;
    }

    public void setWeight(int weight) {
        Weight = weight;
    }

    public int getHeight() {
        return height;
    }

    public void setHeight(int height) {
        this.height = height;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }


}
