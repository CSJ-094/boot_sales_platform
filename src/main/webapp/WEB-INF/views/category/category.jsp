
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>MANS - MY MODERN SHOP</title>
<link
	href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600;700&family=Noto+Sans+KR:wght@300;400;500;700&display=swap"
	rel="stylesheet" />
	<link rel="stylesheet" href="<c:url value='/css/header.css' />">
	<link rel="stylesheet" href="<c:url value='/css/category.css' />">
</head>
<body>

<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

	<main>
			<section class="recommended-products">
			    <h2>
			        <c:choose>
			            <c:when test="${group == 'mans'}">MANS CATEGORY</c:when>
			            <c:when test="${group == 'women'}">WOMEN CATEGORY</c:when>
			            <c:when test="${group == 'unisex'}">UNISEX CATEGORY</c:when>
			            <c:when test="${group == 'sports'}">SPORTS CATEGORY</c:when>
			            <c:otherwise>ALL CATEGORY</c:otherwise>
			        </c:choose>

			        <c:if test="${sub != 'all'}">
			            -
			            <c:choose>
			                <c:when test="${sub == 'top'}">상의</c:when>
			                <c:when test="${sub == 'bottom'}">하의</c:when>
			                <c:when test="${sub == 'outer'}">아우터</c:when>
			                <c:when test="${sub == 'shoes'}">신발</c:when>
			                <c:when test="${sub == 'acc'}">잡화</c:when>
			            </c:choose>
			        </c:if>
			        ALL PRODUCTS
			    </h2>

			    <c:choose>
			        <c:when test="${not empty productList}">
			            <div class="product-grid">
			                <c:forEach var="product" items="${productList}">
			                    <a href="${pageContext.request.contextPath}/products/detail?prodId=${product.prodId}">
			                        <div class="product-card">
			                            <div class="product-image">
			                                <img src="${pageContext.request.contextPath}${product.prodImgPath}"
			                                     alt="${product.prodName}">
			                            </div>
			                            <div class="product-info">
			                                <p class="product-name">${product.prodName}</p>
			                                <span><fmt:formatNumber value="${product.prodPrice}"
			                                        type="number" />원</span>
			                            </div>
			                        </div>
			                    </a>
			                </c:forEach>
			            </div>
			        </c:when>
			        <c:otherwise>
			            <p>현재 선택한 카테고리에 등록된 상품이 없습니다.</p>
			        </c:otherwise>
			    </c:choose>
			</section>
	</main>

	<footer> © 2025 MY MODERN SHOP. All Rights Reserved. </footer>

</body>
</html>
