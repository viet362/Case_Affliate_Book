package entity;

import java.util.List;

public class Product {
    private int id;
    private String name;
    private double price;
    private Brand brand;
    private String image;
    private String summary;
    private String alink;
    private List<Category> categories;

    public Product() {
    }

    public Product(int id, String name, double price, Brand brand, String image, String summary, String alink, List<Category> categories) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.brand = brand;
        this.image = image;
        this.summary = summary;
        this.alink = alink;
        this.categories = categories;
    }

    public Product(int id, String name, double price, Brand brand, String image, String summary, String alink) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.brand = brand;
        this.image = image;
        this.summary = summary;
        this.alink = alink;
    }

    public Product(String name, double price, Brand brand, String image, String summary, String alink) {
        this.name = name;
        this.price = price;
        this.brand = brand;
        this.image = image;
        this.summary = summary;
        this.alink = alink;
    }

    public Product(int id, String name, double price, Brand brand, String image) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.brand = brand;
        this.image = image;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }


    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }



    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }



    public Brand getBrand() {
        return brand;
    }

    public void setBrand(Brand brand) {
        this.brand = brand;
    }



    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }



    public String getSummary() {
        return summary;
    }

    public void setSummary(String summary) {
        this.summary = summary;
    }



    public String getAlink() {
        return alink;
    }

    public void setAlink(String alink) {
        this.alink = alink;
    }



    public List<Category> getCategories() {
        return categories;
    }

    public void setCategories(List<Category> categories) {
        this.categories = categories;
    }


    @Override
    public String toString() {
        return "Product{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", price=" + price +
                '}';
    }
}