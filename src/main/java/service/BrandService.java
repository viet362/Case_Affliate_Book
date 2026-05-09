package service;

import entity.Brand;
import entity.Category;
import entity.Product;
import lib.MySQLConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BrandService implements IService<Brand>{
    private final Connection connection;
    public BrandService() {
        connection = MySQLConnection.getConnection();
    }

    @Override
    public void add(Brand brand) {
        String sql = "INSERT INTO brand(name) VALUES (?)";
        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, brand.getName());
            statement.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public List<Brand> getAll() {
        String sql = "SELECT * FROM brand";
        List<Brand> list = new ArrayList<>();
        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
                int id = resultSet.getInt("id");
                String name = resultSet.getString("name");
                list.add(new Brand(id, name));
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    @Override
    public Brand getById(int id) {
        String sql = "SELECT * FROM brand WHERE id = ?";
        Brand foundBrand = null;
        try{
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            ResultSet resultSet = statement.executeQuery();
            resultSet.next();
            String name = resultSet.getString("name");
            foundBrand = new Brand(id, name);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return foundBrand;
    }

    @Override
    public void update(int id, Brand brand) {
        String sql = "UPDATE brand SET name = ? WHERE id = ?";
        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, brand.getName());
            statement.setInt(2, id);
            statement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void delete(int id) {
        String sql = "DELETE FROM brand WHERE id = ?";
        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            statement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public List<Brand> getByNameContains(String keyword) {
        if(keyword == null) keyword = "";
        keyword = "%" + keyword + "%";
        System.out.println(keyword);
        String sql = "select * from brand where brand.name like ?";
        List<Brand> list = new ArrayList<>();
        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, keyword);
            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
                int id = resultSet.getInt("id");
                String name = resultSet.getString("name");
                Brand brand = new Brand(id, name);
                list.add(brand);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return list;
    }
}
