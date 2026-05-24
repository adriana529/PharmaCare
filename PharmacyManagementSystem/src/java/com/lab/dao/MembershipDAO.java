
package com.lab.dao;

import com.lab.model.Membership;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MembershipDAO {
    private String jdbcURL = "jdbc:mysql://localhost:3307/pharmacydata";
    private String jdbcUsername = "root";
    private String jdbcPassword = "";

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
    
    //1. new member registration
    public boolean registerMember(Membership member) {
        boolean isSuccess = false;
        String sql = "INSERT INTO memberships (fullName, icNumber, phone, email, status, expiryDate) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, member.getFullName());
            ps.setString(2, member.getIcNum());
            ps.setString(3, member.getPhone());
            ps.setString(4, member.getEmail());
            ps.setString(5, member.getStatus());
            ps.setDate(6, new java.sql.Date(member.getExpiryDate().getTime()));
            
            int rows = ps.executeUpdate();
            isSuccess = (rows > 0);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return isSuccess;
    }
    
    //2. take all member list
    public List<Membership> getAllMembers() {
        List<Membership> list = new ArrayList<>();
        String sql = "SELECT * FROM memberships ORDER BY memberID DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Membership m = new Membership();
                m.setMemberID(rs.getInt("memberID"));
                m.setFullName(rs.getString("fullName"));
                m.setIcNum(rs.getString("icNumber"));
                m.setPhone(rs.getString("phone"));
                m.setEmail(rs.getString("email"));
                m.setStatus(rs.getString("status"));
                m.setExpiryDate(rs.getDate("expiryDate"));
                list.add(m);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    //3. search membership using IC
    public List<Membership> searchMemberByIC(String icSearch) {
        List<Membership> list = new ArrayList<>();
        String sql = "SELECT * FROM memberships WHERE icNumber LIKE ? ORDER BY memberID DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, "%" + icSearch + "%");
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Membership m = new Membership();
                m.setMemberID(rs.getInt("memberID"));
                m.setFullName(rs.getString("fullName"));
                m.setIcNum(rs.getString("icNumber"));
                m.setPhone(rs.getString("phone"));
                m.setEmail(rs.getString("email"));
                m.setStatus(rs.getString("status"));
                m.setExpiryDate(rs.getDate("expiryDate"));
                list.add(m);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    //4. update membership status
    public boolean updateMemberStatus(int id, String status) {
        boolean isSuccess = false;
        String sql = "UPDATE memberships SET status = ? WHERE memberID = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setInt(2, id);
            
            int rows = ps.executeUpdate();
            isSuccess = (rows > 0);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return isSuccess;
    }
    
    //5. calculate total membership status = 'active'
    public int getActiveMembersCount() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM memberships WHERE status = 'Active'";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }
}

