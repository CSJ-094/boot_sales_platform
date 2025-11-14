
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
<style>
* {
	box-sizing: border-box;
	margin: 0;
	padding: 0;
}

body {
	font-family: 'Noto Sans KR', 'Montserrat', sans-serif;
	background-color: #f9f9f9;
	margin: 0;
	padding: 0;
	color: #333;
	line-height: 1.6;
	min-height: 100vh;
	display: flex;
	flex-direction: column;
}

a {
	text-decoration: none;
	color: inherit;
	transition: color 0.3s ease;
}

a:hover {
	color: #886030;
}

ul {
	list-style: none;
}

main {
	max-width: 1440px;
	flex-grow: 1;
	width: 100%;
	margin: 0px auto;
	padding: 20px;
	background: #fff;
	border-radius: 8px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
}

.main-header {
	width: 1440px;
	margin: 0 auto;
	background-color: #2c2c2c;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
	padding: 10px 0 5px 0;
	position: sticky;
	top: 0;
	z-index: 100;
}

.header-top {
	margin: 0 auto;
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 0 20px 5px;
	position: relative;
}

.logo a {
	font-family: 'Montserrat', sans-serif;
	font-size: 18px;
	font-weight: 800;
	color: #ffffff;
	letter-spacing: 1px;
	transition: color 0.3s ease;
}

.logo a:hover {
	color: #b08d57;
}

.user-auth {
	display: flex;
	gap: 5px;
	align-items: center; /* 텍스트와 버튼 정렬 */
}

/* 🚩 추가된 스타일: 로그인 환영 메시지 */
.auth-welcome {
	font-size: 13px;
	color: #ddd;
	padding-right: 5px;
}

.auth-btn {
	padding: 4px 10px;
	border: 1px solid #555;
	border-radius: 3px;
	font-size: 12px;
	color: #ccc !important;
	transition: background-color 0.3s ease, border-color 0.3s ease, color
		0.3s ease;
}

.auth-btn:hover {
	background-color: #b08d57;
	border-color: #b08d57;
	color: #2c2c2c;
}

.auth-btn:visited, .auth-btn:focus, .auth-btn:active {
	color: #ccc !important;
}

/* 🚩 추가된 스타일: 장바구니 버튼 (기존 auth-btn 스타일 재사용) */
/* .cart-btn {} */
.category-nav {
	width: 100%;
	padding-top: 5px;
}

.category-list {
	margin: 0 auto;
	display: flex;
	justify-content: flex-start;
}

.category-item {
	position: relative;
}

.category-item>a {
	display: block;
	padding: 5px 15px;
	font-size: 13px;
	font-weight: 500;
	text-transform: uppercase;
	color: #ccc;
	transition: color 0.3s ease;
}

.category-item>a:hover {
	color: #b08d57;
}

/* 서브 카테고리 드롭다운 (유지) */
.sub-category {
	display: none;
	position: absolute;
	top: 100%;
	left: 0;
	width: 180px;
	background-color: #3a3a3a;
	border: 1px solid #555;
	z-index: 1001;
	padding: 8px 0;
	box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
	border-radius: 4px;
	overflow: hidden;
}

.category-item:hover .sub-category {
	display: block;
}

.sub-category li a {
	display: block;
	padding: 8px 15px;
	font-size: 13px;
	color: #ddd;
	transition: background-color 0.3s ease, color 0.3s ease;
}

.sub-category li a:hover {
	background-color: #4c4c4c;
	color: #b08d57;
}

/* ======= 네비 스타일 ======= */
.mypage-nav {
	margin-bottom: 30px;
}

.mypage-nav ul {
	list-style: none;
	display: flex;
	gap: 25px;
	padding: 0;
	border-bottom: 2px solid #444;
}

.mypage-nav li a {
	display: block;
	padding: 10px 15px;
	font-weight: 600;
	color: #333;
	border-bottom: 3px solid transparent;
	transition: border-color 0.3s ease, background-color 0.3s ease,
		box-shadow 0.3s ease;
	border-radius: 4px;
}

.mypage-nav li a:hover, .mypage-nav li a.active {
	border-color: #444;
	color: #444;
}

.mypage-nav li a:hover {
	background-color: rgba(0, 0, 0, 0.05); /* 검은색 기반으로 투명도 조정 */
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}
/* 기존 스타일 계속 유지 */
h2 {
	border-bottom: 2px solid #444; 
	padding-bottom: 10px;
	margin-bottom: 20px;
	color: #333; /* 본문과 유사한 짙은 회색 */
}

