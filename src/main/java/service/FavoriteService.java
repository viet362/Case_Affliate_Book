package service;

import lib.MySQLConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class FavoriteService {
    private Connection connection;

    public FavoriteService() {
        this.connection = MySQLConnection.getConnection();
    }

    public boolean addFavorite(int userId, int productId) {
        String sql = "INSERT INTO user_favorite (userID, productID) VALUES (?, ?)";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, userId);
            statement.setInt(2, productId);
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            // nếu bị duplicate (do UNIQUE) thì bỏ qua
            return false;
        }
    }

    private boolean isFavorite(int userId, int productId) {
        String sql = "SELECT * FROM user_favorite WHERE userID = ? AND productID = ?";
        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, userId);
            statement.setInt(2, productId);
            ResultSet resultSet = statement.executeQuery();
            return resultSet.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean removeFavorite(int userId, int productId){
        String sql = "DELETE FROM user_favorite WHERE userID = ? AND productID = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, userId);
            statement.setInt(2, productId);
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public void toggleFavorite(int userId, int productId) {
        if (isFavorite(userId, productId)) {
            removeFavorite(userId, productId);
        } else {
            addFavorite(userId, productId);
        }
    }

}
