<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.lab.model.*, java.util.List" %>
<%@page import="com.lab.dao.MembershipDAO"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>PharmaCare Dashboard</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            :root {
                --primary-blue: #2563eb;
                --sidebar-bg: #1e293b;
                --content-bg: #f8fafc;
                --text-main: #0f172a;
                --text-muted: #64748b;
                --border-color: #e2e8f0;
            }

            body {
                margin: 0;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: var(--content-bg);
                display: flex;
                height: 100vh;
                overflow: hidden;
            }

            /* --- Sidebar Styling --- */
            .sidebar {
                width: 260px;
                background-color: var(--sidebar-bg);
                color: white;
                display: flex;
                flex-direction: column;
                padding: 0;
                flex-shrink: 0;
            }

            .logo-section {
                padding: 30px 20px;
                background: rgba(0,0,0,0.2);
                display: flex;
                align-items: center;
                gap: 12px;
            }

            .logo-section i {
                font-size: 24px;
                color: #38bdf8;
            }

            .nav-links {
                list-style: none;
                padding: 20px 10px;
                margin: 0;
                flex-grow: 1;
            }

            .nav-links li {
                margin-bottom: 8px;
            }

            .nav-links a {
                color: #cbd5e1;
                text-decoration: none;
                display: flex;
                align-items: center;
                gap: 12px;
                padding: 12px 15px;
                border-radius: 8px;
                transition: 0.2s;
                font-size: 15px;
            }

            .nav-links a:hover, .nav-links li.active a {
                background: var(--primary-blue);
                color: white;
            }

            .logout-section {
                padding: 20px;
                border-top: 1px solid rgba(255,255,255,0.1);
            }

            /* --- Main Content Area --- */
            .main-content {
                flex-grow: 1;
                padding: 40px;
                overflow-y: auto;
            }

            .header {
                margin-bottom: 35px;
            }

            .header h1 {
                margin: 0;
                color: var(--text-main);
                font-size: 28px;
            }

            .header p {
                color: var(--text-muted);
                margin: 5px 0 0;
            }

            /* --- Statistics Row --- */
            .stats-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
                gap: 25px;
                margin-bottom: 35px;
            }

            .stat-card {
                background: white;
                padding: 20px 25px;
                border-radius: 16px;
                box-shadow: 0 1px 3px rgba(0,0,0,0.05), 0 1px 2px rgba(0,0,0,0.05);
                display: flex;
                align-items: center;
                gap: 20px;
            }

            .icon-box {
                width: 56px;
                height: 56px;
                border-radius: 12px;
                display: flex;
                justify-content: center;
                align-items: center;
                font-size: 22px;
            }

            .blue-box { background: #eff6ff; color: #2563eb; }
            .green-box { background: #f0fdf4; color: #16a34a; }
            .purple-box { background: #faf5ff; color: #9333ea; }

            .stat-info p {
                margin: 0;
                color: var(--text-muted);
                font-size: 13px;
                font-weight: 700;
                letter-spacing: 0.5px;
            }

            .stat-info h2 {
                margin: 4px 0 0;
                font-size: 24px;
                color: var(--text-main);
            }

            /* --- Two Column Layout below metrics --- */
            .dashboard-grid {
                display: grid;
                grid-template-columns: 2fr 1fr;
                gap: 25px;
            }

            .content-card {
                background: white;
                padding: 25px;
                border-radius: 16px;
                box-shadow: 0 1px 3px rgba(0,0,0,0.05), 0 1px 2px rgba(0,0,0,0.05);
                border: 1px solid #f1f5f9;
            }

            .content-card h3 {
                margin-top: 0;
                color: var(--text-main);
                font-size: 16px;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            /* --- Table Design --- */
            .custom-table {
                width: 100%;
                border-collapse: collapse;
                text-align: left;
                font-size: 14px;
            }

            .custom-table th {
                padding: 12px;
                color: var(--text-muted);
                border-bottom: 2px solid var(--border-color);
                font-weight: 600;
            }

            .custom-table td {
                padding: 14px 12px;
                color: var(--text-main);
                border-bottom: 1px solid var(--border-color);
            }

            /* --- Action Panels --- */
            .shortcut-list {
                display: flex;
                flex-direction: column;
                gap: 12px;
            }

            .shortcut-btn {
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 14px 18px;
                background: #f8fafc;
                border: 1px solid var(--border-color);
                border-radius: 10px;
                color: var(--text-main);
                text-decoration: none;
                font-weight: 600;
                font-size: 14px;
                transition: all 0.2s;
            }

            .shortcut-btn:hover {
                background: #eff6ff;
                border-color: #bfdbfe;
                color: var(--primary-blue);
                transform: translateX(4px);
            }

            .shortcut-btn i.arrow {
                font-size: 12px;
                color: var(--text-muted);
            }
        </style>
    </head>
    <body>

        <aside class="sidebar">
            <div class="logo-section">
                <i class="fas fa-prescription-bottle-medical"></i>
                <div>
                    <h3 style="margin:0; font-size: 18px;">PharmaCare</h3>
                    <small style="opacity: 0.6">Admin Portal</small>
                </div>
            </div>

            <ul class="nav-links">
                <li class="active">
                    <a href="dashboard.jsp"><i class="fas fa-chart-line"></i> Dashboard</a>
                </li>
                <li>
                    <a href="MembershipServlet"><i class="fas fa-user-group"></i> Memberships</a>
                </li>
                <li>
                    <a href="medicine.jsp"><i class="fas fa-pills"></i> Medicine List</a>
                </li>
                <li>
                    <a href="inventory.jsp"><i class="fas fa-boxes-stacked"></i> Inventory</a>
                </li>
                <li>
                    <a href="manageOrder.jsp"><i class="fas fa-truck-ramp-box"></i>Orders</a>
                </li>
                <li>
                    <a href="PurchaseHistory.jsp"><i class="fas fa-receipt"></i> Purchase History</a>
                </li>
                <li>
                    <a href="PurchaseServlet"><i class="fas fa-cash-register"></i> Counter Sale</a>
                </li>
                
            </ul>

            <div class="logout-section">
                <a href="login.jsp" style="color: #fca5a5; text-decoration: none; display: flex; align-items: center; gap: 10px;">
                    <i class="fas fa-sign-out-alt"></i> Sign Out
                </a>
            </div>
        </aside>

        <main class="main-content">
            <header class="header">
                <h1>Dashboard Overview</h1>
                <p>Welcome back! Here is a summary of the pharmacy status.</p>
            </header>

            <%-- Extract Dynamic Metric Counters sent by the Servlet --%>
            <%
                Integer totalMeds = (Integer) request.getAttribute("totalMeds");
                Double revenue = (Double) request.getAttribute("revenue");
                Integer memberCount = (Integer) request.getAttribute("memberCount");
                
                // Fallbacks to default database setup benchmarks if accessed cleanly 
                int displayMeds = (totalMeds != null) ? totalMeds : 0;
                double displayRev = (revenue != null) ? revenue : 0.0;
                
                //update logic card
                int displayMembers = 0;
                
                /* if (memberCount != null) {
                    displayMembers = memberCount;
                } else {
                    try {
                        MembershipDAO mDao = new MembershipDAO();
                        displayMembers = mDao.getActiveMembersCount();
                    } catch(Exception e) {
                        displayMembers = 0; // Mengelakkan crash jika table belum siap sepenuhnya
                    }
                }  */
            %>

            <div class="stats-grid">
                <div class="stat-card">
                    <div class="icon-box blue-box">
                        <i class="fas fa-capsules"></i>
                    </div>
                    <div class="stat-info">
                        <p>TOTAL MEDICINES</p>
                        <h2><%= displayMeds %></h2>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="icon-box green-box">
                        <i class="fas fa-dollar-sign"></i>
                    </div>
                    <div class="stat-info">
                        <p>TODAY'S REVENUE</p>
                        <h2>RM <%= String.format("%.2f", displayRev) %></h2>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="icon-box purple-box">
                        <i class="fas fa-id-card"></i>
                    </div>
                    <div class="stat-info">
                        <p>ACTIVE MEMBERS</p>
                        <h2><%= displayMembers %></h2>
                    </div>
                </div>
            </div>

            <div class="dashboard-grid">
                
                <div class="content-card">
                    <h3><i class="fas fa-clock" style="color: var(--primary-blue)"></i> Recent Active Counter Movements</h3>
                    <table class="custom-table">
                        <thead>
                            <tr>
                                <th>Transaction ID</th>
                                <th>Item Code</th>
                                <th>Qty Ordered</th>
                                <th>Final Charged Price</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%-- This can be populated using database attributes or left as an clean placeholder list --%>
                            <tr>
                                <td>#TXN-9082</td>
                                <td>Amoxicillin 500mg</td>
                                <td>2 Packets</td>
                                <td style="font-weight: 600; color: var(--text-main);">RM 24.00</td>
                            </tr>
                            <tr>
                                <td>#TXN-9081</td>
                                <td>Paracetamol 500mg</td>
                                <td>1 Sheet</td>
                                <td style="font-weight: 600; color: var(--text-main);">RM 6.50</td>
                            </tr>
                            <tr>
                                <td>#TXN-9080</td>
                                <td>Metformin 850mg</td>
                                <td>3 Bottles</td>
                                <td style="font-weight: 600; color: var(--text-main);">RM 45.00</td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div class="content-card">
                    <h3><i class="fas fa-bolt" style="color: #eab308"></i> Terminal Operations</h3>
                    <div class="shortcut-list">
                        <a href="PurchaseServlet" class="shortcut-btn">
                            <span><i class="fas fa-cash-register" style="margin-right: 8px; color: var(--primary-blue)"></i> Launch Counter Register Sale</span>
                            <i class="fas fa-chevron-right arrow"></i>
                        </a>
                        <a href="manageOrder.jsp" class="shortcut-btn">
                            <span><i class="fas fa-truck-ramp-box" style="margin-right: 8px; color: #f59e0b"></i> Manage Procurement Orders</span>
                            <i class="fas fa-chevron-right arrow"></i>
                        </a>
                        
                        <a href="medicine.jsp" class="shortcut-btn">
                            <span><i class="fas fa-pills" style="margin-right: 8px; color: #10b981"></i> Update Drug Listings</span>
                            <i class="fas fa-chevron-right arrow"></i>
                        </a>
                        <a href="PurchaseServlet?action=viewHistory" class="shortcut-btn">
                            <span><i class="fas fa-receipt" style="margin-right: 8px; color: #8b5cf6"></i> Pull Audited Invoice Records</span>
                            <i class="fas fa-chevron-right arrow"></i>
                        </a>
                    </div>
                </div>

            </div>
        </main>
    </body>
</html>