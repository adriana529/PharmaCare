package com.lab.controller; 

import com.lab.dao.DashboardDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        DashboardDAO dao = new DashboardDAO(); 
        
        // 1. Safe extraction of fallback primitives to protect against format failures
        int totalMeds = dao.getTotalMedicines(); 
        int lowStock = dao.getLowStockCount(); 
        double salesToday = dao.getTotalSalesToday(); 
        double stockValue = dao.getStockValue(); 
        
        // 2. Pass clean native primitives straight through to your dashboard.jsp file
        request.setAttribute("totalMedicines", totalMeds); 
        request.setAttribute("lowStockCount", lowStock);
        request.setAttribute("salesToday", salesToday);
        request.setAttribute("stockValue", stockValue); 
        
        // 3. Route directly to your layout file matching your project tree structure
        request.getRequestDispatcher("dashboard.jsp").forward(request, response); 
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}