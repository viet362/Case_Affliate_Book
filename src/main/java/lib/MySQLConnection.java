package lib;

import java.sql.Connection;
import java.sql.DriverManager;

public class MySQLConnection {
    // env là gì ? tại sao cần sử dụng env
    private final static String URL = "jdbc:mysql://localhost:3306/abook"; //
    private final static String USERNAME = "root";
    private final static String PASSWORD = "123456";

    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            return DriverManager.getConnection(URL, USERNAME, PASSWORD);
        } catch (Exception e) {
            return null;
        }
    }
}
