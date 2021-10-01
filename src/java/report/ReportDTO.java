/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package report;

/**
 *
 * @author USER
 */
public class ReportDTO {

    String reportID;
    int statusID;
    String feedbackID;
    String description;
    int spentMoney;
    String time;
    int rated;

    public ReportDTO(String reportID, int statusID, String feedbackID, String description, int spentMoney, String time, int rated) {
        this.reportID = reportID;
        this.statusID = statusID;
        this.feedbackID = feedbackID;
        this.description = description;
        this.spentMoney = spentMoney;
        this.time = time;
        this.rated = rated;
    }

    public ReportDTO() {
    }

    public String getReportID() {
        return reportID;
    }

    public void setReportID(String reportID) {
        this.reportID = reportID;
    }

    public int getStatusID() {
        return statusID;
    }

    public void setStatusID(int statusID) {
        this.statusID = statusID;
    }

    public String getFeedbackID() {
        return feedbackID;
    }

    public void setFeedbackID(String feedbackID) {
        this.feedbackID = feedbackID;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getSpentMoney() {
        return spentMoney;
    }

    public void setSpentMoney(int spentMoney) {
        this.spentMoney = spentMoney;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public int getRated() {
        return rated;
    }

    public void setRated(int rated) {
        this.rated = rated;
    }

}
