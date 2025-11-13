<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>

<%--<link rel="stylesheet" href="<c:url value='/css/header.css' />">--%>
<style>
    /* 헤더 카테고리 메뉴의 점(bullet point) 제거 */
    .category-nav .category-list,
    .category-nav .sub-category {
        list-style: none;
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
					<span class="auth-welcome">환영합니다, ${sessionScope.memberName}님!</span>
					<a href="<c:url value='/mypage' />" class="auth-btn">마이페이지</a> 
					<a href="<c:url value='/cart/list' />" class="auth-btn cart-btn">장바구니</a>
					<a href="<c:url value='/logout' />" class="auth-btn">로그아웃</a>
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
					<li><a href="<c:url value='/category/mans/acc' />">모자/액세서리</a></li>
				</ul>
			</li>
			<li class="category-item"><a href="<c:url value='/category/women' />">WOMEN</a>
				<ul class="sub-category">
					<li><a href="<c:url value='/category/women/top' />">블라우스/티셔츠</a></li>
					<li><a href="<c:url value='/category/women/dress' />">원피스</a></li>
					<li><a href="<c:url value='/category/women/skirt' />">스커트</a></li>
					<li><a href="<c:url value='/category/women/bag' />">가방/잡화</a></li>
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