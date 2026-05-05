package service;

import entity.Brand;
import entity.Product;
import lib.MySQLConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProductService implements IService<Product> {
    private final Connection connection;
    public ProductService() {
        connection = MySQLConnection.getConnection();
    }
    public final BrandService brandService = new BrandService();

    @Override
    public void add(Product product) {
        String sql = "INSERT INTO product(name, price, brandID, image, summary, alink) VALUES (?, ?, ?, ?, ?, ?)";

        try {
            PreparedStatement statement = connection.prepareStatement(sql);

            statement.setString(1, product.getName());
            statement.setDouble(2, product.getPrice());
            statement.setInt(3, product.getBrand().getId());
            statement.setString(4, product.getImage());
            statement.setString(5, product.getSummary());
            statement.setString(6, product.getAlink());
            statement.executeUpdate();

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public List<Product> getAll() {
        String sql = "SELECT product.*, brand.id AS brandId, brand.name AS brandName\n" +
                "FROM product JOIN brand ON product.brandID = brand.id";
        List<Product> list = new ArrayList<>();
        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {

                Brand brand = new Brand(
                        resultSet.getInt("brandId"),
                        resultSet.getString("brandName")
                );

                Product product = new Product(
                        resultSet.getInt("id"),
                        resultSet.getString("name"),
                        resultSet.getDouble("price"),
                        brand,
                        resultSet.getString("image"),
                        resultSet.getString("summary"),
                        resultSet.getString("alink")
                );

                list.add(product);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    @Override
    public Product getById(int id) {
        String sql = "SELECT product.*, brand.id AS brandId, brand.name AS brandName\n" +
                "FROM product JOIN brand ON product.brandID = brand.id WHERE product.id = ?";
        Product foundProduct = null;
        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            ResultSet resultSet = statement.executeQuery();
            resultSet.next();
            String name = resultSet.getString("name");
            double price = resultSet.getDouble("price");
            int brandId = resultSet.getInt("brandId");
            String brandName = resultSet.getString("brandName");
            Brand brand  = new Brand(brandId, brandName);
            String image = resultSet.getString("image");
            String summary = resultSet.getString("summary");
            String alink = resultSet.getString("alink");
            foundProduct = new Product(id, name, price, brand, image, summary, alink);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return foundProduct;
    }

    @Override
    public void update(int id, Product product) {
        String sql = """
                UPDATE product
                SET name = ?, price = ?, brandID = ?, image = ?, summary = ?, alink = ?
                WHERE id = ?
                """;

        try {
            PreparedStatement statement = connection.prepareStatement(sql);

            statement.setString(1, product.getName());
            statement.setDouble(2, product.getPrice());
            statement.setInt(3, product.getBrand().getId());
            statement.setString(4, product.getImage());
            statement.setString(5, product.getSummary());
            statement.setString(6, product.getAlink());
            statement.setInt(7, id);

            statement.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void delete(int id) {
        String sql = "DELETE FROM product WHERE id = ?";

        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            statement.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public List<Product> filter(String keyword, String[] brands, String[] categories,
                            int page, int pageSize) {

    List<Product> list = new ArrayList<>();
    StringBuilder sql = new StringBuilder();

    sql.append("SELECT DISTINCT p.*, b.name AS nameBrand ");
    sql.append("FROM product p ");
    sql.append("LEFT JOIN brand b ON p.brandId = b.id ");
    sql.append("LEFT JOIN product_category pc ON p.id = pc.productId ");
    sql.append("LEFT JOIN category c ON pc.categoryId = c.id ");
    sql.append("WHERE 1=1 ");

    // keyword
    if (keyword != null && !keyword.trim().isEmpty()) {
        sql.append("AND p.name LIKE ? ");
    }

    // brands
    if (brands != null && brands.length > 0) {
        sql.append("AND b.name IN (");
        for (int i = 0; i < brands.length; i++) {
            sql.append("?");
            if (i < brands.length - 1) sql.append(",");
        }
        sql.append(") ");
    }

    // categories
    if (categories != null && categories.length > 0) {
        sql.append("AND c.name IN (");
        for (int i = 0; i < categories.length; i++) {
            sql.append("?");
            if (i < categories.length - 1) sql.append(",");
        }
        sql.append(") ");
    }

    // 👉 Pagination (QUAN TRỌNG)
    sql.append("LIMIT ? OFFSET ?");

    try {
        PreparedStatement st = connection.prepareStatement(sql.toString());

        int index = 1;

        if (keyword != null && !keyword.trim().isEmpty()) {
            st.setString(index++, "%" + keyword + "%");
        }

        if (brands != null) {
            for (String b : brands) {
                st.setString(index++, b);
            }
        }

        if (categories != null) {
            for (String c : categories) {
                st.setString(index++, c);
            }
        }

        // pagination params
        int offset = (page - 1) * pageSize;
        st.setInt(index++, pageSize);
        st.setInt(index++, offset);

        ResultSet rs = st.executeQuery();

        while (rs.next()) {
            Product p = new Product(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getDouble("price"),
                    new Brand(rs.getInt("brandId"), rs.getString("nameBrand")),
                    rs.getString("image")
            );
            list.add(p);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}

public int count(String keyword, String[] brands, String[] categories) {

    StringBuilder sql = new StringBuilder();

    sql.append("SELECT COUNT(DISTINCT p.id) ");
    sql.append("FROM product p ");
    sql.append("LEFT JOIN brand b ON p.brandId = b.id ");
    sql.append("LEFT JOIN product_category pc ON p.id = pc.productId ");
    sql.append("LEFT JOIN category c ON pc.categoryId = c.id ");
    sql.append("WHERE 1=1 ");

    if (keyword != null && !keyword.trim().isEmpty()) {
        sql.append("AND p.name LIKE ? ");
    }

    if (brands != null && brands.length > 0) {
        sql.append("AND b.name IN (");
        for (int i = 0; i < brands.length; i++) {
            sql.append("?");
            if (i < brands.length - 1) sql.append(",");
        }
        sql.append(") ");
    }

    if (categories != null && categories.length > 0) {
        sql.append("AND c.name IN (");
        for (int i = 0; i < categories.length; i++) {
            sql.append("?");
            if (i < categories.length - 1) sql.append(",");
        }
        sql.append(") ");
    }

    try {
        PreparedStatement st = connection.prepareStatement(sql.toString());

        int index = 1;

        if (keyword != null && !keyword.trim().isEmpty()) {
            st.setString(index++, "%" + keyword + "%");
        }

        if (brands != null) {
            for (String b : brands) {
                st.setString(index++, b);
            }
        }

        if (categories != null) {
            for (String c : categories) {
                st.setString(index++, c);
            }
        }

        ResultSet rs = st.executeQuery();
        if (rs.next()) {
            return rs.getInt(1);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return 0;
}

    public List<Product> getFavoriteByUser(int userId) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.*, b.id AS brandId, b.name AS brandName " +
                "FROM user_favorite uf " +
                "JOIN product p ON uf.productID = p.id " +
                "JOIN brand b ON p.brandID = b.id " +
                "WHERE uf.userID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Brand brand = new Brand(
                            rs.getInt("brandId"),
                            rs.getString("brandName")
                    );
                    Product p = new Product(
                            rs.getInt("id"),
                            rs.getString("name"),
                            rs.getDouble("price"),
                            brand,
                            rs.getString("image"),
                            rs.getString("summary"),
                            rs.getString("alink")
                    );
                    list.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
