/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package report;

import feedback.FeedbackDTO;
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
public class ReportDAO {

    public static int addReport(ReportDTO newReport) throws SQLException {
        int functionStatus = 0;
        // 0 - nothing changed in DB
        // 1 - insert new report successful
        // 2 - update rate successful
        Connection conn = null;
        PreparedStatement stm = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                int rated = newReport.getRated();
                String feedbackID = newReport.getFeedbackID();
                String sql = "SELECT COUNT(*) as sumReported "
                        + "FROM tblReports "
                        + "WHERE feedbackID = ?";
                stm = conn.prepareStatement(sql);
                stm.setString(1, feedbackID);
                rs = stm.executeQuery();
                if (rs.next()) {
                    String newReportID = String.format(feedbackID + ".%02d", rs.getInt("sumReported") + 1);
                    sql = "INSERT INTO tblReports "
                            + "VALUES (?,?,?,?,?,?,?)";
                    stm = conn.prepareStatement(sql);
                    stm.setString(1, newReportID);
                    stm.setInt(2, newReport.getStatusID());
                    stm.setString(3, feedbackID);
                    stm.setString(4, newReport.getDescription());
                    stm.setInt(5, newReport.getSpentMoney());
                    stm.setString(6, newReport.getTime());
                    stm.setInt(7, rated);
                    int value = stm.executeUpdate();
                    if (value > 0) {
                        functionStatus = 1;
                        sql = "SELECT handlerEmail "
                                + "FROM tblFeedbacks "
                                + "WHERE feedbackID = ?";
                        stm = conn.prepareStatement(sql);
                        stm.setString(1, feedbackID);
                        rs = stm.executeQuery();
                        if (rs.next()) {
                            String email = rs.getString("handlerEmail");
                            if (rated != 0) {
                                sql = "UPDATE tblRates "
                                        + "SET rate = (rate*handledFeedbacks + ?)/(handledFeedbacks + 1),"
                                        + " handledFeedbacks = handledFeedbacks + 1"
                                        + " WHERE email = ?";
                            }
                            stm = conn.prepareStatement(sql);
                            stm.setInt(1, rated);
                            stm.setString(2, email);
                            functionStatus = stm.executeUpdate() > 0 ? 2 : 1;
                        }
                    }
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
        return functionStatus;

    }
}
