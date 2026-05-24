package com.fitnesscenter.service;

import com.fitnesscenter.model.Member;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

@Service
public class MemberService {
    @Value("${member.file.path}")
    private String filePath;

    public List<Member> getAllMembers() throws IOException {
        List<Member> members = new ArrayList<>();
        File file = new File(filePath);
        if (!file.exists()) return members;

        BufferedReader reader = new BufferedReader(new FileReader(file));
        String line;
        while ((line = reader.readLine()) != null) {
            if (line.trim().isEmpty()) continue;
            String[] parts = line.split("\\|");
            if (parts.length == 12) {
                members.add(new Member(
                        parts[0], parts[1], parts[2], parts[3],
                        parts[4], parts[5], parts[6], parts[7],
                        parts[8], parts[9], parts[10], parts[11]
                ));
            }
        }
        reader.close();
        return members;
    }

    public void saveAllMembers(List<Member> members) throws IOException {
        File file = new File(filePath);
        file.getParentFile().mkdirs();
        BufferedWriter writer = new BufferedWriter(new FileWriter(file));
        for (Member m : members) {
            writer.write(m.toFileString());
            writer.newLine();
        }
        writer.close();
    }

    public Member findByIdAndPassword(String id, String password) throws IOException {
        for (Member m : getAllMembers()) {
            if (m.getId().equals(id) && m.getPassword().equals(password)) {
                return m;
            }
        }
        return null;
    }

    public Member findById(String id) throws IOException {
        for (Member m : getAllMembers()) {
            if (m.getId().equals(id)) return m;
        }
        return null;
    }

    public String generateId() throws IOException {
        List<Member> members = getAllMembers();
        return "M" + String.format("%03d", members.size() + 1);
    }

    public void createMember(String name, String email, String phone,
                             String membershipType, String workoutPlan, String dietPlan,
                             String trainerName, String joinDate, String expiryDate,
                             String paymentStatus, String password) throws IOException {
        List<Member> members = getAllMembers();
        String newId = generateId();
        members.add(new Member(newId, name, email, phone,
                membershipType, workoutPlan, dietPlan,
                trainerName, joinDate, expiryDate,
                paymentStatus, password));
        saveAllMembers(members);
    }

    public void updateMember(String id, String name, String email, String phone,
                             String membershipType, String workoutPlan, String dietPlan,
                             String trainerName, String expiryDate,
                             String paymentStatus) throws IOException {
        List<Member> members = getAllMembers();
        for (Member m : members) {
            if (m.getId().equals(id)) {
                m.setName(name);
                m.setEmail(email);
                m.setPhone(phone);
                m.setMembershipType(membershipType);
                m.setWorkoutPlan(workoutPlan);
                m.setDietPlan(dietPlan);
                m.setTrainerName(trainerName);
                m.setExpiryDate(expiryDate);
                m.setPaymentStatus(paymentStatus);
                break;
            }
        }
        saveAllMembers(members);
    }

    public void deleteMember(String id) throws IOException {
        List<Member> members = getAllMembers();
        members.removeIf(m -> m.getId().equals(id));
        saveAllMembers(members);
    }

}
