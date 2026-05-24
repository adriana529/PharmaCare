package com.lab.dao;

import com.lab.model.theusersDAO;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class pharmacyUserDAO {
    private String jdbcURL = "jdbc:mysql://localhost:3307/pharmacydata";
    private String jdbcUsername = "root";
    private String jdbcPassword = "";
    
    protected Connection getConnection() {
        Connection connection = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(jdbcURL,jdbcUsername, jdbcPassword);
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return connection;
    }
    
    // 1. register - insert new user
    public boolean registerUser(theusersDAO user) {
        boolean isSuccess = false; 
        try (Connection connection = getConnection();
                PreparedStatement ps = connection.prepareStatement("Insert into users(fullName, username, password, email) VALUES (?, ?, ?, ?)")){
            
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getUsername()); 
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getEmail());
            
            int rowsAffected = ps.executeUpdate();
            isSuccess = (rowsAffected > 0); 
            
        } catch (SQLException e){
            e.printStackTrace();
        }
        return isSuccess; 
    }
    
    // 2. method - validate login
    public boolean validateLogin(String username, String password) {
        boolean isValid = false; 
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM users WHERE username = ? AND password = ? ")) {
            
            ps.setString(1, username);
            ps.setString(2, password);
            
            ResultSet rs = ps.executeQuery();
            if(rs.next()) {
                isValid = true; 
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return isValid;
    }
    
    // 3. method - get a single user by username (Fixed syntax errors here!)
    public theusersDAO getUserByUsername(String username){
        theusersDAO user = null; 
        
        try (Connection connection = getConnection(); 
             PreparedStatement ps = connection.prepareStatement("SELECT * FROM users WHERE username = ?")) { 
            
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery(); 
            
            // Added the missing if-statement and object creation
            if (rs.next()) {
                user = new theusersDAO();
                user.setFullName(rs.getString("fullName"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setEmail(rs.getString("email"));
            }
        } catch (SQLException e) { // Fixed space in SQLException
            e.printStackTrace();
        }
        return user;
    }

    // 4. method - get ALL users (Needed for ViewServlet)
    public List<theusersDAO> getAllUsers() {
        List<theusersDAO> usersList = new ArrayList<>();
        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement("SELECT * FROM users");
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                theusersDAO user = new theusersDAO(); 
                user.setFullName(rs.getString("fullName"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                usersList.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return usersList;
    }

    // 5. method - update user (Needed for UpdateServlet)
    public boolean updateUser(theusersDAO user) {
        boolean isSuccess = false;
        try (Connection connection = getConnection();
             PreparedStatement ps = connection.prepareStatement("UPDATE users SET fullName = ?, password = ?, email = ? WHERE username = ?")) {
            
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getUsername()); 
            
            int rowsAffected = ps.executeUpdate();
            isSuccess = (rowsAffected > 0);
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return isSuccess;
    }
}