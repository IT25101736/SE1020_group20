package com.fitnesscenter.service;

import com.fitnesscenter.model.Admin;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

@Service
public class AdminService {

    @Value("${admin.file.path}")
    private String filePath;

    public List<Admin> getAllAdmins() throws IOException {
        List<Admin> admins = new ArrayList<>();
        File file = new File(filePath);
        if (!file.exists()) return admins;

        BufferedReader reader = new BufferedReader(new FileReader(file));
        String line;
        while ((line = reader.readLine()) != null) {
            if (line.trim().isEmpty()) continue;
            String[] parts = line.split("\\|");
            if (parts.length == 4) {
                admins.add(new Admin(parts[0], parts[1], parts[2], parts[3]));
            }
        }
        reader.close();
        return admins;
    }

    public void saveAllAdmins(List<Admin> admins) throws IOException {
        File file = new File(filePath);
        file.getParentFile().mkdirs();
        BufferedWriter writer = new BufferedWriter(new FileWriter(file));
        for (Admin a : admins) {
            writer.write(a.toFileString());
            writer.newLine();
        }
        writer.close();
    }

    public Admin findByUsernameAndPassword(String username, String password) throws IOException {
        for (Admin a : getAllAdmins()) {
            if (a.getUsername().equals(username) && a.getPassword().equals(password)) {
                return a;
            }
        }
        return null;
    }

    public String generateId() throws IOException {
        List<Admin> admins = getAllAdmins();
        return "A" + String.format("%03d", admins.size() + 1);
    }

    public void createAdmin(String username, String password, String role) throws IOException {
        List<Admin> admins = getAllAdmins();
        String newId = generateId();
        admins.add(new Admin(newId, username, password, role));
        saveAllAdmins(admins);
    }

    public void updateAdmin(String id, String newPassword, String newRole) throws IOException {
        List<Admin> admins = getAllAdmins();
        for (Admin a : admins) {
            if (a.getId().equals(id)) {
                if (newPassword != null && !newPassword.isEmpty()) {
                    a.setPassword(newPassword);
                }
                a.setRole(newRole);
                break;
            }
        }
        saveAllAdmins(admins);
    }

    public void deleteAdmin(String id) throws IOException {
        List<Admin> admins = getAllAdmins();
        admins.removeIf(a -> a.getId().equals(id));
        saveAllAdmins(admins);
    }
}