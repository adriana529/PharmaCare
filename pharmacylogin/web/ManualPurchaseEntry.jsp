<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.lab.model.*, java.util.List" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Dashboard - Manual Sales Entry</title>
        <style>
            body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; display: flex; background: #f4f6f9; color: #333; }
            .sidebar { width: 260px; background: #1e293b; color: #f8fafc; min-height: 100vh; padding: 24px; box-sizing: border-box; }
            .sidebar h3 { margin: 0 0 20px 0; font-size: 20px; font-weight: 700; letter-spacing: 0.5px; color: #38bdf8; }
            .sidebar hr { border: 0; border-top: 1px solid #334155; margin-bottom: 20px; }
            .sidebar a { display: block; color: #cbd5e1; padding: 12px 16px; text-decoration: none; border-radius: 6px; margin-bottom: 8px; font-size: 14px; transition: all 0.2s; }
            .sidebar a:hover { background: #334155; color: #fff; }
            .sidebar a.active { background: #0284c7; color: white; font-weight: 600; }
            .main-content { flex: 1; padding: 40px; box-sizing: border-box; }
            .card { background: white; padding: 32px; border-radius: 12px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05), 0 2px 4px -1px rgba(0,0,0,0.03); max-width: 800px; }
            h2 { margin-top: 0; color: #0f172a; font-size: 24px; font-weight: 700; }
            .form-group { margin-bottom: 24px; }
            .form-group label { display: block; margin-bottom: 8px; font-weight: 600; font-size: 14px; color: #475569; }
            .form-group input, .form-group select { width: 100%; padding: 11px 14px; border: 1px solid #cbd5e1; border-radius: 6px; box-sizing: border-box; font-size: 14px; background-color: #fff; color: #1e293b; }
            .calc-panel { background: #f8fafc; padding: 20px; border-radius: 8px; border-left: 4px solid #0284c7; margin-top: 20px; }
            .calc-row { display: flex; justify-content: space-between; margin-bottom: 8px; font-size: 14px; color: #64748b; }
            .calc-total { display: flex; justify-content: space-between; margin-top: 12px; padding-top: 12px; border-top: 1px solid #e2e8f0; font-size: 18px; font-weight: 700; color: #16a34a; }
            .btn-submit { width: 100%; padding: 14px; background: #16a34a; color: white; border: none; border-radius: 6px; font-size: 15px; font-weight: 600; cursor: pointer; }
            .btn-submit:hover { background: #15803d; }
            .alert { padding: 14px 16px; border-radius: 6px; margin-bottom: 24px; font-size: 14px; font-weight: 500; }
            .alert-success { background: #dcfce7; color: #166534; border: 1px solid #bbf7d0; }
            .alert-danger { background: #fee2e2; color: #991b1b; border: 1px solid #fca5a5; }
        </style>
        <script>
            function runLiveCalculation() {
                var select = document.getElementById("medId");
                var qtyInput = document.getElementById("qty");

                var unitPrice = parseFloat(select.options[select.selectedIndex].getAttribute("data-price")) || 0;
                var qty = parseInt(qtyInput.value) || 0;
                var eligibilityFlag = document.getElementById("isEligible").value === "true";

                var subtotal = unitPrice * qty;
                var discountAmount = 0.00;
                var finalTotal = subtotal;

                // Applies the 10% discount ONLY if they are an eligible verified member
                if (eligibilityFlag && qty > 0) {
                    finalTotal = subtotal * 0.90;
                    discountAmount = subtotal * 0.10;
                }

                document.getElementById("valUnitPrice").innerText = unitPrice.toFixed(2);
                document.getElementById("valDiscount").innerText = discountAmount.toFixed(2);
                document.getElementById("valTotal").innerText = finalTotal.toFixed(2);
                document.getElementById("hiddenUnitPrice").value = unitPrice;
            }
        </script>
    </head>
    <body>

        <div class="sidebar">
            <h3>Pharmacy ERP</h3>
            <hr>
            <a href="${pageContext.request.contextPath}/DashboardServlet">📊 Dashboard Overview</a>
            <a href="${pageContext.request.contextPath}/PurchaseServlet?action=counterSale" class="active">🛒 Manual Counter Sale</a>
            <a href="${pageContext.request.contextPath}/PurchaseServlet?action=viewHistory">📋 Purchase Logs & Lookup</a>
        </div>

        <div class="main-content">
            <div class="card">
                <h2>Manual Counter Registry Sale</h2>
                <hr style="border:0; border-top: 1px solid #e2e8f0; margin-bottom: 25px;">

                <form action="${pageContext.request.contextPath}/PurchaseServlet" method="GET" style="margin-bottom: 30px; display: flex; gap: 12px;">
                    <input type="hidden" name="action" value="counterSale">
                    <input type="text" name="searchQuery" placeholder="Verify IC for Member Discount (Optional)" 
                           value="${param.searchQuery != null ? param.searchQuery : ''}" 
                           style="flex: 1; padding: 11px 14px; border: 1px solid #cbd5e1; border-radius: 6px; font-size: 14px;">
                    <button type="submit" style="padding: 11px 24px; background: #0284c7; color: white; border:none; border-radius:6px; font-weight: 600; font-size: 14px; cursor:pointer;">Verify Member ID</button>
                </form>

                <%
                    Member m = (Member) request.getAttribute("member");
                    List<Medicine> medList = (List<Medicine>) request.getAttribute("medList");
                    String status = request.getParameter("status");
                    
                    // Defaults to GUEST if no valid member is found
                    String displayIC = (m != null) ? m.getIcNumber() : "GUEST";
                %>

                <% if ("success".equals(status)) { %>
                <div class="alert alert-success">✔ Transaction successfully posted to the master database ledger.</div>
                <% } else if ("error".equals(status)) { %>
                <div class="alert alert-danger">❌ Processing Failure. Check inventory system dependencies.</div>
                <% }%>

                <form action="${pageContext.request.contextPath}/PurchaseServlet" method="POST">
                    <input type="hidden" name="icNumber" value="<%= displayIC %>">
                    <input type="hidden" id="isEligible" value="<%= (m != null && m.getPoints() >= 10)%>">
                    <input type="hidden" name="unitPrice" id="hiddenUnitPrice">

                    <div class="form-group">
                        <label>Customer Classification Context:</label>
                        <input type="text" readonly style="background:#f1f5f9; color: #475569; font-weight: 500;" 
                               value="<%= (m != null) ? "Registered Profile: " + m.getMemberName() + " (" + m.getPoints() + " Points Available)" : "Unregistered Account / Walk-in Guest" %>">
                    </div>

                    <div class="form-group">
                        <label for="medId">Select Medicine Inventory Stock Item:</label>
                        <select name="medId" id="medId" onchange="runLiveCalculation()" required>
                            <option value="" data-price="0">-- Select Inventory Product Stock --</option>
                            <% if (medList != null) {
                                for (Medicine med : medList) {%>
                            <option value="<%= med.getId()%>" data-price="<%= med.getUnitPrice()%>">
                                <%= med.getName()%> (In Stock: <%= med.getStockQuantity()%>)
                            </option>
                            <% }
                                }%>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="qty">Quantity Dispensed:</label>
                        <input type="number" name="qty" id="qty" min="1" oninput="runLiveCalculation()" required placeholder="0">
                    </div>

                    <div class="calc-panel">
                        <div class="calc-row">
                            <span>Item Rate Price:</span>
                            <span>RM <span id="valUnitPrice">0.00</span></span>
                        </div>
                        <div class="calc-row" style="color: #dc2626;">
                            <span>Deducted Discount:</span>
                            <span>- RM <span id="valDiscount">0.00</span></span>
                        </div>
                        <div class="calc-total">
                            <span>Net Payable Total:</span>
                            <span>RM <span id="valTotal">0.00</span></span>
                        </div>
                    </div>

                    <br>
                    <button type="submit" class="btn-submit">Complete Payment Processing</button>
                </form>
            </div>
        </div>
    </body>
</html>