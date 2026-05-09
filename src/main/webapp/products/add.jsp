<%--
  Created by IntelliJ IDEA.
  User: DELL INSPIRON 5445
  Date: 5/9/2026
  Time: 6:40 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm sản phẩm mới</title>
    <link rel="stylesheet" href="style/nav_sidebar.css">
    <link rel="stylesheet" href="style/main_detail.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        .edit-form-group { margin-bottom: 15px; display: flex; flex-direction: column; }
        .edit-form-group label { font-weight: bold; margin-bottom: 5px; color: #555; }
        .edit-form-group input, .edit-form-group textarea, .edit-form-group select {
            padding: 10px; border: 1px solid #ddd; border-radius: 5px; font-size: 1rem;
        }
        .category-checkbox-list {
            display: grid; grid-template-columns: 1fr 1fr; gap: 10px;
            background: #f9f9f9; padding: 10px; border-radius: 5px;
        }
        .btn-submit {
            background: #007bff; color: white; padding: 12px; border: none;
            border-radius: 5px; cursor: pointer; font-weight: bold; width: 100%;
        }
        .btn-submit:hover { background: #0056b3; }
    </style>
</head>
<body>

<header class="header">
    <div class="left">
        <a href="products?page=home" class="logo-link">
            <img src="https://png.pngtree.com/png-vector/20240515/ourmid/pngtree-an-open-book-logo-png-image_12467718.png" alt="Logo" class="logo">
        </a>
    </div>
    <div class="center"><h1>Thêm Sản Phẩm Mới</h1></div>
</header>

<div class="container">
    <main class="main">
        <fieldset>
            <form action="products?action=add" method="post">

                <div class="book-detail-container" style="align-items: flex-start;">

                    <div class="img-container">
                        <div class="edit-form-group" style="margin-top: 15px;">
                            <label>Link ảnh (URL):</label>
                            <input type="text" name="image" onchange="document.getElementById('previewImg').src=this.value" required>
                        </div>
                    </div>

                    <div class="details" style="flex: 2;">

                        <div class="edit-form-group">
                            <label>Tên sách:</label>
                            <input type="text" name="name" value="" required>
                        </div>

                        <div class="edit-form-group">
                            <label>Nhà xuất bản:</label>
                            <select name="brandId">
                                <c:forEach var="b" items="${brands}">
                                    <option value="${b.id}" ${b.id == product.brand.id ? 'selected' : ''}>
                                            ${b.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="edit-form-group">
                            <label>Giá bán (VNĐ):</label>
                            <input type="number" name="price" value="" step="0.1" required>
                        </div>

                        <div class="edit-form-group">
                            <label>Link mua hàng (Affiliate):</label>
                            <input type="text" name="alink" value="" required>
                        </div>

                        <div class="edit-form-group">
                            <label>Thể loại:</label>
                            <div class="category-checkbox-list">
                                <c:forEach var="item" items="${categories}">
                                    <label style="font-weight: normal;">
                                        <input type="checkbox" name="categoryIds" value="${item.id}">
                                            ${item.name}
                                    </label>
                                </c:forEach>
                            </div>
                        </div>
                    </div>

                    <div class="summary-box" style="flex: 0 0 100%;">
                        <h4 style="border-bottom: 1px solid #eee; padding-bottom: 5px;">Tóm tắt nội dung:</h4>
                        <textarea name="summary" rows="8" style="width: 100%; border: 1px solid #ddd; border-radius: 5px; padding: 10px;"></textarea>
                    </div>

                    <div style="flex: 0 0 100%; margin-top: 20px;">
                        <button type="submit" class="btn-submit">LƯU THAY ĐỔI</button>
                        <button type="button" class="btn btn-outline" style="width: 100%; margin-top: 10px;" onclick="history.back()">HỦY BỎ</button>
                    </div>
                </div>
            </form>
        </fieldset>
    </main>
</div>

</body>
</html>
