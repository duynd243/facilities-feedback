<%-- 
    Document   : employee
    Created on : Sep 23, 2021, 9:40:20 AM
    Author     : Duy
--%>

<%@page import="googleuser.Constant"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        
        <meta name="google-signin-client_id" content="<%=Constant.GOOGLE_CLIENT_ID%>">
        <script src="https://apis.google.com/js/platform.js" async defer></script>

        
        
    </head>
    <body>

        <div style="display: none" class="g-signin2" data-onsuccess="onSignIn" data-prompt="select_account"></div>
        <a  href="MainController?action=Log out" onclick="signOut()">Sign out</a>
        <script>
            function signOut() {
                var auth2 = gapi.auth2.getAuthInstance();
                auth2.signOut().then(function () {
                    console.log('User signed out.');
                });
            }
         
        </script>
        
    </body>
</html>
