<%-- 
    Document   : login-error
    Created on : Sep 23, 2021, 3:57:13 PM
    Author     : Duy
--%>

<%@page import="googleuser.Constant"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Login</title>

        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="css/style-login.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">


        <script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
        <meta name="google-signin-client_id" content="<%=Constant.GOOGLE_CLIENT_ID%>">
        <script>
            function onSignIn(googleUser) {
                var profile = googleUser.getBasicProfile();
                console.log('ID: ' + profile.getId()); // Do not send to your backend! Use an ID token instead.
                console.log('token: ' + googleUser.getAuthResponse().id_token);
                console.log('Name: ' + profile.getName());
                console.log('Image URL: ' + profile.getImageUrl());
                console.log('Email: ' + profile.getEmail()); // This is null if the 'email' scope is not present.
            }


        </script>

        <script src="https://apis.google.com/js/platform.js?onload=renderButton" async defer></script>
    </head>

    <body>
        <header>
            <div class="header-left">
                <img src="images/fpt.png">
                <div id="logo-text">Facilities Feedback</div>
            </div>
            <div class="header-right">
                <div style="display: none"><i class="material-icons"
                                              style=" padding-top: 5px; font-size: 26px;">notifications_none</i></div>
               
                <button style="display: none;" class="login-button"><a href="#"><span>Sign in</span></a></button>
            </div>
        </header>

        <main>
            <div class="login-pane">
                <div class="top">
                    <i class="fa fa-shield" aria-hidden="true" id="fa-shield"></i>

                    <div class="title">ERROR :(</div>
                </div>


                <% String ERROR = (String) request.getAttribute("ERROR"); %>


                <div style="display: none" class="g-signin2" data-onsuccess="onSignIn" data-prompt="select_account"></div>



                <% if (ERROR != null && ERROR.equals("email")) {%>
                <div class="error">Sorry! Only emails belonging to fpt.edu.vn can signin.<br>
                    <div style="display: flex; margin: 5px 0">
                        <a href="login.jsp" onclick="signOut();" style="text-align: center; margin: 0 auto"><i class="fa fa-refresh" aria-hidden="true"></i> Try again</a>
                    </div>
                </div>

                <% }%>


                <script>
                    function signOut() {
                        var auth2 = gapi.auth2.getAuthInstance();
                        auth2.signOut().then(function () {
                            console.log('User signed out.');
                        });

                    }

                </script>
                <button class="goback" onclick="location.href = 'landing.html'"><i class="fa fa-chevron-circle-left" aria-hidden="true" style="margin-right: 10px;"></i>Return to home page</button>

            </div>
        </main>

        <footer>
            <div class="footer-1">
                <img src="images/fpt.png">
                <p>This system helps teachers and students to leave feedback about the damage of equipment and facilities in
                    the classroom quickly, without calling or meeting the technical department directly. Thanks to this
                    system, teaching and learning will not be interrupted for a long time.</p>
            </div>
            <div class="footer-2">
                <div class="contact">
                    <h2>CONTACT US</h2>
                    <p><i class="fa fa-envelope" aria-hidden="true"></i>abc@gmail.com</p>
                    <p><i class="fa fa-phone" aria-hidden="true"></i>0901234567</p>
                </div>
                <div class="address">
                    <h2>ADDRESS</h2>
                    <p><i class="fa fa-map-marker" aria-hidden="true"></i>Lô E2a-7, Đường D1, Khu Công Nghệ Cao, P. Long
                        Thạnh Mỹ,<br>Q.9, TP. Hồ Chí Minh</p>
                </div>
            </div>

        </footer>
    </body>
</html>
