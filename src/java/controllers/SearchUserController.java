package controllers;

import googleuser.GoogleUserDAO;
import googleuser.GoogleUserDTO;
import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Duy
 */
@WebServlet(name = "SearchUserController", urlPatterns = {"/search-user"})
public class SearchUserController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        try {
            String searchName = request.getParameter("keyword").trim();
            int searchStatusID = Integer.parseInt(request.getParameter("block-status"));
            int pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
            GoogleUserDAO userDAO = new GoogleUserDAO();
            ArrayList<GoogleUserDTO> list = userDAO.getListUser(searchName, searchStatusID, pageNumber);
            request.setAttribute("LIST_SEARCHED_USER", list);
            request.setAttribute("SEARCH_USER_PAGENUM", pageNumber);
            request.setAttribute("SEARCH_USER_KEYWORD", searchName);
            request.setAttribute("SEARCH_USER_STATUSID", searchStatusID);
        } catch (Exception e) {
            log("Error at SearchUserController" + e.toString());
        } finally {
            request.getRequestDispatcher("manager.jsp").forward(request, response);
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