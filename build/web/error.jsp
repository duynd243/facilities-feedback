<%-- 
    Document   : error
    Created on : Sep 23, 2021, 5:14:36 PM
    Author     : Duy
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Error Page</title>
    </head>
    <body>
        <h1>Error: <%= session.getAttribute("ERROR_MESSAGE")%></h1>
    </body>
</html>

