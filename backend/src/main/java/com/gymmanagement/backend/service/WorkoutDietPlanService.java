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

            )
        }

        }
    }




}
