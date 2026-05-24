package com.lab.dao;

import com.lab.model.Medicine;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MedicineDAO {
    
  
    private String jdbcURL = "jdbc:mysql://localhost:3307/pharmacydata";
    private String jdbcUsername = "root";
    private String jdbcPassword = "";

    // Method sambung Database
    protected Connection getConnection() {
        Connection connection = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return connection;
    }

    //1. check duplicate
    public boolean isDuplicate(String name) {
        boolean exists = false;
        String sql = "SELECT name FROM medicines WHERE name = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setString(1, name);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    exists = true; // nama jumpa in the database
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return exists;
    }

    //2. tambah medicine dekat database 
    public boolean addMedicine(String name, int quantity, double price, int reorderLevel) {
        boolean isSuccess = false;
        String sql = "INSERT INTO medicines (name, stock_quantity, unit_price, reorder_level) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setString(1, name);
            ps.setInt(2, quantity);
            ps.setDouble(3, price);
            ps.setInt(4, reorderLevel);
            
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                isSuccess = true; // Insert was successful
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return isSuccess;
    }

    //3. dpt information medicine - pergi ke jsp table 
    public List<Medicine> getAllMedicines() {
        List<Medicine> medicineList = new ArrayList<>();
        String sql = "SELECT * FROM medicines ORDER BY id DESC"; // Orders newest first
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
             
            while (rs.next()) {
                
                // Extract data from the database row
                int id = rs.getInt("id");
                String name = rs.getString("name");
                int reorderLevel = rs.getInt("reorder_level");
                double price = rs.getDouble("unit_price");
                int quantity = rs.getInt("stock_quantity");
                
                // Create a new Medicine object and add it to the list
                Medicine med = new Medicine(id, name, quantity, price, reorderLevel);
                medicineList.add(med);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return medicineList;
    }

    public boolean updateStock(int id, int addedQty) {
        String sql = "UPDATE medicines SET stock_quantity = stock_quantity + ? WHERE id = ?";
        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, addedQty);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { 
            return false; 
        }
    }

    public Medicine getMedicineById(int medId) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
}
