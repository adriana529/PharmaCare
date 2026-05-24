/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.lab.model;

/**
 *
 * @author sazliosman
 */

public class Member {
    private String memberId; 
    private String memberName; 
    private String icNumber;
    private String status; 
    private String memberSince; 
    private int points;
    
    //constructor 
    public Member() {}
    
    //getters and setters 
    public String getMemberId() {
        return memberId; 
    }
    
    public void setMemberId(String memberId) {
        this.memberId= memberId;
    }
    
    public String getMemberName() {
        return memberName;
    }
    
    public void setMemberName(String memberName) {
        this.memberName = memberName; 
    }
    
    public String getIcNumber() {
        return icNumber;
    }
    
    public void setIcNumber(String icNumber) {
        this.icNumber = icNumber;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public String getMemberSince() {
        return memberSince;
    }
    
    public void setMemberSince(String memberSince) {
        this.memberSince = memberSince;
    }
    
    public int getPoints() {
        return points;
    }
    
    public void setPoints(int points) {
        this.points = points;
    }
}
