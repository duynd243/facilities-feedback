/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package feedback;

/**
 *
 * @author USER
 */
public class FeedbackDTO {

    private String feedbackID;
    private String senderEmail;
    private String title;
    private String description;
    private String sentTime;
    private String handlerEmail;
    private int roomNumber;
    private String facilityID;
    private int statusID;

    public FeedbackDTO() {
    }

    public FeedbackDTO(String feedbackID, String senderEmail, String title, String description, String sentTime, String handlerEmail, int roomNumber, String facilityID, int statusID) {
        this.feedbackID = feedbackID;
        this.senderEmail = senderEmail;
        this.title = title;
        this.description = description;
        this.sentTime = sentTime;
        this.handlerEmail = handlerEmail;
        this.roomNumber = roomNumber;
        this.facilityID = facilityID;
        this.statusID = statusID;
    }

    public FeedbackDTO(String senderEmail, String title, String description, String sentTime, int roomNumber, String facilityID) {
        this.senderEmail = senderEmail;
        this.title = title;
        this.description = description;
        this.sentTime = sentTime;
        this.roomNumber = roomNumber;
        this.facilityID = facilityID;
    }

    public String getFeedbackID() {
        return feedbackID;
    }

    public void setFeedbackID(String feedbackID) {
        this.feedbackID = feedbackID;
    }

    public String getSenderEmail() {
        return senderEmail;
    }

    public void setSenderEmail(String senderEmail) {
        this.senderEmail = senderEmail;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getSentTime() {
        return sentTime;
    }

    public void setSentTime(String sentTime) {
        this.sentTime = sentTime;
    }

    public String getHandlerEmail() {
        return handlerEmail;
    }

    public void setHandlerEmail(String handlerEmail) {
        this.handlerEmail = handlerEmail;
    }

    public int getRoomNumber() {
        return roomNumber;
    }

    public void setRoomNumber(int roomNumber) {
        this.roomNumber = roomNumber;
    }

    public String getFacilityID() {
        return facilityID;
    }

    public void setFacilityID(String facilityID) {
        this.facilityID = facilityID;
    }

    public int getStatusID() {
        return statusID;
    }

    public void setStatusID(int statusID) {
        this.statusID = statusID;
    }

    @Override
    public String toString() {
        return "FeedbackDTO{" + "feedbackID=" + feedbackID + ", senderEmail=" + senderEmail + ", title=" + title + ", description=" + description + ", sentTime=" + sentTime + ", handlerEmail=" + handlerEmail + ", roomNumber=" + roomNumber + ", facilityID=" + facilityID + ", statusID=" + statusID + '}';
    }

}
