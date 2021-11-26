<%-- 
    Document   : manager
    Created on : Sep 23, 2021, 9:40:08 AM
    Author     : Duy
--%>

<%@page import="report.ReportDTO"%>
<%@page import="report.ReportDAO"%>
<%@page import="java.util.HashMap"%>
<%@page import="utils.DeleteReasonsUtils"%>
<%@page import="department.DepartmentDTO"%>
<%@page import="department.DepartmentDAO"%>
<%@page import="googleuser.GoogleUserDAO"%>
<%@page import="utils.PaginationUtils"%>
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
<% ReportDAO repDAO = new ReportDAO();%>
<% FacilityDAO facilityDAO = new FacilityDAO();%>
<% FeedbackDAO feedbackDAO = new FeedbackDAO();%>
<% GoogleUserDAO userDAO = new GoogleUserDAO();%>
<% ImageDAO imageDAO = new ImageDAO();%>
<% DepartmentDAO depDAO = new DepartmentDAO();%>


<% ArrayList<FacilityDTO> facilitiesList = (ArrayList<FacilityDTO>) facilityDAO.getAllFacilities();%>


<% int numOfPendingFeedbacks = feedbackDAO.getNumOfFeedbacksForManager(1); %>
<% int numOfProcessingFeedbacks = feedbackDAO.getNumOfFeedbacksForManager(2); %>
<% int numOfWaitingFeedbacks = feedbackDAO.getNumOfFeedbacksForManager(3); %>
<% int numOfCompletedFeedbacks = feedbackDAO.getNumOfFeedbacksForManager(4); %>


<% int currentPageList1 = 1; %>
<% int currentPageList2 = 1; %>
<% int currentPageList3 = 1; %>
<% int currentPageList4 = 1; %>

<% int currentPageList = 0; %>
<% int numOfFeedbacks = 0; %>
<% String pageSection = ""; %>


<%!
    public String getSection(String section) {
        String result = "";
        if ("pending".equalsIgnoreCase(section) || "processing".equalsIgnoreCase(section) || "waiting".equalsIgnoreCase(section) || "completed".equalsIgnoreCase(section)) {
            result = section;
        } else {
            result = "pending";
        }
        return result;
    }
%>


<% String section = getSection(request.getParameter("section"));%>
<% String current = request.getParameter("page");%>

<% if ("pending".equalsIgnoreCase(section)) {
        currentPageList1 = PaginationUtils.getCurrentPage(current, PaginationUtils.getNumOfFeedbackPages(numOfPendingFeedbacks));
    }%>
<% if ("processing".equalsIgnoreCase(section)) {
        currentPageList2 = PaginationUtils.getCurrentPage(current, PaginationUtils.getNumOfFeedbackPages(numOfProcessingFeedbacks));
    }%>
<% if ("waiting".equalsIgnoreCase(section)) {
        currentPageList3 = PaginationUtils.getCurrentPage(current, PaginationUtils.getNumOfFeedbackPages(numOfWaitingFeedbacks));
    }%>
<% if ("completed".equalsIgnoreCase(section)) {
        currentPageList4 = PaginationUtils.getCurrentPage(current, PaginationUtils.getNumOfFeedbackPages(numOfCompletedFeedbacks));
    }%>

