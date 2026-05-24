package com.fitnesscenter.service;

import com.fitnesscenter.model.Member;
import com.fitnesscenter.model.RenewalRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.*;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Queue;

@Service
public class RenewalQueueService {

    @Value("${renewal.file.path}")
    private String filePath;

    @Autowired
    private MemberService memberService;

    // ---- READ all requests from file ----
    public List<RenewalRequest> getAllRequests() throws IOException {
        List<RenewalRequest> list = new ArrayList<>();
        File file = new File(filePath);
        if (!file.exists()) return list;

        BufferedReader reader = new BufferedReader(new FileReader(file));
        String line;
        while ((line = reader.readLine()) != null) {
            if (line.trim().isEmpty()) continue;
            String[] p = line.split("\\|");
            if (p.length == 7) {
                list.add(new RenewalRequest(p[0], p[1], p[2], p[3], p[4], p[5], p[6]));
            }
        }
        reader.close();
        return list;
    }

    // ---- WRITE all requests back to file ----
    public void saveAllRequests(List<RenewalRequest> requests) throws IOException {
        File file = new File(filePath);
        file.getParentFile().mkdirs();
        BufferedWriter writer = new BufferedWriter(new FileWriter(file));
        for (RenewalRequest r : requests) {
            writer.write(r.toFileString());
            writer.newLine();
        }
        writer.close();
    }

    // ---- Generate ID ----
    public String generateId() throws IOException {
        return "REQ" + String.format("%03d", getAllRequests().size() + 1);
    }

    // ---- ENQUEUE — add new renewal request ----
    public void enqueue(String memberId, String memberName,
                        String currentPlan, String requestedPlan,
                        String requestDate) throws IOException {
        List<RenewalRequest> list = getAllRequests();
        String id = generateId();
        list.add(new RenewalRequest(id, memberId, memberName,
                currentPlan, requestedPlan,
                requestDate, "PENDING"));
        saveAllRequests(list);
    }

    // ---- Get PENDING requests as a Queue (FIFO) ----
    public Queue<RenewalRequest> getPendingQueue() throws IOException {
        Queue<RenewalRequest> queue = new LinkedList<>();
        for (RenewalRequest r : getAllRequests()) {
            if (r.getStatus().equals("PENDING")) {
                queue.add(r); // enqueue
            }
        }
        return queue;
    }

    // ---- DEQUEUE — process the first PENDING request ----
    public RenewalRequest dequeue() throws IOException {
        List<RenewalRequest> list = getAllRequests();
        for (RenewalRequest r : list) {
            if (r.getStatus().equals("PENDING")) {
                r.setStatus("PROCESSED");
                saveAllRequests(list);
                return r; // return the processed request
            }
        }
        return null; // queue is empty
    }

    // ---- INSERTION SORT — sort members by expiry date ----
    public List<Member> sortMembersByRenewalDate(List<Member> members) {
        // Insertion Sort algorithm
        for (int i = 1; i < members.size(); i++) {
            Member key = members.get(i);
            int j = i - 1;

            // Move elements that are greater than key one position ahead
            while (j >= 0 && members.get(j).getExpiryDate().compareTo(key.getExpiryDate()) > 0) {
                members.set(j + 1, members.get(j));
                j--;
            }
            members.set(j + 1, key);
        }
        return members; // sorted by earliest expiry date first
    }

    // ---- Count pending requests ----
    public int getPendingCount() throws IOException {
        return (int) getAllRequests().stream()
                .filter(r -> r.getStatus().equals("PENDING"))
                .count();
    }
}