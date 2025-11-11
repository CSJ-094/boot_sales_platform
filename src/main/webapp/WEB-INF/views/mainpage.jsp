<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>메인 페이지 - MY MODERN SHOP</title>
<link
	href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600;700;800&family=Noto+Sans+KR:wght@300;400;500;700&display=swap"
	rel="stylesheet">
<style>

* {
	box-sizing: border-box;
	margin: 0;
	padding: 0;
}

body {
	font-family: 'Noto Sans KR', 'Montserrat', sans-serif;
	color: #333;
	line-height: 1.6;
	background-color: #f9f9f9;
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

/* ==================== 1. 헤더 (유지) ==================== */
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

/* ==================== 2. 바디 & 이벤트 배너 (유지) ==================== */
/* 너비 1440px로 수정*/
.slider-section {
	width: 100%;
	max-width: 1440px;
	height: 430px;
	padding-bottom: 0;
	position: relative;
	margin: 0 auto 50px auto;
	overflow: hidden;
	box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
}

.banner-inner {
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	justify-content: center;
	align-items: center;
}

.slide {
	width: 100%;
	height: 100%;
	position: absolute;
	top: 0;
	left: 0;
	transition: left 1.0s ease-in-out;
	background-repeat: no-repeat;
	background-position: center center;
	background-size: cover;
}

#slide2 {
	left: 100%;
}

/* 메인 콘텐츠 영역 (main-content) - 왼쪽 마진 350px로 고정 */
.main-content {
	max-width: 1440px;
	margin-right: auto; /* 오른쪽은 자동 마진 */
	margin-left: 350px;
	padding: 0 20px;
	flex-grow: 1;
}

/* 2-3. 추천 상품 섹션 제목 (유지) */
.recommend-section h4 {
	font-size: 24px;
	color: #333;
	border-bottom: 2px solid #b08d57;
	padding-bottom: 12px;
	margin-bottom: 25px;
	text-align: left;
	letter-spacing: 0.5px;
	font-weight: 600;
}

/* 상품 아이템 스타일 (유지) */
.product-grid {
	display: grid;
	grid-template-columns: repeat(4, 1fr);
	gap: 20px;
	margin-bottom: 50px;
}

.product-item {
	background-color: #ffffff;
	border: 1px solid #e0e0e0;
	border-radius: 6px;
	overflow: hidden;
	text-align: center;
	transition: box-shadow 0.3s ease, transform 0.3s ease;
	box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
}

.product-item:hover {
	box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
	transform: translateY(-3px);
}

.product-img {
	width: 100%;
	height: 80%;
	padding-bottom: 10%;
	background-color: #f0f0f0;
	display: flex;
	justify-content: center;
	align-items: center;
	font-size: 14px;
	color: #999;
	border-bottom: 1px solid #eee;
}

.product-info {
	padding: 10px;
	color: #333;
}

.product-info p {
	font-weight: 500;
	margin-bottom: 0;
	font-size: 14px;
}

.product-info span {
	color: #d64545;
	font-weight: 700;
	font-size: 15px;
}

/* 푸터 (유지) */
.main-footer {
	background-color: #e0e0e0;
	color: #666;
	padding: 25px 0;
	margin-top: auto;
	font-size: 13px;
	border-top: 1px solid #d0d0d0;
	box-shadow: 0 -2px 8px rgba(0, 0, 0, 0.05);
}

.footer-content {
	max-width: 1200px;
	margin: 0 auto;
	padding: 0 20px;
	text-align: center;
}

.footer-content p {
	margin-bottom: 4px;
}

