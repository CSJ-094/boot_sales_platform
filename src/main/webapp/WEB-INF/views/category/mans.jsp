
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
	<link rel="stylesheet" href="<c:url value='/css/mans.css' />">
</head>
<body>

<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

	<main>
		<!-- 가로 카테고리 네비게이션 -->
		<nav class="mypage-nav">
			<ul>
				<li><a href="#" class="active">상의</a></li>
				<li><a href="#">하의</a></li>
				<li><a href="#">아우터</a></li>
				<li><a href="#">신발</a></li>
				<li><a href="#">잡화</a></li>
			</ul>
		</nav>
		<section class="recommended-products">
			<h2>MANS CATEGORY ALL PRODUCTS</h2>
			<c:choose>
				<c:when test="${not empty mansList}">
					<div class="product-grid">
						<c:forEach var="product" items="${mansList}">
							<a
								href="${pageContext.request.contextPath}/products/detail?prodId=${product.prodId}">
								<div class="product-card">
									<div class="product-image">
										<img
											src="${pageContext.request.contextPath}${product.prodImgPath}"
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
					<p>현재 MENS 카테고리에 등록된 상품이 없습니다.</p>
				</c:otherwise>
			</c:choose>
		</section>

	</main>

	<footer> © 2025 MY MODERN SHOP. All Rights Reserved. </footer>
</body>
</html>