.recommended-products {
	margin-top: 40px;
}

.recommended-products h2 {
	font-size: 20px;
	color: #333; /* 🚩 수정 대상 */
	margin-bottom: 20px;
	border-bottom: 2px solid #444; /* 🚩 수정 대상 */
	padding-bottom: 10px;
}

.product-grid {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(270px, 1fr));
	gap: 0px;
	justify-content: center;
}

.product-card {
	width: 270px;
	height: 290px;
	background: #fff;
	border: 1px solid #eee;
	border-radius: 8px;
	text-align: center;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
	transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.product-card:hover {
	transform: translateY(-5px);
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.product-image img {
	width: 270px;
	height: 290px;
	object-fit: cover;
	border: none;
	border-radius: 0;
}

.product-name {
	padding: 10px 0 5px;
	font-weight: 500;
	font-size: 14px;
	color: #333;
}

.product-price {
	padding-bottom: 12px;
	font-size: 15px;
	color: #d64545;
	font-weight: bold;
}
</style>
</head>
<body>

	<header class="main-header">
		<div class="header-top">

			<div class="logo">
				<a href='<c:url value="/mainpage"/>' title="메인 페이지로 이동">MY MODERN SHOP</a>
			</div>

			<div class="user-auth">
				<c:choose>
					<c:when test="${not empty sessionScope.memberId}">
						<span class="auth-welcome">환영합니다,
							${sessionScope.memberName}님!</span>
						<a href='<c:url value="/mypage"/>' class="auth-btn">마이페이지</a>
						<a href='<c:url value="/cart"/>' class="auth-btn cart-btn">장바구니</a>
						<a href='<c:url value="/logout"/>' class="auth-btn">로그아웃</a>
					</c:when>
					<c:otherwise>
						<a href='<c:url value="/login"/>' class="auth-btn">로그인/회원가입</a>
					</c:otherwise>
				</c:choose>
			</div>
		</div>

		<nav class="category-nav">
			<ul class="category-list">
				<li class="category-item"><a
					href="${pageContext.request.contextPath}/category/mans">MANS</a>
					<ul class="sub-category">
						<li><a href="/category/mans/top">상의</a></li>
						<li><a href="/category/mans/bottom">하의</a></li>
						<li><a href="/category/mans/outer">아우터</a></li>
						<li><a href="/category/mans/acc">모자/액세서리</a></li>
					</ul></li>
				<li class="category-item"><a href="/category/women">WOMEN</a>
					<ul class="sub-category">
						<li><a href="/category/women/top">블라우스/티셔츠</a></li>
						<li><a href="/category/women/dress">원피스</a></li>
						<li><a href="/category/women/skirt">스커트</a></li>
						<li><a href="/category/women/bag">가방/잡화</a></li>
					</ul></li>
				<li class="category-item"><a href="/category/unisex">UNISEX</a>
					<ul class="sub-category">
						<li><a href="/category/unisex/top">상의</a></li>
						<li><a href="/category/unisex/bottom">하의</a></li>
						<li><a href="/category/unisex/outer">아우터</a></li>
						<li><a href="/category/unisex/shoes">신발</a></li>
					</ul></li>
				<li class="category-item"><a href="/category/sports">SPORTS</a>
					<ul class="sub-category">
						<li><a href="/category/sports/top">상의</a></li>
						<li><a href="/category/sports/bottom">하의</a></li>
						<li><a href="/category/sports/outer">아우터</a></li>
						<li><a href="/category/sports/shoes">신발</a></li>
					</ul></li>
			</ul>
		</nav>
	</header>

	<main>
		<!-- 가로 카테고리 네비게이션 -->
		<nav class="mypage-nav">
			<ul>
				<li><a href="#" class="active">상의</a></li>
				<li><a href="#">하의</a></li>
				<li><a href="#">아우터</a></li>
				<li><a href="#">모자/액세서리</a></li>
			</ul>
		</nav>
		<section class="recommended-products">
			<h2>MANS CATEGORY ALL PRODUCTS</h2>
			<c:choose>
				<c:when test="${not empty mansList}">
					<div class="product-grid">
						<c:forEach var="product" items="${mansList}">
							<a
								href="${pageContext.request.contextPath}/product/detail?id=${product.prodId}">
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
