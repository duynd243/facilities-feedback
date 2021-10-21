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

    public String addFeedback(FeedbackDTO newFeedback) throws SQLException {
        boolean check = false;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String newFeedbackID = "";
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                while (!check) {
                    String sender = newFeedback.getSenderEmail();
                    String sql = "SELECT COUNT(*) as sumSendersFeedback "
                            + "FROM tblFeedbacks "
                            + "WHERE senderEmail = ?";
                    ps = conn.prepareStatement(sql);
                    ps.setString(1, sender);
                    rs = ps.executeQuery();
                    rs.next();
                    String[] part = sender.split("@");
                    newFeedbackID = String.format(part[0] + ".%03d", rs.getInt("sumSendersFeedback") + 1);
                    sql = "INSERT INTO tblFeedbacks"
                            + "(feedbackID, senderEmail, title, description, sentTime, roomNumber, facilityID, statusID )"
                            + " VALUES (?,?,?,?,?,?,?,1)";
                    ps = conn.prepareStatement(sql);
                    ps.setString(1, newFeedbackID);
                    ps.setString(2, newFeedback.getSenderEmail());
                    ps.setString(3, newFeedback.getTitle());
                    ps.setString(4, newFeedback.getDescription());
                    ps.setString(5, newFeedback.getSentTime());
                    ps.setInt(6, newFeedback.getRoomNumber());
                    ps.setString(7, newFeedback.getFacilityID());
                    check = ps.executeUpdate() > 0 ? true : false;
                }

            }
        } catch (Exception e) {
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
        return newFeedbackID;
    }

    public static List<FeedbackDTO> getListFeedback(GoogleUserDTO loggedUser, int searchStatusID) throws SQLException {
        List<FeedbackDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String roleID = loggedUser.getRoleID();
                String email = loggedUser.getEmail();
                String sql = "";
                if (roleID.equals("US")) {
                    sql = "SELECT * FROM tblFeedbacks WHERE senderEmail = ? AND statusID = ? ORDER BY sentTime desc";
                    ps = conn.prepareStatement(sql);
                    ps.setString(1, email);
                    ps.setInt(2, searchStatusID);
                } else if (roleID.equals("MG")) {
                    sql = "SELECT * "
                            + "FROM tblFeedbacks"
                            + "WHERE handlerEmail like ?";
                    ps = conn.prepareStatement(sql);
                    ps.setString(1, "%" + email + "%");
                } else {
                    sql = "SELECT * "
                            + "FROM tblFeedbacks "
                            + "WHERE statusID = " + searchStatusID;
                    ps = conn.prepareStatement(sql);
                }
                rs = ps.executeQuery();
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
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
        return list;
    }

    public List<FeedbackDTO> getListFeedbackOfSender(GoogleUserDTO user, int statusID, int pageNum) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<FeedbackDTO> list = new ArrayList<>();
        String senderEmail = user.getEmail();
        int numFeedbacksPerPage = 4;
        int startIndex, endIndex, size = 0;

        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                endIndex = numFeedbacksPerPage * pageNum;
                startIndex = endIndex - numFeedbacksPerPage + 1;

                String sql = "SELECT *\n"
                        + "    FROM (\n"
                        + "        SELECT *, ROW_NUMBER() OVER (ORDER BY sentTime desc) AS RowNum\n"
                        + "        FROM tblFeedbacks where senderEmail = ? and statusID = ? \n"
                        + "    ) AS MyDerivedTable\n"
                        + "    WHERE (MyDerivedTable.RowNum BETWEEN ? AND ?)";
                if (statusID == 2) {
                    sql = "SELECT *\n"
                            + "    FROM (\n"
                            + "        SELECT *, ROW_NUMBER() OVER (ORDER BY sentTime desc) AS RowNum\n"
                            + "        FROM tblFeedbacks where senderEmail = ? and (statusID = ? or statusID = 3) \n"
                            + "    ) AS MyDerivedTable\n"
                            + "    WHERE (MyDerivedTable.RowNum BETWEEN ? AND ?)";
                }

                ps = conn.prepareStatement(sql);
                ps.setString(1, senderEmail);
                ps.setInt(2, statusID);
                ps.setInt(3, startIndex);
                ps.setInt(4, endIndex);
                rs = ps.executeQuery();
                while (rs.next()) {
                    String feedbackID = rs.getString("feedbackID");
                    String title = rs.getString("title");
                    String description = rs.getString("description");
                    String sentTime = rs.getString("sentTime");
                    String handlerEmail = rs.getString("handlerEmail");
                    int roomNumber = rs.getInt("roomNumber");
                    String facilityID = rs.getString("facilityID");

                    list.add(new FeedbackDTO(feedbackID, senderEmail, title, description, sentTime, handlerEmail, roomNumber, facilityID, statusID));
                }
            }
        } catch (Exception e) {
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
        return list;
    }

    public int getNumOfFeedbacksOfSender(GoogleUserDTO user, int statusID) throws SQLException {
        int result = 0;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String senderEmail = user.getEmail();
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "SELECT COUNT(*) as count FROM tblFeedbacks WHERE senderEmail = ? AND statusID = ?";
                if (statusID == 2) {
                    sql = "SELECT COUNT(*) as count FROM tblFeedbacks WHERE senderEmail = ? AND (statusID = ? OR statusID = 3)";
                }
                ps = conn.prepareStatement(sql);
                ps.setString(1, senderEmail);
                ps.setInt(2, statusID);
                rs = ps.executeQuery();
                if (rs.next()) {
                    result = rs.getInt("count");
                }

            }
        } catch (Exception e) {
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
        return result;
    }

    public List<FeedbackDTO> getListFeedbackForManager(int statusID, int pageNum) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<FeedbackDTO> list = new ArrayList<>();
        int numFeedbacksPerPage = 4;
        int startIndex, endIndex, size = 0;

        try {
            conn = DBUtils.getConnection();
            if (conn != null) {

                endIndex = numFeedbacksPerPage * pageNum;
                startIndex = endIndex - numFeedbacksPerPage + 1;

                String sql = "SELECT *\n"
                        + "    FROM (\n"
                        + "        SELECT *, ROW_NUMBER() OVER (ORDER BY sentTime desc) AS RowNum\n"
                        + "        FROM tblFeedbacks where statusID = ? \n"
                        + "    ) AS MyDerivedTable\n"
                        + "    WHERE (MyDerivedTable.RowNum BETWEEN ? AND ?)";

                ps = conn.prepareStatement(sql);

                ps.setInt(1, statusID);
                ps.setInt(2, startIndex);
                ps.setInt(3, endIndex);
                rs = ps.executeQuery();
                while (rs.next()) {
                    String feedbackID = rs.getString("feedbackID");
                    String senderEmail = rs.getString("senderEmail");
                    String title = rs.getString("title");
                    String description = rs.getString("description");
                    String sentTime = rs.getString("sentTime");
                    String handlerEmail = rs.getString("handlerEmail");
                    int roomNumber = rs.getInt("roomNumber");
                    String facilityID = rs.getString("facilityID");

                    list.add(new FeedbackDTO(feedbackID, senderEmail, title, description, sentTime, handlerEmail, roomNumber, facilityID, statusID));
                }
            }
        } catch (Exception e) {
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
        return list;
    }

    public int getNumOfFeedbacksForManager(int statusID) throws SQLException {
        int result = 0;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "SELECT COUNT(*) as count FROM tblFeedbacks WHERE statusID = ?";

                ps = conn.prepareStatement(sql);
                ps.setInt(1, statusID);
                rs = ps.executeQuery();
                if (rs.next()) {
                    result = rs.getInt("count");
                }

            }
        } catch (Exception e) {
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
        return result;
    }

    public boolean assignEmployee(String feedbackID, String handlerEmail) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        int check = 0;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "UPDATE tblFeedbacks set statusID = 2, handlerEmail = ?\n"
                        + "where feedbackID = ?";
                ps = conn.prepareStatement(sql);
                ps.setString(1, handlerEmail);
                ps.setString(2, feedbackID);
                check = ps.executeUpdate();
            }
        } catch (Exception e) {
        } finally {
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
        return check > 0;
    }

}
