/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controllers;

import feedback.FeedbackDAO;
import googleuser.GoogleUserDAO;
import java.io.IOException;
import java.util.HashMap;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import utils.DeleteReasonsUtils;

/**
 *
 * @author Duy
 */
@WebServlet(name = "DeleteFeedbackController", urlPatterns = {"/delete-feedback"})
public class DeleteFeedbackController extends HttpServlet {
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        try {
            FeedbackDAO feedbackDAO = new FeedbackDAO();
            GoogleUserDAO userDAO = new GoogleUserDAO();
            HashMap<Integer, String> deleteReasons = (HashMap<Integer, String>) DeleteReasonsUtils.deleteReasons;
            
            String feedbackID = request.getParameter("feedbackID");
            String blockSenderEmail = request.getParameter("blockSenderEmail");
            String reason = "";
            
            int reasonKey = Integer.parseInt(request.getParameter("reason"));
            if (reasonKey == 0) {
                reason = request.getParameter("other-reason");
            } else {
                reason = deleteReasons.get(reasonKey);
            }
            feedbackDAO.deleteFeedback(feedbackID, reason);
            String block = request.getParameter("block");
            if (block.equals("true")) {
                userDAO.blockUser(blockSenderEmail);
            }
            
        } catch (Exception e) {
            log("Error at DeleteFeedbackController" + e.toString());
        } finally {
            response.sendRedirect("manager.jsp?status=delete-success");
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
