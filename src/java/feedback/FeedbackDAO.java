/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package feedback;

import googleuser.GoogleUserDTO;
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
                String sender = newFeedback.getSenderEmail();
                String sql = "SELECT COUNT(*) as sumSendersFeedback "
                        + "FROM tblFeedbacks "
                        + "WHERE senderEmail = ?";
                stm = conn.prepareStatement(sql);
                stm.setString(1, sender);
                rs = stm.executeQuery();
                rs.next();
                String[] part = sender.split("@");
                String newFeedbackID = String.format(part[0] + ".%03d", rs.getInt("sumSendersFeedback") + 1);
                sql = "INSERT INTO tblFeedbacks"
                        + "(feedbackID, senderEmail, title, description, sentTime, roomNumber, facilityID, statusID )"
                        + " VALUES (?,?,?,?,?,?,?,1)";
                stm = conn.prepareStatement(sql);
                stm.setString(1, newFeedbackID);
                stm.setString(2, newFeedback.getSenderEmail());
                stm.setString(3, newFeedback.getTitle());
                stm.setString(4, newFeedback.getDescription());
                stm.setString(5, newFeedback.getSentTime());
                stm.setInt(6, newFeedback.getRoomNumber());
                stm.setString(7, newFeedback.getFacilityID());
                check = stm.executeUpdate() > 0 ? true : false;
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

    public static List<FeedbackDTO> getListFeedback(GoogleUserDTO loggedUser, int searchStatusID) throws SQLException {
        List<FeedbackDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stm = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String roleID = loggedUser.getRoleID();
                String email = loggedUser.getEmail();
                String sql = "";
                if (roleID.equals("US")) {
                    sql = "SELECT * "
                            + "FROM tblFeedbacks "
                            + "WHERE senderEmail = '" + email + "'";
                    stm = conn.prepareStatement(sql);
                } else if (roleID.equals("MG")) {
                    sql = "SELECT * "
                            + "FROM tblFeedbacks"
                            + "WHERE handlerEmail like ?";
                    stm = conn.prepareStatement(sql);
                    stm.setString(1, "%" + email + "%");
                } else {
                    sql = "SELECT * "
                            + "FROM tblFeedbacks "
                            + "WHERE statusID = " + searchStatusID;
                    stm = conn.prepareStatement(sql);
                }
                rs = stm.executeQuery();
                while (rs.next()) {
                    String feedbackID = rs.getString("feedbackID");
                    String title = rs.getString("title");
                    String description = rs.getString("description");
                    String sentTime = rs.getString("sentTime");
                    String handlerEmail = rs.getString("handlerEmail");
                    int roomNumber = rs.getInt("roomNumber");
                    String facilityID = rs.getString("facilityID");
                    int statusID = rs.getInt("statusID");
                    list.add(new FeedbackDTO(feedbackID, email, title, description, sentTime, handlerEmail, roomNumber, facilityID, statusID));
                }

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
        return list;
    }
}
