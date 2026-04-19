package com.gymmanagement.backend.service;

import com.gymmanagement.backend.model.member;
import org.springframework.stereotype.Service;


import  java.io.*;
import java.util.ArrayList;
import java.util.List;

@Service
public class MemberService {

    private final String FILE_PATH = "member.txt";

    //create

    public void addMember(member member) throws IOException {
        BufferedWriter writer = new BufferedWriter(new FileWriter(FILE_PATH, true));

        writer.write(member.getMemberId() + "," +
                member.getName() + "," +
                member.getEmail() + "," +
                member.getPassword() + "," +
                member.getWeight()+","+
                member.getHeight()+","+
                member.getRole());

        writer.newLine();
        writer.close();
    }

    //Read

    public List<member> getAllMembers() throws IOException {
        List<member> list = new ArrayList<>();

        File file = new File(FILE_PATH);
        if (!file.exists()) return list;

        BufferedReader reader = new BufferedReader(new FileReader(file));
        String line;

        while ((line = reader.readLine()) != null) {
            String[] data = line.split(",");

            member m = new member(data[0], data[1], data[2], data[3], data[4]);

            list.add(m);

        }

        reader.close();
        return list;
    }

    //Search

    public member findById(String Id) throws IOException {
        List<member> list = getAllMembers();

        for (member m : list) {
            if (m.getMemberId().equals(Id)) {
                return m;
            }
        }
        return null;
    }

    //Update

    public void updateMember(member updatedMember,String currentUserId,String role)throws IOException{
        List<member>list=getAllMembers();

        BufferedWriter writer=new BufferedWriter(new FileWriter("member.txt"));


        for (member m: list){
            if (role.equals("ADMIN")|| m.getMemberId().equals(currentUserId)) {

                if (m.getMemberId().equals(updatedMember.getMemberId())) {
                    writer.write(updatedMember.getMemberId() + "," +
                            updatedMember.getName() + "," +
                            updatedMember.getEmail() + "," +
                            updatedMember.getEmail() + "," +
                            updatedMember.getPassword() + "," +
                            updatedMember.getWeight() + "," +
                            updatedMember.getHeight() + "," +
                            updatedMember.getRole());
                } else {
                    throw new RuntimeException(("Access denied!"));
                }
            }else{

                writer.write(m.getMemberId()+","+
                        m.getName()+","+
                        m.getEmail()+","+
                        m.getPassword()+","+
                        m.getWeight()+","+
                        m.getHeight()+","+
                        m.getRole());

            }
            writer.newLine();
        }
        writer.close();
    }

    //Delete

    public void deleteMember(String Id,String currentUserId,String role)throws IOException{
        List<member>list=getAllMembers();

        BufferedWriter writer=new BufferedWriter(new FileWriter("member.txt"));

        for (member m:list){
            //role check
            if (m.getMemberId().equals(Id)) {
                if (role.equals("ADMIN") || Id.equals(currentUserId)) {
                    continue;//delete
                } else {
                    throw new RuntimeException("Access denied!");
                }
            }
            writer.write(m.getMemberId()+","+
                    m.getName()+","+
                    m.getEmail()+","+
                    m.getPassword()+","+
                    m.getWeight()+","+
                    m.getHeight()+","+
                    m.getRole());
            writer.newLine();
        }
        writer.close();
    }
}
