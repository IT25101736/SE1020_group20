package com.fitnesscenter.service;

import com.fitnesscenter.model.DietPlan;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

@Service
public class DietPlanService {

    @Value("${diet.file.path}")
    private String filePath;



    //READ

    //Read ALL

    public List<DietPlan> getAllDietPlans() throws IOException {

        List<DietPlan> plans = new ArrayList<>();

        File file = new File(filePath);

        if (!file.exists()) return plans;

        BufferedReader reader = new BufferedReader(new FileReader(file));
        String line;

        while ((line = reader.readLine()) != null) {
            if (line.trim().isEmpty()) continue;
            String[] p = line.split("\\|", -1);
            if (p.length == 7) {
                plans.add(new DietPlan(p[0], p[1], p[2], p[3], p[4], p[5], p[6]));
            }
        }
        reader.close();
        return plans; // return all diet plans
    }



    public void saveAllDietPlans(List<DietPlan> plans) throws IOException {
        File file = new File(filePath);
        file.getParentFile().mkdirs();
        BufferedWriter writer = new BufferedWriter(new FileWriter(file));
        for (DietPlan p : plans) {
            writer.write(p.toFileString());
            writer.newLine();
        }
        writer.close();
    }



    // Read ONE by memberId
    public DietPlan findByMemberId(String memberId) throws IOException {

        for (DietPlan p : getAllDietPlans()) {

            if (p.getMemberId().equals(memberId)) return p; // found it — return this one plan
        }
        return null; // not found
    }




    //CREATE , UPDATE
    public void createOrUpdate(String memberId, String planName, String breakfast,
                               String lunch, String dinner, String snacks,
                               String notes) throws IOException {

        List<DietPlan> plans = getAllDietPlans();

        for (DietPlan p : plans) {
            if (p.getMemberId().equals(memberId)) {

                // member found ----> UPDATE
                p.setPlanName(planName);
                p.setBreakfastItems(breakfast);
                p.setLunchItems(lunch);
                p.setDinnerItems(dinner);
                p.setSnackItems(snacks);
                p.setNotes(notes);

                saveAllDietPlans(plans);  // save updated list to file
                return;
            }
        }


        // Member NOT found ----> CREATE
        plans.add(new DietPlan(memberId, planName, breakfast, lunch, dinner, snacks, notes));
        saveAllDietPlans(plans);
    }



    //DELETE
    public void deleteDietPlan(String memberId) throws IOException {

        List<DietPlan> plans = getAllDietPlans();

        plans.removeIf(p -> p.getMemberId().equals(memberId)); //remove matching one

        saveAllDietPlans(plans);
    }
}