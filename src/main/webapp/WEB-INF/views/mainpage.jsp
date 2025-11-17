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
	<link rel="stylesheet" href="<c:url value='/css/header.css' />">
<%--	헤더 추가할때 윗줄 필요 --%>
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
/*헤더 분리*/
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
	margin-left: auto;  /* ⭐️ 좌우 마진을 auto로 설정하여 중앙 정렬 */
	margin-right: auto;
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
.main-notice-section {
    max-width: 1440px;
    margin: 0 0 40px 0;
}

.main-notice-section h4 {
    font-size: 20px;
    border-bottom: 2px solid #b08d57;
    padding-bottom: 8px;
    margin-bottom: 10px;
}

.notice-header-row {
    display: flex;
    justify-content: space-between;
    align-items: flex-end;
}

.notice-more {
    font-size: 14px;
    color: #666;
}

.notice-table {
    width: 100%;
    border-collapse: collapse;
    font-size: 14px;
}

.notice-table tr {
    border-bottom: 1px solid #eee;
}

.notice-title-cell {
    padding: 8px 4px;
}

.notice-date-cell {
    width: 110px;
    text-align: right;
    padding: 8px 4px;
    color: #999;
}

</style>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/header.jsp" />
<%--헤더 삽입--%>

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
		<section class="main-notice-section">
		    <div class="notice-header-row">
		        <h4>공지사항</h4>
		    </div>

		    <table class="notice-table">
		        <tbody>
		        <c:choose>
		            <c:when test="${not empty recentNotices}">
		                <c:forEach var="notice" items="${recentNotices}">
		                    <tr>
		                        <td class="notice-title-cell">
		                            <a href="${pageContext.request.contextPath}/notices/view?notNo=${notice.NOT_NO}">
		                                ${notice.NOT_TITLE}
		                            </a>
		                        </td>
		                        <td class="notice-date-cell">
		                            <fmt:formatDate value="${notice.NOT_TIME}" pattern="yyyy-MM-dd"/>
		                        </td>
		                    </tr>
		                </c:forEach>
		            </c:when>
		            <c:otherwise>
		                <tr>
		                    <td colspan="2" style="text-align:center; padding:10px; color:#777;">
		                        등록된 공지사항이 없습니다.
		                    </td>
		                </tr>
		            </c:otherwise>
		        </c:choose>
		        </tbody>
		    </table>
		</section>
		<section class="recommend-section">

			<h4>MANS 추천 상품</h4>
			<div class="product-grid">
				<c:choose>
					<c:when test="${not empty mansRecommendList}">
						<c:forEach var="product" items="${mansRecommendList}">
							<a href="${pageContext.request.contextPath}/products/detail?prodId=${product.prodId}">
								<div class="product-item">
									<div class="product-img">
										<img
											src="${pageContext.request.contextPath}${product.prodImgPath}"
											alt="${product.prodName}" style="width: 100%; height: auto;">
									</div>
									<div class="product-info">
										<p>${product.prodName}</p>
										<span><fmt:formatNumber value="${product.prodPrice}" type="number" maxFractionDigits="0"/>원</span>
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
							<a href="${pageContext.request.contextPath}/products/detail?prodId=${product.prodId}">
								<div class="product-item">
									<div class="product-img">
										<img
											src="${pageContext.request.contextPath}${product.prodImgPath}"
											alt="${product.prodName}" style="width: 100%; height: auto;">
									</div>
									<div class="product-info">
										<p>${product.prodName}</p>
										<span><fmt:formatNumber value="${product.prodPrice}" type="number" maxFractionDigits="0"/>원</span>
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
	<script type="text/javascript" src="/js/chat.js"></script>
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