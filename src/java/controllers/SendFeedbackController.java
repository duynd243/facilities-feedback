/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controllers;

import feedback.FeedbackDAO;
import feedback.FeedbackDTO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import utils.TimeUtils;

/**
 *
 * @author Duy
 */
@MultipartConfig

public class SendFeedbackController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        String sentTime = TimeUtils.currentTimeString();
        String senderEmail = request.getParameter("senderEmail");
        String title = request.getParameter("title");
        String description = request.getParameter("desciption");
        int roomNumber = Integer.parseInt(request.getParameter("roomNumber"));
        String facilityID = request.getParameter("facilityID");
        
        Part part = request.getPart("images");
        String path = getServletContext().getRealPath("/images");
        String fileName = part.getSubmittedFileName();

        FeedbackDTO newFeedback = new FeedbackDTO(senderEmail, title, description, sentTime, roomNumber, facilityID);
        FeedbackDAO feedbackDAO = new FeedbackDAO();

        String feebbackID = "";
        try {
            feebbackID = feedbackDAO.addFeedback(newFeedback);
        } catch (Exception e) {
            e.printStackTrace();
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
