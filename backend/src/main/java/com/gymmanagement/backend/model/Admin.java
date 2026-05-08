package com.fitnesscenter.model;

public class Admin {

    private String id;
    private String username;
    private String password;
    private String role;

    public Admin(String id, String username, String password, String role) {
        this.id       = id;
        this.username = username;
        this.password = password;
        this.role     = role;
    }

    public String getId()       { return id; }
    public String getUsername() { return username; }
    public String getPassword() { return password; }
    public String getRole()     { return role; }

    public void setUsername(String username) { this.username = username; }
    public void setPassword(String password) { this.password = password; }
    public void setRole(String role)         { this.role = role; }

    public String getAccessLevel() {
        if (role.equals("superadmin")) return "Manager";
        return "Staff";
    }

    public String toFileString() {
        return id + "|" + username + "|" + password + "|" + role;
    }
}