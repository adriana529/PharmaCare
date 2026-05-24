<%-- 
    Document   : inventory
    Created on : 2 May 2026, 08:49:17
    Author     : sazliosman
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Pharmacy Inventory Dashboard</title>
        <style>
            body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f0f2f5; margin: 0; padding: 20px; }
            .inventory-wrapper { max-width: 1100px; margin: auto; background: white; padding: 30px; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
            
            /* Header & Stats */
            .header-flex { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #eee; padding-bottom: 15px; margin-bottom: 25px; }
            .stats-container { display: flex; gap: 20px; margin-bottom: 25px; }
            .stat-card { flex: 1; padding: 15px; border-radius: 8px; color: white; text-align: center; }
            .total-items { background: #3498db; }
            .low-stock-alert { background: #e74c3c; }

            /* Table UI */
            table { width: 100%; border-collapse: collapse; }
            th { background-color: #f8f9fa; color: #333; text-align: left; padding: 15px; border-bottom: 2px solid #dee2e6; }
            td { padding: 15px; border-bottom: 1px solid #eee; vertical-align: middle; }
            tr:hover { background-color: #fafafa; }

            /* Badges */
            .badge { padding: 5px 12px; border-radius: 20px; font-size: 12px; font-weight: bold; text-transform: uppercase; }
            .badge-in { background: #d4edda; color: #155724; }
            .badge-low { background: #fff3cd; color: #856404; }
            .badge-out { background: #f8d7da; color: #721c24; }
            
            .nav-link { text-decoration: none; color: #3498db; font-weight: bold; }
        </style>
    </head>
    <body>

        <div class="inventory-wrapper">
            <div class="header-flex">
                <h2>📦 Live Inventory Dashboard</h2>
                <a href="MedicineList" class="nav-link">+ Add New Product</a>
            </div>

            <div class="stats-container">
                <div class="stat-card total-items">
                    <strong>Total Products</strong><br>
                    <span style="font-size: 24px;">${medList.size()}</span>
                </div>
                <div class="stat-card low-stock-alert">
                    <strong>Low Stock Alerts</strong><br>
                    <span style="font-size: 24px;">
                        <c:set var="lowCount" value="0" />
                        <c:forEach var="m" items="${medList}">
                            <c:if test="${m.stockQuantity <= m.reorderLevel}"><c:set var="lowCount" value="${lowCount + 1}" /></c:if>
                        </c:forEach>
                        ${lowCount}
                    </span>
                </div>
            </div>

            <table>
                <thead>
                    <tr>
                        <th>SKU / ID</th>
                        <th>Medicine Name</th>
                        <th>Reorder Level</th>
                        <th>Unit Price</th>
                        <th>In Stock</th>
                        <th>Inventory Status</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="med" items="${medList}">
                        <tr>
                            <td>#MED-${med.id}</td>
                            <td><strong>${med.name}</strong></td>
                            <td>${med.reorderLevel}</td>
                            <td>RM ${String.format("%.2f", med.unitPrice)}</td>
                            <td>${med.stockQuantity}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${med.stockQuantity <= 0}">
                                        <span class="badge badge-out">Empty</span>
                                    </c:when>
                                    <c:when test="${med.stockQuantity <= med.reorderLevel}">
                                        <span class="badge badge-low">Low Stock</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-in">Healthy</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    
                    <c:if test="${empty medList}">
                        <tr>
                            <td colspan="6" style="text-align: center; padding: 50px; color: #999;">
                                Inventory is currently empty. Start by adding medicines.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

    </body>
</html>
