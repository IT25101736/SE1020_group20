package com.gymmanagement.backend.controller;

import com.gymmanagement.backend.model.RenewalRequest;
import com.gymmanagement.backend.service.RenewalService;

import java.io.IOException;
import java.util.List;


public class RenewalController {

    private RenewalService service;

    // CREATE
    public String addRequest(RenewalRequest request) throws IOException {
        service.addRequest(request);
        return "Renewal request added ";

    }
    // READ
    public List<RenewalRequest> getAllRequests() throws IOException {
        return service.getAllRequests();
    }
    // UPDATE
    public RenewalRequest processRequest() throws IOException {
        return service.processNextRequest();
    }
    // DELETE
    public String deleteProcessed() throws IOException{
        service.deleteProcessedRequests();
        return "Processed requests deleted";
    }
}