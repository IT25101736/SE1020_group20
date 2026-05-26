package com.fitnesscenter.model;

public class Payment {

    private String paymentId;
    private String memberId;
    private String memberName;
    private String plan;
    private String amount;
    private String paymentMethod;
    private String paymentDate;
    private String status;

    public Payment(String paymentId, String memberId, String memberName,
                   String plan, String amount, String paymentMethod,
                   String paymentDate, String status) {
        this.paymentId     = paymentId;
        this.memberId      = memberId;
        this.memberName    = memberName;
        this.plan          = plan;
        this.amount        = amount;
        this.paymentMethod = paymentMethod;
        this.paymentDate   = paymentDate;
        this.status        = status;
    }

    public String getPaymentId()     { return paymentId; }
    public String getMemberId()      { return memberId; }
    public String getMemberName()    { return memberName; }
    public String getPlan()          { return plan; }
    public String getAmount()        { return amount; }
    public String getPaymentMethod() { return paymentMethod; }
    public String getPaymentDate()   { return paymentDate; }
    public String getStatus()        { return status; }

    public void setStatus(String status)        { this.status = status; }
    public void setAmount(String amount)        { this.amount = amount; }
    public void setPaymentMethod(String method) { this.paymentMethod = method; }

    public String toFileString() {
        return paymentId + "|" + memberId + "|" + memberName + "|" +
                plan + "|" + amount + "|" + paymentMethod + "|" +
                paymentDate + "|" + status;
    }
}