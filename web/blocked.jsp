<%-- 
    Document   : blocked
    Created on : Oct 27, 2021, 8:12:48 PM
    Author     : Duy
--%>

<%@page import="googleuser.Constant"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <meta name="google-signin-client_id" content="<%=Constant.GOOGLE_CLIENT_ID%>">
        <script src="https://apis.google.com/js/platform.js" async defer></script>

        <title>Document</title>
        <link rel="stylesheet" href="css/style-blocked.css">

        <script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
        <script>
            function signOut() {
                var auth2 = gapi.auth2.getAuthInstance();
                auth2.signOut().then(function () {
                    console.log('User signed out.');
                });
            }
        </script>
    </head>

    <body>
        <div style="display: none" class="g-signin2" data-onsuccess="onSignIn" data-prompt="select_account"></div>
        <div class="container">
            <span class="title">Oops! You were blocked from the system</span>
            <img src="images/blocked.png" class="img">
            <div class="sendmail" onclick="window.location = 'mailto: help@facilities-feedback.tech'">Email to
                <span>help@facilities-feedback.tech</span>
            </div>
            <div class="logout">
                <a href="MainController?action=Log out" onclick="signOut()">Logout from the page</a>
            </div>
        </div>
    </body>

</html>