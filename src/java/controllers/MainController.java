package controllers;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Duy
 */
@WebServlet(name = "MainController", urlPatterns = {"/MainController"})
@MultipartConfig
public class MainController extends HttpServlet {

    private static final String ERROR = "error.jsp";
    private static final String LOGOUT = "logout";
    private static final String SEND_FEEDBAK = "send-feedback";
    private static final String DELETE_FEEDBACK = "delete-feedback";
    private static final String ASSIGN_EMPLOYEE = "assign-employee";
    private static final String SEARCH_EMPLOYEE = "search-employee";
    private static final String SEARCH_USER = "search-user";
    private static final String BLOCK_USER = "block-user";
    private static final String UNBLOCK_USER = "unblock-user";
    private static final String CHANGE_DEPARTMENT = "change-department";
    private static final String SEND_REPORT = "send-report";
    private static final String DECLINE_REPORT = "decline-report";
    private static final String APPROVE_REPORT = "approve-report";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        String url = ERROR;
        try {
            String action = request.getParameter("action");
            if ("Log out".equals(action)) {
                url = LOGOUT;
            } else if ("Send".equals(action)) {
                url = SEND_FEEDBAK;
            } else if ("DeleteFeedback".equals(action)) {
                url = DELETE_FEEDBACK;
            } else if ("AssignEmployee".equals(action)) {
                url = ASSIGN_EMPLOYEE;
            } else if ("SearchEmployee".equals(action)) {
                url = SEARCH_EMPLOYEE;
            } else if ("SearchUser".equals(action)) {
                url = SEARCH_USER;
            } else if ("BlockUser".equals(action)) {
                url = BLOCK_USER;
            } else if ("UnblockUser".equals(action)) {
                url = UNBLOCK_USER;
            } else if ("ChangeDepartment".equals(action)) {
                url = CHANGE_DEPARTMENT;
            } else if ("SendReport".equals(action)) {
                url = SEND_REPORT;
            } else if ("DeclineReport".equals(action)) {
                url = DECLINE_REPORT;
            } else if ("RateReport".equals(action)) {
                url = APPROVE_REPORT;
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("ERROR_MESSAGE", "Function is not avaiable");
            }
        } catch (Exception e) {
            log("Error at MainController:" + e.toString());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
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
