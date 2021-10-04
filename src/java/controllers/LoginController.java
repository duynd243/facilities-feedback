/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controllers;

import googleuser.GoogleUserDAO;
import googleuser.GoogleUserDTO;
import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import utils.GoogleUtils;

/**
 *
 * @author Duy
 */
public class LoginController extends HttpServlet {

    private static final String MANAGER_PAGE = "manager.jsp";
    private static final String EMPLOYEE_PAGE = "employee.jsp";
    private static final String USER_PAGE = "send-feedback.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String id_token = request.getParameter("id_token");
        GoogleUserDTO user = GoogleUtils.getUserInfo(id_token);

        if (user.getHd() != null && user.getHd().equals("fpt.edu.vn")) {

            GoogleUserDAO userDAO = new GoogleUserDAO();
            String roleID = "";
            try {
                roleID = userDAO.checkLogin(user.getEmail());
            } catch (Exception e) {
                e.printStackTrace();
            }

            RequestDispatcher rd = null;

            if (!roleID.isEmpty()) {
                user.setRoleID(roleID);
            }
            if ("MG".equals(roleID)) {
                rd = request.getRequestDispatcher(MANAGER_PAGE);
            } else if ("EP".equals(roleID)) {
                rd = request.getRequestDispatcher(EMPLOYEE_PAGE);
            } else if ("US".equals(roleID)) {
                rd = request.getRequestDispatcher(USER_PAGE);
            } else if (roleID.isEmpty()) {
                try {
                    user.setRoleID("US");
                    userDAO.addNewUser(user);
                } catch (Exception e) {
                    e.printStackTrace();
                }
                rd = request.getRequestDispatcher(USER_PAGE);
            }

            HttpSession session = request.getSession();
            session.setAttribute("LOGGED_IN_USER", user);
            rd.forward(request, response);
        } else {
            request.setAttribute("ERROR", "email");
            request.getRequestDispatcher("login-error.jsp").forward(request, response);
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
