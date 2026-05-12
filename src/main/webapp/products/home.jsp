<%--
  Created by IntelliJ IDEA.
  User: DELL INSPIRON 5445
  Date: 5/2/2026
  Time: 10:32 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang chủ</title>
    <link rel="stylesheet" href="style/nav_sidebar.css">
    <link rel="stylesheet" href="style/main_home.css">
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
    <div>
    <aside class="sidebar">
        <a href="auth?page=favorite" alt="" style="color: black; text-decoration: none;"><h3>Danh sách yêu thích</h3></a>
    </aside>
        <br>
    <aside class="sidebar">
        <h3>Bộ lọc nâng cao</h3>
        <form action="products" method="get" id="filterForm">
            <div class="dropdown" onclick="toggleBox('filterBox')">
                Chọn danh mục <span>▼</span>
            </div>

            <div class="dropdown-content" id="filterBox" style="display:none;">
                <p><b>Nhà xuất bản</b></p>
                <c:forEach var="item" items="${brands}">
                    <label>
                        <input type="checkbox" name="brand" value="${item.name}"> ${item.name}
                    </label><br>
                </c:forEach>

                <br>
                <hr>
                <br>

                <p><b>Thể loại</b></p>
                <c:forEach var="item" items="${categories}">
                    <label>
                        <input type="checkbox" name="category" value="${item.name}"> ${item.name}
                    </label><br>
                </c:forEach>
            </div>

            <button type="submit" class="btn" style="width:100%;margin-top:10px;">Lọc</button>
        </form>
    </aside>
    </div>

    <main class="main">
        <fieldset style="display:flex; gap:10px; align-items:center; margin-bottom: 20px; flex-wrap: nowrap; justify-content: flex-start;">
            <legend>Tìm kiếm</legend>
            <form action="products" method="get" style="display:flex;gap:10px; flex: 0 1 700px; max-width: 100%;">
                <input type="text" name="search" value="${param.search}" placeholder="Nhập tên sách..." style="flex:1;padding:8px;">
                <button type="submit" class="btn">Tìm</button>
            </form>
            <c:if test="${not empty currentUser && currentUser.userRole.id == 1}">
                <a href="products?page=add" class="btn" type="button">Thêm sản phẩm</a>
            </c:if>
        </fieldset>

        <fieldset>
            <legend>Danh sách sản phẩm</legend>
            <div class="book-grid">
                <c:forEach var="item" items="${products}">
                    <div class="book-card" style="position: relative; cursor: pointer;" onclick="if(!(event.target.closest('button') || event.target.closest('form'))) { window.location.href='/products?page=detail&id=${item.id}'; }">
                        <div class="img-container">
                            <img src="${item.image}" alt="${item.name}">
                        </div>

                        <div class="details">
                            <div>
                                <div style="font-weight:bold; font-size:1rem;
                                            display: -webkit-box;
                                            -webkit-line-clamp: 2;
                                            -webkit-box-orient: vertical;
                                            overflow: hidden;
                                            text-overflow: ellipsis;
                                            height: 2.4rem;
                                            line-height: 1.2rem;">${item.name}</div>
                                <div style="color:#777;">${item.brand.name}</div>
                            </div>

                            <div>
                                <div class="price">${item.price} VNĐ</div>

                                <div class="actions">
                                    <!-- FAVORITE -->
                                    <c:set var="isFav" value="${favoriteIds.contains(item.id)}" />

                                    <form action="${pageContext.request.contextPath}/favorite" method="post" style="display:inline;">
                                        <input type="hidden" name="productId" value="${item.id}">
                                        <input type="hidden" name="action" value="${isFav ? 'remove' : 'add'}">

                                        <c:if test="${not empty sessionScope.currentUser}">
                                        <button type="submit" class="btn btn-outline" style="${isFav ? 'color: gray; border-color: gray;' : ''}">
                                            <c:choose>
                                                <c:when test="${isFav}">💔 Bỏ thích</c:when>
                                                <c:otherwise>❤️ Yêu thích</c:otherwise>
                                            </c:choose>
                                        </button>
                                        </c:if>
                                    </form>

                                </div>

                                <div class="actions">
                                        <%-- Chỉ hiển thị nút Sửa/Xóa nếu là Admin --%>
                                    <c:if test="${not empty currentUser && currentUser.userRole.id == 1}">
                                        <a href="/products?page=edit&id=${item.id}"><button type="button" class="btn btn-outline">CẬP NHẬT</button></a>
                                        <a href="/products?page=delete&id=${item.id}"><button type="button" class="btn btn-outline">XÓA</button></a>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </fieldset>

<div class="pagination">

    <!-- Trang trước -->
    <c:choose>
        <c:when test="${currentPage == 1}">
            <span class="page-link disabled">Trang trước</span>
        </c:when>
        <c:otherwise>
            <a href="products?page=${currentPage - 1}&search=${param.search}
                <c:forEach var='b' items='${paramValues.brand}'>
                    &brand=${b}
                </c:forEach>
                <c:forEach var='c' items='${paramValues.category}'>
                    &category=${c}
                </c:forEach>"
               class="page-link">
                Trang trước
            </a>
        </c:otherwise>
    </c:choose>


    <!-- Danh sách số trang (hiển thị tối đa 5 trang quanh current) -->
    <c:set var="start" value="${currentPage - 2 > 0 ? currentPage - 2 : 1}" />
    <c:set var="end" value="${currentPage + 2 < totalPages ? currentPage + 2 : totalPages}" />

    <c:forEach begin="${start}" end="${end}" var="i">
        <a href="products?page=${i}&search=${param.search}
            <c:forEach var='b' items='${paramValues.brand}'>
                &brand=${b}
            </c:forEach>
            <c:forEach var='c' items='${paramValues.category}'>
                &category=${c}
            </c:forEach>"
           class="page-link ${currentPage == i ? 'active' : ''}">
            ${i}
        </a>
    </c:forEach>


    <!-- Trang sau -->
    <c:choose>
        <c:when test="${currentPage == totalPages}">
            <span class="page-link disabled">Trang sau</span>
        </c:when>
        <c:otherwise>
            <a href="products?page=${currentPage + 1}&search=${param.search}
                <c:forEach var='b' items='${paramValues.brand}'>
                    &brand=${b}
                </c:forEach>
                <c:forEach var='c' items='${paramValues.category}'>
                    &category=${c}
                </c:forEach>"
               class="page-link">
                Trang sau
            </a>
        </c:otherwise>
    </c:choose>

</div>
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


    function toggleBox(id){
        const box=document.getElementById(id);
        box.style.display = box.style.display === 'block' ? 'none' : 'block';
    }
    function editBook(id){
        window.location.href='products?action=edit&id=' + id;
    }
    function deleteBook(id){
        if(confirm('Bạn có chắc muốn xóa sản phẩm này?')){
            window.location.href='products?action=delete&id=' + id;
        }
    }
</script>
</body>
</html>

