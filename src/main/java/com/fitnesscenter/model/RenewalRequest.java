package com.fitnesscenter.model;

public class RenewalRequest {

    private String requestId;
    private String memberId;
    private String memberName;
    private String currentPlan;
    private String requestedPlan;
    private String requestDate;
    private String status; // PENDING, PROCESSED

    public RenewalRequest(String requestId, String memberId, String memberName,
                          String currentPlan, String requestedPlan,
                          String requestDate, String status) {
        this.requestId     = requestId;
        this.memberId      = memberId;
        this.memberName    = memberName;
        this.currentPlan   = currentPlan;
        this.requestedPlan = requestedPlan;
        this.requestDate   = requestDate;
        this.status        = status;
    }

    public String getRequestId()     { return requestId; }
    public String getMemberId()      { return memberId; }
    public String getMemberName()    { return memberName; }
    public String getCurrentPlan()   { return currentPlan; }
    public String getRequestedPlan() { return requestedPlan; }
    public String getRequestDate()   { return requestDate; }
    public String getStatus()        { return status; }
    public void setStatus(String status) { this.status = status; }

    public String toFileString() {
        return requestId + "|" + memberId + "|" + memberName + "|" +
                currentPlan + "|" + requestedPlan + "|" + requestDate + "|" + status;
    }
}