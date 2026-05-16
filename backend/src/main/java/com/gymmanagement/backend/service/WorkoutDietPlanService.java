/*package com.gymmanagement.backend.service;

import com.gymmanagement.backend.model.WorkoutDietPlan;
import com.sun.jdi.PrimitiveValue;
import org.springframework.Service;
import org.springframework.stereotype.Service;

import java.io.*;
import java.io.BufferedWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.PropertyResourceBundle;

@Service
public class WorkoutDietPlanService {

    private static final String FILE_PATH=  "workout-diet-plans.txt";


    //READ FROM TXT FILE

    private List<WorkoutDietPlan> readFromFile(){

         List<WorkoutDietPlan> plans = new ArrayList<>();

         try {
             File file = new File(FILE_PATH);

             if(!file.exists()){
                 return plans;
             }

             BufferedReader reader = new BufferedReader(new FileReader(FILE_PATH));

             String line;

             while ( (line = reader.readLine()) != null){

                 //Skip empty lines
                 if(line.trim().isEmpty())continue;

                 String[] data = line.split(",");

                 WorkoutDietPlan plan = new WorkoutDietPlan(
                         Integer.parseInt(data[0].trim()),
                         data[1].trim(),
                         data[2].trim(),
                         data[3].trim(),
                         Integer.parseInt(data[4].trim())
                 );

                 plans.add(plan);
             }

             reader.close();

         } catch (IOException e){
             System.out.println("Error reading file: " + e.getMessage());
         }

         return plans;
    }

    //WRITE TO TXT FILE

    Private void writeToFile(List<WorkoutDietPlan> plans){

        try {
            BufferedWriter writer = new BufferedWriter(new FileWriter(FILE_PATH)); //METHN IDAN

            for (WorkoutDietPlan plan : plans) {

                writer.write(
                        plan.getPlanID() + "," +
                                plan.getWorkoutType() + "," +
                                plan.getDietType() + "," +
                                plan.getDescription() + "," +
                                plan.getAssignedMemberId()
                );

                writer.newLine();
            }

            writer.close();

        } catch (IOException e) {
            System.out.println("Error writing file: " + e.getMessage());
        }
    }

    // ─────────────────────────────────────────────
    // ID GENERATION
    // ─────────────────────────────────────────────
    private int generateNextId(List<WorkoutDietPlan> plans) {
        return plans.stream()
                .mapToInt(WorkoutDietPlan::getPlanID)
                .max()
                .orElse(0) + 1;
    }

    // ─────────────────────────────────────────────
    // VALIDATION
    // ─────────────────────────────────────────────
    private String validate(WorkoutDietPlan plan) {
        if (plan.getWorkoutType() == null ||
                plan.getWorkoutType().trim().isEmpty()) {
            return "Workout type is required.";
        }

        if (plan.getDietType() == null ||
                plan.getDietType().trim().isEmpty()) {
            return "Diet type is required.";
        }

        if (plan.getDescription() == null ||
                plan.getDescription().trim().isEmpty()) {
            return "Description is required.";
        }

        if (plan.getAssignedMemberId() <= 0) {
            return "Assigned member ID must be positive.";
        }

        return null;
    }
    }



 */


