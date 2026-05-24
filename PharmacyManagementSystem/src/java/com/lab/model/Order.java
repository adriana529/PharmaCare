/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.lab.model;

import java.util.Date;

public class Order {
    private int orderID;
    private Date orderDate;
    private String status;
    private int supplierID;
    
    public int getOrderID() {
        return orderID;
    }
    public void setOrderID(int orderID) {
        this.orderID = orderID;
    }
    
    public Date getOrderDate() {
        return orderDate;
    }
    public void setOrderDate(Date orderDate) {
        this.orderDate = orderDate;
    } 
    
    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }
    
    public int getSupplierID() {
        return supplierID;
    }
    public void setSupplierID(int supplierID) {
        this.supplierID = supplierID;
    }
}
