<%-- 
    Document   : memberships
    Created on : 16 May 2026, 7:22:22 pm
    Author     : akmaa
--%>
<%@page import="com.lab.model.Membership"%>
<%@page import="com.lab.dao.MembershipDAO"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>PharmaCare | Membership Management</title>
        
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        
        <style>
            :root {
                --primary-color: #2563eb;
                --sidebar-bg: #1e293b;
                --sidebar-hover: #334155;
                --sidebar-active: #2563eb;
                --body-bg: #f8fafc;
                --card-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.05), 0 2px 4px -2px rgb(0 0 0 / 0.05);
            }

            body { 
                font-family: 'Segoe UI', system-ui, -apple-system, sans-serif; 
                background-color: var(--body-bg);
                margin: 0;
                padding: 0;
                display: flex;
                min-height: 100vh;
            }

            /* ================= SIDEBAR STYLING ================= */
            .sidebar {
                width: 260px;
                background-color: var(--sidebar-bg);
                color: white;
                display: flex;
                flex-direction: column;
                position: fixed;
                top: 0;
                bottom: 0;
                left: 0;
                padding-top: 24px;
                z-index: 100;
            }

            .sidebar-brand {
                display: flex;
                align-items: center;
                gap: 12px;
                padding: 0 24px;
                margin-bottom: 32px;
            }

            .sidebar-brand i {
                font-size: 24px;
                color: #38bdf8;
            }

            .sidebar-brand h2 {
                margin: 0;
                font-size: 20px;
                font-weight: 700;
                letter-spacing: 0.5px;
            }

            .sidebar-brand p {
                margin: 2px 0 0 0;
                font-size: 12px;
                color: #94a3b8;
            }

            .sidebar-menu {
                list-style: none;
                padding: 0;
                margin: 0;
                flex: 1;
            }

            .sidebar-menu li {
                padding: 4px 16px;
            }

            .sidebar-menu a {
                display: flex;
                align-items: center;
                gap: 14px;
                padding: 12px 16px;
                color: #94a3b8;
                text-decoration: none;
                border-radius: 8px;
                font-weight: 500;
                font-size: 15px;
                transition: all 0.2s ease;
            }

            .sidebar-menu a:hover {
                background-color: var(--sidebar-hover);
                color: white;
            }

            .sidebar-menu li.active a {
                background-color: var(--sidebar-active);
                color: white;
            }

            .sidebar-footer {
                padding: 24px;
                border-top: 1px solid #334155;
            }

            .btn-signout {
                display: flex;
                align-items: center;
                gap: 12px;
                color: #f1f5f9;
                text-decoration: none;
                font-weight: 500;
                font-size: 15px;
                opacity: 0.8;
                transition: opacity 0.2s;
            }

            .btn-signout:hover {
                opacity: 1;
                color: #f87171;
            }

            /* ================= MAIN CONTENT STYLING ================= */
            .main-content {
                flex: 1;
                margin-left: 260px; /* Alihkan kandungan ke kanan supaya tidak bertindih dengan sidebar */
                padding: 40px;
                box-sizing: border-box;
            }

            .main-title { 
                font-size: 28px;
                color: #0f172a; 
                margin: 0 0 6px 0; 
                font-weight: 700;
            }

            .sub-title { 
                color: #64748b; 
                margin: 0 0 32px 0;
                font-size: 15px;
            }

            .workspace-container { 
                display: flex; 
                gap: 30px; 
            }

            .card { 
                background: white; 
                padding: 28px; 
                border-radius: 12px; 
                box-shadow: var(--card-shadow);
            }

            .form-side { 
                width: 35%; 
            }

            .table-side { 
                width: 65%; 
            }

            h3 { 
                margin-top: 0; 
                margin-bottom: 20px;
                color: #1e293b; 
                font-size: 18px;
                font-weight: 600;
                border-bottom: 2px solid #f1f5f9; 
                padding-bottom: 12px; 
            }

            .form-group { 
                margin-bottom: 18px; 
            }

            .form-group label { 
                display: block; 
                margin-bottom: 8px; 
                font-weight: 600; 
                color: #334155;
                font-size: 14px;
            }

            .form-group input { 
                width: 100%; 
                padding: 11px 14px; 
                box-sizing: border-box; 
                border-radius: 8px; 
                border: 1px solid #cbd5e1; 
                font-size: 14px;
                background-color: #fff;
                transition: border-color 0.2s;
            }

            .form-group input:focus {
                outline: none;
                border-color: var(--primary-color);
            }

            .btn-primary { 
                background-color: var(--primary-color); 
                color: white; 
                border: none; 
                padding: 12px; 
                border-radius: 8px; 
                cursor: pointer; 
                width: 100%; 
                font-weight: 600; 
                font-size: 15px; 
                transition: background-color 0.2s;
            }

            .btn-primary:hover { 
                background-color: #1d4ed8; 
            }
          
            /* Search Section */
            .search-box { 
                display: flex; 
                gap: 12px; 
                margin-bottom: 24px; 
            }

            .search-input { 
                flex: 1; 
                padding: 11px 14px; 
                border: 1px solid #cbd5e1; 
                border-radius: 8px; 
                font-size: 14px; 
            }

            .btn-search { 
                background-color: #10b981; 
                color: white; 
                border: none; 
                padding: 10px 24px; 
                border-radius: 8px; 
                cursor: pointer; 
                font-weight: 600; 
                font-size: 14px;
            }

            .btn-search:hover { background-color: #059669; }

            .btn-clear { 
                background-color: #64748b; 
                color: white; 
                text-decoration: none; 
                padding: 11px 24px; 
                border-radius: 8px; 
                font-size: 14px; 
                text-align: center; 
                font-weight: 600; 
                box-sizing: border-box;
            }
            .btn-clear:hover { background-color: #475569; }
          
            /* Table Styling */
            table { 
                width: 100%; 
                border-collapse: collapse; 
            }

            th, td { 
                padding: 14px 16px; 
                text-align: left; 
                border-bottom: 1px solid #e2e8f0; 
                font-size: 14px;
            }

            th { 
                background-color: #f8fafc; 
                color: #64748b; 
                font-weight: 600; 
            }

            td { color: #334155; }

            .status-active { 
                background-color: #dcfce7; 
                color: #15803d; 
                padding: 4px 12px; 
                border-radius: 9999px; 
                font-weight: 600; 
                font-size: 12px; 
                display: inline-block; 
            }

            .status-inactive { 
                background-color: #fee2e2; 
                color: #b91c1c; 
                padding: 4px 12px; 
                border-radius: 9999px; 
                font-weight: 600; 
                font-size: 12px; 
                display: inline-block; 
            }

            .btn-toggle { 
                background-color: white; 
                color: #475569; 
                border: 1px solid #cbd5e1; 
                padding: 6px 14px; 
                border-radius: 6px; 
                cursor: pointer; 
                font-size: 13px; 
                font-weight: 500;
                transition: all 0.2s;
            }

            .btn-toggle:hover { 
                background-color: #f1f5f9; 
                color: #0f172a;
            }
        </style>
        
    </head>
    <body>
         <div class="sidebar">
            <div class="sidebar-brand">
                <i class="fa-solid fa-square-plus"></i>
                <div>
                    <h2>PharmaCare</h2>
                    <p>Admin Portal</p>
                </div>
            </div>
            
            <ul class="sidebar-menu">
                <li><a href="dashboard.jsp"><i class="fa-solid fa-chart-pie"></i> Dashboard</a></li>
                <li class="active"><a href="memberships.jsp"><i class="fa-solid fa-users"></i> Memberships</a></li>
                <li><a href="medicine.jsp"><i class="fa-solid fa-capsules"></i> Medicine List</a></li>
                <li><a href="inventory.jsp"><i class="fa-solid fa-boxes-stacked"></i> Inventory</a></li>
                <li><a href="PurchaseHistory.jsp"><i class="fa-solid fa-file-invoice-dollar"></i> Purchase History</a></li>
                <li><a href="ManualPurchaseEntry.jsp"><i class="fa-solid fa-cash-register"></i> Counter Sale</a></li>
                
            </ul>
            
            <div class="sidebar-footer">
                <a href="login.jsp" class="btn-signout"><i class="fa-solid fa-right-from-bracket"></i> Sign Out</a>
            </div>
        </div>

        <div class="main-content">
            <h1 class="main-title">Membership Management</h1>
            <p class="sub-title">Register new members, secure validation, and filter records instantly by IC Number.</p>
            
            <div class="workspace-container">
                <div class="card form-side">
                    <h3>Register New Member</h3>
                    <form action="MembershipServlet" method="POST">
                        <input type="hidden" name="action" value="register">
                        
                        <div class="form-group">
                            <label>Full Name:</label>
                            <input type="text" name="fullName" required placeholder="e.g. Ahmad bin Ali">
                        </div>
                        <div class="form-group">
                            <label>IC Number:</label>
                            <input type="text" name="icNumber" required placeholder="e.g. 990125115433" maxlength="14">
                        </div>
                        <div class="form-group">
                            <label>Phone Number:</label>
                            <input type="text" name="phone" required placeholder="e.g. 0123456789">
                        </div>
                        <div class="form-group">
                            <label>Email Address:</label>
                            <input type="email" name="email" placeholder="e.g. ahmad@gmail.com">
                        </div>
                        <div class="form-group">
                            <label>Expiry Date:</label>
                            <input type="date" name="expiryDate" required>
                        </div>
                        <button type="submit" class="btn-primary">Register Member</button>
                    </form>
                </div>

                <div class="card table-side">
                    <h3>Registered Members List</h3>
                    
                    <form action="memberships.jsp" method="GET" class="search-box">
                        <input type="text" name="searchIC" class="search-input" placeholder="Type IC Number to filter..." 
                               value="<%= request.getParameter("searchIC") != null ? request.getParameter("searchIC") : "" %>">
                        <button type="submit" class="btn-search">Search</button>
                        <a href="memberships.jsp" class="btn-clear">Clear</a>
                    </form>

                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Member Info</th>
                                <th>Contact</th>
                                <th>Expiry Date</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                MembershipDAO dao = new MembershipDAO();
                                List<Membership> list;
                                
                                String searchIC = request.getParameter("searchIC");
                                if (searchIC != null && !searchIC.trim().isEmpty()) {
                                    list = dao.searchMemberByIC(searchIC.trim());
                                } else {
                                    list = dao.getAllMembers();
                                }
                                
                                for(Membership m : list) {
                            %>
                            <tr>
                                <td><b>MB-<%= m.getMemberID() %></b></td>
                                <td>
                                    <span style="font-size: 14px; font-weight: 600; color: #1e293b;"><%= m.getFullName() %></span><br>
                                    <small style="color: #64748b; font-weight: 500;">IC: <%= m.getIcNum() %></small>
                                </td>
                                <td><%= m.getPhone() %><br><small style="color: #64748b;"><%= (m.getEmail() != null && !m.getEmail().isEmpty()) ? m.getEmail() : "-" %></small></td>
                                <td><%= m.getExpiryDate() %></td>
                                <td>
                                    <span class="<%= "Active".equals(m.getStatus()) ? "status-active" : "status-inactive" %>">
                                        <%= m.getStatus() %>
                                    </span>
                                </td>
                                <td>
                                    <form action="MembershipServlet" method="POST" style="display:inline;">
                                        <input type="hidden" name="action" value="toggleStatus">
                                        <input type="hidden" name="memberID" value="<%= m.getMemberID() %>">
                                        <input type="hidden" name="currentStatus" value="<%= m.getStatus() %>">
                                        <button type="submit" class="btn-toggle">
                                            <%= "Active".equals(m.getStatus()) ? "Suspend" : "Activate" %>
                                        </button>
                                    </form>
                                </td>
                            </tr>
                            <% 
                                } 
                                if(list.isEmpty()) {
                            %>
                            <tr>
                                <td colspan="6" style="text-align: center; color: #ef4444; padding: 30px; font-weight: 600;">
                                    No membership records found matching that IC Number.
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </body>
</html>
