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
        int statusID = 0;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "SELECT * FROM tblUsers WHERE email = ?";
                ps = conn.prepareStatement(sql);
                ps.setString(1, user.getEmail());
                rs = ps.executeQuery();
                if (rs.next()) {
                    roleID = rs.getString("roleID").trim();
                    depID = rs.getInt("depID");
                    statusID = rs.getInt("statusID");
                }
                user.setRoleID(roleID);
                user.setDepID(depID);
                user.setStatusID(statusID);
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

    public boolean blockUser(String blockSenderEmail) throws SQLException {
        int check = 0;
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtils.getConnection();
            String sql = "UPDATE tblUsers SET statusID = 0 WHERE email = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, blockSenderEmail);
            check = ps.executeUpdate();
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

    public boolean unblockUser(String email) throws SQLException {
        int check = 0;
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtils.getConnection();
            String sql = "UPDATE tblUsers SET statusID = 1 WHERE email = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            check = ps.executeUpdate();
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
            ps.executeUpdate();
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

    // Function show list Employee theo từ khoá (tìm theo tên), Department và có phân trang
    public ArrayList<GoogleUserDTO> getListEmployee(String searchName, int searchDepID, int page) throws SQLException {
        ArrayList<GoogleUserDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int size = 5;
        int endIndex = size * page;
        int startIndex = endIndex - size + 1;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "";
                if (searchDepID != 0) {
                    sql = "SELECT *\n"
                            + "    FROM (\n"
                            + "        SELECT tblUsers.email, fullName, picture, depID, tblRates.rate, ROW_NUMBER() OVER (ORDER BY depID) AS RowNum\n"
                            + "        FROM tblUsers, tblRates where tblRates.email = tblUsers.email AND fullName LIKE ? AND roleID = 'EP' and statusID = 1 and depID = ?\n"
                            + "    ) AS MyDerivedTable\n"
                            + "    WHERE (MyDerivedTable.RowNum BETWEEN ? AND ?)";
                    ps = conn.prepareStatement(sql);
                    ps.setString(1, "%" + searchName + "%");
                    ps.setInt(2, searchDepID);
                    ps.setInt(3, startIndex);
                    ps.setInt(4, endIndex);
                } else {
                    sql = "SELECT *\n"
                            + "    FROM (\n"
                            + "        SELECT tblUsers.email, fullName, picture, depID, tblRates.rate, ROW_NUMBER() OVER (ORDER BY depID) AS RowNum\n"
                            + "        FROM tblUsers, tblRates where tblRates.email = tblUsers.email AND fullName LIKE ? AND roleID = 'EP' and statusID = 1\n"
                            + "    ) AS MyDerivedTable\n"
                            + "    WHERE (MyDerivedTable.RowNum BETWEEN ? AND ?)";
                    ps = conn.prepareStatement(sql);
                    ps.setString(1, "%" + searchName + "%");
                    ps.setInt(2, startIndex);
                    ps.setInt(3, endIndex);
                }
                rs = ps.executeQuery();
                while (rs.next()) {
                    String email = rs.getString("email");
                    String fullName = rs.getString("fullName");
                    String picture = rs.getString("picture");
                    int depID = rs.getInt("depID");
                    float rate = rs.getFloat("rate");
                    list.add(new GoogleUserDTO(email, fullName, picture, depID, rate));
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

    public int TotalEmployee(String searchName, int searchDepID) throws SQLException {
        int total = 0;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "";
                if (searchDepID != 0) {
                    sql = "select count(*) as total\n"
                            + "from tblUsers, tblRates\n"
                            + "where tblRates.email = tblUsers.email\n"
                            + "AND fullName LIKE ?\n"
                            + "AND roleID = 'EP'\n"
                            + "and statusID = 1\n"
                            + "and depID = ?";
                    ps = conn.prepareStatement(sql);
                    ps.setString(1, "%" + searchName + "%");
                    ps.setInt(2, searchDepID);
                } else {
                    sql = "select count(*) as total\n"
                            + "from tblUsers, tblRates\n"
                            + "where tblRates.email = tblUsers.email\n"
                            + "AND fullName LIKE ?\n"
                            + "AND roleID = 'EP'\n"
                            + "and statusID = 1";

                    ps = conn.prepareStatement(sql);
                    ps.setString(1, "%" + searchName + "%");
                }
                rs = ps.executeQuery();
                if (rs.next()) {
                    total = rs.getInt("total");
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
        return total;
    }

    public ArrayList<GoogleUserDTO> getListUser(String searchName, int statusID, int page) throws SQLException {
        ArrayList<GoogleUserDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int size = 5;
        int endIndex = size * page;
        int startIndex = endIndex - size + 1;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "";
                if (statusID == -1) {
                    sql = "SELECT *\n"
                            + "    FROM (\n"
                            + "        SELECT *, ROW_NUMBER() OVER (ORDER BY fullName) AS RowNum\n"
                            + "        FROM tblUsers where fullName LIKE ? AND roleID = 'US'\n"
                            + "    ) AS MyDerivedTable\n"
                            + "    WHERE (MyDerivedTable.RowNum BETWEEN ? AND ?)";
                    ps = conn.prepareStatement(sql);
                    ps.setString(1, "%" + searchName + "%");
                    ps.setInt(2, startIndex);
                    ps.setInt(3, endIndex);
                } else {
                    sql = "SELECT *\n"
                            + "    FROM (\n"
                            + "        SELECT *, ROW_NUMBER() OVER (ORDER BY fullName) AS RowNum\n"
                            + "        FROM tblUsers where fullName LIKE ? AND roleID = 'US' and statusID = ?\n"
                            + "    ) AS MyDerivedTable\n"
                            + "    WHERE (MyDerivedTable.RowNum BETWEEN ? AND ?)";
                    ps = conn.prepareStatement(sql);
                    ps.setString(1, "%" + searchName + "%");
                    ps.setInt(2, statusID);
                    ps.setInt(3, startIndex);
                    ps.setInt(4, endIndex);
                }
                rs = ps.executeQuery();
                while (rs.next()) {
                    String email = rs.getString("email");
                    String fullName = rs.getString("fullName");
                    String picture = rs.getString("picture");
                    statusID = rs.getInt("statusID");
                    list.add(new GoogleUserDTO(email, fullName, picture, statusID));
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

    public int TotalUser(String searchName, int searchStatusID) throws SQLException {
        int total = 0;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "";
                if (searchStatusID == -1) {
                    sql = "select count(*) as total\n"
                            + "from tblUsers\n"
                            + "where fullName LIKE ?\n"
                            + "AND roleID = 'US'";
                    ps = conn.prepareStatement(sql);
                    ps.setString(1, "%" + searchName + "%");
                } else {
                    sql = "select count(*) as total\n"
                            + "from tblUsers\n"
                            + "where fullName LIKE ?\n"
                            + "AND roleID = 'US'\n"
                            + "and statusID = ?";

                    ps = conn.prepareStatement(sql);
                    ps.setString(1, "%" + searchName + "%");
                    ps.setInt(2, searchStatusID);
                }
                rs = ps.executeQuery();
                if (rs.next()) {
                    total = rs.getInt("total");
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
        return total;
    }

    public boolean hasProcessingFeedback(String email) throws SQLException {
        int check = 0;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "select count(*) as total\n"
                        + "from tblFeedbacks\n"
                        + "where handlerEmail = ?\n"
                        + "AND (statusID = 2 or statusID = 3)";
                ps = conn.prepareStatement(sql);
                ps.setString(1, email);
                rs = ps.executeQuery();
                if (rs.next()) {
                    check = rs.getInt("total");
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
        return check > 0;
    }

    public boolean changeDepartment(String email, int newDepID) throws SQLException {
        int check = 0;
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "update tblUsers set depID = ? WHERE email = ?";
                ps = conn.prepareStatement(sql);
                ps.setInt(1, newDepID);
                ps.setString(2, email);
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