
package com.lab.model;

import java.util.Date;

public class Membership {
    private int memberID;
    private String fullName;
    private String icNum;
    private String phone;
    private String email;
    private String status;
    private Date expiryDate;
    
    //constructor
    public Membership() {}
    
    //getter and setter
    public int getMemberID() {
        return memberID;
    }
    public void setMemberID(int memberID) {
        this.memberID = memberID;
    }
    
    public String getFullName() { 
        return fullName; 
    }
    public void setFullName(String fullName) { 
        this.fullName = fullName; 
    }

    public String getIcNum() { 
        return icNum; 
    }
    public void setIcNum(String icNum) { 
        this.icNum = icNum; 
    }

    public String getPhone() { 
        return phone; 
    }
    public void setPhone(String phone) { 
        this.phone = phone; 
    }

    public String getEmail() { 
        return email; 
    }
    public void setEmail(String email) { 
        this.email = email; 
    }

    public String getStatus() { 
        return status; 
    }
    public void setStatus(String status) { 
        this.status = status; 
    }

    public Date getExpiryDate() { 
        return expiryDate; 
    }
    public void setExpiryDate(Date expiryDate) { 
        this.expiryDate = expiryDate; 
    }
}
