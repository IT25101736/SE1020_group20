package com.gymmanagement.backend.service;



import com.fitnesscenter.model.MemberWorkout;
import com.fitnesscenter.model.WorkoutPlan;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.*;
import java.util.*;

@Service
public class WorkoutService {

    @Value("${workout.file.path}")
    private String filePath;

    // ---- Pre-built Templates ----
    public MemberWorkout getTemplate(String planType) {
        MemberWorkout workout = new MemberWorkout("", planType);

        if (planType.equals("PPL")) {
            workout.addDay(new WorkoutPlan("Monday",    "Push — Chest & Shoulders", "Bench Press 4x8,Incline DB Press 3x10,Cable Flyes 3x15,Shoulder Press 3x10,Lateral Raises 3x15"));
            workout.addDay(new WorkoutPlan("Tuesday",   "Pull — Back & Biceps",     "Deadlift 4x6,Pull Ups 3x10,Bent Over Row 4x8,Face Pulls 3x15,Barbell Curl 3x12"));
            workout.addDay(new WorkoutPlan("Wednesday", "Legs",                      "Squat 4x8,Leg Press 3x12,Romanian Deadlift 3x10,Leg Curl 3x12,Calf Raises 4x15"));
            workout.addDay(new WorkoutPlan("Thursday",  "Push — Chest & Shoulders", "Incline Bench 4x8,DB Shoulder Press 3x10,Tricep Pushdown 3x12,Chest Dips 3x10,Arnold Press 3x10"));
            workout.addDay(new WorkoutPlan("Friday",    "Pull — Back & Biceps",     "Weighted Pull Ups 4x6,Seated Cable Row 3x12,Single Arm DB Row 3x10,Hammer Curl 3x12,Reverse Curl 3x15"));
            workout.addDay(new WorkoutPlan("Saturday",  "Legs",                      "Front Squat 4x8,Walking Lunges 3x12,Leg Extension 3x15,Hip Thrust 4x10,Calf Raises 4x15"));
            workout.addDay(new WorkoutPlan("Sunday",    "Rest",                      "Recovery Day"));

        } else if (planType.equals("Full Body")) {
            workout.addDay(new WorkoutPlan("Monday",    "Full Body A", "Squat 4x8,Bench Press 4x8,Bent Over Row 3x10,Shoulder Press 3x10,Plank 3x60s"));
            workout.addDay(new WorkoutPlan("Tuesday",   "Rest",        "Recovery Day"));
            workout.addDay(new WorkoutPlan("Wednesday", "Full Body B", "Deadlift 4x6,Incline DB Press 3x10,Pull Ups 3x10,Lateral Raises 3x15,Russian Twist 3x20"));
            workout.addDay(new WorkoutPlan("Thursday",  "Rest",        "Recovery Day"));
            workout.addDay(new WorkoutPlan("Friday",    "Full Body C", "Front Squat 3x10,DB Bench Press 3x12,Cable Row 3x12,Arnold Press 3x10,Leg Raises 3x15"));
            workout.addDay(new WorkoutPlan("Saturday",  "Rest",        "Recovery Day"));
            workout.addDay(new WorkoutPlan("Sunday",    "Rest",        "Recovery Day"));

        } else if (planType.equals("Arnold Split")) {
            workout.addDay(new WorkoutPlan("Monday",    "Chest & Back",     "Bench Press 4x8,Pull Ups 4x10,Incline DB Press 3x10,Bent Over Row 3x10,Cable Flyes 3x15"));
            workout.addDay(new WorkoutPlan("Tuesday",   "Shoulders & Arms", "Arnold Press 4x10,Barbell Curl 3x12,Tricep Dips 3x12,Lateral Raises 3x15,Hammer Curl 3x12"));
            workout.addDay(new WorkoutPlan("Wednesday", "Legs",             "Squat 4x8,Leg Press 3x12,Romanian Deadlift 3x10,Leg Curl 3x12,Calf Raises 4x15"));
            workout.addDay(new WorkoutPlan("Thursday",  "Chest & Back",     "Incline Bench 4x8,Weighted Pull Ups 3x8,DB Flyes 3x15,Single Arm Row 3x10,Face Pulls 3x15"));
            workout.addDay(new WorkoutPlan("Friday",    "Shoulders & Arms", "DB Shoulder Press 4x10,Preacher Curl 3x12,Skull Crushers 3x12,Front Raises 3x15,Tricep Pushdown 3x12"));
            workout.addDay(new WorkoutPlan("Saturday",  "Legs",             "Front Squat 4x8,Walking Lunges 3x12,Hip Thrust 4x10,Leg Extension 3x15,Calf Raises 4x15"));
            workout.addDay(new WorkoutPlan("Sunday",    "Rest",             "Recovery Day"));

        } else if (planType.equals("Upper Lower")) {
            workout.addDay(new WorkoutPlan("Monday",    "Upper A", "Bench Press 4x8,Bent Over Row 4x8,Shoulder Press 3x10,Pull Ups 3x10,Tricep Pushdown 3x12"));
            workout.addDay(new WorkoutPlan("Tuesday",   "Lower A", "Squat 4x8,Romanian Deadlift 3x10,Leg Press 3x12,Leg Curl 3x12,Calf Raises 4x15"));
            workout.addDay(new WorkoutPlan("Wednesday", "Rest",    "Recovery Day"));
            workout.addDay(new WorkoutPlan("Thursday",  "Upper B", "Incline DB Press 4x8,Seated Cable Row 4x8,Arnold Press 3x10,Lat Pulldown 3x10,Barbell Curl 3x12"));
            workout.addDay(new WorkoutPlan("Friday",    "Lower B", "Deadlift 4x6,Front Squat 3x10,Hip Thrust 4x10,Walking Lunges 3x12,Calf Raises 4x15"));
            workout.addDay(new WorkoutPlan("Saturday",  "Rest",    "Recovery Day"));
            workout.addDay(new WorkoutPlan("Sunday",    "Rest",    "Recovery Day"));
        }

        return workout;
    }

