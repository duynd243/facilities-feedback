<%-- 
    Document   : send-feedback
    Created on : Sep 23, 2021, 5:00:41 PM
    Author     : Duy
--%>

<%@page import="facilities.FacilityDAO"%>
<%@page import="image.ImageDAO"%>
<%@page import="image.ImageDTO"%>
<%@page import="utils.TimeUtils"%>
<%@page import="feedback.FeedbackDTO"%>
<%@page import="feedback.FeedbackDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="facilities.FacilityDTO"%>
<%@page import="googleuser.GoogleUserDTO"%>
<%@page import="googleuser.Constant"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<% GoogleUserDTO loggedInUser = (GoogleUserDTO) session.getAttribute("LOGGED_IN_USER"); %>
<% FacilityDAO facilityDAO = new FacilityDAO();%>
<% ArrayList<FacilityDTO> facilitiesList = (ArrayList<FacilityDTO>) facilityDAO.getAllFacilities();%>
<% ArrayList<FeedbackDTO> feedbackList1 = (ArrayList<FeedbackDTO>) FeedbackDAO.getListFeedback(loggedInUser, 1); %>
<% ArrayList<FeedbackDTO> feedbackList2 = (ArrayList<FeedbackDTO>) FeedbackDAO.getListFeedback(loggedInUser, 2); %>
<% ArrayList<FeedbackDTO> feedbackList3 = (ArrayList<FeedbackDTO>) FeedbackDAO.getListFeedback(loggedInUser, 3);%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <meta name="google-signin-client_id" content="<%=Constant.GOOGLE_CLIENT_ID%>">
        <script src="https://apis.google.com/js/platform.js" async defer></script>


        <script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
        <script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>
        <link
            href="https://fonts.googleapis.com/css?family=Material+Icons|Material+Icons+Outlined|Material+Icons+Two+Tone|Material+Icons+Round|Material+Icons+Sharp"
            rel="stylesheet">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300&display=swap" rel="stylesheet">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Noto+Sans&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="css/style-send-feedback.css">
        <link rel="stylesheet" href="css/toast.css">
        <script src="js/toast.js"></script>

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">


        <script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
        <script>
            function signOut() {
                var auth2 = gapi.auth2.getAuthInstance();
                auth2.signOut().then(function () {
                    console.log('User signed out.');
                });
            }

            function showSuccessToast() {
                toast({
                    title: "Success!",
                    message: "Your feedback has been sent.",
                    type: "success",
                    duration: 5000
                });
            }

            function onloadFunction() {
                var post = document.getElementById("postStatus").value;

                if (post == 'success') {
                    selectSidebarMenu('m2', 'sent-feedback');
                    showSuccessToast();
                }
            }

        </script>
    </head>
    <body onload="onloadFunction()">

        <% if (request.getAttribute("STATUS") != null) {%>
        <input id="postStatus" type="hidden" value="<%=request.getAttribute("STATUS")%>">
        <%}%>

        <div id="toast"></div>
        <div style="display: none" class="g-signin2" data-onsuccess="onSignIn" data-prompt="select_account"></div>

        <header>
            <div class="header-left">
                <img class="fptlogo" src="images/fpt.png">
                <div id="logo-text">Facilities Feedback</div>
            </div>
            <div class="header-right">
                <div><i class="material-icons" style="font-size: 26px;">notifications_none</i></div>



                <div class="dropdown">
                    <img src="<%=loggedInUser.getPicture()%>"
                         class="profile-picture dropbtn" onclick="myFunction()">

                    <div id="myDropdown" class="dropdown-content">
                        <div class="info">
                            <img
                                src="<%=loggedInUser.getPicture()%>">
                            <div><%=loggedInUser.getName()%></div>
                        </div>

                        <div class="sign-out">
                            <a id="signoutlink" href="MainController?action=Log out" onclick="signOut()"><i class="fa fa-sign-out" aria-hidden="true" style="margin-right: 10px;"></i>Sign out</a>
                        </div>
                    </div>
                </div>

                <script>
                    function myFunction() {
                        document.getElementById("myDropdown").classList.toggle("show");
                    }

                    // Close the dropdown if the user clicks outside of it
                    window.onclick = function (event) {
                        if (!event.target.matches('.dropbtn')) {
                            var dropdowns = document.getElementsByClassName("dropdown-content");
                            var i;
                            for (i = 0; i < dropdowns.length; i++) {
                                var openDropdown = dropdowns[i];
                                if (openDropdown.classList.contains('show')) {
                                    openDropdown.classList.remove('show');
                                }
                            }
                        }
                    }



                    function selectSidebarMenu(id, item) {
                        var i;
                        var x = document.getElementsByClassName("sbcontent");
                        for (i = 0; i < x.length; i++) {
                            x[i].style.display = "none";
                        }
                        document.getElementById(item).style.display = "block";
                        var current = document.getElementsByClassName("sbbutton-active");
                        current[0].className = current[0].className.replace(" sbbutton-active", "");
                        document.getElementById(id).className += " sbbutton-active";
                    }


                    function selectFeedbackCategory(id, item) {
                        var i;
                        var x = document.getElementsByClassName("feedback-category-content");
                        for (i = 0; i < x.length; i++) {
                            x[i].style.display = "none";
                        }
                        document.getElementById(item).style.display = "block";
                        var current = document.getElementsByClassName("cate-active");
                        current[0].className = current[0].className.replace(" cate-active", "");
                        document.getElementById(id).className += " cate-active";
                    }

                    $(document).ready(function () {
                        var $txtArea = $('textarea');
                        var $chars = $('#chars-remain');
                        var textMax = $txtArea.attr('maxlength');
                        $chars.html(textMax + ' characters remaining');
                        $txtArea.on('keyup', countChar);
                        function countChar() {
                            var textLength = $txtArea.val().length;
                            var textRemaining = textMax - textLength;
                            $chars.html(textRemaining + ' characters remaining');
                        }
                        ;
                    });
                </script>




            </div>
        </header>

        <main>
            <div class="sidebar-menu">
                <div class="welcome">
                    <img class="picture"
                         src="<%=loggedInUser.getPicture()%>">
                    <div class="name"><%=loggedInUser.getName()%></div>
                    <button class="role">Reporter</button>
                </div>
                <div class="buttons">
                    <button class="sbbutton sbbutton-active" id="m1" onclick="selectSidebarMenu(this.id, 'new-feedback')"><i
                            class="material-icons">add</i>New feedback</button>
                    <button class="sbbutton" id="m2" onclick="selectSidebarMenu(this.id, 'sent-feedback')"><i
                            class="material-icons">format_list_bulleted</i>Sent feedbacks</button>
                </div>
            </div>
            <div class="content">
                <div class="sbcontent" id="new-feedback">
                    <form action="MainController" method="POST" enctype="multipart/form-data">
                        <input type="hidden" name="senderEmail" value="<%=loggedInUser.getEmail()%>">
                        <div class="ilabel">Title</div>
                        <div style="display: flex;">
                            <input type="text" name="title" class="title"maxlength="150" placeholder="Enter your title here..." required>
                        </div>

                        <div class="ilabel">Desciption</div>
                        <div style="display: flex; justify-content: center;">
                            <textarea name="desciption" maxlength="3000" placeholder="Tell us detail problem..."
                                      required></textarea>
                        </div>
                        <span id="chars-remain"></span>

                        <div class="ilabel" style="margin-top: 30px;">Choose facility</div>

                        <div class="facilities" style ="margin: 0 1.875vw;display: grid;grid-template-columns: repeat(<%=facilitiesList.size()%>, 1fr);grid-template-rows: 1;gap: 20px;">
                            <% int i = 0; %>
                            <% for (FacilityDTO f : facilitiesList) {
                                    i++;%>
                            <input type="radio" id="facility<%=i%>" name="facilityID" class="facilityID" value="<%=f.getFacilityID()%>" required>
                            <label style="grid-column: <%=i%>;" id="radio-label" for="facility<%=i%>">
                                <div class="label-box"><%=f.getFacilityName()%></div>
                            </label>
                            <%}%>
                        </div>

                        <div style="display: flex;">
                            <div style="width: 50%;">
                                <div class="ilabel">Location</div>
                                <input type="number" name="roomNumber" min="1" max="50" placeholder="Enter room number..." required>
                            </div>

                            <div style="width: 50%;">
                                <div class="ilabel">Attach Images</div>
                                <div style="display: flex; align-items: center;">
                                    <label for="images">
                                        <div class="upload-button"><i class="material-icons"
                                                                      style="margin-right: 10px;">add_photo_alternate</i>
                                            <div>Upload your images</div>
                                        </div>
                                    </label>
                                    <input type="file" name="images" id="images" required="required" multiple="multiple"
                                           accept="image/png, image/jpeg" />
                                </div>
                                <script>
                                    $(function () {
                                        $("button[type = 'submit']").click(function () {
                                            var $fileUpload = $("input[type='file']");
                                            if (parseInt($fileUpload.get(0).files.length) > 2) {
                                                alert("You are only allowed to upload a maximum of 2 files");
                                                return false;
                                            }
                                        });
                                    });
                                </script>
                            </div>
                        </div>
                        <button type="submit" class="send" name="action" value="Send">
                            <i class="material-icons" id="send-icon" style="margin-right: 10px;">send</i>
                            <div>
                                Send feedback
                            </div>
                        </button>
                    </form>


                </div>
                <div class="sbcontent" id="sent-feedback" style="display: none;">
                    <div class="feedback-category-bar">
                        <button id="f1" class="feedback-category cate-active"
                                onclick="selectFeedbackCategory(id, 'pending-content')">
                            <ion-icon name="hourglass-outline"></ion-icon>
                            Pending
                            <div class="badge-num"><%=feedbackList1.size()%></div>
                        </button>
                        <button id="f2" class="feedback-category"
                                onclick="selectFeedbackCategory(id, 'processing-content')">
                            <ion-icon name="hammer-outline"></ion-icon>Processing <div class="badge-num"><%=feedbackList2.size()%></div>
                        </button>
                        <button id="f3" class="feedback-category" onclick="selectFeedbackCategory(id, 'completed-content')">
                            <ion-icon name="checkmark-done-outline"></ion-icon>Completed
                            <div class="badge-num"><%=feedbackList3.size()%></div>
                        </button>
                    </div>

                    <div class="feedback-category-content" id="pending-content">

                        <% if (feedbackList1.size() != 0) {%>
                        <% for (FeedbackDTO f1 : feedbackList1) {%>
                        <%String feedbackID = f1.getFeedbackID().trim();%>
                        <div class="pending-item feedback-item" onclick="openFeedback('<%=feedbackID%>', this.className)">
                            <div class="item-left">
                                <img class="feedback-profilepic-list"
                                     src="<%=loggedInUser.getPicture().trim()%>">
                                <div class="title-description">
                                    <div class="feedback-title-list"><%=f1.getTitle().trim()%></div>
                                    <div class="feedback-description-list"><%=f1.getDescription().trim()%></div>
                                </div>
                            </div>
                            <div class="item-right">
                                <div class="location-time">
                                    <div class="feedback-location-list">
                                        <ion-icon name="location"></ion-icon>Room <%=f1.getRoomNumber()%>
                                    </div>
                                    <div class="feedback-senttime-list"><%=TimeUtils.renderedTime(f1.getSentTime().trim())%></div>
                                </div>
                            </div>
                        </div>

                        <div id="<%=f1.getFeedbackID().trim()%>" class="feeback-post" style="display: none;">
                            <div onclick="wayBack('<%=feedbackID%>', 'pending-item')" class="fbp-back">
                                <i class="material-icons-outlined">chevron_left</i>
                                Back
                            </div>
                            <h1 class="fbp-title"><%=f1.getTitle().trim()%></h1>

                            <div class="fbp-aftertitle">
                                <div class="sender-time">
                                    <img class="fbp-profilepic"
                                         src="https://lh3.googleusercontent.com/a/AATXAJxPxz0xf1QV3YjGMZIava1b17obCvA-MTsxBRLj=s96-c">
                                    <div>Sent by You (<%=loggedInUser.getEmail().trim()%>)</br>at <%=TimeUtils.renderedTime(f1.getSentTime().trim())%></div>
                                </div>
                                <div class="facility-location">
                                    <div class="fbp-facility" style="display: flex; align-items: center;">
                                        <i class="material-icons">widgets</i>
                                        <div>
                                            <% String facilityName = ""; %> 
                                            <%for (FacilityDTO facility : facilitiesList) {%>
                                            <% if (facility.getFacilityID().equals(f1.getFacilityID())) {
                                                    facilityName = facility.getFacilityName();
                                                } %>
                                            <%}%>
                                            <b>Facility</b><br><%=facilityName%>
                                        </div>
                                    </div>
                                    <div class="fbp-location" style="display: flex; align-items: center;">
                                        <i class="material-icons">house</i>
                                        <div>
                                            <b>Location</b><br>Room <%=f1.getRoomNumber()%>
                                        </div>
                                    </div>

                                </div>
                            </div>

                            <hr style="height:1.5px; border:none; background-color:#ddd; margin-bottom: 20px;">
                            <img class="fbp-image"
                                 src="https://hcmuni.fpt.edu.vn/Data/Sites/1/media/2020-kim-vi/seo/campus/1-truong-dai-hoc-fpt-tphcm/truong-dai-hoc-fpt-tp-hcm-(1).jpg"
                                 alt="">
                            <p class="fbp-description"><%=f1.getDescription().trim()%></p>
                        </div>        

                        <%}
                        } else { %> 
                        <div class="empty-feedback"
                             style="display: flex; flex-direction: column; align-items: center; justify-content: space-around; height: 408px;">
                            <i style="font-size: 220px; color: #ddd;" class="material-icons">inbox</i>
                            <p style="font-family: Arial, Helvetica, sans-serif; font-size: 32px;color: rgb(100, 95, 95);">
                                There are no feedbacks for this section.</p>

                        </div>
                        <%}%>

                    </div>

                    <script>
                        function openFeedback(itemToShow, classToHide) {
                            var i;
                            var index = classToHide.indexOf(' ');
                            var classToHide2 = classToHide.substring(0, index);
                            var x = document.getElementsByClassName(classToHide2);
                            for (i = 0; i < x.length; i++) {
                                x[i].style.display = "none";
                            }
                            document.getElementById(itemToShow).style.display = "block";
                        }

                        function wayBack(itemToHide, classToShow) {
                            var i;
                            var x = document.getElementById(itemToHide);
                            x.style.display = "none";
                            var y = document.getElementsByClassName(classToShow);
                            for (i = 0; i < y.length; i++) {
                                y[i].style.display = "flex";
                            }

                        }
                    </script>
                    <div class="feedback-category-content" id="processing-content" style="display: none;">

                    </div>
                    <div class="feedback-category-content" id="completed-content" style="display: none;">


                    </div>
                </div>
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