/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package image;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import utils.DBUtils;

/**
 *
 * @author Duy
 */
public class ImageDAO {

    public boolean insertFeedbackImages(ImageDTO image) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        boolean check = false;
        try {
            conn = DBUtils.getConnection();
            String sql = "insert into tblFeedbackImages (imageURL, feedbackID) values(?, ?)";
            ps = conn.prepareStatement(sql);
            ps.setString(1, image.getImageURL());
            ps.setString(2, image.getFeedbackID());
            check = ps.executeUpdate() > 0 ? true : false;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }

        }
        return check;
    }

    public static ImageDTO loadImageByFeedbackID(String feedbackID) throws SQLException {
        ImageDTO image = null;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            String sql = "select * from tblFeedbackImages where feedbackID= ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, feedbackID);
            rs = ps.executeQuery();
            if (rs.next()) {
                int imageID = rs.getInt("imageID");
                String imageURL = rs.getString("imageURL");
                image = new ImageDTO(imageID, imageURL, feedbackID);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }

        }
        return image;
    }
}