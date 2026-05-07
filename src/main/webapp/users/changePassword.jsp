<%--
  Created by IntelliJ IDEA.
  User: DELL INSPIRON 5445
  Date: 5/7/2026
  Time: 9:35 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Đổi mật khẩu</title>
  <link rel="stylesheet" href="style/nav_sidebar.css">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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
      <a href="<%=request.getContextPath()%>/auth?page=change_password">Thay đổi mật khẩu</a>
      <a href="<%=request.getContextPath()%>/auth?page=logout">Đăng xuất</a>
      <%
        }
      %>
    </div>
  </div>

</header>

<%--  change pass main --%>
<main class="container d-flex justify-content-center align-items-center vh-80">
  <div class="card shadow-lg border-0 p-4" style="width: 400px; border-radius: 15px;">
    <div class="card-body">
      <h3 class="card-title text-center mb-4">Đổi mật khẩu</h3>

      <p class="text-muted text-center mb-4">
        Tài khoản: <span class="badge bg-light text-dark fs-6">${currentUser.username}</span>
      </p>

      <form method="POST" action="auth?action=changePassword">
        <div class="mb-3">
          <label for="oldPassword" class="form-label fw-bold">Mật khẩu hiện tại</label>
          <input type="password" class="form-control" id="oldPassword" name="oldPassword"
                 placeholder="Nhập mật khẩu hiện tại" required>
        </div>

        <div class="mb-3">
          <label for="newPassword" class="form-label fw-bold">Mật khẩu mới</label>
          <input type="password" class="form-control" id="newPassword" name="newPassword"
                 placeholder="Nhập mật khẩu mới" required>
        </div>

        <c:if test="${not empty message}">
          <div class="alert alert-danger py-2 text-center" role="alert" style="font-size: 0.9rem;">
              ${message}
          </div>
        </c:if>

        <div class="mt-4">
          <button type="submit" class="btn btn-primary w-100 shadow-sm fw-bold py-2">
            Xác nhận thay đổi
          </button>
        </div>
      </form>

      <div class="text-center mt-3">
        <a href="products?page=home" class="text-decoration-none small text-secondary">Quay lại trang chủ</a>
      </div>
    </div>
  </div>
</main>
</div>
</body>
</html>
