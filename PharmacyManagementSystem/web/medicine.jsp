<%-- 
    Document   : medicine
    Created on : 2 May 2026, 08:49:33
    Author     : sazliosman
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Pharmacy Inventory System</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 40px;
                background-color: #f4f7f6;
            }
            .container {
                background: white;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            h2 {
                color: #2c3e50;
                border-bottom: 2px solid #3498db;
                padding-bottom: 10px;
            }

            /* Messages */
            .msg {
                padding: 10px;
                margin-bottom: 20px;
                border-radius: 4px;
            }
            .success {
                background-color: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }
            .error {
                background-color: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
            }

            /* Form Styling */
            form {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 15px;
                margin-bottom: 30px;
                background: #ecf0f1;
                padding: 20px;
                border-radius: 8px;
            }
            .form-group {
                display: flex;
                flex-direction: column;
            }
            label {
                font-weight: bold;
                margin-bottom: 5px;
            }
            input, select {
                padding: 8px;
                border: 1px solid #bdc3c7;
                border-radius: 4px;
            }
            .btn-submit {
                grid-column: span 2;
                background-color: #3498db;
                color: white;
                padding: 10px;
                border: none;
                cursor: pointer;
                border-radius: 4px;
                font-size: 16px;
            }
            .btn-submit:hover {
                background-color: #2980b9;
            }

            /* Table Styling */
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }
            th, td {
                padding: 12px;
                text-align: left;
                border-bottom: 1px solid #ddd;
            }
            th {
                background-color: #34495e;
                color: white;
            }
            tr:hover {
                background-color: #f1f1f1;
            }
            .low-stock {
                color: red;
                font-weight: bold;
            }
        </style>
    </head>
    <body>

        <div class="container">
            <h2>Medicine Inventory Management</h2>

            <c:if test="${not empty message}">
                <div class="msg success">${message}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="msg error">${error}</div>
            </c:if>

            <form action="MedicineList" method="POST">
                <div class="form-group">
                    <label>Medicine Name:</label>
                    <input type="text" name="medName" required placeholder="e.g. Paracetamol">
                </div>
                <div class="form-group">
                    <label>Reorder Level Alert (Stock Minimum):</label>
                    <input type="number" name="reorderLevel" required placeholder="Example: 10">
                </div>
                <div class="form-group">
                    <label>Price (RM):</label>
                    <input type="number" step="0.01" name="price" required>
                </div>
                <div class="form-group">
                    <label>Quantity:</label>
                    <input type="number" name="quantity" required>
                </div>
                <button type="submit" class="btn-submit">Add to Inventory</button>
            </form>

            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Medicine Name</th>
                        <th>Reorder Level</th>
                        <th>Price (RM)</th>
                        <th>Quantity</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="med" items="${medList}">
                        <tr>
                            <td>${med.id}</td>
                            <td><strong>${med.name}</strong></td>
                            <td>${med.reorderLevel}</td>
                            <td>RM ${String.format("%.2f", med.unitPrice)}</td>
                            <td class="${med.stockQuantity <= med.reorderLevel ? 'low-stock' : ''}">${med.stockQuantity}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${med.stockQuantity <= 0}">
                                        <span style="color: red; font-weight: bold;">Out of Stock</span></c:when>
                                    <c:when test="${med.stockQuantity <= med.reorderLevel}">
                                        <span style="color: orange; font-weight: bold;">Low Stock</span></c:when>
                                    <c:otherwise>
                                        <span style="color: green; font-weight: bold;">In Stock</span></c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty medList}">
                        <tr>
                            <td colspan="6" style="text-align: center;">No medicines found in inventory.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

    </body>
</html>     