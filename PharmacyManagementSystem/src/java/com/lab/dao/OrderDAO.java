/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.lab.dao;

import com.lab.model.Order;
import com.lab.model.OrderDetails;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {
    private String url = "jdbc:mysql://localhost:3307/pharmacydata";
    private String user = "root";
    private String pass = "";
    
    private Connection getConnection() throws SQLException, ClassNotFoundException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(url, user, pass);
    }
    
    // Cipta induk order baru
    public int createOrder(Order o) {
        int orderID = 0;
        String sql = "INSERT INTO orders(orderDate, status, supplierID) VALUES(?,?,?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setDate(1, new java.sql.Date(o.getOrderDate().getTime()));
            ps.setString(2, o.getStatus());
            ps.setInt(3, o.getSupplierID());
            ps.executeUpdate();
            
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    orderID = rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orderID;
    }
    
    // Tambah senarai ubat dipesan
    public void addOrderDetails(OrderDetails d) {
        String sql = "INSERT INTO order_details(orderID, medicineID, quantity) VALUES(?,?,?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, d.getOrderID());
            ps.setInt(2, d.getMedicineID());
            ps.setInt(3, d.getQuantity());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    // Lihat semua senarai sejarah tempahan
    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders ORDER BY orderID DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Order o = new Order();
                o.setOrderID(rs.getInt("orderID"));
                o.setOrderDate(rs.getDate("orderDate"));
                o.setStatus(rs.getString("status"));
                o.setSupplierID(rs.getInt("supplierID"));
                list.add(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    // Kemaskini status tempahan (Pending -> Received)
    public void updateStatus(int id, String status) {
        String sql = "UPDATE orders SET status=? WHERE orderID=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    // SINKRONISASI INVENTORI: Menambah stok ke dalam jadual ubat utama 'medicines'
    public void syncStock (int orderID) {
        String selectSql = "SELECT medicineID, quantity FROM order_details WHERE orderID = ?";
        String updateSql = "UPDATE medicines SET stock_quantity = stock_quantity + ? WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement psSelect = conn.prepareStatement(selectSql)) {
            
            psSelect.setInt(1, orderID);
            try (ResultSet rs = psSelect.executeQuery()) {
                while (rs.next()) {
                    try (PreparedStatement psUpdate = conn.prepareStatement(updateSql)) {
                        psUpdate.setInt(1, rs.getInt("quantity"));
                        psUpdate.setInt(2, rs.getInt("medicineID"));
                        psUpdate.executeUpdate();
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    // Padam tempahan
    public boolean deleteOrder(int id) {
        boolean success = false;
        String deleteDetailsSql = "DELETE FROM order_details WHERE orderID = ?";
        String deleteOrderSql = "DELETE FROM orders WHERE orderID = ?";
        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps1 = conn.prepareStatement(deleteDetailsSql);
                 PreparedStatement ps2 = conn.prepareStatement(deleteOrderSql)) {
                
                ps1.setInt(1, id);
                ps1.executeUpdate();
                
                ps2.setInt(1, id);
                int rows = ps2.executeUpdate();
                
                if (rows > 0) success = true;
                conn.commit();
            } catch (SQLException ex) {
                conn.rollback();
                throw ex;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return success;
    }
}