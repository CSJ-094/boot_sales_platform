<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<header class="main-header">
<div class="header-top">
	
	<div class="logo">
		<a href="${pageContext.request.contextPath}/mainpage">MY MODERN SHOP</a>
	</div>
	
	<div class="user-auth">
	 	<span class="auth-welcome">환영합니다, 판매자님!</span>
		<a href='<c:url value="/logout"/>' class="auth-btn">로그아웃</a>
	</div>
</div>
</header>