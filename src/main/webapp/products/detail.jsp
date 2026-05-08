<%--
  Created by IntelliJ IDEA.
  User: DELL INSPIRON 5445
  Date: 5/8/2026
  Time: 10:50 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông tin sản phẩm</title>
    <link rel="stylesheet" href="style/nav_sidebar.css">
    <link rel="stylesheet" href="style/main_detail.css">
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

<header class="header">
    <div class="left">
        <a href="products?page=home" class="logo-link">
            <img src="https://png.pngtree.com/png-vector/20240515/ourmid/pngtree-an-open-book-logo-png-image_12467718.png" alt="Logo" class="logo">
        </a>
    </div>

    <div class="center">
        <h1>Nhà Sách Trực Tuyến</h1>
    </div>


    <%@ page import="entity.User" %>
    <%
        User currentUser = (User) session.getAttribute("currentUser");
    %>

    <div class="right">
        <i class="fas fa-user-circle" id="userIcon"></i>
        <div class="user-popup" id="userPopup">
            <%
                if (currentUser == null) {
            %>
            <!-- Người dùng chưa đăng nhập -->
            <a href="<%=request.getContextPath()%>/auth?page=signUp">Đăng ký</a>
            <a href="<%=request.getContextPath()%>/auth?page=signIn">Đăng nhập</a>
            <%
            } else {
            %>
            <!-- Người dùng đã đăng nhập -->
            <div class="user-name">Xin chào, <b><%= currentUser.getUsername() %></b></div>
            <a href="<%=request.getContextPath()%>/auth?page=changePassword">Thay đổi mật khẩu</a>
            <a href="<%=request.getContextPath()%>/auth?page=logout">Đăng xuất</a>
            <%
                }
            %>
        </div>
    </div>

</header>

<div class="container">
    <main class="main">
        <fieldset>
            <legend>Thông tin chi tiết</legend>
            <div class="book-detail-container">

                <!-- Ảnh bên trái -->
                <div class="img-container">
                    <img src="${product.image}" alt="${product.name}">
                </div>

                <!-- Thông tin bên phải -->
                <div class="details" style="flex: 2;">
                    <h2>${product.name}</h2>
                    <p style="color:#777;">Nhà xuất bản: <b>${product.brand.name}</b></p>
                    <p class="price">
                        ${product.price} VNĐ
                    </p>

                    <div class="actions">
                        <!-- FAVORITE -->
                        <c:set var="isFav" value="${favoriteIds.contains(product.id)}" />
                        <form action="${pageContext.request.contextPath}/favorite" method="post" style="display:inline;">
                            <input type="hidden" name="productId" value="${product.id}">
                            <input type="hidden" name="action" value="${isFav ? 'remove' : 'add'}">

                            <c:if test="${not empty sessionScope.currentUser}">
                                <button type="submit" class="btn btn-outline">
                                        ${isFav ? '💔 Bỏ thích' : '❤️ Yêu thích'}
                                </button>
                            </c:if>
                        </form>

                        <!-- MUA HÀNG -->
                        <button type="button" class="btn" style="background: #28a745; color: white;"
                                onclick="window.location.href='${product.alink}'">
                            Mua ngay (Tới nơi bán)
                        </button>
                    </div>

                    <c:if test="${not empty currentUser && currentUser.userRole.id == 1}">
                        <div class="admin-actions" style="margin-top: 15px; padding-top: 15px; border-top: 1px dashed #ccc;">
                            <a href="/products?page=edit&id=${product.id}"><button type="button" class="btn btn-outline">CẬP NHẬT SẢN PHẨM</button></a>
                            <a href="/products?page=delete&id=${product.id}"><button type="button" class="btn btn-outline">XÓA SẢN PHẨM</button></a>
                        </div>
                    </c:if>
                </div>
                <div class="summary-box" style="margin: 20px 0; line-height: 1.6; color: #333;">
                    <h4 style="border-bottom: 1px solid #eee; padding-bottom: 5px;">Tóm tắt nội dung:</h4>
                    ${product.summary}
                </div>
            </div>
        </fieldset>

    </main>
</div>

<script>

    const icon = document.getElementById("userIcon");
    const popup = document.getElementById("userPopup");
    // Toggle menu khi click icon
    icon.addEventListener("click", function(e){
        e.stopPropagation();
        popup.style.display = (popup.style.display === "block") ? "none" : "block";
    });

    // Click ra ngoài ẩn menu
    document.addEventListener("click", function(){
        popup.style.display = "none";
    });

    // Click bên trong menu không ẩn
    popup.addEventListener("click", function(e){
        e.stopPropagation();
    });
</script>
</body>
</html>
