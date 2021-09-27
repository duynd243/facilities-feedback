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
import java.util.ArrayList;
import java.util.List;
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
                        + " VALUES (?,?,?,'" + newFeedback.sentTime + "',?,?,1)";
                stm = conn.prepareStatement(sql);
                stm.setString(1, newFeedback.senderEmail);
                stm.setString(2, newFeedback.title);
                stm.setString(3, newFeedback.description);
                stm.setInt(4, newFeedback.roomNumber);
                stm.setInt(5, newFeedback.facilityID);
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