.footer-content p:last-child {
	margin-bottom: 0;
}
</style>
</head>
<body>

	<header class="main-header">
		<div class="header-top">

			<div class="logo">
				<a href="/">MY MODERN SHOP</a>
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

	<section class="slider-section">
		<div class="banner-inner">
			<div class="slide" id="slide1"
				style="background-image: url('<c:url value="/img/main_banner.jpg"/>');">
			</div>
			<div class="slide" id="slide2"
				style="background-image: url('<c:url value="/img/main_banner2.jpg"/>');">
			</div>
		</div>
	</section>

	<main class="main-content">
		<section class="recommend-section">

			<h4>MANS 추천 상품</h4>
			<div class="product-grid">
				<c:choose>
					<c:when test="${not empty mansRecommendList}">
						<c:forEach var="product" items="${mansRecommendList}">
							<a
								href="${pageContext.request.contextPath}/product/detail?id=${product.prodId}">
								<div class="product-item">
									<div class="product-img">
										<img
											src="${pageContext.request.contextPath}${product.prodImgPath}"
											alt="${product.prodName}" style="width: 100%; height: auto;">
									</div>
									<div class="product-info">
										<p>${product.prodName}</p>
										<span><fmt:formatNumber value="${product.prodPrice}"
												type="number" />원</span>
									</div>
								</div>
							</a>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<p style="grid-column: span 4; color: #777;">현재 MANS 추천 상품 기능
							준비 중입니다.</p>
					</c:otherwise>
				</c:choose>
			</div>

			<h4>WOMEN 인기 상품</h4>
			<div class="product-grid">
				<c:choose>
					<c:when test="${not empty womansRecommendList}">
						<c:forEach var="product" items="${womansRecommendList}">
							<a
								href="${pageContext.request.contextPath}/product/detail?id=${product.prodId}">
								<div class="product-item">
									<div class="product-img">
										<img
											src="${pageContext.request.contextPath}${product.prodImgPath}"
											alt="${product.prodName}" style="width: 100%; height: auto;">
									</div>
									<div class="product-info">
										<p>${product.prodName}</p>
										<span><fmt:formatNumber value="${product.prodPrice}"
												type="number" />원</span>
									</div>
								</div>
							</a>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<p style="grid-column: span 4; color: #777;">현재 WOMEN 인기 상품 기능
							준비 중입니다.</p>
					</c:otherwise>
				</c:choose>
			</div>
		</section>

	</main>

	<footer class="main-footer">
		<div class="footer-content">
			<p class="company-info">© 2025 MY MODERN SHOP. All Rights
				Reserved.</p>
			<p>대표자: 김모던 | 사업자 등록번호: 123-45-67890 | 고객센터: 1588-XXXX</p>
		</div>
	</footer>

	<!-- 슬라이드 관련 스크립트 -->
	<script>
    document.addEventListener('DOMContentLoaded', function() {
        const slide1 = document.getElementById('slide1');
        const slide2 = document.getElementById('slide2');
        let currentSlide = 1; 
        const intervalTime = 5000;
        const transitionDuration = 1000;
        const transitionStyle = `left ${transitionDuration / 1000}s ease-in-out`; 

        function nextSlide() {
            if (currentSlide === 1) {
                slide1.style.left = '-100%';
                slide2.style.left = '0%';
                currentSlide = 2;
                
            } else {
                slide2.style.left = '-100%';
                
                slide1.style.transition = 'none'; 
                slide1.style.left = '100%';

                setTimeout(() => {
                    slide1.style.transition = transitionStyle; // 트랜지션 복구
                    slide1.style.left = '0%'; // 1번을 화면 중앙으로 슬라이드 인
                }, 50); 

                setTimeout(() => {
                    slide2.style.transition = 'none';
                    slide2.style.left = '100%'; // 2번을 오른쪽 화면 밖으로 리셋
                    
                    setTimeout(() => {
                         slide2.style.transition = transitionStyle;
                    }, 50); 
                    
                }, transitionDuration); 
                
                currentSlide = 1;
            }
        }
        
        slide1.style.left = '0%'; 
        slide2.style.left = '100%'; 

        let slideInterval = setInterval(nextSlide, intervalTime);
    });
</script>

</body>
</html>