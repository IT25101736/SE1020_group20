package com.fitnesscenter.model;

public class SuperAdmin extends Admin {

    public SuperAdmin(String id, String username, String password) {
        super(id, username, password, "superadmin");
    }

    @Override
    public String getAccessLevel() {
        return "Full Access — Can manage all modules";
    }
}
