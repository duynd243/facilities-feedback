package controllers;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
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
import report.ReportDAO;
import report.ReportDTO;
import utils.ConfigUtils;
import utils.TimeUtils;

/**
 *
 * @author Duy
 */
@WebServlet(name = "SendReportController", urlPatterns = {"/send-report"})
@MultipartConfig
public class SendReportController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        try {
            String time = TimeUtils.currentTimeString();
            String feedbackID = request.getParameter("feedbackID");
            int spentMoney = Integer.parseInt(request.getParameter("spentMoney"));
            String description = request.getParameter("description");

            ReportDTO report = new ReportDTO(1, feedbackID, description, spentMoney, time);
            ReportDAO reportDAO = new ReportDAO();
            ImageDAO imageDAO = new ImageDAO();

            String reportID = reportDAO.addReport(report);

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
                    imagesList.add(new ImageDTO(imageURL, reportID));
                }
            }

            imageDAO.insertReportImages(imagesList);
            
        } catch (Exception e) {
            log("Error at SendReportController" + e.toString());
        } finally {
            response.sendRedirect("employee.jsp?status=success");
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