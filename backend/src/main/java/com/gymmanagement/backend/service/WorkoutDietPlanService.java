package com.gymmanagement.backend.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.gymmanagement.backend.model.WorkoutDietPlan;
import org.springframework.stereotype.Service;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;




@Service
public class WorkoutDietPlanService {

    private static final String FILE_PATH =
            "src/main/resources/data/workout-diet-plans.json";

    private final ObjectMapper objectMapper = new ObjectMapper();




    private List<WorkoutDietPlan> readFromFile(){

        try {

            File file = new File(FILE_PATH);

            if (!file.exists() || file.length() == 0 ) {
                return new ArrayList<>();
            }

            return objectMapper.readValue(
                    file,
                    new TypeReference<List<WorkoutDietPlan>>() {}
            );
        } catch (IOException e){
            System.out.println(" Error reading workout-diet-plans.json : " + e.getMessage());
            return new ArrayList<>();
        }

    }

    private void writeToFile(List<WorkoutDietPlan> plans){

        try {
            objectMapper.writerWithDefaultPrettyPrinter()
                    .writeValue(new File(FILE_PATH),plans);

        }catch (IOException e){
            System.out.println("Error writing workout-diet-plans.json : " + e.getMessage());
    }

    }



    //ID GENERATION

    //Auto generate next ID (max existing ID + 1)
    private int generateNextId(List<WorkoutDietPlan> plans){

        return plans.stream()
                .mapToInt(WorkoutDietPlan::getPlanID)
                .max()
                .orElse(0)+1;

    }


    private String validate(WorkoutDietPlan plan){

        if (plan.getWorkoutType() == null || plan.getWorkoutType().trim().isEmpty()){
            return "Workout type is required. ";
        }

        if(plan.getDietType() == null || plan.getDietType().trim().isEmpty() ){
            return "Diet type is required. ";
        }

        if(plan.getDescription() == null || plan.getDescription().trim().isEmpty()){
            return "Description is required. ";
        }

        if (plan.getAssignedMemberId() <= 0 ){
            return "Assigned member ID must be a positive number. ";
        }

        return null;  //no error = valid
    }



   //GET ALL
    public List<WorkoutDietPlan> getAllPlans(){
        return readFromFile();
    }


    //GET BY ID
    public WorkoutDietPlan getPlanById(int planId){

        return readFromFile().stream()
                .filter(p -> p.getPlanID() == planId)
                .findFirst()
                .orElse(null);

    }



    //ADD (create)
    //Return the saved plan, or throws IllegalArgumentException if invalid
    public WorkoutDietPlan addPlan(WorkoutDietPlan plan){
        String error =  validate(plan);

        if ( error != null ){
            throw new IllegalArgumentException(error);

        }

        List<WorkoutDietPlan> plans = readFromFile();
        plan.setPlanID(generateNextId(plans));
        plans.add(plan);
        writeToFile(plans);
        return plan;

    }


    //UPDATE
    //Returns updated plan, null if not found throws if invalid
    public WorkoutDietPlan updatePlan(int planId, WorkoutDietPlan updatedPlan) {
        String error = validate(updatedPlan);

        if( error != null){
            throw new IllegalArgumentException(error);
        }

        List<WorkoutDietPlan> plans = readFromFile();

        for (int i = 0; i < plans.size(); i++) {
            if (plans.get(i).getPlanID() == planId){
                updatedPlan.setPlanID(planId);  //keep original ID
                plans.set(i, updatedPlan);
                writeToFile(plans);
                return updatedPlan;

            }
        }

        return null;
    }




    //DELETE
    //Returns true if deleted, false if not found
    public boolean deletePlan(int planId){
        List<WorkoutDietPlan> plans = readFromFile();
        boolean removed =plans.removeIf(p -> p.getPlanId() == planId);

        if(removed){
            writeToFile(plans);

        }
        return removed;

    }

}
