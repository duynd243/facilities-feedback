package report;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.UUID;
import utils.DBUtils;

/**
 *
 * @author Duy
 */
public class ReportDAO {

    public String addReport(ReportDTO newReport) throws SQLException {
        String reportID = "";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                reportID = UUID.randomUUID().toString();
                String sql = "insert into tblReports(reportID, statusID, feedbackID, spentMoney, [description], [time])\n"
                        + "VALUES(?, ?, ?, ?, ?, ?)";
                ps = conn.prepareStatement(sql);
                ps.setString(1, reportID);
                ps.setInt(2, newReport.getStatusID());
                ps.setString(3, newReport.getFeedbackID());
                ps.setInt(4, newReport.getSpentMoney());
                ps.setString(5, newReport.getDescription());
                ps.setString(6, newReport.getTime());
                ps.executeUpdate();
                sql = "update tblFeedbacks set statusID = 3 where feedbackID = ?";
                ps = conn.prepareStatement(sql);
                ps.setString(1, newReport.getFeedbackID());
                ps.executeUpdate();
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
        return reportID;
    }

    public ReportDTO getReport(String feedbackID) throws SQLException {
        feedbackID = feedbackID.trim();
        ReportDTO report = null;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "SELECT * FROM tblReports WHERE feedbackID = ? AND statusID = 1";
                ps = conn.prepareStatement(sql);
                ps.setString(1, feedbackID);
                rs = ps.executeQuery();
                if (rs.next()) {
                    String reportID = rs.getString("reportID");
                    String description = rs.getString("description");
                    int spentMoney = rs.getInt("spentMoney");
                    String time = rs.getString("time");
                    int rated = rs.getInt("rated");
                    report = new ReportDTO(reportID, 1, feedbackID, description, spentMoney, time, rated);
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
        return report;
    }

    public void DeclineReport(String feedbackID, String reportID) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "DELETE tblReportImages WHERE reportID = ?";
                ps = conn.prepareStatement(sql);
                ps.setString(1, reportID);
                ps.executeUpdate();

                sql = "DELETE tblReports WHERE reportID = ?";
                ps = conn.prepareStatement(sql);
                ps.setString(1, reportID);
                ps.executeUpdate();

                sql = "UPDATE tblFeedbacks SET statusID = 2 WHERE feedbackID = ?";
                ps = conn.prepareStatement(sql);
                ps.setString(1, feedbackID);
                ps.executeUpdate();
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
    }
    
    public void ApproveReport(String feedbackID, String reportID, String completeTime, int rated, String handlerEmail) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "UPDATE tblFeedbacks SET completeTime = ?, statusID = 4  WHERE feedbackID = ?";
                ps = conn.prepareStatement(sql);
                ps.setString(1, completeTime);
                ps.setString(2, feedbackID);
                ps.executeUpdate();

                sql = "UPDATE tblReports SET rated = ? WHERE reportID = ?";
                ps = conn.prepareStatement(sql);
                ps.setInt(1, rated);
                ps.setString(2, reportID);
                ps.executeUpdate();
                
                
                float employeeRate = 0;
                int handledFeedbacks = 0;
                
                sql = "SELECT * FROM tblRates WHERE email = ?";
                ps = conn.prepareStatement(sql);
                ps.setString(1, handlerEmail);
                rs = ps.executeQuery();
                if(rs.next()){
                    employeeRate = rs.getFloat("rate");
                }
                
                
                sql = "SELECT COUNT(*) as handledFeedbacks FROM tblFeedbacks WHERE handlerEmail = ? AND statusID = 4";
                ps = conn.prepareStatement(sql);
                ps.setString(1, handlerEmail);
                rs = ps.executeQuery();
                if(rs.next()){
                    handledFeedbacks = rs.getInt("handledFeedbacks");
                }
                float newRate = (employeeRate*handledFeedbacks + rated)/(float)(handledFeedbacks+1);
                
                sql = "UPDATE tblRates SET rate = ? WHERE email = ?";
                ps = conn.prepareStatement(sql);
                ps.setFloat(1, newRate);
                ps.setString(2, handlerEmail);
                ps.executeUpdate();
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
    }
}