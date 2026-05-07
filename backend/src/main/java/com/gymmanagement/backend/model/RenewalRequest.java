package com.gymmanagement.backend.model;

public class RenewalRequest {

    private String renewalId;
    private String memberId;
    private String requestDate;
    private String status;

    public RenewalRequest() {
    }
    public RenewalRequest(String renewalId,String memberId,String requestDate,String status) {
        this.renewalId = renewalId;
        this.memberId = memberId;
        this.requestDate = requestDate;
        this.status = status; // PENDING / PROCESSED
    }
    public String getRenewalId(){
        return renewalId;
    }
    public void setRenewalId(String renewalId){
        this.renewalId = renewalId;
    }
    public  String getMemberId(){
        return memberId;
    }

    public void setMemberId(String memberId) {
        this.memberId = memberId;
    }

    public String getRequestDate() {
        return requestDate;
    }

    public void setRequestDate(String requestDate) {
        this.requestDate = requestDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}