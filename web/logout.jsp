<%-- 
    Document   : logout
    Created on : Sep 23, 2021, 5:21:28 PM
    Author     : Duy
--%>

<%@page import="googleuser.Constant"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Logout</title>
        <meta name="google-signin-client_id" content="<%=Constant.GOOGLE_CLIENT_ID%>">
        <script src="https://apis.google.com/js/platform.js" async defer></script>


    </head>
    <body>

        <div style="display: none" class="g-signin2" data-onsuccess="onSignIn" data-prompt="select_account"></div>

        <a  href="landing.html" onclick="signOut()" id="autoClickBtn">Sign out</a>

        <div class="g_id_signout" id="signout_button">Sign Out</div>

        <script>
            function signOut() {
                var auth2 = gapi.auth2.getAuthInstance();
                auth2.signOut().then(function () {
                    console.log('User signed out.');
                });
            }

            window.onbeforeunload = function (e) {
                gapi.auth2.getAuthInstance().signOut();
                document.getElementById('autoClickBtn').click();
                
            };
         

        </script>
    </body>
</html>
