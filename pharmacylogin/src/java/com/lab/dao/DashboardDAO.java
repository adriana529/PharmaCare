/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.lab.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

public class DashboardDAO {

    private String url = "jdbc:mysql://localhost:3307/pharmacydata";
    private String username = "root";
    private String password = "";

    private Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

        return DriverManager.getConnection(url, username, password);
    }

    //total number of medicine 
    public int getTotalMedicines() {
        int count = 0;
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM medicines")) {

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    //Count of low stock Items 
    public int getLowStockCount() {
        int count = 0;
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM medicines WHERE stock_quantity < reorder_level")) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;

    }

    //3. Get total sales by day 
    public double getTotalSalesToday() {
        double total = 0;

        String sql = "SELECT SUM(total_amount) FROM sales WHERE DATE(sale_date)=CURDATE()";

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                
            }
            
                 {
                     total = rs.getDouble(1);
            }
        } catch (SQLException e) {

        }
        return total;
    }

    //4. Get total value of stock (quantity x price) 
    public double getStockValue() {
        double total = 0;
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement("SELECT SUM(stock_quantity")){ 
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                total = rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
    }

}
