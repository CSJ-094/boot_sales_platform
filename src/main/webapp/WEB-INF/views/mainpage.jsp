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
	<link rel="stylesheet" href="<c:url value='/css/mainpage.css' />">
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/header.jsp" />
<%-- 헤더 삽입 --%>
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
		<!-- 중앙 검색 기능 추가 -->
		<section class="main-search-section">
		    <form action="<c:url value='/product/search'/>" method="get" class="main-search-form">
		        <input type="text" name="keyword" placeholder="검색어를 입력하세요" class="main-search-input">
		        <button type="submit" class="main-search-button">검색</button>
		    </form>
		</section>

		<section class="benefit-strip">
		       <div class="benefit-strip-inner">
		           <div class="benefit-strip-item">
		               <span class="benefit-strip-dot"></span>
		               <div>
		                   <strong>FREE SHIPPING</strong>
		                   <span>3만원 이상 무료 배송</span>
		               </div>
		           </div>
		           <div class="benefit-strip-item">
		               <span class="benefit-strip-dot"></span>
		               <div>
		                   <strong>TODAY DELIVERY</strong>
		                   <span>오후 2시 이전 결제 시 당일 발송</span>
		               </div>
		           </div>
		           <div class="benefit-strip-item">
		               <span class="benefit-strip-dot"></span>
		               <div>
		                   <strong>EASY RETURN</strong>
		                   <span>7일 이내 간편 교환/반품</span>
		               </div>
		           </div>
		       </div>
		   </section>
		<section class="main-notice-section">
		    <div class="notice-header-row">
		        <div class="section-title">
		            <h4 class="section-title-kor">공지사항</h4>
		            <span class="section-title-eng">NOTICE</span>
		        </div>
		        <%-- 필요하면 더보기 링크 추가 가능
		        <a class="notice-more" href="${pageContext.request.contextPath}/notices">더 보기</a>
		        --%>
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

		    <div class="section-title">
		        <h4 class="section-title-kor">MANS 추천 상품</h4>
		        <span class="section-title-eng">RECOMMENDED FOR YOU</span>
		    </div>

		    <div class="product-grid">
				<c:choose>
					<c:when test="${not empty mansRecommendList}">
						<c:forEach var="product" items="${mansRecommendList}">
							<a href="${pageContext.request.contextPath}/product/detail?id=${product.prodId}">
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

			<div class="section-title">
			      <h4 class="section-title-kor">WOMEN 인기 상품</h4>
			      <span class="section-title-eng">WOMEN'S TREND PICKS</span>
			  </div>

			  <div class="product-grid">
				<c:choose>
					<c:when test="${not empty womansRecommendList}">
						<c:forEach var="product" items="${womansRecommendList}">
							<a href="${pageContext.request.contextPath}/product/detail?id=${product.prodId}">
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
	<script type="text/javascript" src="/js/supportChat.js"></script>
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

<%-- 룰렛 팝업을 페이지에 포함시킵니다. --%>
<jsp:include page="/WEB-INF/views/roulette.jsp" />

</body>
</html>