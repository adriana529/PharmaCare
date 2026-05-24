package com.lab.model;

public class Medicine {

    private int id;
    private String name;
    private double unitPrice;       // Must match getUnitPrice()
    private int stockQuantity;      // Must match getStockQuantity()
    private int reorderLevel;

    // Constructor
    public Medicine(int id, String name, int stockQuantity, double unitPrice, int reorderLevel) {
        this.id = id;
        this.name = name;
        this.reorderLevel = reorderLevel;
        this.unitPrice = unitPrice;
        this.stockQuantity = stockQuantity;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    // This method fixes the line 227 error
    public double getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
    }

    // This method fixes the line 228 error
    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }
    
    public int getReorderLevel() { 
        return reorderLevel; 
    }
    public void setReorderLevel(int reorderLevel) { 
        this.reorderLevel = reorderLevel; 
    }
}
