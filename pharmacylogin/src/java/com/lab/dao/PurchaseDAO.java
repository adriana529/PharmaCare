package com.lab.dao;

import com.lab.model.Member;
import com.lab.model.Purchase;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PurchaseDAO {
    private String url = "jdbc:mysql://localhost:3307/pharmacydata";
    private String user = "root";
    private String pass = ""; // Add your password here if you have one

    private Connection getConnection() throws SQLException, ClassNotFoundException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(url, user, pass);
    }

    public Member findMemberByPartialIC(String query) {
        Member member = null;
        String sql = "SELECT * FROM memberships WHERE icNumber LIKE ? OR icNumber LIKE ?";
        
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, "%" + query);
            ps.setString(2, query + "%");
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    member = new Member();
                    member.setMemberId(rs.getString("memberId"));
                    member.setMemberName(rs.getString("fullName"));
                    member.setIcNumber(rs.getString("icNumber"));
                    member.setPoints(0); // Safely hardcode 0 for now
                    member.setStatus(rs.getString("status")); 
                    member.setMemberSince(rs.getString("expiryDate"));
                }
            }
        } catch (Exception e) {
            System.out.println("DAO Error mapping member profile data: " + e.getMessage());
            e.printStackTrace();
        }
        return member;
    }
        
    public boolean saleProcess(String icNumber, int medId, int qty, double unitPrice) {
        Connection con = null; 
        try {
            con = getConnection();
            con.setAutoCommit(false); // Begin ACID Transaction

            String lastFour = icNumber.length() > 4 ? icNumber.substring(icNumber.length() - 4) : icNumber;
            Member m = findMemberByPartialIC(lastFour);
            
            int currentPoints = (m != null) ? m.getPoints() : 0;
            double subtotal = qty * unitPrice; 
            double finalPrice = subtotal; 
            int pointsEarned = (int) (subtotal / 10); 

            if (m != null && currentPoints >= 10) {
                finalPrice = subtotal * 0.90; // Apply 10% discount
                currentPoints -= 10; 
            }

            // A. Insert into Purchases table
            // NOTE: You may need to update these column names in the future if this insert fails!
            String insPurchase = "INSERT INTO purchases (icNumber, medicine_id, qty, totalPrice, points_earned) VALUES(?, ?, ?, ?, ?)";
            try (PreparedStatement ps = con.prepareStatement(insPurchase)) {
                ps.setString(1, icNumber);
                ps.setInt(2, medId);
                ps.setInt(3, qty);
                ps.setDouble(4, finalPrice);
                ps.setInt(5, pointsEarned);
                ps.executeUpdate();
            }

            // C. Reduce Medicine Stock Level
            String updStock = "UPDATE medicines SET stock_quantity = stock_quantity - ? WHERE id = ?"; 
            try (PreparedStatement ps = con.prepareStatement(updStock)) {
                ps.setInt(1, qty);
                ps.setInt(2, medId);
                ps.executeUpdate();
            }

            con.commit(); 
            return true;
        } catch (Exception e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            System.out.println("Transaction failed in saleProcess: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Fixed: Search History by Partial IC
    public List<Purchase> getHistoryByPartialIC(String searchInput) {
        List<Purchase> history = new ArrayList<>();
        String sql = "SELECT * FROM purchases WHERE RIGHT(icNumber, 4) = ? " +
                     "AND purchaseDate >= DATE_SUB(NOW(), INTERVAL 1 YEAR) ORDER BY purchaseDate DESC";
        
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, searchInput);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Purchase p = new Purchase();
                    p.setOrderId(rs.getString("orderId")); // Fixed to match DB
                    p.setIcNumber(rs.getString("icNumber"));
                    p.setPurchaseDate(rs.getString("purchaseDate")); 
                    p.setItems(rs.getString("items")); // Fixed to match DB
                    p.setAmount(rs.getDouble("amount")); // Fixed to match DB
                    p.setStatus(rs.getString("status")); // Fixed to match DB
                    history.add(p);
                }
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return history;
    }

    // Fixed: Get all history when there is no search query
    public List<Purchase> getAllHistory() {
        List<Purchase> history = new ArrayList<>();
        String sql = "SELECT * FROM purchases ORDER BY purchaseDate DESC";
        
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Purchase p = new Purchase();
                p.setOrderId(rs.getString("orderId")); // Fixed to match DB
                p.setIcNumber(rs.getString("icNumber")); 
                p.setPurchaseDate(rs.getString("purchaseDate")); 
                p.setItems(rs.getString("items")); // Fixed to match DB
                p.setAmount(rs.getDouble("amount")); // Fixed to match DB
                p.setStatus(rs.getString("status")); // Fixed to match DB
                history.add(p);
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return history;
    }
}