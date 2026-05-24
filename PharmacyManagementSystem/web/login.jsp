<%-- 
    Document   : login
    Created on : 22 Apr 2026, 11:16:43
    Author     : sazliosman
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>PharmaCare Portal-Login</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            body {
                background-color: whitesmoke; 
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
                display: flex; 
                justify-content: center; 
                align-items: center; 
                min-height: 100vh; 
                margin: 0; 
                padding: 20px; 
                box-sizing: border-box;
            }
            
            .card { 
                background: white; 
                padding: 40px; 
                border-radius: 12px; 
                box-shadow: 0 10px 25px rgba(0,0,0,0.1);
                width: 100%; 
                max-width: 350px; 
                text-align: center;
            }
            
            .logo-circle {
                background-color: #1d4ed8; 
                color: white; 
                width: 60px; 
                height: 60px; 
                border-radius: 50%;
                display: flex;
                justify-content: center;
                align-items: center;
                margin: 0 auto 20px;
                font-size: 24px;
            }

            .form-group {
                text-align: left;
                margin-bottom: 15px;
            }

            .form-group label {
                display: block;
                margin-bottom: 5px;
                font-weight: 600;
                color: #333;
            }

            .form-group input {
                width: 100%;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 6px;
                box-sizing: border-box; /* Crucial for padding */
            }

            .btn-primary {
                background-color: #1d4ed8;
                color: white;
                border: none;
                padding: 12px;
                width: 100%;
                border-radius: 6px;
                cursor: pointer;
                font-size: 16px;
                font-weight: bold;
                margin-top: 10px;
            }

            .btn-primary:hover {
                background-color: #1e40af;
            }

            .footer-link {
                margin-top: 20px;
                font-size: 14px;
            }
            
            .subtitle { color: #666; margin-bottom: 30px; }
            
            /* error message*/
            .error-box { 
            color: #b91c1c; 
            background-color: #fee2e2;
            padding: 10px;
            border-radius: 6px; 
            margin-bottom: 15px; 
            align-content: font-size 14px;
            }
        </style>
    </head>
         
    <body>
        <div class="card">
                <div class="logo-circle">
                    <i class="fas fa-lock"></i>
                </div>
            
        <h2>PharmaCare Portal</h2>
        <p class="subtitle">Staff Login</p>
        <form action="LoginServlet" method="POST">
   
            <!-- error message(invalid) -->
            <% if(request.getParameter("error")!=null) { %>
            <div class="error-box">
                Invalid username or password. Please try again.
            </div>
            <% } %>
            
         
            <div class="form-group"> 
                <label>Username</label>
                <i class="far fa-user"></i> 
                <input type="text" name="username" placeholder="Enter your username"required>
                <br>
                <label>Password</label>
                <i class="far fa-user"></i> 
                
                <input type="text" name="password" placeholder="Enter your password"required>
              
            </div>
            
            <button type="submit" class="btn-primary">Login</button>
            
        </form>
        
        <div class="footer-link">
            Register for new user <a href="register.jsp">Register here</a>
        </div>
        
    </body>
</html>
