package service;

import entity.Category;
import entity.Product;
import entity.ProductCategory;
import lib.MySQLConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProductCategoryService {
    private final Connection connection;
    public ProductCategoryService() {
        connection = MySQLConnection.getConnection();
    }

    public void add(ProductCategory productCategory) {
        String sql = "INSERT INTO product_category(productID, categoryID) VALUES (?, ?)";
        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, productCategory.getProduct().getId());
            statement.setInt(2, productCategory.getCategory().getId());
            statement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void addMany(int productId, List<Category> categories) {
        for (Category c : categories) {
            ProductCategory pc = new ProductCategory();
            Product p = new Product();
            p.setId(productId);
            pc.setProduct(p);
            pc.setCategory(c);
            add(pc);
        }
    }

    public List<Category> getByProductId(int productId) {
        List<Category> list = new ArrayList<>();

        String sql = "SELECT c.* FROM category c JOIN product_category pc" +
                     "ON c.id = pc.categoryID WHERE pc.productID = ?";

        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, productId);

            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                Category c = new Category(
                        resultSet.getInt("id"),
                        resultSet.getString("name")
                );
                list.add(c);
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    public void update(int productId, List<Category> categories) {
        deleteByProductId(productId);
        addMany(productId, categories);
    }

    public void deleteByProductId(int productId) {
        String sql = "DELETE FROM product_category WHERE productID = ?";
        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, productId);
            statement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
