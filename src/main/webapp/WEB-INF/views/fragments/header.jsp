<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
    /* 헤더 카테고리 메뉴의 점(bullet point) 제거 */
    .category-nav .category-list,
    .category-nav .sub-category {
        list-style: none;
    }

    /* 출석체크 버튼 스타일 */
    .attendance-btn {
        background-color: #b08d57; /* 포인트 색상 */
        color: white;
        padding: 5px 10px;
        border-radius: 5px;
        font-size: 12px;
        font-weight: 500;
        margin-left: 10px;
        cursor: pointer;
        transition: background-color 0.3s ease;
    }
    .attendance-btn:hover {
        background-color: #886030; /* 호버 시 어두운 색상 */
        color: white; /* 호버 시 글자색 유지 */
    }
</style>

<header class="main-header">
    <div class="header-top">
        <div class="logo">
            <a href="<c:url value='/' />">MY MODERN SHOP</a>
        </div>

        <div class="user-auth">
            <c:choose>
                <c:when test="${not empty sessionScope.memberId}">
                    <c:choose>
                        <c:when test="${sessionScope.userType == 'customer' or sessionScope.userType == 'kakao'}">
                            <span class="auth-welcome">환영합니다, ${sessionScope.memberName}님!</span>
                            <a href="<c:url value='/mypage' />" class="auth-btn">마이페이지</a>
                            <a href="<c:url value='/cart/list' />" class="auth-btn cart-btn">장바구니</a>
                            <a href="<c:url value='/logout' />" class="auth-btn">로그아웃</a>
                            <button type="button" id="attendanceCheckBtn" class="attendance-btn">출석체크</button>
                        </c:when>
                        <c:when test="${sessionScope.userType == 'seller'}">
                            <span class="auth-welcome">환영합니다, 판매자 ${sessionScope.memberId}님!</span>
                            <a href="<c:url value='/seller/products' />" class="auth-btn">관리페이지</a>
                            <a href="<c:url value='/logout' />" class="auth-btn">로그아웃</a>
                        </c:when>
                    </c:choose>
                </c:when>
                <c:otherwise>
                    <a href="<c:url value='/login' />" class="auth-btn">로그인/회원가입</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <nav class="category-nav">
        <ul class="category-list">
			<li class="category-item"><a href="<c:url value='/category/mans' />">MANS</a>
				<ul class="sub-category">
					<li><a href="<c:url value='/category/mans/top' />">상의</a></li>
					<li><a href="<c:url value='/category/mans/bottom' />">하의</a></li>
					<li><a href="<c:url value='/category/mans/outer' />">아우터</a></li>
					<li><a href="<c:url value='/category/mans/shoes' />">신발</a></li>
					<li><a href="<c:url value='/category/mans/acc' />">잡화</a></li>
				</ul>
			</li>
			<li class="category-item"><a href="<c:url value='/category/women' />">WOMEN</a>
				<ul class="sub-category">
					<li><a href="<c:url value='/category/women/top' />">상의</a></li>
					<li><a href="<c:url value='/category/women/dress' />">하의</a></li>
					<li><a href="<c:url value='/category/women/skirt' />">아우터</a></li>
					<li><a href="<c:url value='/category/women/shoes' />">신발</a></li>
					<li><a href="<c:url value='/category/women/acc' />">잡화</a></li>
				</ul>
			</li>
			<li class="category-item"><a href="<c:url value='/category/unisex' />">UNISEX</a>
				<ul class="sub-category">
					<li><a href="<c:url value='/category/unisex/top' />">상의</a></li>
					<li><a href="<c:url value='/category/unisex/bottom' />">하의</a></li>
					<li><a href="<c:url value='/category/unisex/outer' />">아우터</a></li>
					<li><a href="<c:url value='/category/unisex/shoes' />">신발</a></li>
				</ul>
			</li>
			<li class="category-item"><a href="<c:url value='/category/sports' />">SPORTS</a>
				<ul class="sub-category">
					<li><a href="<c:url value='/category/sports/top' />">상의</a></li>
					<li><a href="<c:url value='/category/sports/bottom' />">하의</a></li>
					<li><a href="<c:url value='/category/sports/outer' />">아우터</a></li>
					<li><a href="<c:url value='/category/sports/shoes' />">신발</a></li>
				</ul>
			</li>
		</ul>
    </nav>
</header>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const attendanceBtn = document.getElementById('attendanceCheckBtn');
    if (attendanceBtn) {
        attendanceBtn.addEventListener('click', function() {
            fetch('<c:url value="/api/attendance/check-in"/>', {
                method: 'POST'
            })
            .then(response => response.json())
            .then(data => {
                alert(data.message);
            })
            .catch(error => {
                console.error('출석체크 오류:', error);
                alert('오류가 발생했습니다. 다시 시도해주세요.');
            });
        });
    }
});
</script>
