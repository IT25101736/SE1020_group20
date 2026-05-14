package com.gymmanagement.backend.service;

import com.gymmanagement.backend.model.RenewalRequest;

import java.io.*;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Queue;

public class RenewalService {

    Queue <RenewalRequest> queue = new LinkedList<>();

    private final String FILE_PATH = "renewals.txt";
    // CREATE
    public void addRequest(RenewalRequest request) throws IOException{

        BufferedWriter writer = new BufferedWriter(new FileWriter(FILE_PATH,true));

        writer.write(
                request.getRenewalId() + "," +
                    request.getMemberId() +","+
                    request.getRequestDate() +","+
                    request.getStatus()
        );
        writer.newLine();
        writer.close();
    }
    //READ
    public List<RenewalRequest> getAllRequests() throws IOException{
       List<RenewalRequest> list = new ArrayList<>();

       File file = new File(FILE_PATH);
       if (!file.exists()) return list;

       BufferedReader reader = new BufferedReader(new FileReader(file));
       String line;

       while ((line = reader.readLine()) !=null) {

           String[] data = line.split(",");

           RenewalRequest r = new RenewalRequest(
                   data[0],
                   data[1],
                   data[2],
                   data[3]
           );
           list.add(r);
       }
       reader.close();
       return list;
    }
    //UPDATE
    public RenewalRequest processNextRequest() throws IOException {

        List<RenewalRequest> list = getAllRequests();

        for(RenewalRequest r : list){
            if (r.getStatus().equals("PENDING")) {
                r.setStatus("PROCESSED");
                updateFile(list);
                return r;
            }
        }
        return null;

    }
    // DELETE (remove processed)
    public void deleteProcessedRequests() throws IOException {

        List<RenewalRequest> list = getAllRequests();

        BufferedWriter writer = new BufferedWriter (new FileWriter(FILE_PATH));

        for (RenewalRequest r : list) {
            if (!r.getStatus().equals("PROCESSED")){

                writer.write(
                       r.getRenewalId()+ "," +
                       r.getMemberId()+ "," +
                       r.getRequestDate()+ "," +
                       r.getStatus()
                );

                writer.newLine();
            }
        }

        writer.close();
    }
    // Helper method
    private void updateFile(List<RenewalRequest> list) throws IOException {

        BufferedWriter writer =  new BufferedWriter(new FileWriter(FILE_PATH));

        for (RenewalRequest r : list) {

            writer.write(
                    r.getRenewalId()+ "," +
                        r.getMemberId()+ "," +
                        r.getRequestDate()+ "," +
                        r.getStatus()
            );
            writer.newLine();
        }
        writer.close();
    }
}