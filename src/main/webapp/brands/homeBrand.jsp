<%--
  Created by IntelliJ IDEA.
  User: DELL INSPIRON 5445
  Date: 5/9/2026
  Time: 9:38 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Quản lý Thương hiệu</title>
    <link href="style/brand-category.css" rel="stylesheet">
</head>
<body>
<div class="header-container">
    <c:choose>
        <c:when test="${not empty targetProductId}">
            <!-- Nếu có ID sản phẩm, quay lại đúng trang Edit của sản phẩm đó -->
            <a href="products?page=edit&id=${targetProductId}" class="btn-back" title="Quay lại">
                &#10229;
            </a>
        </c:when>
        <c:otherwise>
            <!-- Nếu vào trực tiếp từ add quay lại add -->
            <a href="products?page=add" class="btn-back" title="Quay lại">
                &#10229;
            </a>
        </c:otherwise>
    </c:choose>
    <h2 class="header-title">Quản lý thương hiệu</h2>
</div>
<div class="toolbar">
    <!-- 1. Ô tìm kiếm -->
    <fieldset>
        <legend>Tìm kiếm</legend>
        <form action="brands" method="get" style="display:flex; gap:10px;">
            <input type="hidden" name="page" value="home">
            <input type="hidden" name="productId" value="${targetProductId}">
            <input type="text" name="keyword" value="${param.keyword}" placeholder="Nhập tên thương hiệu..." style="flex:1; padding:8px;">
            <button type="submit" class="btn btn-search">Tìm kiếm</button>
        </form>
    </fieldset>

    <!-- 2. Ô thêm Brand mới -->
    <fieldset>
        <legend>Thêm nhà xuất bản</legend>
        <form action="brands?action=add" method="post" style="display:flex; gap:10px;">
            <input type="hidden" name="targetProductId" value="${targetProductId}">
            <input type="text" name="name" placeholder="Tên thương hiệu mới..." required style="flex:1; padding:8px;">
            <button type="submit" class="btn btn-add">Xác nhận</button>
        </form>
    </fieldset>
</div>

<!-- 3. Bảng danh sách -->
<table>
    <thead>
    <tr>
        <th style="width: 10%;">ID</th>
        <th>Tên Thương Hiệu</th>
        <th style="width: 20%;">Hành động</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="b" items="${brands}">
        <tr>
            <td>${b.id}</td>
            <td>${b.name}</td>
            <td>
                <!-- Nút Edit gọi hàm JS để mở popup -->
                <button class="btn btn-edit" onclick="openEditModal('${b.id}', '${b.name}')">Sửa</button>

                <!-- Nút Delete dùng form post -->
                <form action="brands?action=delete" method="post" style="display:inline;" onsubmit="return confirm('Bạn có chắc muốn xóa?')">
                    <input type="hidden" name="targetProductId" value="${targetProductId}">
                    <input type="hidden" name="id" value="${b.id}">
                    <button type="submit" class="btn btn-delete">Xóa</button>
                </form>
            </td>
        </tr>
    </c:forEach>
    <c:if test="${empty brands}">
        <tr>
            <td colspan="3" style="text-align: center;">Không tìm thấy thương hiệu nào.</td>
        </tr>
    </c:if>
    </tbody>
</table>

<!-- 4. Popup (Modal) Chỉnh sửa -->
<div id="editModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">Cập nhật thương hiệu</div>
        <form action="brands?action=edit" method="post">
            <input type="hidden" name="targetProductId" value="${targetProductId}">
            <input type="hidden" name="id" id="editId">
            <input type="text" name="name" id="editName" required style="width:100%; padding:8px; margin-bottom:10px;">
            <div class="modal-footer">
                <button type="button" class="btn btn-delete" onclick="closeEditModal()" style="background-color: #6c757d;">Hủy</button>
                <button type="submit" class="btn btn-add">Lưu thay đổi</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openEditModal(id, name) {
        document.getElementById('editId').value = id;
        document.getElementById('editName').value = name;
        document.getElementById('editModal').style.display = 'block';
    }

    function closeEditModal() {
        document.getElementById('editModal').style.display = 'none';
    }

    // Đóng modal khi click ra ngoài vùng modal
    window.onclick = function(event) {
        let modal = document.getElementById('editModal');
        if (event.target == modal) {
            closeEditModal();
        }
    }
</script>
</body>
</html>
