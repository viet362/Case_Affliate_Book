package service;

import entity.User;
import entity.UserRole;
import lib.MySQLConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserService {
    private Connection connection;

    public UserService() {
        this.connection = MySQLConnection.getConnection();
    }

    public User signIn(String username, String password) {
        String sql = "select * from user where username = ? and password = ?;";
        User foundUser = null;
        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, username);
            statement.setString(2, password);
            ResultSet resultSet = statement.executeQuery();
            boolean isFoundUser = resultSet.next();
            if(isFoundUser) {
                int id = resultSet.getInt("id");
                int roleID = resultSet.getInt("roleID");
                foundUser = new User(id, username);

                UserRole role = new UserRole();
                role.setId(roleID);

                foundUser.setUserRole(role);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return foundUser;
    }

    public void signUp(User user) {
        String sql = "insert into user(username, password , roleID) values (?, ?, ?);";
        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, user.getUsername());
            statement.setString(2, user.getPassword());
            statement.setInt(3, 2);
            statement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public boolean changePassword(int userId, String oldPassword, String newPassword) {
        String sqlSelect = "SELECT password FROM user WHERE id = ?";
        String sqlUpdate = "UPDATE user SET password = ? WHERE id = ?";

        try {
            PreparedStatement psSelect = connection.prepareStatement(sqlSelect);
            psSelect.setInt(1, userId);
            ResultSet rs = psSelect.executeQuery();

            if (!rs.next()) {
                return false;
            }

            String passwordInDB = rs.getString("password");

            if (!passwordInDB.equals(oldPassword)) {
                return false; // sai mật khẩu
            }

            PreparedStatement psUpdate = connection.prepareStatement(sqlUpdate);
            psUpdate.setString(1, newPassword);
            psUpdate.setInt(2, userId);

            int rows = psUpdate.executeUpdate();

            return rows > 0; // true nếu update thành công

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isAdmin(User user) {
        return user != null && user.getUserRole().getId() == 1;
    }

}
