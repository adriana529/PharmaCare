package com.lab.controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.lab.model.Medicine;
import com.lab.model.Purchase;
import com.lab.model.Member;
import com.lab.dao.PurchaseDAO; 
import com.lab.dao.MedicineDAO;

@WebServlet("/PurchaseServlet")
public class PurchaseServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null || action.isEmpty()) {
            action = "counterSale";
        }

        try {
            PurchaseDAO purchaseDAO = new PurchaseDAO();

            if (action.equals("viewHistory")) {
                // --- 1. HANDLE PURCHASE HISTORY ---
                String searchQuery = request.getParameter("searchQuery");
                List<Purchase> historyList;

                if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                    historyList = purchaseDAO.getHistoryByPartialIC(searchQuery);
                    request.setAttribute("searchedQuery", searchQuery);
                } else {
                    historyList = purchaseDAO.getAllHistory();
                }

                request.setAttribute("history", historyList);
                // FIXED: Capitalized "P" in PurchaseHistory.jsp to prevent the 404 error
                request.getRequestDispatcher("PurchaseHistory.jsp").forward(request, response);

            } else if (action.equals("counterSale")) {
                // --- 2. HANDLE MANUAL COUNTER SALE ---
                String searchQuery = request.getParameter("searchQuery");
                
                // Fetch Member using PurchaseDAO
                if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                    Member member = purchaseDAO.findMemberByPartialIC(searchQuery);
                    request.setAttribute("member", member);
                }

                // Fetch Medicine list
                MedicineDAO medicineDAO = new MedicineDAO();
                List<Medicine> medList = medicineDAO.getAllMedicines();
                request.setAttribute("medList", medList);

                // Forwards to the correct manual sale JSP
                request.getRequestDispatcher("ManualPurchaseEntry.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error occurred.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // --- 3. PROCESS THE ACTUAL SALE FORM SUBMISSION ---
        try {
            String icNumber = request.getParameter("icNumber");
            int medId = Integer.parseInt(request.getParameter("medId"));
            int qty = Integer.parseInt(request.getParameter("qty"));
            
            // Fetch the unitPrice from the form so it can be passed to the DAO
            double unitPrice = Double.parseDouble(request.getParameter("unitPrice"));
            
            PurchaseDAO purchaseDAO = new PurchaseDAO();
            boolean success = purchaseDAO.saleProcess(icNumber, medId, qty, unitPrice);
            
            if (success) {
                response.sendRedirect("PurchaseServlet?action=counterSale&status=success");
            } else {
                response.sendRedirect("PurchaseServlet?action=counterSale&status=error");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("PurchaseServlet?action=counterSale&status=error");
        }
    }
}