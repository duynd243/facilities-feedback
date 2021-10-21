
// feedbackList4
// pagination4
// currentPageList4
// numOfFeedbacks = numOfCompletedFeedbacks
// pageSection = "completed"
// wayBack('<%=feedbackID%>', 'completed-item'
// <div class="completed-item feedback-item" onclick="openFeedback

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
                            <i style="font-size: 220px; color: #ddd;" class="material-icons">inbox</i>
                            <p style="font-family: Arial, Helvetica, sans-serif; font-size: 32px;color: rgb(100, 95, 95);">
                                There are no feedbacks for this section.</p>

                        </div>
                        <%}%>



                        <!--PHÂN TRANG-->

                        <div class="pagination-container">
                            <%currentPageList = currentPageList4; %>
                            <%numOfFeedbacks = numOfCompletedFeedbacks; %>
                            <%pageSection = "completed"; %>

                            <% if (PaginationUtils.getNumOfPages(numOfFeedbacks) > 1) { %>

                            <div class="pagination" id="pagination4">

                                <%if (currentPageList != 1) {%>
                                <i class="material-icons" id="page-navigation" onclick="location.href = 'send-feedback.jsp?&section=<%=pageSection%>&page=1'">first_page</i> 
                                <%}%>    

                                <% if (PaginationUtils.getNumOfPages(numOfFeedbacks) <= 5) { %>
                                <% for (int i = 1; i <= PaginationUtils.getNumOfPages(numOfFeedbacks); i++) { %>
                                <% if (currentPageList == i) {%>
                                <button class="active-page"><%=i%></button>
                                <% } else {%>
                                <button><a href="send-feedback.jsp?&section=<%=pageSection%>&page=<%=i%>"><%=i%></a></button>
                                    <% } %>    
                                    <% } %>
                                    <% } else if (PaginationUtils.getNumOfPages(numOfFeedbacks) > 5) { %>
                                    <%if (PaginationUtils.getNumOfPages(numOfFeedbacks) - (currentPageList + 2) < 0) {%>


                                <% for (int i = PaginationUtils.getNumOfPages(numOfFeedbacks) - 5 + 1; i <= PaginationUtils.getNumOfPages(numOfFeedbacks); i++) { %>
                                <% if (currentPageList == i) {%>
                                <button class="active-page"><%=i%></button>
                                <% } else {%>
                                <button><a href="send-feedback.jsp?&section=<%=pageSection%>&page=<%=i%>"><%=i%></a></button>
                                    <% } %>    
                                    <% } %>

                                <% } else if (currentPageList - 2 <= 0) {%>

                                <% for (int i = 1; i <= 5; i++) { %>
                                <% if (currentPageList == i) {%>
                                <button class="active-page"><%=i%></button>
                                <% } else {%>
                                <button><a href="send-feedback.jsp?&section=<%=pageSection%>&page=<%=i%>"><%=i%></a></button>
                                    <% } %>    
                                    <% } %>    

                                <%} else {%> 


                                <% for (int i = currentPageList - 2; i <= currentPageList + 2; i++) { %>
                                <% if (currentPageList == i) {%>
                                <button class="active-page"><%=i%></button>
                                <% } else {%>
                                <button><a href="send-feedback.jsp?&section=<%=pageSection%>&page=<%=i%>"><%=i%></a></button>
                                    <% } %>    
                                    <% } %>      


                                <%}%>
                                <% } %>


                                <%if (currentPageList != PaginationUtils.getNumOfPages(numOfFeedbacks)) {%>
                                <i class="material-icons" id="page-navigation" onclick="location.href = 'send-feedback.jsp?&section=<%=pageSection%>&page=<%=PaginationUtils.getNumOfPages(numOfFeedbacks)%>'">last_page</i> 
                                <%}%>
                            </div>
                            <%}%>
                        </div>
                        <!--PHÂN TRANG-->