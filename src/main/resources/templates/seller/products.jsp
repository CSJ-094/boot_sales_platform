<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>상품 관리</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/sellerstyle.css" />
</head>
<body>
  <jsp:include page="/WEB-INF/views/fragments/header.jsp" />

  <main class="mypage-body">
    <aside class="mypage-sidebar">
      <nav>
        <ul>
          <li class="sidebar-title">판매자 마이페이지</li>
          <li><a href="${pageContext.request.contextPath}/seller/products" class="active">상품 관리</a></li>
          <li><a href="${pageContext.request.contextPath}/seller/members">회원 관리</a></li>
          <li><a href="${pageContext.request.contextPath}/seller/notices">공지사항</a></li>
        </ul>
      </nav>
    </aside>

    <section class="mypage-content-area">
     <header class="page-header">
  <div class="page-title">
    <h2>상품 관리</h2>
  </div>

  <a href="${pageContext.request.contextPath}/seller/products/new" class="btn btn-primary btn-lg">
    <span class="btn-icon" aria-hidden="true">＋</span>
    신규 상품 등록
  </a>
</header>

      <!-- 등록 성공 배너 (Flash Attribute) -->
      <c:if test="${not empty createdId}">
        <div class="alert success" style="margin-bottom:16px;">
          상품 #${createdId} 이(가) 등록되었습니다.
          <a href="${pageContext.request.contextPath}/seller/products/${createdId}" style="margin-left:8px;">상세 보기</a>
        </div>
      </c:if>

      <!-- 상품 목록 -->
      <section class="product-list">
        <h3 class = "section-title">상품 목록</h3>

        <c:if test="${empty products}">
          <p>상품이 없습니다.</p>
        </c:if>

        <c:if test="${not empty products}">
          <table class="table">
            <thead>
              <tr>
                <th>ID</th>
                <th>상품명</th>
                <th>가격</th>
                <th>재고</th>
                <th>판매자</th>
                <th>상세</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="p" items="${products}">
                <tr>
                  <td>${p.prodId}</td>
                  <td>${p.prodName}</td>
                  <td><fmt:formatNumber value="${p.prodPrice}" type="number"/>원</td>
                  <td>${p.prodStock}</td>
                  <td>${p.prodSeller}</td>
                  <td><a href="${pageContext.request.contextPath}/seller/products/${p.prodId}"><b>보기</b></a></td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </c:if>
      </section>
    </section>
  </main>

  <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />
</body>
</html>
