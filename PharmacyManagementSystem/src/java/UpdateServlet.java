import com.lab.dao.pharmacyUserDAO;
import com.lab.model.theusersDAO;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/UpdateServlet")
public class UpdateServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet UpdateServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UpdateServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        // get username
        String username = request.getParameter("username");
        
        if(username != null && !username.trim().isEmpty()) {
           pharmacyUserDAO dao = new pharmacyUserDAO(); 
           theusersDAO existingUser = dao.getUserByUsername(username);

            if(existingUser != null) {
                out.println("<html><body>"); 
                out.println("<h2>Update User: " + username + "</h2>");
                out.println("<form action='UpdateServlet' method='POST'>"); 
                
                // FIXED: Added the input fields so you can actually edit the data!
                out.println("Username (Read-Only): <input type='text' name='username' value='" + existingUser.getUsername() + "' readonly><br><br>");
                out.println("Full Name: <input type='text' name='fullName' value='" + existingUser.getFullName() + "' required><br><br>");
                out.println("Email: <input type='email' name='email' value='" + existingUser.getEmail() + "' required><br><br>");
                out.println("Password: <input type='text' name='password' value='" + existingUser.getPassword() + "' required><br><br>");
                
                out.println("<input type='submit' value='Save Changes'>"); 
                out.println("</form>");
                out.println("</body></html>");
                
            } else {
                out.println("User not found");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String username = request.getParameter("username");
        String password = request.getParameter("password"); 
        String email = request.getParameter("email");
        
        theusersDAO updatedUser = new theusersDAO();
        updatedUser.setFullName(fullName);
        updatedUser.setUsername(username);
        updatedUser.setPassword(password);
        updatedUser.setEmail(email);
        
        pharmacyUserDAO dao = new pharmacyUserDAO(); 
        boolean isSuccess = dao.updateUser(updatedUser); 
       
        if(isSuccess) {
            response.sendRedirect("ViewServlet");
        } else {
            response.getWriter().println("<h3>Could not update the user</h3>"); // Fixed the typo in the closing tag here too
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}