/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package googleuser;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import utils.DBUtils;

/**
 *
 * @author Duy
 */
public class GoogleUserDAO {

    public String checkLogin(GoogleUserDTO user) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String roleID = "";
        int depID = 0;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "SELECT * FROM tblUsers WHERE email = ? AND statusID = 1";
                ps = conn.prepareStatement(sql);
                ps.setString(1, user.getEmail());
                rs = ps.executeQuery();
                if (rs.next()) {
                    roleID = rs.getString("roleID").trim();
                    depID = rs.getInt("depID");
                }
                user.setRoleID(roleID);
                user.setDepID(depID);
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
        return roleID;
    }

    public void addNewUser(GoogleUserDTO user) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtils.getConnection();
            String sql = "INSERT into tblUsers(email, fullName, picture, roleID, statusID) VALUES(?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(sql);
            ps.setString(1, user.getEmail());
            ps.setString(2, user.getName());
            ps.setString(3, user.getPicture());
            ps.setString(4, "US");
            ps.setInt(5, 1);
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
    }

    public GoogleUserDTO getUserByFeedbackID(String feedbackID) throws SQLException {
        GoogleUserDTO user = null;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "SELECT tblUsers.* FROM tblFeedbacks, tblUsers\n"
                        + "WHERE tblUsers.email = tblFeedbacks.senderEmail AND feedbackID = ?";
                ps = conn.prepareStatement(sql);
                ps.setString(1, feedbackID);
                rs = ps.executeQuery();
                if (rs.next()) {
                    String email = rs.getString("email");
                    String name = rs.getString("fullName");
                    String picture = rs.getString("picture");
                    String roleID = rs.getString("roleID");

                    user = new GoogleUserDTO(email, name, picture, roleID, "");
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

        return user;
    }

    public ArrayList<GoogleUserDTO> getListEmployeeByDepID(int depID) throws SQLException {
        ArrayList<GoogleUserDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "SELECT * FROM tblUsers where roleID = 'EP' AND depID = ?";
                ps = conn.prepareStatement(sql);
                ps.setInt(1, depID);
                rs = ps.executeQuery();
                while (rs.next()) {
                    String email = rs.getString("email");
                    String name = rs.getString("fullName");
                    String picture = rs.getString("picture");
                    String roleID = rs.getString("roleID");
                    GoogleUserDTO user = new GoogleUserDTO(email, name, picture, roleID, depID);
                    list.add(user);
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
}
