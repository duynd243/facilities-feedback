/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package feedback;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import utils.DBUtils;

/**
 *
 * @author USER
 */
public class FeedbackDAO {

    public static boolean addFeedback(FeedbackDTO newFeedback) throws SQLException {
        boolean check = false;
        Connection conn = null;
        PreparedStatement stm = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "INSERT INTO tblFeedbacks"
                        + "(senderEmail, title, description, sentTime, roomNumber, facilityID, statusID )"
                        + " VALUES (?,?,?,?,?,?,1)";
                stm = conn.prepareStatement(sql);
                stm.setString(1, newFeedback.getSenderEmail());
                stm.setString(2, newFeedback.getTitle());
                stm.setString(3, newFeedback.getDescription());
                stm.setString(4, newFeedback.getSentTime());
                stm.setInt(5, newFeedback.getRoomNumber());
                stm.setString(6, newFeedback.getFacilityID());
                String x = newFeedback.getSenderEmail() + " " + newFeedback.getTitle() + " " + newFeedback.getDescription() + " "
                        + newFeedback.getSentTime() + " "
                        + newFeedback.getRoomNumber() + " "
                        + newFeedback.getFacilityID() + " ";

                int value = stm.executeUpdate();
                check = value > 0 ? true : false;
            }
        } catch (Exception e) {
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (stm != null) {
                stm.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
        return check;
    }
}
