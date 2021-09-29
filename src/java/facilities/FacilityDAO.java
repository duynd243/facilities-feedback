/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package facilities;

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
public class FacilityDAO {

    public static boolean addFacility(String ID, String name) throws SQLException {
        boolean check = false;
        Connection conn = null;
        PreparedStatement stm = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "INSERT INTO tblFacilities "
                        + "VALUES(?,?)";
                stm = conn.prepareStatement(sql);
                stm.setString(1, ID);
                stm.setString(2, name);
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

    public static List<FacilityDTO> getListFacilities(String searchKey, String searchBy) throws SQLException {
        List<FacilityDTO> foundList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stm = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "";
                if (searchBy.equals("ID")) {
                    sql = "SELECT * "
                            + "FROM tblFacilities "
                            + "WHERE facilityID like ? ";
                } else {
                    sql = "SELECT * "
                            + "FROM tblFacilities "
                            + "WHERE facilityName like ? ";
                }
                stm = conn.prepareStatement(sql);
                stm.setString(1, "%" + searchKey + "%");
                rs = stm.executeQuery();
                while (rs.next()) {
                    String ID = rs.getString("facilityID");
                    String name = rs.getString("facilityName");
                    foundList.add(new FacilityDTO(ID, name));
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
        return foundList;
    }

    public static boolean updateFacility(String oldID, String newID, String newName) throws SQLException {
        boolean update = false;
        Connection conn = null;
        PreparedStatement stm = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "UPDATE tblFacilities "
                        + "SET facilityID = ?, facilityName = ? "
                        + "WHERE facilityID = ? ";
                stm = conn.prepareStatement(sql);
                stm.setString(1, newID);
                stm.setString(2, newName);
                stm.setString(3, oldID);
                update = stm.executeUpdate() > 0;
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
        return update;
    }

    public List<FacilityDTO> getAllFacilities() throws SQLException {
        List<FacilityDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            String sql = "SELECT * FROM tblFacilities";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                String facilityID = rs.getString("facilityID");
                String facilityName = rs.getString("facilityName");
                list.add(new FacilityDTO(facilityID, facilityName));
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
        return list;
    }
}