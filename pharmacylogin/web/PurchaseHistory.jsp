<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.lab.model.*, java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard - Purchase Logs</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; margin: 0; display: flex; background: #f4f6f9; }
        .sidebar { width: 240px; background: #2c3e50; color: white; min-height: 100vh; padding: 20px; box-sizing: border-box; }
        .sidebar h3 { margin-top: 0; }
        .sidebar a { display: block; color: #ecf0f1; padding: 12px; text-decoration: none; border-radius: 4px; margin-bottom: 5px; }
        .sidebar a:hover, .sidebar a.active { background: #34495e; font-weight: bold; }
        .main-content { flex: 1; padding: 40px; }
        .card { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; background: white; }
        th, td { padding: 12px; border: 1px solid #ddd; text-align: left; }
        th { background-color: #f8f9fa; font-weight: 600; color: #333; }
        tr:hover { background-color: #f1f3f5; }
    </style>
</head>
<body>

    <div class="sidebar">
        <h3>Pharmacy ERP</h3>
        <hr style="border-color: #34495e;">
        <a href="${pageContext.request.contextPath}/DashboardServlet">📊 Dashboard Overview</a>
        <a href="${pageContext.request.contextPath}/PurchaseServlet?action=counterSale">🛒 Manual Counter Sale</a>
        <a href="${pageContext.request.contextPath}/PurchaseServlet?action=viewHistory" class="active">📋 Purchase Logs & Lookup</a>
    </div>

    <div class="main-content">
        <div class="card">
            <h2>Customer Purchase Logs Ledger</h2>
            <hr style="border:0; border-top: 1px solid #eee; margin-bottom: 25px;">

            <form action="${pageContext.request.contextPath}/PurchaseServlet" method="GET" style="margin-bottom: 30px; display: flex; gap: 10px;">
                <input type="hidden" name="action" value="viewHistory">
                <input type="text" name="searchQuery" placeholder="Search invoices by last 4 digits of IC..." 
                       value="${param.searchQuery != null ? param.searchQuery : ''}" 
                       style="flex: 1; padding: 10px; border: 1px solid #ccc; border-radius: 4px;">
                <button type="submit" style="padding: 10px 20px; background: #007bff; color: white; border:none; border-radius:4px; cursor:pointer;">Search Logs</button>
            </form>

            <%
                List<Purchase> history = (List<Purchase>) request.getAttribute("history");
                String searchedQuery = (String) request.getAttribute("searchedQuery");
                
                if (history != null && !history.isEmpty()) {
            %>
                <table>
                    <thead>
                        <tr>
                            <th>Order ID</th>
                            <th>Member Reference ID</th>
                            <th>Customer Identity (IC)</th>
                            <th>Purchase Date</th>
                            <th>Items Prescribed</th>
                            <th>Total Price Paid</th>
                            <th>Payment Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Purchase p : history) { %>
                            <tr>
                                <td><strong><%= p.getOrderId() %></strong></td>
                                <td><%= (p.getMemberId() != null) ? p.getMemberId() : "<span style='color:#999;'>None (Guest)</span>" %></td>
                                <td><%= p.getIcNumber() %></td>
                                <td><%= p.getPurchaseDate() %></td>
                                <td><%= p.getItems() %></td>
                                <td><strong>RM <%= String.format("%.2f", p.getAmount()) %></strong></td>
                                <td><span style="background:#d4edda; color:#155724; padding:3px 8px; border-radius:12px; font-size:12px; font-weight:bold;"><%= p.getStatus() %></span></td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } else if (searchedQuery != null) { %>
                <div style="background:#fff3cd; color:#856404; padding:15px; border-radius:4px; border:1px solid #ffeeba;">
                    No historical logs found in the system for input reference criteria: <strong><%= searchedQuery %></strong>
                </div>
            <% } else { %>
                <p style="color: #666; font-style: italic;">Provide a target customer IC identity query sequence above to retrieve audit records.</p>
            <% } %>
        </div>
    </div>

</body>
</html>