package controllers;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import report.ReportDAO;
import utils.TimeUtils;

/**
 *
 * @author Duy
 */
@WebServlet(name = "ApproveReportController", urlPatterns = {"/approve-report"})
public class ApproveReportController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        try {
            String completeTime = TimeUtils.currentTimeString();
            String feedbackID = request.getParameter("feedbackID");
            String reportID = request.getParameter("reportID");
            String handlerEmail = request.getParameter("handlerEmail");
            int rated = Integer.parseInt(request.getParameter("rated"));

            ReportDAO repDAO = new ReportDAO();
            repDAO.ApproveReport(feedbackID, reportID, completeTime, rated, handlerEmail);

        } catch (Exception e) {
            log("Error at ApproveReportController" + e.toString());
        } finally {
            response.sendRedirect("manager.jsp?status=approve-success");
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