<% ArrayList<FeedbackDTO> feedbackList1 = (ArrayList<FeedbackDTO>) feedbackDAO.getListFeedbackForManager(1, currentPageList1); %>
<% ArrayList<FeedbackDTO> feedbackList2 = (ArrayList<FeedbackDTO>) feedbackDAO.getListFeedbackForManager(2, currentPageList2); %>
<% ArrayList<FeedbackDTO> feedbackList3 = (ArrayList<FeedbackDTO>) feedbackDAO.getListFeedbackForManager(3, currentPageList3); %>
<% ArrayList<FeedbackDTO> feedbackList4 = (ArrayList<FeedbackDTO>) feedbackDAO.getListFeedbackForManager(4, currentPageList4);%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Manager</title>
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
        <link rel="stylesheet" href="css/style-manager.css">
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

            function showChangeDepartmentSuccessToast() {
                toast({
                    title: "Success!",
                    message: "Department has been changed.",
                    type: "success",
                    duration: 5000
                });
            }

            function showChangeDepartmentFailedToast() {
                toast({
                    title: "Failed!",
                    message: "Employee has uncompleted feedbacks.",
                    type: "error",
                    duration: 5000
                });
            }

            function showBlockSuccessToast() {
                toast({
                    title: "Success!",
                    message: "User has been blocked.",
                    type: "success",
                    duration: 5000
                });
            }

            function showUnblockSuccessToast() {
                toast({
                    title: "Success!",
                    message: "User has been unblocked.",
                    type: "success",
                    duration: 5000
                });
            }

            window.onload = function onloadFunction() {

                var urlParams = new URLSearchParams(window.location.search);

                var status = urlParams.get('status');
                if (status == 'assign-success') {
                    selectFeedbackCategory('f2', 'processing-content');
                    showAssignSuccessToast();
                }

                if (status == 'delete-success') {
                    showDeleteSuccessToast();
                }

                var section = urlParams.get('section');
                if (section == 'processing') {
                    selectFeedbackCategory('f2', 'processing-content');
                } else if (section == 'waiting') {
                    selectFeedbackCategory('f3', 'waiting-content');
                } else if (section == 'completed') {
                    selectFeedbackCategory('f4', 'completed-content');
                } else if (section == 'pending') {
                    selectFeedbackCategory('f1', 'pending-content');
                }

                var employeeMenu = document.getElementById('EmployeeMenu');
                if (employeeMenu.value == 'true') {
                    selectSidebarMenu('m2', 'users')
                }

                var userMenu = document.getElementById('UserMenu');
                if (userMenu.value == 'true') {
                    selectSidebarMenu('m2', 'users');
                    selectUserCategory('u2', 'normal-users');
                }

                var changeDepartment = urlParams.get('change-department');
                if (changeDepartment !== null) {
                    selectSidebarMenu('m2', 'users');
                    if (changeDepartment == 'success') {
                        showChangeDepartmentSuccessToast();
                    } else if (changeDepartment == 'failed') {
                        showChangeDepartmentFailedToast();
                    }
                }

                if (urlParams.get('block') == 'success') {
                    selectSidebarMenu('m2', 'users');
                    selectUserCategory('u2', 'normal-users');
                    showBlockSuccessToast();
                }

                if (urlParams.get('unblock') == 'success') {
                    selectSidebarMenu('m2', 'users');
                    selectUserCategory('u2', 'normal-users');
                    showUnblockSuccessToast();
                }
                if (urlParams.get('status') == 'approve-success') {
                    selectFeedbackCategory('f4', 'completed-content');
                }

            }
        </script>
    </head>
    <body>
        <div id="toast"></div>
        <div style="display: none" class="g-signin2" data-onsuccess="onSignIn" data-prompt="select_account"></div>
        <% if (request.getAttribute("LIST_SEARCHED_EMPLOYEE") != null) {%>
        <input type="hidden" id="EmployeeMenu" value="true">
        <%} else { %>
        <input type="hidden" id="EmployeeMenu" value="false">
        <%}%>

        <% if (request.getAttribute("LIST_SEARCHED_USER") != null) {%>
        <input type="hidden" id="UserMenu" value="true">
        <%} else { %>
        <input type="hidden" id="UserMenu" value="false">
        <%}%>

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

                    function selectUserCategory(id, item) {
                        var i;
                        var x = document.getElementsByClassName("users-category-content");
                        for (i = 0; i < x.length; i++) {
                            x[i].style.display = "none";
                        }
                        document.getElementById(item).style.display = "block";
                        var current = document.getElementsByClassName("users-cate-active");
                        current[0].className = current[0].className.replace(" users-cate-active", "");
                        document.getElementById(id).className += " users-cate-active";
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
                    <button class="role">Manager</button>
                </div>
                <div class="buttons">
                    <button class="sbbutton sbbutton-active" id="m1" onclick="selectSidebarMenu(this.id, 'feedback')"><i
                            class="material-icons">format_list_bulleted</i>Feedbacks</button>
                    <button class="sbbutton" id="m2" onclick="selectSidebarMenu(this.id, 'users')"><i
                            class="material-icons-outlined">account_circle</i>Users</button>
                    <button class="sbbutton" id="m3" onclick="selectSidebarMenu(this.id, 'dashboard')"><i
                            class="material-icons-outlined">insert_chart_outlined</i>Dashboard</button>
                </div>
            </div>
            <div class="content">
                <div class="sbcontent" id="feedback">
                    <div class="feedback-category-bar">
                        <button id="f1" class="feedback-category cate-active"
                                onclick="selectFeedbackCategory(id, 'pending-content')">
                            <ion-icon name="hourglass-outline"></ion-icon>
                            Pending
                            <div class="badge-num"><%=numOfPendingFeedbacks%></div>
                        </button>
                        <button id="f2" class="feedback-category"
                                onclick="selectFeedbackCategory(id, 'processing-content')">
                            <ion-icon name="hammer-outline"></ion-icon>Processing <div class="badge-num"><%=numOfProcessingFeedbacks%></div>
                        </button>
                        <button id="f3" class="feedback-category" onclick="selectFeedbackCategory(id, 'waiting-content')">
                            <ion-icon name="file-tray-full-outline"></ion-icon>Waiting for approval
                            <div class="badge-num"><%=numOfWaitingFeedbacks%></div>
                        </button>
                        <button id="f4" class="feedback-category" onclick="selectFeedbackCategory(id, 'completed-content')">
                            <ion-icon name="checkmark-done-outline"></ion-icon>Completed
                            <div class="badge-num"><%=numOfCompletedFeedbacks%></div>
                        </button>
                    </div>

                    <div class="feedback-category-content" id="pending-content">
                        <% if (feedbackList1.size() != 0) {%>
                        <% for (FeedbackDTO f : feedbackList1) {%>
                        <%String feedbackID = f.getFeedbackID().trim();%>
                        <%GoogleUserDTO user = userDAO.getUserByFeedbackID(feedbackID);%>
                        <div class="pending-item feedback-item" onclick="openFeedback('<%=feedbackID%>', this.className, 'pagination1')">
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
                                <div onclick="wayBack('<%=feedbackID%>', 'pending-item', 'pagination1')" class="fbp-back">
                                    <i class="material-icons-outlined">chevron_left</i>
                                    Back
                                </div>

                                <div class="fbp-action-btn" style="display: flex;">
                                    <button id="fbp-delete-btn" class="fbp-btn fbp-delete-btn" onclick="openDeleteModal('<%=f.getFeedbackID().trim()%>', '<%=f.getSenderEmail().trim()%>')">
                                        <span class="material-icons-outlined" style="margin-right: 10px">delete</span>
                                        Delete
                                    </button>
                                    <button id="fbp-assign-btn" class="fbp-btn fbp-assign-btn" onclick="openAssignModal('<%=f.getFeedbackID().trim()%>')">
                                        <span class="material-icons-outlined" style="margin-right: 10px">task_alt</span>
                                        Assign to employee
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
                            <%numOfFeedbacks = numOfPendingFeedbacks; %>
                            <%pageSection = "pending"; %>

                            <% if (PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks) > 1) { %>

                            <div class="pagination" id="pagination1">

                                <%if (currentPageList != 1) {%>
                                <i class="material-icons" id="page-navigation" onclick="location.href = 'manager.jsp?&section=<%=pageSection%>&page=1'">first_page</i> 
                                <%}%>    

                                <% if (PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks) <= 5) { %>
                                <% for (int i = 1; i <= PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks); i++) { %>
                                <% if (currentPageList == i) {%>
                                <button class="active-page"><%=i%></button>
                                <% } else {%>
                                <button><a href="manager.jsp?&section=<%=pageSection%>&page=<%=i%>"><%=i%></a></button>
                                    <% } %>    
                                    <% } %>
                                    <% } else if (PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks) > 5) { %>
                                    <%if (PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks) - (currentPageList + 2) < 0) {%>


                                <% for (int i = PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks) - 5 + 1; i <= PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks); i++) { %>
                                <% if (currentPageList == i) {%>
                                <button class="active-page"><%=i%></button>
                                <% } else {%>
                                <button><a href="manager.jsp?&section=<%=pageSection%>&page=<%=i%>"><%=i%></a></button>
                                    <% } %>    
                                    <% } %>

                                <% } else if (currentPageList - 2 <= 0) {%>

                                <% for (int i = 1; i <= 5; i++) { %>
                                <% if (currentPageList == i) {%>
                                <button class="active-page"><%=i%></button>
                                <% } else {%>
                                <button><a href="manager.jsp?&section=<%=pageSection%>&page=<%=i%>"><%=i%></a></button>
                                    <% } %>    
                                    <% } %>    

                                <%} else {%> 


                                <% for (int i = currentPageList - 2; i <= currentPageList + 2; i++) { %>
                                <% if (currentPageList == i) {%>
                                <button class="active-page"><%=i%></button>
                                <% } else {%>
                                <button><a href="manager.jsp?&section=<%=pageSection%>&page=<%=i%>"><%=i%></a></button>
                                    <% } %>    
                                    <% } %>      


                                <%}%>
                                <% } %>


                                <%if (currentPageList != PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks)) {%>
                                <i class="material-icons" id="page-navigation" onclick="location.href = 'manager.jsp?&section=<%=pageSection%>&page=<%=PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks)%>'">last_page</i> 
                                <%}%>
                            </div>
                            <%}%>
                        </div>
                        <!--PHÂN TRANG-->

                    </div>

                    <div class="feedback-category-content" id="processing-content" style="display: none;">
                        <% if (feedbackList2.size() != 0) {%>
                        <% for (FeedbackDTO f : feedbackList2) {%>
                        <%String feedbackID = f.getFeedbackID().trim();%>
                        <%GoogleUserDTO user = userDAO.getUserByFeedbackID(feedbackID);%>
                        <div class="processing-item feedback-item" onclick="openFeedback('<%=feedbackID%>', this.className, 'pagination2')">
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
                            <div style="display: flex; align-items: flex-start; justify-content: space-between">
                                <div onclick="wayBack('<%=feedbackID%>', 'processing-item', 'pagination2')" class="fbp-back">
                                    <i class="material-icons-outlined">chevron_left</i>
                                    Back
                                </div>
                                <div class="fbp-handler">
                                    <span class="material-icons" style="color: #24ab4e">check_circle</span>
                                    <div>
                                        <span style="font-weight: 600;">
                                            Assigned to<br>
                                        </span>
                                        <span>
                                            <%=f.getHandlerEmail().trim()%>
                                        </span>
                                    </div>
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
                            <%numOfFeedbacks = numOfProcessingFeedbacks; %>
                            <%pageSection = "processing"; %>

                            <% if (PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks) > 1) { %>

                            <div class="pagination" id="pagination2">

                                <%if (currentPageList != 1) {%>
                                <i class="material-icons" id="page-navigation" onclick="location.href = 'manager.jsp?&section=<%=pageSection%>&page=1'">first_page</i> 
                                <%}%>    

                                <% if (PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks) <= 5) { %>
                                <% for (int i = 1; i <= PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks); i++) { %>
                                <% if (currentPageList == i) {%>
                                <button class="active-page"><%=i%></button>
                                <% } else {%>
                                <button><a href="manager.jsp?&section=<%=pageSection%>&page=<%=i%>"><%=i%></a></button>
                                    <% } %>    
                                    <% } %>
                                    <% } else if (PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks) > 5) { %>
                                    <%if (PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks) - (currentPageList + 2) < 0) {%>


                                <% for (int i = PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks) - 5 + 1; i <= PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks); i++) { %>
                                <% if (currentPageList == i) {%>
                                <button class="active-page"><%=i%></button>
                                <% } else {%>
                                <button><a href="manager.jsp?&section=<%=pageSection%>&page=<%=i%>"><%=i%></a></button>
                                    <% } %>    
                                    <% } %>

                                <% } else if (currentPageList - 2 <= 0) {%>

                                <% for (int i = 1; i <= 5; i++) { %>
                                <% if (currentPageList == i) {%>
                                <button class="active-page"><%=i%></button>
                                <% } else {%>
                                <button><a href="manager.jsp?&section=<%=pageSection%>&page=<%=i%>"><%=i%></a></button>
                                    <% } %>    
                                    <% } %>    

                                <%} else {%> 


                                <% for (int i = currentPageList - 2; i <= currentPageList + 2; i++) { %>
                                <% if (currentPageList == i) {%>
                                <button class="active-page"><%=i%></button>
                                <% } else {%>
                                <button><a href="manager.jsp?&section=<%=pageSection%>&page=<%=i%>"><%=i%></a></button>
                                    <% } %>    
                                    <% } %>      


                                <%}%>
                                <% } %>


                                <%if (currentPageList != PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks)) {%>
                                <i class="material-icons" id="page-navigation" onclick="location.href = 'manager.jsp?&section=<%=pageSection%>&page=<%=PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks)%>'">last_page</i> 
                                <%}%>
                            </div>
                            <%}%>
                        </div>
                        <!--PHÂN TRANG-->

                    </div>

                    <div class="feedback-category-content" id="waiting-content" style="display: none;">
                        <% if (feedbackList3.size() != 0) {%>
                        <% for (FeedbackDTO f : feedbackList3) {%>
                        <%String feedbackID = f.getFeedbackID().trim();%>
                        <%GoogleUserDTO user = userDAO.getUserByFeedbackID(feedbackID);%>
                        <div class="waiting-item feedback-item" onclick="openFeedback('<%=feedbackID%>', this.className, 'pagination3')">
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
                            <div onclick="wayBack('<%=feedbackID%>', 'waiting-item', 'pagination3')" class="fbp-back">
                                <i class="material-icons-outlined">chevron_left</i>
                                Back
                            </div>
                            <div class="view-report-container">

                                <span><span style="font-weight: 500;"><%=f.getHandlerEmail()%></span> sent a report at <%=TimeUtils.renderedTime(repDAO.getReport(feedbackID).getTime())%></span>
                                <button class="view-btn" onclick="openViewReportModal('viewReport-<%=repDAO.getReport(feedbackID).getReportID()%>')">View report</button>
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
                            <%numOfFeedbacks = numOfWaitingFeedbacks; %>
                            <%pageSection = "waiting"; %>

                            <% if (PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks) > 1) { %>

                            <div class="pagination" id="pagination3">

                                <%if (currentPageList != 1) {%>
                                <i class="material-icons" id="page-navigation" onclick="location.href = 'manager.jsp?&section=<%=pageSection%>&page=1'">first_page</i> 
                                <%}%>    

                                <% if (PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks) <= 5) { %>
                                <% for (int i = 1; i <= PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks); i++) { %>
                                <% if (currentPageList == i) {%>
                                <button class="active-page"><%=i%></button>
                                <% } else {%>
                                <button><a href="manager.jsp?&section=<%=pageSection%>&page=<%=i%>"><%=i%></a></button>
                                    <% } %>    
                                    <% } %>
                                    <% } else if (PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks) > 5) { %>
                                    <%if (PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks) - (currentPageList + 2) < 0) {%>


                                <% for (int i = PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks) - 5 + 1; i <= PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks); i++) { %>
                                <% if (currentPageList == i) {%>
                                <button class="active-page"><%=i%></button>
                                <% } else {%>
                                <button><a href="manager.jsp?&section=<%=pageSection%>&page=<%=i%>"><%=i%></a></button>
                                    <% } %>    
                                    <% } %>

                                <% } else if (currentPageList - 2 <= 0) {%>

                                <% for (int i = 1; i <= 5; i++) { %>
                                <% if (currentPageList == i) {%>
                                <button class="active-page"><%=i%></button>
                                <% } else {%>
                                <button><a href="manager.jsp?&section=<%=pageSection%>&page=<%=i%>"><%=i%></a></button>
                                    <% } %>    
                                    <% } %>    

                                <%} else {%> 


                                <% for (int i = currentPageList - 2; i <= currentPageList + 2; i++) { %>
                                <% if (currentPageList == i) {%>
                                <button class="active-page"><%=i%></button>
                                <% } else {%>
                                <button><a href="manager.jsp?&section=<%=pageSection%>&page=<%=i%>"><%=i%></a></button>
                                    <% } %>    
                                    <% } %>      


                                <%}%>
                                <% } %>


                                <%if (currentPageList != PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks)) {%>
                                <i class="material-icons" id="page-navigation" onclick="location.href = 'manager.jsp?&section=<%=pageSection%>&page=<%=PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks)%>'">last_page</i> 
                                <%}%>
                            </div>
                            <%}%>
                        </div>
                        <!--PHÂN TRANG-->
                    </div>

                    <div class="feedback-category-content" id="completed-content" style="display: none;">
                        <% if (feedbackList4.size() != 0) {%>
                        <% for (FeedbackDTO f : feedbackList4) {%>
                        <%String feedbackID = f.getFeedbackID().trim();%>
                        <%GoogleUserDTO user = userDAO.getUserByFeedbackID(feedbackID);%>
                        <div class="completed-item feedback-item" onclick="openFeedback('<%=feedbackID%>', this.className, 'pagination4')">
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
                            <div onclick="wayBack('<%=feedbackID%>', 'completed-item', 'pagination4')" class="fbp-back">
                                <i class="material-icons-outlined">chevron_left</i>
                                Back
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
                            <%currentPageList = currentPageList4; %>
                            <%numOfFeedbacks = numOfCompletedFeedbacks; %>
                            <%pageSection = "completed"; %>

                            <% if (PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks) > 1) { %>

                            <div class="pagination" id="pagination4">

                                <%if (currentPageList != 1) {%>
                                <i class="material-icons" id="page-navigation" onclick="location.href = 'manager.jsp?&section=<%=pageSection%>&page=1'">first_page</i> 
                                <%}%>    

                                <% if (PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks) <= 5) { %>
                                <% for (int i = 1; i <= PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks); i++) { %>
                                <% if (currentPageList == i) {%>
                                <button class="active-page"><%=i%></button>
                                <% } else {%>
                                <button><a href="manager.jsp?&section=<%=pageSection%>&page=<%=i%>"><%=i%></a></button>
                                    <% } %>    
                                    <% } %>
                                    <% } else if (PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks) > 5) { %>
                                    <%if (PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks) - (currentPageList + 2) < 0) {%>


                                <% for (int i = PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks) - 5 + 1; i <= PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks); i++) { %>
                                <% if (currentPageList == i) {%>
                                <button class="active-page"><%=i%></button>
                                <% } else {%>
                                <button><a href="manager.jsp?&section=<%=pageSection%>&page=<%=i%>"><%=i%></a></button>
                                    <% } %>    
                                    <% } %>

                                <% } else if (currentPageList - 2 <= 0) {%>

                                <% for (int i = 1; i <= 5; i++) { %>
                                <% if (currentPageList == i) {%>
                                <button class="active-page"><%=i%></button>
                                <% } else {%>
                                <button><a href="manager.jsp?&section=<%=pageSection%>&page=<%=i%>"><%=i%></a></button>
                                    <% } %>    
                                    <% } %>    

                                <%} else {%> 


                                <% for (int i = currentPageList - 2; i <= currentPageList + 2; i++) { %>
                                <% if (currentPageList == i) {%>
                                <button class="active-page"><%=i%></button>
                                <% } else {%>
                                <button><a href="manager.jsp?&section=<%=pageSection%>&page=<%=i%>"><%=i%></a></button>
                                    <% } %>    
                                    <% } %>      


                                <%}%>
                                <% } %>


                                <%if (currentPageList != PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks)) {%>
                                <i class="material-icons" id="page-navigation" onclick="location.href = 'manager.jsp?&section=<%=pageSection%>&page=<%=PaginationUtils.getNumOfFeedbackPages(numOfFeedbacks)%>'">last_page</i> 
                                <%}%>
                            </div>
                            <%}%>
                        </div>
                        <!--PHÂN TRANG-->


                    </div>


                </div>

                <div class="sbcontent" id="users" style="display: none;">
                    <%ArrayList<GoogleUserDTO> listSearchedEmployee = new ArrayList<>();%>
                    <% if (request.getAttribute("LIST_SEARCHED_EMPLOYEE") != null) {
                            listSearchedEmployee = (ArrayList<GoogleUserDTO>) request.getAttribute("LIST_SEARCHED_EMPLOYEE");
                        } else {
                            listSearchedEmployee = userDAO.getListEmployee("", 0, 1);
                        }%>

                    <%int searchedEmployeePageNumber = (request.getAttribute("SEARCH_EMPLOYEE_PAGENUM") != null) ? (int) request.getAttribute("SEARCH_EMPLOYEE_PAGENUM") : 1;%>
                    <%String searchedEmployeeKeyword = (request.getAttribute("SEARCH_EMPLOYEE_KEYWORD") != null) ? (String) request.getAttribute("SEARCH_EMPLOYEE_KEYWORD") : "";%>
                    <%int searchedEmployeeDepID = (request.getAttribute("SEARCH_EMPLOYEE_DEPARMENT") != null) ? (int) request.getAttribute("SEARCH_EMPLOYEE_DEPARMENT") : 0;%>


                    <%ArrayList<GoogleUserDTO> listSearchedUser = new ArrayList<>();%>
                    <% if (request.getAttribute("LIST_SEARCHED_USER") != null) {
                            listSearchedUser = (ArrayList<GoogleUserDTO>) request.getAttribute("LIST_SEARCHED_USER");
                        } else {
                            listSearchedUser = userDAO.getListUser("", -1, 1);
                        }%>

                    <%int searchedUserPageNumber = (request.getAttribute("SEARCH_USER_PAGENUM") != null) ? (int) request.getAttribute("SEARCH_USER_PAGENUM") : 1;%>
                    <%String searchedUserKeyword = (request.getAttribute("SEARCH_USER_KEYWORD") != null) ? (String) request.getAttribute("SEARCH_USER_KEYWORD") : "";%>
                    <%int searchedUserStatusID = (request.getAttribute("SEARCH_USER_STATUSID") != null) ? (int) request.getAttribute("SEARCH_USER_STATUSID") : -1;%>


                    <%int totalEmployee = userDAO.TotalEmployee(searchedEmployeeKeyword, searchedEmployeeDepID);%>
                    <%int totalUser = userDAO.TotalUser(searchedUserKeyword, searchedUserStatusID);%>
                    <!-- CATEGORY BAR -->
                    <div class="users-category-bar">
                        <button id="u1" class="users-category users-cate-active"
                                onclick="selectUserCategory(id, 'employee-users')">
                            <span class="material-icons-outlined" style="margin-right: 10px;">
                                badge
                            </span>
                            Employee
                            <div class="badge-num"><%=totalEmployee%></div>
                        </button>
                        <button id="u2" class="users-category"
                                onclick="selectUserCategory(id, 'normal-users')">
                            <span class="material-icons-outlined" style="margin-right: 10px;">
                                account_circle
                            </span>
                            User<div class="badge-num"><%=totalUser%></div>
                        </button>

                    </div>


                    <div class="users-category-content" id="employee-users">

                        <!-- SEARCH - ADD -->
                        <div class="search-add">
                            <form action="MainController" method="POST">
                                <div class="search-employee">

                                    <select name="depID">
                                        <option value="0">All department</option>
                                        <% ArrayList<DepartmentDTO> depList = depDAO.getListDepartment(); %>
                                        <% for (DepartmentDTO dep : depList) {%>
                                        <%if (searchedEmployeeDepID == dep.getDepID()) {%>
                                        <option value="<%=dep.getDepID()%>" selected="selected"><%=dep.getDepName().trim()%></option>
                                        <%} else {%>
                                        <option value="<%=dep.getDepID()%>"><%=dep.getDepName().trim()%></option>
                                        <%}
                                            }%>
                                    </select>
                                    <%if (!searchedEmployeeKeyword.isEmpty()) {%>
                                    <input name="keyword" type="text" value="<%=searchedEmployeeKeyword%>">
                                    <%} else { %>
                                    <input name="keyword" type="text" placeholder="Search employee ...">
                                    <%}%>
                                    <input name="pageNumber" type="hidden" value="1">
                                    <button name="action" value="SearchEmployee" type="submit" class="search-btn"><span class="material-icons-outlined"
                                                                                                                        id="search-ico">search</span></button>

                                </div>
                            </form>
                            <div class="add-employee">
                                <button>
                                    <span class="material-icons-outlined" style="font-size: 16px;">
                                        add
                                    </span>
                                    Add new employee
                                </button>
                            </div>
                        </div>
                        <!-- USER LIST -->


                        <%if (listSearchedEmployee.size() == 0) {%>
                        <div class="no-result">
                            <img src="images/no-result.png">
                            <span>Sorry, no any matches for '<%=searchedEmployeeKeyword%>'</span>
                        </div>
                        <%} else { %>
                        <div class="employee-item-container">
                            <% for (GoogleUserDTO emp : listSearchedEmployee) {%>
                            <div class="employee-item">
                                <div class="employee-pic">
                                    <img src="<%=emp.getPicture()%>"
                                         alt="" srcset="">
                                </div>
                                <div class="employee-name-email">
                                    <div style="font-weight: 550; opacity: 0.85;"><%=emp.getName().trim()%></div>
                                    <div style="opacity: 0.7;"><%=emp.getEmail().trim()%></div>
                                </div>
                                <div class="employee-department">
                                    <span><%=depDAO.getDepartmentName(emp.getDepID()).trim()%></span>
                                </div>
                                <div class="employee-rating">

                                    <% float empRate = emp.getRate(); %>
                                    <% for (int i = 1; i <= (int) empRate; i++) { %>
                                    <span class="material-icons-outlined">
                                        star
                                    </span>
                                    <% } %>
                                    <% if ((empRate - (int) empRate) < 0.5) { %>
                                    <% for (int i = 1; i <= 5 - (int) empRate; i++) { %>
                                    <span class="material-icons-outlined">
                                        grade
                                    </span>
                                    <% } %>

                                    <% } else if ((empRate - (int) empRate) == 0.5) { %>
                                    <span class="material-icons-outlined">
                                        star_half
                                    </span>
                                    <% for (int i = 1; i <= 5 - (int) empRate - 1; i++) { %>
                                    <span class="material-icons-outlined">
                                        grade
                                    </span>
                                    <% } %>

                                    <% } else if ((empRate - (int) empRate) > 0.5) { %>
                                    <span class="material-icons-outlined">
                                        star
                                    </span>
                                    <% for (int i = 1; i <= 5 - (int) empRate - 1; i++) { %>
                                    <span class="material-icons-outlined">
                                        grade
                                    </span>
                                    <% } %>
                                    <%}%>
                                </div>
                                <div class="employee-changedep-btn">
                                    <button style="display: flex; align-items: center; gap: 4px;" onclick="openChangeDepModal('changeDepModal-<%=emp.getEmail().trim()%>')">
                                        <span class="material-icons-outlined">
                                            autorenew
                                        </span>
                                        Change department</button>
                                </div>
                            </div>
                            <%}%>
                        </div>
                        <%}%>

                        <!-- PHÂN TRANG -->
                        <div class="pagination-container">

                            <% currentPageList = searchedEmployeePageNumber;%>
                            <% int numOfEmployees = totalEmployee; %>

                            <% if (PaginationUtils.getNumOfUserPages(numOfEmployees) > 1) {%>
                            <form action="MainController" id="SearchEmployeeForm" method = "POST">
                                <input id="EmployeePageNumber" type="hidden" name="pageNumber" value="">
                                <input type="hidden" name="depID" value="<%=searchedEmployeeDepID%>">
                                <input type="hidden" name="keyword" value="<%=searchedEmployeeKeyword%>">
                                <input type="hidden" name="action" value="SearchEmployee">

                            </form>
                            <div class="pagination">

                                <%if (currentPageList != 1) {%>
                                <i class="material-icons" id="page-navigation" value="1" onclick="LoadEmployee(this)">first_page</i> 
                                <%}%> 

                                <% if (PaginationUtils.getNumOfUserPages(numOfEmployees) <= 5) { %>
                                <% for (int i = 1; i <= PaginationUtils.getNumOfUserPages(numOfEmployees); i++) { %>
                                <% if (currentPageList == i) {%>
                                <button class="active-page"><%=i%></button>
                                <% } else {%>
                                <button value="<%=i%>" onclick="LoadEmployee(this)"><%=i%></button>
                                <% } %>    
                                <% } %>
                                <% } else if (PaginationUtils.getNumOfUserPages(numOfEmployees) > 5) { %>
                                <%if (PaginationUtils.getNumOfUserPages(numOfEmployees) - (currentPageList + 2) < 0) {%>


                                <% for (int i = PaginationUtils.getNumOfUserPages(numOfEmployees) - 5 + 1; i <= PaginationUtils.getNumOfUserPages(numOfEmployees); i++) { %>
                                <% if (currentPageList == i) {%>
                                <button class="active-page"><%=i%></button>
                                <% } else {%>
                                <button value="<%=i%>" onclick="LoadEmployee(this)"><%=i%></button>
                                <% } %>    
                                <% } %>

                                <% } else if (currentPageList - 2 <= 0) {%>

                                <% for (int i = 1; i <= 5; i++) { %>
                                <% if (currentPageList == i) {%>
                                <button class="active-page"><%=i%></button>
                                <% } else {%>
                                <button value="<%=i%>" onclick="LoadEmployee(this)"><%=i%></button>
                                <% } %>    
                                <% } %>    

                                <%} else {%> 


                                <% for (int i = currentPageList - 2; i <= currentPageList + 2; i++) { %>
                                <% if (currentPageList == i) {%>
                                <button class="active-page"><%=i%></button>
                                <% } else {%>
                                <button value="<%=i%>" onclick="LoadEmployee(this)"><%=i%></button>
                                <% } %>    
                                <% } %>      


                                <%}%>
                                <% } %>


                                <%if (currentPageList != PaginationUtils.getNumOfUserPages(numOfEmployees)) {%>
                                <i class="material-icons" id="page-navigation" value="<%=PaginationUtils.getNumOfUserPages(numOfEmployees)%>" onclick="LoadEmployee(this)">last_page</i> 
                                <%}%>
                            </div>
                            <%}%>
                        </div>
                        <!--PHÂN TRANG-->
                        <script>
                            function LoadEmployee(param) {
                                var page = param.getAttribute("value");
                                document.getElementById('EmployeePageNumber').value = page;
                                document.getElementById('SearchEmployeeForm').submit();
                            }
                        </script>

                    </div>
                    <div class="users-category-content" id="normal-users" style="display: none;">
                        <!-- SEARCH - ADD -->
                        <div class="search-add">
                            <form action="MainController" method="POST">
                                <div class="search-user">
                                    <select name="block-status">
                                        <%if (searchedUserStatusID == -1) {%>
                                        <option value="-1" selected="selected">All status</option>
                                        <option value="1">Active</option>
                                        <option value="0">Blocked</option>
                                        <%} else if (searchedUserStatusID == 1) {%>
                                        <option value="-1">All status</option>
                                        <option value="1" selected="selected">Active</option>
                                        <option value="0">Blocked</option>
                                        <%} else if (searchedUserStatusID == 0) {%>
                                        <option value="-1">All status</option>
                                        <option value="1">Active</option>
                                        <option value="0" selected="selected">Blocked</option>
                                        <%}%>
                                    </select>
                                    <%if (!searchedUserKeyword.isEmpty()) {%>
                                    <input name="keyword" type="text" value="<%=searchedUserKeyword%>">
                                    <%} else { %>
                                    <input name="keyword" type="text" placeholder="Search user ...">
                                    <%}%>
                                    <input name="pageNumber" type="hidden" value="1">
                                    <button name="action" value="SearchUser" type="submit" class="search-btn"><span class="material-icons-outlined"
                                                                                                                    id="search-ico">search</span></button>

                                </div>
                            </form>

                        </div>
                        <!-- USER LIST -->
                        <%if (listSearchedUser.size() == 0) {%>
                        <div class="no-result">
                            <img src="images/no-result.png">
                            <span>Sorry, no any matches for '<%=searchedEmployeeKeyword%>'</span>
                        </div>
                        <%} else { %>

                        <div class="user-item-container">
                            <% for (GoogleUserDTO user : listSearchedUser) {%>
                            <div class="user-item">
                                <div class="user-pic">
                                    <img src="<%=user.getPicture().trim()%>"
                                         alt="" srcset="">
                                </div>
                                <div class="user-name-email">
                                    <div style="font-weight: 550; opacity: 0.85;"><%=user.getName().trim()%></div>
                                    <div style="opacity: 0.7;"><%=user.getEmail().trim()%></div>
                                </div>
                                <div class="user-total-sent">
                                    <span>Sent feedbacks: <%=feedbackDAO.getNumOfFeedbacksOfSender(user, 1)%></span>
                                </div>
                                <div class="user-status">
                                    <%if (user.getStatusID() == 0) {%>
                                    <div style="background: #d14d4d;">
                                        <span class="material-icons-outlined" style="font-size: 20px;">
                                            block
                                        </span>
                                        <span style="font-size: 16px;">Blocked</span>
                                    </div>
                                    <%} else if (user.getStatusID() == 1) { %>
                                    <div style="background: #61c14a;">
                                        <span class="material-icons-outlined" style="font-size: 20px;">
                                            done
                                        </span>
                                        <span style="font-size: 16px;">Active</span>
                                    </div>
                                    <%}%>
                                </div>
                                <div class="user-btn">

                                    <%if (user.getStatusID() == 0) {%>
                                    <form action="MainController" onsubmit="return confirm('Do you really want to unblock <%=user.getName()%>?')">
                                        <input type="hidden" value="<%=user.getEmail().trim()%>" name="email-to-unblock">
                                        <button type="submit" name="action" value="UnblockUser" style="color: #39ac2d;">
                                            Unblock</button>
                                    </form>
                                    <%} else if (user.getStatusID() == 1) {%>
                                    <form action="MainController" onsubmit="return confirm('Do you really want to block <%=user.getName()%>?')">
                                        <input type="hidden" value="<%=user.getEmail().trim()%>" name="email-to-block">
                                        <button type="submit" name="action" value="BlockUser" style="color: #e02828;">
                                            Block</button>
                                    </form>
                                    <%}%>

                                </div>
                            </div>
                            <%}%>
                        </div>
                        <%} %>

                        <!-- PHÂN TRANG -->
                        <div class="pagination-container">

                            <% currentPageList = searchedUserPageNumber;%>
                            <% int numOfUsers = totalUser; %>

                            <% if (PaginationUtils.getNumOfUserPages(numOfUsers) > 1) {%>
                            <form action="MainController" id="SearchUserForm" method = "POST">
                                <input id="UserPageNumber" type="hidden" name="pageNumber" value="">
                                <input type="hidden" name="block-status" value="<%=searchedUserStatusID%>">
                                <input type="hidden" name="keyword" value="<%=searchedUserKeyword%>">
                                <input type="hidden" name="action" value="SearchUser">

                            </form>
                            <div class="pagination">

                                <%if (currentPageList != 1) {%>
                                <i class="material-icons" id="page-navigation" value="1" onclick="LoadUser(this)">first_page</i> 
                                <%}%> 

                                <% if (PaginationUtils.getNumOfUserPages(numOfUsers) <= 5) { %>
                                <% for (int i = 1; i <= PaginationUtils.getNumOfUserPages(numOfUsers); i++) { %>
                                <% if (currentPageList == i) {%>
                                <button class="active-page"><%=i%></button>
                                <% } else {%>
                                <button value="<%=i%>" onclick="LoadUser(this)"><%=i%></button>
                                <% } %>    
                                <% } %>
                                <% } else if (PaginationUtils.getNumOfUserPages(numOfUsers) > 5) { %>
                                <%if (PaginationUtils.getNumOfUserPages(numOfUsers) - (currentPageList + 2) < 0) {%>


                                <% for (int i = PaginationUtils.getNumOfUserPages(numOfUsers) - 5 + 1; i <= PaginationUtils.getNumOfUserPages(numOfUsers); i++) { %>
                                <% if (currentPageList == i) {%>
                                <button class="active-page"><%=i%></button>
                                <% } else {%>
                                <button value="<%=i%>" onclick="LoadUser(this)"><%=i%></button>
                                <% } %>    
                                <% } %>

                                <% } else if (currentPageList - 2 <= 0) {%>

                                <% for (int i = 1; i <= 5; i++) { %>
                                <% if (currentPageList == i) {%>
                                <button class="active-page"><%=i%></button>
                                <% } else {%>
                                <button value="<%=i%>" onclick="LoadUser(this)"><%=i%></button>
                                <% } %>    
                                <% } %>    

                                <%} else {%> 


                                <% for (int i = currentPageList - 2; i <= currentPageList + 2; i++) { %>
                                <% if (currentPageList == i) {%>
                                <button class="active-page"><%=i%></button>
                                <% } else {%>
                                <button value="<%=i%>" onclick="LoadUser(this)"><%=i%></button>
                                <% } %>    
                                <% } %>      


                                <%}%>
                                <% } %>


                                <%if (currentPageList != PaginationUtils.getNumOfUserPages(numOfUsers)) {%>
                                <i class="material-icons" id="page-navigation" value="<%=PaginationUtils.getNumOfUserPages(numOfUsers)%>" onclick="LoadUser(this)">last_page</i> 
                                <%}%>
                            </div>
                            <%}%>
                        </div>
                        <!--PHÂN TRANG-->
                        <script>
                            function LoadUser(param) {
                                var page = param.getAttribute("value");
                                document.getElementById('UserPageNumber').value = page;
                                document.getElementById('SearchUserForm').submit();
                            }
                        </script>
                    </div>

                </div>

                <div class="sbcontent" id="dashboard" style="display: none;">
                    Dashboard
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
        <div class="modal" id="modal-assign">
            <div class="modal-assign-employee">
                <div class="modal-department">
                    <div style="display: flex; justify-content: flex-end;"><span id="modal-close-icon" class="material-icons-outlined modal-close-icon">
                            close
                        </span>
                    </div>
                    <span class="modal-title">Choose Department</span>
                    <div class="department-wrapper">


                        <% for (DepartmentDTO dep : depList) {%>
                        <% ArrayList<GoogleUserDTO> listEmp = userDAO.getListEmployeeByDepID(dep.getDepID());%>
                        <div class="department" onclick="showEmployee('dep<%=dep.getDepID()%>')">
                            <span><%=dep.getDepName().trim()%></span>
                            <div class="number-employees">
                                <div class="number-employees-left">
                                    <span style="font-size: 20px;" class="material-icons">person</span>
                                </div>
                                <div class="number-employees-right">
                                    <span>Employees: <%=listEmp.size()%></span>
                                </div>
                            </div>
                        </div>
                        <%}%>
                    </div>
                </div>

                <% for (DepartmentDTO dep : depList) {%>
                <div class="modal-employee" id="dep<%=dep.getDepID()%>" style="display: none;">

                    <button class="modal-back-btn" onclick="showDepartment('dep<%=dep.getDepID()%>')"><span
                            class="material-icons-outlined">chevron_left</span>Back</button>

                    <!-- VÒNG FOR HIỂN THỊ LIST CÁC EMPLOYEE (NHỚ THÊM ASSIGN BUTTON NẰM TRONG FORM, FORM CÓ CONFIRM BẰNG JS ALERT)-->

                    <div class="employee-wrapper">
                        <% ArrayList<GoogleUserDTO> listEmp = userDAO.getListEmployeeByDepID(dep.getDepID());%>
                        <%for (GoogleUserDTO emp : listEmp) {%>
                        <div class="employee-to-assign">
                            <div class="employee-detail" style="display: flex; align-items: center;">
                                <div class="employee-pic" style="margin-right: 10px;">
                                    <img
                                        src="<%=emp.getPicture().trim()%>">
                                </div>
                                <div class="employee-info">
                                    <div class="employee-name"><%=emp.getName().trim()%></div>

                                    <div class="employee-badge">
                                        <div class="employee-rate" style="display: flex; align-items: center;">
                                            <span style="margin-right: 5px;" class="material-icons-outlined">star</span>5
                                        </div>
                                        <div class="employee-proccessing" style="display: flex; align-items: center;">
                                            <span style="margin-right: 5px;" class="material-icons">handyman</span>2
                                        </div>
                                        <div class="employee-completed" style="display: flex; align-items: center;">
                                            <span style="margin-right: 5px;" class="material-icons">done_all</span>2
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div>
                                <form action="MainController" onsubmit="return confirm('Do you agree to assign this feedback over to <%=emp.getName().trim()%> for processing?')" method="POST">
                                    <input type="hidden" value="<%=emp.getEmail().trim()%>" name="handlerEmail">
                                    <input class="feedbackID" name="feedbackID" type="hidden" value="">
                                    <button class="assign-btn" type="submit" name="action" value="AssignEmployee" style="display: flex; align-items: center;"><span
                                            class="material-icons-outlined"
                                            style="margin-right: 5px;">task_alt</span>Assign</button>
                                </form>
                            </div>
                        </div>
                        <%}%>
                    </div>
                </div>
                <%}%>
            </div>
        </div>

        <div class="modal" id="modal-delete">
            <div class="modal-delete-container">
                <div class="modal-delete-content">

                    <!--CLOSE BUTTON-->
                    <div style="display: flex; justify-content: flex-end;"><span id="modal-close-icon"
                                                                                 class="material-icons-outlined modal-close-icon">
                            close
                        </span>
                    </div>

                    <!--TITLE-->
                    <span class="modal-title">Delete feedback</span>

                    <!--FORM-->

                    <form id="delete-form" action="MainController" method="POST">
                        <span class="title2">Choose a reason</span>
                        <input class="feedbackID" name="feedbackID" type="hidden" value="">
                        <input class="blockSenderEmail" type="hidden" name="blockSenderEmail" value="">
                        <select required id="reason-combobox" style="display: block;" name="reason"
                                onchange="checkOtherReason()">
                            <option value="" disabled selected>Choose one...</option>
                            <%HashMap<Integer, String> deleteReasons = (HashMap<Integer, String>) DeleteReasonsUtils.deleteReasons;%>
                            <% for (int key : deleteReasons.keySet()) {%>
                            <option value="<%=key%>"><%=deleteReasons.get(key)%></option>
                            <%}%>
                            <option value="0">Other</option>
                        </select>
                        <div>

                            <input id="other-reason" type="text" name="other-reason" placeholder="Enter reason..."
                                   style="visibility: hidden; position: absolute; opacity: 0;">
                        </div>

                        <!--BLOCK USER CHECKBOX-->
                        <label class="checkbox-container" style="margin: 40px 0 20px 0;">
                            <span style="opacity: 0.9;">Block this user also</span>
                            <input type="checkbox" id="blockuser-check">
                            <span class="checkmark"></span>
                            <input id="isChecked" type="hidden" name="block" value="false">

                        </label>

                        <script>

                            function checkOtherReason() {
                                var combobox = document.getElementById("reason-combobox");
                                var str = combobox.options[combobox.selectedIndex].text;
                                if (str == "Other") {
                                    document.getElementById("other-reason").style.visibility = "visible";
                                    document.getElementById("other-reason").style.position = "relative";
                                    document.getElementById("other-reason").style.opacity = 1;
                                    document.getElementById("other-reason").required = true;
                                } else {
                                    document.getElementById('other-reason').value = '';
                                    document.getElementById("other-reason").style.visibility = "hidden";
                                    document.getElementById("other-reason").style.position = "absolute";
                                    document.getElementById("other-reason").style.opacity = 0;
                                    document.getElementById("other-reason").required = false;
                                }

                            }
                            var x = document.getElementById('blockuser-check');
                            x.onchange = function () {
                                document.getElementById('isChecked').value = x.checked;
                            }
                        </script>

                        <!--BUTTONS-->
                        <div style="display: flex; justify-content: flex-end; gap: 10px;">
                            <button class="action-btn delete-btn" type="submit" name="action" value="DeleteFeedback">Delete</button>
                            <div id="modal-delete-close" class="action-btn cancel-btn">Cancel</div>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <% for (FeedbackDTO f : feedbackList3) { %>
        <% ReportDTO r = repDAO.getReport(f.getFeedbackID().trim());%>
        <div class="modal" id="viewReport-<%=r.getReportID()%>">
            <div class="modal-view-report-container">
                <div class="view-report-close" onclick="closeReportModal('viewReport-<%=r.getReportID()%>')">
                    <span class="material-icons-outlined">
                        close
                    </span>
                </div>
                <div class="modal-view-report-content">

                    <div class="images">
                        <% ArrayList<ImageDTO> listImages = imageDAO.getReportImagesList(r.getReportID().trim()); %>
                        <% for (ImageDTO image : listImages) {%>
                        <img src="<%=image.getImageURL()%>">
                        <%}%>

                    </div>
                    <span class="title">Description</span>
                    <div class="description"><%=r.getDescription()%></div>
                    <div style="display: flex; justify-content: space-between;">
                        <span class="title">Spent money</span>
                        <span class="money">$<%=r.getSpentMoney()%></span>
                    </div>

                </div>
                <div class="btn" style="display: flex; justify-content: flex-end; gap: 20px;">
                    <button class="approve-btn" onclick="openRateModal('<%=r.getReportID()%>', '<%=f.getFeedbackID()%>', '<%=f.getHandlerEmail()%>')">Approve</button>
                    <form action="MainController" method="POST">
                        <input type="hidden" value="<%=r.getReportID()%>" name="reportID">
                        <input type="hidden" value="<%=f.getFeedbackID()%>" name="feedbackID">
                        <button class="decline-btn" name="action" value="DeclineReport">Decline</button>
                    </form>
                </div>
            </div>
        </div>
        <% } %>



        <% for (GoogleUserDTO emp : listSearchedEmployee) {%>
        <div class="modal modal-change-department" id="changeDepModal-<%=emp.getEmail().trim()%>">
            <div class="modal-change-department-container">
                <div class="modal-change-department-content">

                    <!--CLOSE BUTTON-->
                    <div style="display: flex; justify-content: flex-end;">
                    </div>

                    <!--TITLE-->
                    <span class="modal-title">Change department</span>

                    <!--FORM-->

                    <form id="changeDepForm" action="MainController" method="POST">
                        <input type="hidden" value="<%=emp.getEmail().trim()%>" name="email">
                        <span class="title2">Choose a deparment</span>
                        <select required id="department-combobox" style="display: block;" name="depID"
                                onchange="checkOtherReason()">
                            <option value="" disabled selected>Choose one...</option>

                            <% for (DepartmentDTO dep : depList) {%>
                            <%if (dep.getDepID() != emp.getDepID()) {%>
                            <option value="<%=dep.getDepID()%>"><%=dep.getDepName()%></option>
                            <%}%>        

                            <%}%>
                        </select>

                        <!--BUTTONS-->
                        <div style="display: flex; justify-content: flex-end; gap: 10px;">
                            <button class="action-btn confirm-btn" type="submit" name="action" value="ChangeDepartment">Confirm</button>
                            <div id="modal-change-deparment-close" class="action-btn cancel-btn" onclick="CloseChangeDepModal()">Cancel</div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <%}%>

        <div class="modal" id="modal-rate-star">
            <div class="modal-rate-star-container">
                <span class="heading">Rate for employee's work</span>
                <div class="modal-rate-star-content">

                    <div class="stars">
                        <form action="MainController" id="rate-star-form" method="POST">
                            <input class="star star-5" id="star-5" type="radio" name="rated" value="5" required />
                            <label class="star star-5" for="star-5"></label>
                            <input class="star star-4" id="star-4" type="radio" name="rated" value="4" />
                            <label class="star star-4" for="star-4"></label>
                            <input class="star star-3" id="star-3" type="radio" name="rated" value="3" />
                            <label class="star star-3" for="star-3"></label>
                            <input class="star star-2" id="star-2" type="radio" name="rated" value="2" />
                            <label class="star star-2" for="star-2"></label>
                            <input class="star star-1" id="star-1" type="radio" name="rated" value="1" />
                            <label class="star star-1" for="star-1"></label>
                            <input type="hidden" value="" id="rateHandlerEmail" name="handlerEmail">
                            <input type="hidden" value="" id="rateReportID" name="reportID">
                            <input type="hidden" value="" id="rateFeedbackID" name="feedbackID">
                        </form>

                        <button name="action" value="RateReport" type="submit" form="rate-star-form" class="submit-btn">Submit</button>
                        <div class="cancel-btn" onclick="closeRateModal()">Cancel</div>
                    </div>

                </div>

            </div>
        </div>


        <script>
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


            function showEmployee(idOfDivToShow) {
                document.getElementById(idOfDivToShow).style.display = "block";
                var x = document.getElementsByClassName('modal-department');
                for (i = 0; i < x.length; i++) {
                    x[i].style.display = "none";
                }
            }

            function showDepartment(idOfDivToHide) {
                document.getElementById(idOfDivToHide).style.display = "none";
                var x = document.getElementsByClassName('modal-department');
                for (i = 0; i < x.length; i++) {
                    x[i].style.display = "block";
                }
            }

            // Get the modal
            var modalAssign = document.getElementById("modal-assign");
            var modalDelete = document.getElementById("modal-delete");

            // Get the button that opens the modal
            var btn = document.getElementById("fbp-assign-btn");

            // Get the <span> element that closes the modal
            var closeModalBtn = document.getElementsByClassName("modal-close-icon");


            // When the user clicks the button, open the modal 
            function openAssignModal(feedbackID) {
                modalAssign.style.display = "flex";
                var inputFeedbackID = document.getElementsByClassName('feedbackID');
                for (i = 0; i < inputFeedbackID.length; i++) {
                    inputFeedbackID[i].value = feedbackID;
                }
            }

            function openDeleteModal(feedbackID, blockSenderEmail) {
                modalDelete.style.display = "flex";
                var inputFeedbackID = document.getElementsByClassName('feedbackID');
                for (i = 0; i < inputFeedbackID.length; i++) {
                    inputFeedbackID[i].value = feedbackID;
                }

                var inputBlockSenderEmail = document.getElementsByClassName('blockSenderEmail');
                for (i = 0; i < inputBlockSenderEmail.length; i++) {
                    inputBlockSenderEmail[i].value = blockSenderEmail;
                }
            }


            function openViewReportModal(modalId) {
                document.getElementById(modalId).style.display = "flex";
            }

            function closeReportModal(modalId) {
                document.getElementById(modalId).style.display = "none";
            }

            function openChangeDepModal(modalId) {
                document.getElementById(modalId).style.display = "flex";
            }

            function openRateModal(reportId, feedbackId, handlerEmail) {
                document.getElementById('modal-rate-star').style.display = "flex";
                document.getElementById('rateReportID').value = reportId;
                document.getElementById('rateFeedbackID').value = feedbackId;
                document.getElementById('rateHandlerEmail').value = handlerEmail;
            }

            function closeRateModal() {
                document.getElementById('modal-rate-star').style.display = "none";
                document.getElementById('rateReportID').value = "";
                document.getElementById('rateFeedbackID').value = "";
                document.getElementById('rateHandlerEmail').value = "";
            }



            // When the user clicks on <span> (x), close the modal
            for (i = 0; i < closeModalBtn.length; i++) {
                closeModalBtn[i].onclick = function () {
                    modalAssign.style.display = "none";
                }
            }

            document.getElementById('modal-delete-close').onclick = function () {

                modalDelete.style.display = "none";
                // RESET COMBOBOX VALUE
                document.getElementById('reason-combobox').selectedIndex = 0;

                // HIDE AND RESET OTHER REASON INPUT 
                document.getElementById('other-reason').value = '';
                document.getElementById("other-reason").style.visibility = "hidden";
                document.getElementById("other-reason").style.position = "absolute";
                document.getElementById("other-reason").style.opacity = 0;
                document.getElementById("other-reason").required = false;

                // UNCHECK BLOCK USER CHECKBOX
                document.getElementById('blockuser-check').checked = false;

                document.getElementById('isChecked').value = false;

            }

            function CloseChangeDepModal() {
                var modal = document.getElementsByClassName('modal-change-department');
                for (i = 0; i < modal.length; i++) {
                    modal[i].style.display = "none";
                }
            }




            // When the user clicks anywhere outside of the modal, close it
            /*
             window.onclick = function (event) {
             if (event.target == modal) {
             modal.style.display = "none";
             }
             }*/
        </script>

    </body>
</html>