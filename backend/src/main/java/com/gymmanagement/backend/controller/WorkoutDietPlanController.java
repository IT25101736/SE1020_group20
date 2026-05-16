//package com.gymmanagement.backend.controller;
//
//import com.gymmanagement.backend.model.WorkoutDietPlan;
//import com.gymmanagement.backend.service.WorkoutDietPlanService;
//import org.springframework.http.HttpStatus;
//import org.springframework.http.ResponseEntity;
//import org.springframework.web.bind.annotation.*;
//
//import java.util.List;
//
//@RestController
//@RequestMapping("/api/workout-diet-plans")
//@CrossOrigin(origins = "*")
//public class WorkoutDietPlanController {
//
//    private final WorkoutDietPlanService service;
//
//    public WorkoutDietPlanController(WorkoutDietPlanService service) {
//        this.service = service;
//    }
//
//    // Get all plans
//    @GetMapping
//    public ResponseEntity<List<WorkoutDietPlan>> getAllPlans() {
//
//        return ResponseEntity.ok(service.getAllPlans());
//    }
//
//    // Get plan by ID
//    @GetMapping("/{id}")
//    public ResponseEntity<?> getPlanById(@PathVariable int id) {
//
//        WorkoutDietPlan plan = service.getPlanById(id);
//
//        if (plan == null) {
//
//            return ResponseEntity.status(HttpStatus.NOT_FOUND)
//                    .body("Plan not found with ID: " + id);
//        }
//
//        return ResponseEntity.ok(plan);
//    }
//
//    // Add new plan
//    @PostMapping
//    public ResponseEntity<?> addPlan(
//            @RequestBody WorkoutDietPlan plan) {
//
//        try {
//
//            WorkoutDietPlan saved =
//                    service.addPlan(plan);
//
//            return ResponseEntity.status(HttpStatus.CREATED)
//                    .body(saved);
//
//        } catch (IllegalArgumentException e) {
//
//            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
//                    .body(e.getMessage());
//        }
//    }
//
//    // Update plan
//    @PutMapping("/{id}")
//    public ResponseEntity<?> updatePlan(
//            @PathVariable int id,
//            @RequestBody WorkoutDietPlan updatedPlan) {
//
//        try {
//
//            WorkoutDietPlan result =
//                    service.updatePlan(id, updatedPlan);
//
//            if (result == null) {
//
//                return ResponseEntity.status(HttpStatus.NOT_FOUND)
//                        .body("Plan not found with ID: " + id);
//            }
//
//            return ResponseEntity.ok(result);
//
//        } catch (IllegalArgumentException e) {
//
//            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
//                    .body(e.getMessage());
//        }
//    }
//
//    // Delete plan
//    @DeleteMapping("/{id}")
//    public ResponseEntity<?> deletePlan(
//            @PathVariable int id) {
//
//        boolean deleted =
//                service.deletePlan(id);
//
//        if (!deleted) {
//
//            return ResponseEntity.status(HttpStatus.NOT_FOUND)
//                    .body("Plan not found with ID: " + id);
//        }
//
//        return ResponseEntity.ok("Deleted successfully");
//    }
//}