    // ---- SAVE member workout to file ----
    public void saveMemberWorkout(MemberWorkout workout) throws IOException {
        List<String> lines = new ArrayList<>();
        File file = new File(filePath);
        file.getParentFile().mkdirs();

        // Read existing lines excluding this member
        if (file.exists()) {
            BufferedReader reader = new BufferedReader(new FileReader(file));
            String line;
            boolean skip = false;
            while ((line = reader.readLine()) != null) {
                if (line.startsWith("MEMBER:" + workout.getMemberId())) {
                    skip = true;
                }
                if (skip && line.startsWith("END:" + workout.getMemberId())) {
                    skip = false;
                    continue;
                }
                if (!skip) lines.add(line);
            }
            reader.close();
        }

        // Add new workout block
        lines.add("MEMBER:" + workout.getMemberId());
        lines.add("PLAN:" + workout.getPlanType());
        for (WorkoutPlan day : workout.getDays()) {
            lines.add("DAY:" + day.toFileString());
        }
        lines.add("END:" + workout.getMemberId());

        // Write back
        BufferedWriter writer = new BufferedWriter(new FileWriter(file));
        for (String l : lines) {
            writer.write(l);
            writer.newLine();
        }
        writer.close();
    }

    // ---- GET member workout from file ----
    public MemberWorkout getMemberWorkout(String memberId) throws IOException {
        File file = new File(filePath);
        if (!file.exists()) return null;

        BufferedReader reader = new BufferedReader(new FileReader(file));
        String line;
        MemberWorkout workout = null;
        boolean reading = false;

        while ((line = reader.readLine()) != null) {
            if (line.equals("MEMBER:" + memberId)) {
                reading = true;
                workout = new MemberWorkout(memberId, "");
            } else if (reading && line.startsWith("PLAN:")) {
                workout.setPlanType(line.substring(5));
            } else if (reading && line.startsWith("DAY:")) {
                String[] parts = line.substring(4).split("\\|", 3);
                if (parts.length == 3) {
                    workout.addDay(new WorkoutPlan(parts[0], parts[1], parts[2]));
                }
            } else if (line.equals("END:" + memberId)) {
                reading = false;
                break;
            }
        }
        reader.close();
        return workout;
    }

    // ---- DELETE member workout ----
    public void deleteMemberWorkout(String memberId) throws IOException {
        File file = new File(filePath);
        if (!file.exists()) return;

        List<String> lines = new ArrayList<>();
        BufferedReader reader = new BufferedReader(new FileReader(file));
        String line;
        boolean skip = false;

        while ((line = reader.readLine()) != null) {
            if (line.equals("MEMBER:" + memberId)) { skip = true; }
            if (!skip) lines.add(line);
            if (line.equals("END:" + memberId)) { skip = false; }
        }
        reader.close();

        BufferedWriter writer = new BufferedWriter(new FileWriter(file));
        for (String l : lines) {
            writer.write(l);
            writer.newLine();
        }
        writer.close();
    }
}