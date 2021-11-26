<%-- 
    Document   : employee
    Created on : Sep 23, 2021, 9:40:20 AM
    Author     : Duy
--%>

<%@page import="department.DepartmentDAO"%>
<%@page import="image.ImageDTO"%>
<%@page import="utils.TimeUtils"%>
<%@page import="feedback.FeedbackDTO"%>
<%@page import="utils.PaginationUtils"%>
<%@page import="image.ImageDAO"%>
<%@page import="googleuser.GoogleUserDAO"%>
<%@page import="feedback.FeedbackDAO"%>
<%@page import="facilities.FacilityDAO"%>
<%@page import="googleuser.GoogleUserDTO"%>
<%@page import="facilities.FacilityDTO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="googleuser.Constant"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<% GoogleUserDTO loggedInUser = (GoogleUserDTO) session.getAttribute("LOGGED_IN_USER"); %>
<% FacilityDAO facilityDAO = new FacilityDAO();%>
<% FeedbackDAO feedbackDAO = new FeedbackDAO();%>
<% GoogleUserDAO userDAO = new GoogleUserDAO();%>
<% ImageDAO imageDAO = new ImageDAO();%>
<% DepartmentDAO depDAO = new DepartmentDAO();%>


<% ArrayList<FacilityDTO> facilitiesList = (ArrayList<FacilityDTO>) facilityDAO.getAllFacilities();%>


<% int numOfProcessingFeedbacks = feedbackDAO.getNumOfFeedbacksForEmployee(loggedInUser, 2); %>
<% int numOfWaitingFeedbacks = feedbackDAO.getNumOfFeedbacksForEmployee(loggedInUser, 3); %>
<% int numOfCompletedFeedbacks = feedbackDAO.getNumOfFeedbacksForEmployee(loggedInUser, 4); %>


<% int currentPageList1 = 1; %>
<% int currentPageList2 = 1; %>
<% int currentPageList3 = 1; %>

<% int currentPageList = 0; %>
<% int numOfFeedbacks = 0; %>
<% String pageSection = ""; %>


<%!
    public String getSection(String section) {
        String result = "";
        if ("processing".equalsIgnoreCase(section) || "waiting".equalsIgnoreCase(section) || "completed".equalsIgnoreCase(section)) {
            result = section;
        } else {
            result = "processing";
        }
        return result;
    }
%>


<% String section = getSection(request.getParameter("section"));%>
<% String current = request.getParameter("page");%>

<% if ("pending".equalsIgnoreCase(section)) {
        currentPageList1 = PaginationUtils.getCurrentPage(current, PaginationUtils.getNumOfFeedbackPages(numOfProcessingFeedbacks));
    }%>
<% if ("processing".equalsIgnoreCase(section)) {
        currentPageList2 = PaginationUtils.getCurrentPage(current, PaginationUtils.getNumOfFeedbackPages(numOfWaitingFeedbacks));
    }%>
<% if ("waiting".equalsIgnoreCase(section)) {
        currentPageList3 = PaginationUtils.getCurrentPage(current, PaginationUtils.getNumOfFeedbackPages(numOfCompletedFeedbacks));
    }%>

<% ArrayList<FeedbackDTO> feedbackList1 = (ArrayList<FeedbackDTO>) feedbackDAO.getListFeedbackForEmployee(loggedInUser, 2, currentPageList1); %>
<% ArrayList<FeedbackDTO> feedbackList2 = (ArrayList<FeedbackDTO>) feedbackDAO.getListFeedbackForEmployee(loggedInUser, 3, currentPageList2); %>
<% ArrayList<FeedbackDTO> feedbackList3 = (ArrayList<FeedbackDTO>) feedbackDAO.getListFeedbackForEmployee(loggedInUser, 4, currentPageList3);%>


