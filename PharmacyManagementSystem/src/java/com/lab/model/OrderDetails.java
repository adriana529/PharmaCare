/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.lab.model;


public class OrderDetails {
    private int detailID;
    private int orderID;
    private int medicineID;
    private int quantity;
    
    public int getDetailID() {
        return detailID;
    }
    public void setDetailID(int detailID) {
        this.detailID = detailID;
    }
    
    public int getOrderID() {
        return orderID;
    }
    public void setOrderID(int orderID) {
        this.orderID = orderID;
    }
    
    public int getMedicineID() {
        return medicineID;
    }
    public void setMedicineID(int medicineID) {
        this.medicineID = medicineID;
    }
    
    public int getQuantity() {
        return quantity;
    }
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
}
