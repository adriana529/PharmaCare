/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.lab.controller;

import com.lab.dao.MedicineDAO;
import com.lab.model.Medicine;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author sazliosman
 */
@WebServlet("/MedicineList")
public class MedicineListServlet extends HttpServlet {

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
            out.println("<title>Servlet MedicineListServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet MedicineListServlet at " + request.getContextPath() + "</h1>");
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
    
    //handle loading page & display table 
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        //1. panggil DAO untuk dapat semua medicine from database
        MedicineDAO dao = new MedicineDAO(); 
        List<Medicine> medList = dao.getAllMedicines(); 
        
        //2. attach dengan list ke request untuk JSP baca 
        request.setAttribute("medList", medList); 
        
        //3. forwardkan ke user to page JSP 
        request.getRequestDispatcher("medicine.jsp").forward(request,response); 
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    
    //handle "add new medicine" 
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        //1. capture data dari JSP form 
        String name = request.getParameter("medName"); 
        String reorderStr = request.getParameter("reorderLevel"); 
        String priceStr = request.getParameter("price"); 
        String quantityStr = request.getParameter("quantity"); 
        
        MedicineDAO dao = new MedicineDAO(); 
        
    try{
        //2. check duplication 
        if(dao.isDuplicate(name)) {
            
            //error message
            request.setAttribute("error", "Error: '" + name + "' already exists in the system.");  
        }else{ 
            
            //3. parse the num & save dekat database
            double price = Double.parseDouble(priceStr); 
            int quantity = Integer.parseInt(quantityStr); 
            int reorderLevel = Integer.parseInt(reorderStr);
            boolean success = dao.addMedicine(name, quantity, price, reorderLevel);
            
            if(success) {
                request.setAttribute("message", "Medicine added successfully"); 
            }else{ 
                request.setAttribute("error", "Database error. Could not save"); 
            }
        }
    }     catch (NumberFormatException e){
                request.setAttribute("error", "Invalid format. Please enter numbers for Price and Quantity ");
          }
    
    List<Medicine> medList = dao.getAllMedicines(); 
        request.setAttribute("medList", medList); 
        request.getRequestDispatcher("medicine.jsp").forward(request, response);
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
