/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package department;

import googleuser.GoogleUserDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import utils.DBUtils;

/**
 *
 * @author Duy
 */
public class DepartmentDAO {
    
    public ArrayList<DepartmentDTO> getListDepartment() throws SQLException{
        ArrayList<DepartmentDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "SELECT * FROM tblDepartments";
                ps = conn.prepareStatement(sql);
                rs = ps.executeQuery();
                while(rs.next()){
                    int depID = rs.getInt("depID");
                    String depName = rs.getString("depName");
                    list.add(new DepartmentDTO(depID, depName));
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

    public HashMap<DepartmentDTO, ArrayList<GoogleUserDTO>> LoadDepartmentsAndEmployees() throws SQLException {
        HashMap<DepartmentDTO, ArrayList<GoogleUserDTO>> hm = new HashMap<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "SELECT * FROM tblDepartments, tblUsers\n"
                        + "where tblUsers.depID = tblDepartments.depID";
                ps = conn.prepareStatement(sql);
                rs = ps.executeQuery();
                while (rs.next()) {
                    int depID = rs.getInt("depID");
                    String depName = rs.getString("depName");
                    DepartmentDTO department = new DepartmentDTO(depID, depName);
                    String email = rs.getString("email");
                    String name = rs.getString("fullName");
                    String picture = rs.getString("picture");
                    String roleID = rs.getString("roleID");
                    GoogleUserDTO user = new GoogleUserDTO(email, name, picture, roleID, depID);
                    if (hm.containsKey(department)) {
                        hm.get(department).add(user);
                    } else {
                        ArrayList<GoogleUserDTO> list = new ArrayList<>();
                        list.add(user);
                        hm.put(department, list);
                    }
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
        return hm;
    }
}
