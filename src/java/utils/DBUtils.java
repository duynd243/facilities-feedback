/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author Duy
 */
public class DBUtils {

    public static Connection getConnection() throws ClassNotFoundException, SQLException {
        Connection conn = null;
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        String url = "jdbc:sqlserver://" + ConfigUtils.DB_URL + ";databaseName=" + ConfigUtils.DB_NAME;
        conn = DriverManager.getConnection(url, ConfigUtils.DB_USER, ConfigUtils.DB_PASS);
        return conn;
    }
}
