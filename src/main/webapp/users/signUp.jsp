<%--
  Created by IntelliJ IDEA.
  User: truon
  Date: 4/28/2026
  Time: 7:11 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Đăng ký</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body class="bg-light">

<div class="container d-flex justify-content-center align-items-center vh-100">
  <div class="card shadow p-4" style="width: 350px;">

    <h3 class="text-center mb-4">Đăng ký</h3>

    <form method="POST" action="/auth?action=signUp">
      <div class="mb-3">
        <label class="form-label">Tên đăng nhập</label>
        <input type="text" class="form-control" name="username" placeholder="Username">
      </div>

      <div class="mb-3">
        <label class="form-label">Mật khẩu</label>
        <input type="password" class="form-control" name="password" placeholder="Password">
      </div>

      <button class="btn btn-success w-100">Xác nhận</button>
    </form>

    <div class="text-center mt-3">
      <a href="auth?page=signIn">Đã có tài khoản? Đăng nhập.</a>
    </div>

  </div>
</div>

</body>

</body>
</html>