<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Employee</title>
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
        <link href="https://fonts.googleapis.com/css2?family=Rubik:wght@300;400;500&display=swap" rel="stylesheet">



        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300&display=swap" rel="stylesheet">



        <link rel="stylesheet" href="css/checkbox.css">
        <link rel="stylesheet" href="css/style-employee.css">
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

            function showAssignSuccessToast() {
                toast({
                    title: "Success!",
                    message: "Feedback has been assigned.",
                    type: "success",
                    duration: 5000
                });
            }

            function showDeleteSuccessToast() {
                toast({
                    title: "Success!",
                    message: "Feedback has been deleted.",
                    type: "success",
                    duration: 5000
                });
            }

            window.onload = function onloadFunction() {

                var urlParams = new URLSearchParams(window.location.search);


                var section = urlParams.get('section');
                if (section == 'processing') {
                    selectFeedbackCategory('f1', 'processing-content');
                } else if (section == 'waiting') {
                    selectFeedbackCategory('f2', 'waiting-content');
                } else if (section == 'completed') {
                    selectFeedbackCategory('f3', 'completed-content');
                }

                var status = urlParams.get('status');
                if (status == 'success') {
                    selectFeedbackCategory('f2', 'waiting-content');
                }
            }
        </script>
    </head>
    <body>

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
                </script>




            </div> <!--close header-right div-->
        </header>

        <main>
            <div class="sidebar-menu">
                <div class="welcome">
                    <img class="picture"
                         src="<%=loggedInUser.getPicture()%>">
                    <div class="name"><%=loggedInUser.getName()%></div>
                    <button class="role">Employee</button>
                </div>
                <div class="buttons">
                    <button class="sbbutton sbbutton-active" id="m1" onclick="selectSidebarMenu(this.id, 'feedback')"><i
                            class="material-icons">format_list_bulleted</i>Feedbacks</button>

                    <button class="sbbutton" id="m2" onclick="selectSidebarMenu(this.id, 'sent-feedback')"><i
                            class="material-icons-outlined">insert_chart_outlined</i>Dashboard</button>
                </div>
            </div>

            <div class="content">
                <div class="sbcontent" id="feedback">
                    <div class="feedback-category-bar">
                        <button id="f1" class="feedback-category cate-active"
                                onclick="selectFeedbackCategory(id, 'processing-content')">
                            <ion-icon name="hammer-outline"></ion-icon>
                            Processing
                            <div class="badge-num"><%=numOfProcessingFeedbacks%></div>
                        </button>
                        <button id="f2" class="feedback-category"
                                onclick="selectFeedbackCategory(id, 'waiting-content')">
                            <ion-icon name="file-tray-full-outline"></ion-icon>Waiting for approval
                            <div class="badge-num"><%=numOfWaitingFeedbacks%></div>
                        </button>
                        <button id="f3" class="feedback-category"
                                onclick="selectFeedbackCategory(id, 'completed-content')">
                            <ion-icon name="checkmark-done-outline"></ion-icon>Completed
                            <div class="badge-num"><%=numOfCompletedFeedbacks%></div>
                        </button>
                    </div>

                    <div class="feedback-category-content" id="processing-content">
                        <% if (feedbackList1.size() != 0) {%>
                        <% for (FeedbackDTO f : feedbackList1) {%>
                        <%String feedbackID = f.getFeedbackID().trim();%>
                        <%GoogleUserDTO user = userDAO.getUserByFeedbackID(feedbackID);%>
                        <div class="processing-item feedback-item" onclick="openFeedback('<%=feedbackID%>', this.className, 'pagination1')">
                            <div class="item-left">
                                <img class="feedback-profilepic-list"
                                     src="<%=user.getPicture().trim()%>">
                                <div class="title-description">
                                    <div class="feedback-title-list"><%=f.getTitle().trim()%></div>
                                    <div class="feedback-description-list"><%=f.getDescription().trim()%></div>
                                </div>
                            </div>
                            <div class="item-right">
                                <div class="location-time">
                                    <div class="feedback-location-list">
                                        <ion-icon name="location"></ion-icon>Room <%=f.getRoomNumber()%>
                                    </div>
                                    <div class="feedback-senttime-list"><%=TimeUtils.renderedTime(f.getSentTime().trim())%></div>
                                </div>
                            </div>
                        </div>

                        <div id="<%=f.getFeedbackID().trim()%>" class="feeback-post" style="display: none;">
                            <div style="display: flex; align-items: center; justify-content: space-between">
                                <div onclick="wayBack('<%=feedbackID%>', 'processing-item', 'pagination1')" class="fbp-back">
                                    <i class="material-icons-outlined">chevron_left</i>
                                    Back
                                </div>
                                <div class="fbp-action-btn" style="display: flex;">

                                    <button id="fbp-sendreport-btn" class="fbp-btn fbp-sendreport-btn" onclick="openSendReportModal('<%=f.getFeedbackID().trim()%>')">
                                        <span class="material-icons-outlined" style="margin-right: 10px">summarize</span>
                                        Send report
                                    </button>
                                </div>
                            </div>
                            <h1 class="fbp-title"><%=f.getTitle().trim()%></h1>

                            <div class="fbp-aftertitle">
                                <div class="sender-time">
                                    <img class="fbp-profilepic"
                                         src="<%=user.getPicture().trim()%>">
                                    <div>Sent by <%=user.getName().trim()%></br>at <%=TimeUtils.renderedTime(f.getSentTime().trim())%></div>
                                </div>
                                <div class="facility-location">
                                    <div class="fbp-facility" style="display: flex; align-items: center;">
                                        <i class="material-icons">widgets</i>
                                        <div>
                                            <% String facilityName = ""; %> 
                                            <%for (FacilityDTO facility : facilitiesList) {%>
                                            <% if (facility.getFacilityID().equals(f.getFacilityID())) {
                                                    facilityName = facility.getFacilityName();
                                                } %>
                                            <%}%>
                                            <b>Facility</b><br><%=facilityName%>
                                        </div>
                                    </div>
                                    <div class="fbp-location" style="display: flex; align-items: center;">
                                        <i class="material-icons">house</i>
                                        <div>
                                            <b>Location</b><br>Room <%=f.getRoomNumber()%>
                                        </div>
                                    </div>

                                </div>
                            </div>

                            <hr style="height:1.5px; border:none; background-color:#ddd; margin-bottom: 20px;">

                            <% ArrayList<ImageDTO> imagesList = (ArrayList<ImageDTO>) imageDAO.getImagesList(f.getFeedbackID()); %>

                            <% for (ImageDTO image : imagesList) {%>
                            <img class="fbp-image"
                                 src="<%=image.getImageURL()%>"
                                 style="margin: 15px auto;">
                            <%}%>
                            <p class="fbp-description"><%=f.getDescription().trim()%></p>
                        </div>        

                        <%}
                        } else { %> 
                        <div class="empty-feedback"
                             style="display: flex; flex-direction: column; align-items: center; justify-content: space-around; height: 408px;">
                            <img width="480px" src="images/empty.jpg">
                            <p style="font-family: Arial, Helvetica, sans-serif; font-size: 32px;color: rgb(100, 95, 95);">
                                There are no feedbacks for this section.</p>

                        </div>
                        <%}%>



                        <!--PHÂN TRANG-->

                        <div class="pagination-container">
                            <%currentPageList = currentPageList1; %>
                            <%numOfFeedbacks = numOfProcessingFeedbacks; %>
                            <%pageSection = "processing"; %>

                            <% if (PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks) > 1) { %>

                            <div class="pagination" id="pagination1">

                                <%if (currentPageList != 1) {%>
                                <i class="material-icons" id="page-navigation" onclick="location.href = 'employee.jsp?&section=<%=pageSection%>&page=1'">first_page</i> 
                                <%}%>    

                                <% if (PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks) <= 5) { %>
                                <% for (int i = 1; i <= PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks); i++) { %>
                                <% if (currentPageList == i) {%>
                                <button class="active-page"><%=i%></button>
                                <% } else {%>
                                <button><a href="employee.jsp?&section=<%=pageSection%>&page=<%=i%>"><%=i%></a></button>
                                    <% } %>    
                                    <% } %>
                                    <% } else if (PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks) > 5) { %>
                                    <%if (PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks) - (currentPageList + 2) < 0) {%>


                                <% for (int i = PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks) - 5 + 1; i <= PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks); i++) { %>
                                <% if (currentPageList == i) {%>
                                <button class="active-page"><%=i%></button>
                                <% } else {%>
                                <button><a href="employee.jsp?&section=<%=pageSection%>&page=<%=i%>"><%=i%></a></button>
                                    <% } %>    
                                    <% } %>

                                <% } else if (currentPageList - 2 <= 0) {%>

                                <% for (int i = 1; i <= 5; i++) { %>
                                <% if (currentPageList == i) {%>
                                <button class="active-page"><%=i%></button>
                                <% } else {%>
                                <button><a href="employee.jsp?&section=<%=pageSection%>&page=<%=i%>"><%=i%></a></button>
                                    <% } %>    
                                    <% } %>    

                                <%} else {%> 


                                <% for (int i = currentPageList - 2; i <= currentPageList + 2; i++) { %>
                                <% if (currentPageList == i) {%>
                                <button class="active-page"><%=i%></button>
                                <% } else {%>
                                <button><a href="employee.jsp?&section=<%=pageSection%>&page=<%=i%>"><%=i%></a></button>
                                    <% } %>    
                                    <% } %>      


                                <%}%>
                                <% } %>


                                <%if (currentPageList != PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks)) {%>
                                <i class="material-icons" id="page-navigation" onclick="location.href = 'employee.jsp?&section=<%=pageSection%>&page=<%=PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks)%>'">last_page</i> 
                                <%}%>
                            </div>
                            <%}%>
                        </div>
                        <!--PHÂN TRANG-->

                    </div>

                    <div class="feedback-category-content" id="waiting-content" style="display: none;">
                        <% if (feedbackList2.size() != 0) {%>
                        <% for (FeedbackDTO f : feedbackList2) {%>
                        <%String feedbackID = f.getFeedbackID().trim();%>
                        <%GoogleUserDTO user = userDAO.getUserByFeedbackID(feedbackID);%>
                        <div class="waiting-item feedback-item" onclick="openFeedback('<%=feedbackID%>', this.className, 'pagination2')">
                            <div class="item-left">
                                <img class="feedback-profilepic-list"
                                     src="<%=user.getPicture().trim()%>">
                                <div class="title-description">
                                    <div class="feedback-title-list"><%=f.getTitle().trim()%></div>
                                    <div class="feedback-description-list"><%=f.getDescription().trim()%></div>
                                </div>
                            </div>
                            <div class="item-right">
                                <div class="location-time">
                                    <div class="feedback-location-list">
                                        <ion-icon name="location"></ion-icon>Room <%=f.getRoomNumber()%>
                                    </div>
                                    <div class="feedback-senttime-list"><%=TimeUtils.renderedTime(f.getSentTime().trim())%></div>
                                </div>
                            </div>
                        </div>

                        <div id="<%=f.getFeedbackID().trim()%>" class="feeback-post" style="display: none;">
                            <div style="display: flex; align-items: center; justify-content: space-between">
                                <div onclick="wayBack('<%=feedbackID%>', 'waiting-item', 'pagination2')" class="fbp-back">
                                    <i class="material-icons-outlined">chevron_left</i>
                                    Back
                                </div>
                            </div>
                            <h1 class="fbp-title"><%=f.getTitle().trim()%></h1>

                            <div class="fbp-aftertitle">
                                <div class="sender-time">
                                    <img class="fbp-profilepic"
                                         src="<%=user.getPicture().trim()%>">
                                    <div>Sent by <%=user.getName().trim()%></br>at <%=TimeUtils.renderedTime(f.getSentTime().trim())%></div>
                                </div>
                                <div class="facility-location">
                                    <div class="fbp-facility" style="display: flex; align-items: center;">
                                        <i class="material-icons">widgets</i>
                                        <div>
                                            <% String facilityName = ""; %> 
                                            <%for (FacilityDTO facility : facilitiesList) {%>
                                            <% if (facility.getFacilityID().equals(f.getFacilityID())) {
                                                    facilityName = facility.getFacilityName();
                                                } %>
                                            <%}%>
                                            <b>Facility</b><br><%=facilityName%>
                                        </div>
                                    </div>
                                    <div class="fbp-location" style="display: flex; align-items: center;">
                                        <i class="material-icons">house</i>
                                        <div>
                                            <b>Location</b><br>Room <%=f.getRoomNumber()%>
                                        </div>
                                    </div>

                                </div>
                            </div>

                            <hr style="height:1.5px; border:none; background-color:#ddd; margin-bottom: 20px;">

                            <% ArrayList<ImageDTO> imagesList = (ArrayList<ImageDTO>) imageDAO.getImagesList(f.getFeedbackID()); %>

                            <% for (ImageDTO image : imagesList) {%>
                            <img class="fbp-image"
                                 src="<%=image.getImageURL()%>"
                                 style="margin: 15px auto;">
                            <%}%>
                            <p class="fbp-description"><%=f.getDescription().trim()%></p>
                        </div>        

                        <%}
                        } else { %> 
                        <div class="empty-feedback"
                             style="display: flex; flex-direction: column; align-items: center; justify-content: space-around; height: 408px;">
                            <img width="480px" src="images/empty.jpg">
                            <p style="font-family: Arial, Helvetica, sans-serif; font-size: 32px;color: rgb(100, 95, 95);">
                                There are no feedbacks for this section.</p>

                        </div>
                        <%}%>



                        <!--PHÂN TRANG-->

                        <div class="pagination-container">
                            <%currentPageList = currentPageList2; %>
                            <%numOfFeedbacks = numOfWaitingFeedbacks; %>
                            <%pageSection = "waiting"; %>

                            <% if (PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks) > 1) { %>

                            <div class="pagination" id="pagination2">

                                <%if (currentPageList != 1) {%>
                                <i class="material-icons" id="page-navigation" onclick="location.href = 'employee.jsp?&section=<%=pageSection%>&page=1'">first_page</i> 
                                <%}%>    

                                <% if (PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks) <= 5) { %>
                                <% for (int i = 1; i <= PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks); i++) { %>
                                <% if (currentPageList == i) {%>
                                <button class="active-page"><%=i%></button>
                                <% } else {%>
                                <button><a href="employee.jsp?&section=<%=pageSection%>&page=<%=i%>"><%=i%></a></button>
                                    <% } %>    
                                    <% } %>
                                    <% } else if (PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks) > 5) { %>
                                    <%if (PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks) - (currentPageList + 2) < 0) {%>


                                <% for (int i = PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks) - 5 + 1; i <= PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks); i++) { %>
                                <% if (currentPageList == i) {%>
                                <button class="active-page"><%=i%></button>
                                <% } else {%>
                                <button><a href="employee.jsp?&section=<%=pageSection%>&page=<%=i%>"><%=i%></a></button>
                                    <% } %>    
                                    <% } %>

                                <% } else if (currentPageList - 2 <= 0) {%>

                                <% for (int i = 1; i <= 5; i++) { %>
                                <% if (currentPageList == i) {%>
                                <button class="active-page"><%=i%></button>
                                <% } else {%>
                                <button><a href="employee.jsp?&section=<%=pageSection%>&page=<%=i%>"><%=i%></a></button>
                                    <% } %>    
                                    <% } %>    

                                <%} else {%> 


                                <% for (int i = currentPageList - 2; i <= currentPageList + 2; i++) { %>
                                <% if (currentPageList == i) {%>
                                <button class="active-page"><%=i%></button>
                                <% } else {%>
                                <button><a href="employee.jsp?&section=<%=pageSection%>&page=<%=i%>"><%=i%></a></button>
                                    <% } %>    
                                    <% } %>      


                                <%}%>
                                <% } %>


                                <%if (currentPageList != PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks)) {%>
                                <i class="material-icons" id="page-navigation" onclick="location.href = 'employee.jsp?&section=<%=pageSection%>&page=<%=PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks)%>'">last_page</i> 
                                <%}%>
                            </div>
                            <%}%>
                        </div>
                        <!--PHÂN TRANG-->

                    </div>

                    <div class="feedback-category-content" id="completed-content" style="display: none;">
                        <% if (feedbackList3.size() != 0) {%>
                        <% for (FeedbackDTO f : feedbackList3) {%>
                        <%String feedbackID = f.getFeedbackID().trim();%>
                        <%GoogleUserDTO user = userDAO.getUserByFeedbackID(feedbackID);%>
                        <div class="completed-item feedback-item" onclick="openFeedback('<%=feedbackID%>', this.className, 'pagination3')">
                            <div class="item-left">
                                <img class="feedback-profilepic-list"
                                     src="<%=user.getPicture().trim()%>">
                                <div class="title-description">
                                    <div class="feedback-title-list"><%=f.getTitle().trim()%></div>
                                    <div class="feedback-description-list"><%=f.getDescription().trim()%></div>
                                </div>
                            </div>
                            <div class="item-right">
                                <div class="location-time">
                                    <div class="feedback-location-list">
                                        <ion-icon name="location"></ion-icon>Room <%=f.getRoomNumber()%>
                                    </div>
                                    <div class="feedback-senttime-list"><%=TimeUtils.renderedTime(f.getSentTime().trim())%></div>
                                </div>
                            </div>
                        </div>

                        <div id="<%=f.getFeedbackID().trim()%>" class="feeback-post" style="display: none;">
                            <div style="display: flex; align-items: center; justify-content: space-between">
                                <div onclick="wayBack('<%=feedbackID%>', 'completed-item', 'pagination3')" class="fbp-back">
                                    <i class="material-icons-outlined">chevron_left</i>
                                    Back
                                </div>
                            </div>
                            <h1 class="fbp-title"><%=f.getTitle().trim()%></h1>

                            <div class="fbp-aftertitle">
                                <div class="sender-time">
                                    <img class="fbp-profilepic"
                                         src="<%=user.getPicture().trim()%>">
                                    <div>Sent by <%=user.getName().trim()%></br>at <%=TimeUtils.renderedTime(f.getSentTime().trim())%></div>
                                </div>
                                <div class="facility-location">
                                    <div class="fbp-facility" style="display: flex; align-items: center;">
                                        <i class="material-icons">widgets</i>
                                        <div>
                                            <% String facilityName = ""; %> 
                                            <%for (FacilityDTO facility : facilitiesList) {%>
                                            <% if (facility.getFacilityID().equals(f.getFacilityID())) {
                                                    facilityName = facility.getFacilityName();
                                                } %>
                                            <%}%>
                                            <b>Facility</b><br><%=facilityName%>
                                        </div>
                                    </div>
                                    <div class="fbp-location" style="display: flex; align-items: center;">
                                        <i class="material-icons">house</i>
                                        <div>
                                            <b>Location</b><br>Room <%=f.getRoomNumber()%>
                                        </div>
                                    </div>

                                </div>
                            </div>

                            <hr style="height:1.5px; border:none; background-color:#ddd; margin-bottom: 20px;">

                            <% ArrayList<ImageDTO> imagesList = (ArrayList<ImageDTO>) imageDAO.getImagesList(f.getFeedbackID()); %>

                            <% for (ImageDTO image : imagesList) {%>
                            <img class="fbp-image"
                                 src="<%=image.getImageURL()%>"
                                 style="margin: 15px auto;">
                            <%}%>
                            <p class="fbp-description"><%=f.getDescription().trim()%></p>
                        </div>        

                        <%}
                        } else { %> 
                        <div class="empty-feedback"
                             style="display: flex; flex-direction: column; align-items: center; justify-content: space-around; height: 408px;">
                            <img width="480px" src="images/empty.jpg">
                            <p style="font-family: Arial, Helvetica, sans-serif; font-size: 32px;color: rgb(100, 95, 95);">
                                There are no feedbacks for this section.</p>

                        </div>
                        <%}%>



                        <!--PHÂN TRANG-->

                        <div class="pagination-container">
                            <%currentPageList = currentPageList3; %>
                            <%numOfFeedbacks = numOfCompletedFeedbacks; %>
                            <%pageSection = "completed"; %>

                            <% if (PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks) > 1) { %>

                            <div class="pagination" id="pagination3">

                                <%if (currentPageList != 1) {%>
                                <i class="material-icons" id="page-navigation" onclick="location.href = 'employee.jsp?&section=<%=pageSection%>&page=1'">first_page</i> 
                                <%}%>    

                                <% if (PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks) <= 5) { %>
                                <% for (int i = 1; i <= PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks); i++) { %>
                                <% if (currentPageList == i) {%>
                                <button class="active-page"><%=i%></button>
                                <% } else {%>
                                <button><a href="employee.jsp?&section=<%=pageSection%>&page=<%=i%>"><%=i%></a></button>
                                    <% } %>    
                                    <% } %>
                                    <% } else if (PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks) > 5) { %>
                                    <%if (PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks) - (currentPageList + 2) < 0) {%>


                                <% for (int i = PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks) - 5 + 1; i <= PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks); i++) { %>
                                <% if (currentPageList == i) {%>
                                <button class="active-page"><%=i%></button>
                                <% } else {%>
                                <button><a href="employee.jsp?&section=<%=pageSection%>&page=<%=i%>"><%=i%></a></button>
                                    <% } %>    
                                    <% } %>

                                <% } else if (currentPageList - 2 <= 0) {%>

                                <% for (int i = 1; i <= 5; i++) { %>
                                <% if (currentPageList == i) {%>
                                <button class="active-page"><%=i%></button>
                                <% } else {%>
                                <button><a href="employee.jsp?&section=<%=pageSection%>&page=<%=i%>"><%=i%></a></button>
                                    <% } %>    
                                    <% } %>    

                                <%} else {%> 


                                <% for (int i = currentPageList - 2; i <= currentPageList + 2; i++) { %>
                                <% if (currentPageList == i) {%>
                                <button class="active-page"><%=i%></button>
                                <% } else {%>
                                <button><a href="employee.jsp?&section=<%=pageSection%>&page=<%=i%>"><%=i%></a></button>
                                    <% } %>    
                                    <% } %>      


                                <%}%>
                                <% } %>


                                <%if (currentPageList != PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks)) {%>
                                <i class="material-icons" id="page-navigation" onclick="location.href = 'employee.jsp?&section=<%=pageSection%>&page=<%=PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks)%>'">last_page</i> 
                                <%}%>
                            </div>
                            <%}%>
                        </div>
                        <!--PHÂN TRANG-->

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

        <div class="modal" id="modal-send-report" style="display: none;">
            <div class="modal-send-report-container">
                <div class="modal-send-report-content">


                    <!--TITLE-->
                    <span class="modal-title">Send report</span>

                    <!--FORM-->

                    <form id="sendReportForm" action="MainController" method="POST" enctype="multipart/form-data">
                        <span class="title-description">Description</span>
                        <input id="reportFeedbackID" class="feedbackID" name="feedbackID" type="hidden" value="">

                        <div>
                            <textarea name="description" class="description"></textarea>
                        </div>
                        <span class="title-spentmoney">Spent money</span>
                        <div>
                            <input id="spentmoney" type="number" min="0" name="spentMoney"
                                   placeholder="Enter spent money...">
                        </div>

                        <span class="title-spentmoney">Attachs Image</span>
                        <label for="images">
                            <div class="upload-button"><i class="material-icons" style="margin-right: 10px;">file_upload</i>
                                <div>Upload your images</div>
                            </div>
                        </label>
                        <input type="file" name="images" id="images" required="required" multiple="multiple"
                               accept="image/png, image/jpeg" style="display:none;" onchange="previewImg()">
                        <div id="preview-img"></div>
                        <script src="js/img-upload.js"></script>


                        <!--BUTTONS-->
                        <div style="display: flex; justify-content: flex-end; gap: 10px;">
                            <button class="action-btn send-btn" name="action" value="SendReport" type="submit">Send</button>
                            <div class="action-btn cancel-btn" onclick="closeSendReportModal()">Cancel</div>
                        </div>

                    </form>
                </div>
            </div>
        </div>
        <script>
            function openSendReportModal(feedbackID) {
                document.getElementById('modal-send-report').style.display = "flex";
                document.getElementById('reportFeedbackID').value = feedbackID;

            }
            function closeSendReportModal() {
                document.getElementById('modal-send-report').style.display = "none";
                document.getElementById('reportFeedbackID').value = "";
            }
            function openFeedback(itemToShow, classToHide, paginationToHide) {
                var i;
                var index = classToHide.indexOf(' ');
                var classToHide2 = classToHide.substring(0, index);
                var x = document.getElementsByClassName(classToHide2);
                for (i = 0; i < x.length; i++) {
                    x[i].style.display = "none";
                }
                var pagination = document.getElementById(paginationToHide);
                if (pagination !== null)
                    pagination.style.display = "none";
                document.getElementById(itemToShow).style.display = "block";
            }

            function wayBack(itemToHide, classToShow, paginationToShow) {
                var i;
                var x = document.getElementById(itemToHide);
                x.style.display = "none";
                var y = document.getElementsByClassName(classToShow);
                for (i = 0; i < y.length; i++) {
                    y[i].style.display = "flex";
                }

                var pagination = document.getElementById(paginationToShow);
                if (pagination !== null)
                    pagination.style.display = "flex";

            }
        </script>
    </body>
</html>