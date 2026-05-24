<%-- 
    Document   : manageOrder
    Created on : 17 May 2026, 4:10:39 pm
    Author     : akmaa
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.lab.model.*, java.util.List" %>
<%@page import="com.lab.dao.MedicineDAO" %>
<%@page import="com.lab.dao.OrderDAO" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>PharmaCare | Manage Order</title>
        
        <style>
            body { font-family: Arial, sans-serif; margin: 40px; background-color: #f4f7f6; }
            .container { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
            h2, h3 { color: #2c3e50; border-bottom: 2px solid #3498db; padding-bottom: 10px; }
            .main-container { width: 100%; border-collapse: collapse; }
            .card { vertical-align: top; padding: 15px; }
            form { background: #ecf0f1; padding: 20px; border-radius: 8px; }
            label { font-weight: bold; display: block; margin-top: 10px; }
            input[type="text"], select { width: 100%; padding: 8px; margin-top: 5px; border-radius: 4px; border: 1px solid #bdc3c7; }
            button { background-color: #3498db; color: white; padding: 10px 15px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; margin-top: 15px;}
            button:hover { background-color: #2980b9; }
            .btn-delete { background-color: #e74c3c; padding: 5px 10px; font-size: 12px; }
            .btn-delete:hover { background-color: #c0392b; }
            table.order-table { width: 100%; border-collapse: collapse; margin-top: 10px; }
            table.order-table th, table.order-table td { padding: 10px; text-align: left; border-bottom: 1px solid #ddd; }
            table.order-table th { background-color: #34495e; color: white; }
            .status-select { width: auto; padding: 3px; font-weight: bold; }
        </style>
        
    </head>
    <body>
        <div class="container">
            <h2>Supplier & Order Management</h2>
            
            <%
                String msg = request.getParameter("statusUpdate");
                if("success".equals(msg)) {
                    out.print("<p style='color: green; background: #e6ffed; padding: 10px; border-radius: 5px; font-weight:bold;'>Action successful and inventory updated!</p>");
                } else if("error".equals(msg)) {
                    out.print("<p style='color: red; background: #fff1f0; padding: 10px; border-radius: 5px; font-weight:bold;'>An error occurred. Check input or database transaction.</p>");
                }
            %>

            <table class="main-container">
                <tr>
                    <td width="45%" class="card">
                        <h3>Create New Bulk Order</h3>
                        <form action="InsertOrderServlet" method="post">
                            
                            <label>Supplier Name:</label>
                            <select name="supplierName" required>
                                <option value="1">MedPharma Distribution</option>
                                <option value="2">MultiHealth Care Sdn Bhd</option>
                                <option value="3">Apex Pharmacy</option>
                            </select>

                            <hr style="margin: 20px 0; border: 0; border-top: 1px solid #eee;">

                            <label><b>Select Medicines & Enter Supply Quantity:</b></label>
                            <div style="max-height: 280px; overflow-y: auto; border: 1px solid #ddd; padding: 15px; border-radius: 8px; background: white; margin-top: 10px;">
                                <%
                                    // Memanggil MedicineDAO sedia ada anda untuk menarik semua senarai ubat
                                    MedicineDAO medDao = new MedicineDAO();
                                    List<Medicine> medList = medDao.getAllMedicines();
                                    
                                    if(medList != null && !medList.isEmpty()){
                                        for(Medicine m : medList) {
                                            // Menandakan amaran visual (Teks merah) jika ubat berada di paras bawah reorder level
                                            boolean isLow = m.getStockQuantity() <= m.getReorderLevel();
                                %>
                                <div style="margin-bottom: 15px; padding-bottom: 10px; border-bottom: 1px solid #eee;">
                                    <input type="checkbox" name="medicineIDs" value="<%= m.getId() %>" id="med_<%= m.getId() %>" <%= isLow ? "checked" : "" %>>
                                    <label for="med_<%= m.getId() %>" style="display:inline; font-weight: 500; cursor: pointer; <%= isLow ? "color: red; font-weight: bold;" : "" %>">
                                        <%= m.getName() %> (Current Stock: <%= m.getStockQuantity() %>) <%= isLow ? "[LOW STOCK]" : "" %>
                                    </label>
                                    <br>
                                    <input type="number" name="qty_<%= m.getId() %>" placeholder="Supply Qty" min="1" value="<%= isLow ? (m.getReorderLevel() * 2) : "" %>"
                                           style="width: 120px; margin-top: 5px; padding: 5px; border: 1px solid #ccc; border-radius:4px;">
                                </div>
                                <% 
                                        }
                                    } else {
                                %>
                                    <p style="color: red; font-size: 0.9em;">No medicines found in database.</p>
                                <% } %>
                            </div>

                            <button type="submit">Place Bulk Order</button>
                        </form>
                    </td>

                    <td width="55%" class="card">
                        <h3>Order Procurement History</h3>
                        <table class="order-table">
                            <thead>
                                <tr>
                                    <th>Order ID</th>
                                    <th>Date Created</th>
                                    <th>Status Shipment</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    OrderDAO orderDao = new OrderDAO();
                                    List<Order> orderList = orderDao.getAllOrders();
                                    
                                    if(orderList != null && !orderList.isEmpty()) {
                                        for(Order o : orderList) {
                                %>
                                <tr>
                                    <td><b>ORD-<%= o.getOrderID() %></b></td>
                                    <td><%= o.getOrderDate() %></td>
                                    <td>
                                        <form action="UpdateOrderServlet" method="post" style="background:none; padding:0; margin:0;">
                                            <input type="hidden" name="orderID" value="<%= o.getOrderID() %>">
                                            <select name="status" class="status-select" onchange="this.form.submit()" <%= o.getStatus().equals("Received") ? "disabled style='color:green;'" : "" %>>
                                                <option value="Pending" <%= o.getStatus().equals("Pending")?"selected":"" %>>Pending</option>
                                                <option value="Received" <%= o.getStatus().equals("Received")?"selected":"" %>>Received</option>
                                            </select>
                                        </form>
                                    </td>
                                    <td>
                                        <form action="DeleteOrderServlet" method="post" onsubmit="return confirm('Confirm delete order ORD-<%= o.getOrderID() %>?')" style="background:none; padding:0; margin:0;">
                                            <input type="hidden" name="orderID" value="<%= o.getOrderID() %>">
                                            <button type="submit" class="btn-delete">Delete</button>
                                        </form>
                                    </td>
                                </tr>
                                <% 
                                        } 
                                    } else {
                                %>
                                <tr>
                                    <td colspan="4" style="text-align:center; padding: 20px; color: #7f8c8d;">No historical order parameters found.</td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
    </body>
</html>
