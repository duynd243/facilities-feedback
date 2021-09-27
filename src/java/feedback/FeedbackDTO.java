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

    int feedbackID;
    String senderEmail;
    String title;
    String description;
    String sentTime;
    String handlerEmail;
    int roomNumber;
    int facilityID;
    int statusID;

    public FeedbackDTO() {
    }

    public FeedbackDTO(int feedbackID, String senderEmail, String title, String description, String sentTime, String handlerEmail, int roomNumber, int facilityID, int statusID) {
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

    public FeedbackDTO(String senderEmail, String title, String description, String sentTime, int roomNumber, int facilityID) {
        this.senderEmail = senderEmail;
        this.title = title;
        this.description = description;
        this.sentTime = sentTime;
        this.roomNumber = roomNumber;
        this.facilityID = facilityID;
    }

    public int getFeedbackID() {
        return feedbackID;
    }

    public void setFeedbackID(int feedbackID) {
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

    public int getFacilityID() {
        return facilityID;
    }

    public void setFacilityID(int facilityID) {
        this.facilityID = facilityID;
    }

    public int getStatusID() {
        return statusID;
    }

    public void setStatusID(int statusID) {
        this.statusID = statusID;
    }

}
