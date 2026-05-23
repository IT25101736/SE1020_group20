package com.fitnesscenter.service;

import com.fitnesscenter.model.Payment;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

@Service
public class PaymentService {

    @Value("${payment.file.path}")
    private String filePath;

    public List<Payment> getAllPayments() throws IOException {
        List<Payment> payments = new ArrayList<>();
        File file = new File(filePath);
        if (!file.exists()) return payments;

        BufferedReader reader = new BufferedReader(new FileReader(file));
        String line;
        while ((line = reader.readLine()) != null) {
            if (line.trim().isEmpty()) continue;
            String[] p = line.split("\\|");
            if (p.length == 8) {
                payments.add(new Payment(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7]));
            }
        }
        reader.close();
        return payments;
    }

    public void saveAllPayments(List<Payment> payments) throws IOException {
        File file = new File(filePath);
        file.getParentFile().mkdirs();
        BufferedWriter writer = new BufferedWriter(new FileWriter(file));
        for (Payment p : payments) {
            writer.write(p.toFileString());
            writer.newLine();
        }
        writer.close();
    }

    public String generateId() throws IOException {
        List<Payment> payments = getAllPayments();
        return "PAY" + String.format("%03d", payments.size() + 1);
    }

    public void createPayment(String memberId, String memberName, String plan,
                              String amount, String paymentMethod,
                              String paymentDate, String status) throws IOException {
        List<Payment> payments = getAllPayments();
        String newId = generateId();
        payments.add(new Payment(newId, memberId, memberName, plan,
                amount, paymentMethod, paymentDate, status));
        saveAllPayments(payments);
    }

    public void updateStatus(String paymentId, String newStatus) throws IOException {
        List<Payment> payments = getAllPayments();
        for (Payment p : payments) {
            if (p.getPaymentId().equals(paymentId)) {
                p.setStatus(newStatus);
                break;
            }
        }
        saveAllPayments(payments);
    }

    public void deletePayment(String paymentId) throws IOException {
        List<Payment> payments = getAllPayments();
        payments.removeIf(p -> p.getPaymentId().equals(paymentId));
        saveAllPayments(payments);
    }

    public List<Payment> getPaymentsByMember(String memberId) throws IOException {
        List<Payment> result = new ArrayList<>();
        for (Payment p : getAllPayments()) {
            if (p.getMemberId().equals(memberId)) result.add(p);
        }
        return result;
    }
}
