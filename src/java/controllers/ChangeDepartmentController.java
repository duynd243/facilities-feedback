package controllers;

import googleuser.GoogleUserDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Duy
 */
@WebServlet(name = "ChangeDepartmentController", urlPatterns = {"/change-department"})
public class ChangeDepartmentController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        boolean success = false;
        try {
            String email = request.getParameter("email");
            int newDepID = Integer.parseInt(request.getParameter("depID"));
            GoogleUserDAO userDAO = new GoogleUserDAO();
            boolean hasProcessingFeedback = userDAO.hasProcessingFeedback(email);

            if (!hasProcessingFeedback) {
                success = userDAO.changeDepartment(email, newDepID);
            }
        } catch (Exception e) {
            log("Error at ChangeDepartmentController" + e.toString());
        } finally {
            if (success) {
                response.sendRedirect("manager.jsp?change-department=success");
            } else {
                response.sendRedirect("manager.jsp?change-department=failed");
            }
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}