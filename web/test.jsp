<%-- 
    Document   : test
    Created on : Oct 19, 2021, 7:16:24 AM
    Author     : Duy
--%>

<%@page import="googleuser.GoogleUserDTO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="department.DepartmentDTO"%>
<%@page import="java.util.HashMap"%>
<%@page import="department.DepartmentDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <% DepartmentDAO dao = new DepartmentDAO();%>
        <%HashMap<DepartmentDTO, ArrayList<GoogleUserDTO>> hm = dao.LoadDepartmentsAndEmployees(); %>
        
        
        <% for (DepartmentDTO dep: hm.keySet()) { %>
            
                <%= dep.getDepName() %>
            
        <% } %>
        
        <% for (ArrayList<GoogleUserDTO> l: hm.values()) { %>
            <% for (GoogleUserDTO user:l) { %>
                <%= user %>
            <% } %>
        <% } %>
    </body>
</html>
