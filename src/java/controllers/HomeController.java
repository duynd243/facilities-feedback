/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controllers;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import googleuser.GoogleUserDTO;
import javax.servlet.annotation.WebServlet;

/**
 *
 * @author Duy
 */
@WebServlet(name = "HomeController", urlPatterns = {"/home"})
public class HomeController extends HttpServlet {

    private static final String GUEST_PAGE = "landing.html";
    private static final String MANAGER_PAGE = "manager.jsp";
    private static final String EMPLOYEE_PAGE = "employee.jsp";
    private static final String USER_PAGE = "send-feedback.jsp";
    private static final String BLOCKED_USER_PAGE = "blocked.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        GoogleUserDTO loggedInUser = (GoogleUserDTO) session.getAttribute("LOGGED_IN_USER");
        String url = GUEST_PAGE;
        if (loggedInUser != null) {
            String roleID = loggedInUser.getRoleID();

            if ("MG".equals(roleID)) {
                url = MANAGER_PAGE;
            } else if ("EP".equals(roleID)) {
                url = EMPLOYEE_PAGE;
            } else if ("US".equals(roleID)) {
                if (loggedInUser.getStatusID() == 1) {
                    url = USER_PAGE;
                } else if (loggedInUser.getStatusID() == 0) {
                    url = BLOCKED_USER_PAGE;
                }
            }
            request.getRequestDispatcher(url).forward(request, response);
        } else {
            response.sendRedirect(GUEST_PAGE);
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