/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.lab.controller;

import com.lab.dao.OrderDAO;
import com.lab.model.Order;
import com.lab.model.OrderDetails;
import java.io.IOException;
import java.util.Date;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author akmaa
 */
public class InsertOrderServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet InsertOrderServlet</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet InsertOrderServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String[] selectedMedicineIDs = request.getParameterValues("medicineIDs");
            
            if (selectedMedicineIDs != null && selectedMedicineIDs.length > 0) {
                OrderDAO dao = new OrderDAO();
                
                Order newOrder = new Order();
                newOrder.setOrderDate(new Date());
                newOrder.setStatus("Pending");
                newOrder.setSupplierID(1); // Sementara: Pembekal Lalai (Default)
                
                int generatedOrderID = dao.createOrder(newOrder);
                
                if (generatedOrderID > 0) {
                    for (String medIDStr : selectedMedicineIDs) {
                        int medID = Integer.parseInt(medIDStr);
                        String qtyStr = request.getParameter("qty_" + medID);
                        
                        if (qtyStr != null && !qtyStr.trim().isEmpty()) {
                            int quantity = Integer.parseInt(qtyStr);
                            
                            OrderDetails details = new OrderDetails();
                            details.setOrderID(generatedOrderID);
                            details.setMedicineID(medID);
                            details.setQuantity(quantity);
                            
                            dao.addOrderDetails(details);
                        }
                    }
                    response.sendRedirect("manageOrder.jsp?statusUpdate=success");
                    return;
                }
            }
            response.sendRedirect("manageOrder.jsp?statusUpdate=error");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manageOrder.jsp?statusUpdate=error");
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
