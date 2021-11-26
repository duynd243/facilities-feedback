/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package image;

/**
 *
 * @author Duy
 */
public class ImageDTO {
    private int imageID;
    private String imageURL;
    private String feedbackID;

    @Override
    public String toString() {
        return "ImageDTO{" + "imageID=" + imageID + ", imageURL=" + imageURL + ", feedbackID=" + feedbackID + '}';
    }

    public ImageDTO() {
    }

    public ImageDTO(String imageURL, String feedbackID) {
        this.imageURL = imageURL;
        this.feedbackID = feedbackID;
    }

    public ImageDTO(int imageID, String imageURL, String feedbackID) {
        this.imageID = imageID;
        this.imageURL = imageURL;
        this.feedbackID = feedbackID;
    }

    public int getImageID() {
        return imageID;
    }

    public void setImageID(int imageID) {
        this.imageID = imageID;
    }

    public String getImageURL() {
        return imageURL;
    }

    public void setImageURL(String imageURL) {
        this.imageURL = imageURL;
    }

    public String getFeedbackID() {
        return feedbackID;
    }

    public void setFeedbackID(String feedbackID) {
        this.feedbackID = feedbackID;
    }
    
}
