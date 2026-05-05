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
</head>
<body>
<center>
  <h1>Sign Up</h1>
  <form method="POST" action="/auth?action=signUp">
    <input type="text" name="username" placeholder="Username">
    <input type="text" name="password" placeholder="Password">
    <button>Submit</button>
  </form>
  <a href="/auth?page=signIn">You've account? Sign in.</a>
</center>
</body>
</html>
