package com.gymmanagement.backend.controller;

import com.gymmanagement.backend.model.member;
import com.gymmanagement.backend.service.MemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import  java.io.IOException;
import java.util.List;

@RestController
@RequestMapping("/members")
public class MemberController {

    @Autowired
    private MemberService service;

    //Create
    @PostMapping("/add")
    public String addMember(member member)throws IOException{
        service.addMember(member);
        return "Member added successfully";

    }

    //Read
    @GetMapping("/all")
    public List<member> getAllMembers() throws IOException{
        return service.getAllMembers();
    }

    //Search
    @GetMapping("/{id}")
    public member getMember(@PathVariable String id)throws  IOException{
        return service.findById(id);
    }

    //Update
    @PutMapping("/update")
    public String updateMember(member member, @RequestParam String currentUserId, @RequestParam String role)throws IOException{
        service.updateMember(member,currentUserId,role);
        return "updated successfully";
    }

    //Delete
    @DeleteMapping("/{id}")
    public String deleteMember(@PathVariable String id,@RequestParam String currentUserId,@RequestParam String role)throws IOException{
        service.deleteMember(id,currentUserId,role);
        return "Deleted successfully";
    }
}
