/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controllers;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import feedback.FeedbackDAO;
import feedback.FeedbackDTO;
import image.ImageDAO;
import image.ImageDTO;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import utils.ConfigUtils;
import utils.TimeUtils;

/**
 *
 * @author Duy
 */
@WebServlet(name = "SendFeedbackController", urlPatterns = {"/send-feedback"})
@MultipartConfig
public class SendFeedbackController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        try {
            String sentTime = TimeUtils.currentTimeString();
            String senderEmail = request.getParameter("senderEmail");
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            int roomNumber = Integer.parseInt(request.getParameter("roomNumber"));
            String facilityID = request.getParameter("facilityID");

            FeedbackDTO newFeedback = new FeedbackDTO(senderEmail, title, description, sentTime, roomNumber, facilityID);
            FeedbackDAO feedbackDAO = new FeedbackDAO();
            ImageDAO imageDAO = new ImageDAO();

            String feedbackID = feedbackDAO.addFeedback(newFeedback);

            String cloud_name = ConfigUtils.CL_NAME;
            String api_key = ConfigUtils.CL_API_KEY;
            String api_secret = ConfigUtils.CL_API_SECRET;

            Cloudinary cloudinary = new Cloudinary(ObjectUtils.asMap(
                    "cloud_name", cloud_name,
                    "api_key", api_key,
                    "api_secret", api_secret));

            ArrayList<ImageDTO> imagesList = new ArrayList<>();

            // Upload image to CDN -> Get and insert image url to DB
            for (Part part : request.getParts()) {
                String fileName = part.getSubmittedFileName();
                if (fileName != null) {
                    Map uploadResult = cloudinary.uploader().upload(part.getInputStream().readAllBytes(), ObjectUtils.emptyMap());
                    String imageURL = (String) uploadResult.get("url");
                    imagesList.add(new ImageDTO(imageURL, feedbackID));
                }
            }

            imageDAO.insertFeedbackImages(imagesList);

        } catch (Exception e) {
            log("Error at SendFeedbackController" + e.toString());
        } finally {
            response.sendRedirect("send-feedback.jsp?status=success");
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