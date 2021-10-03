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
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Map;
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

        FeedbackDTO newFeedback = new FeedbackDTO(senderEmail, title, description, sentTime, roomNumber, facilityID);
        FeedbackDAO feedbackDAO = new FeedbackDAO();
        ImageDAO imageDAO = new ImageDAO();

        String feedbackID = "";
        try {
            feedbackID = feedbackDAO.addFeedback(newFeedback);
        } catch (Exception e) {
            e.printStackTrace();
        }

        Cloudinary cloudinary = new Cloudinary(ObjectUtils.asMap(
                "cloud_name", "dsyy2ay9q",
                "api_key", "248543342141912",
                "api_secret", "yhObRBg3HOuUG_lGMgNzjgg8Dzk"));

        ArrayList<ImageDTO> imagesList = new ArrayList<>();

        // Create images folder
        String path = getServletContext().getRealPath("/images");
        if (!Files.exists(Paths.get(path))) {
            Files.createDirectory(Paths.get(path));
        }

        // Save image to given path -> upload image to CDN -> delete saved image on local -> insert image url to DB
        for (Part part : request.getParts()) {
            String fileName = part.getSubmittedFileName();
            if (fileName != null) {
                part.write(path + "/" + fileName);
                File f = new File(path + "/" + fileName);
                Map uploadResult = cloudinary.uploader().upload(f, ObjectUtils.emptyMap());
                String imageURL = (String) uploadResult.get("url");
                f.delete();
                imagesList.add(new ImageDTO(imageURL, feedbackID));
            }
        }
        try {
            imageDAO.insertFeedbackImages(imagesList);
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("STATUS", "success");
        request.getRequestDispatcher("send-feedback.jsp").forward(request, response);

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
