<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
    <title>판매자 대시보드</title>
	<link rel="stylesheet" href="<c:url value='/css/dashboard.css' />" />
	<link rel="stylesheet" href="<c:url value='/css/header.css' />" />
</head>
<body>
	<jsp:include page="/WEB-INF/views/fragments/header.jsp" />
	<jsp:include page="/WEB-INF/views/fragments/header.jsp" />
	<main class="mypage-body">
	    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp">
	        <jsp:param name="menu" value="dashboard"/>
	    </jsp:include>
	
<div class="dash-wrap">
    <div class="dash-title">판매자 대시보드</div>

    <!-- 핵심 지표 카드 -->
    <div class="dash-cards">

        <!-- 오늘 매출 -->
        <div class="dash-card">
            <div class="dash-card-title">오늘 매출</div>
            <div class="dash-card-number">
                <c:out value="${summary.todaySalesAmount}" />원
            </div>
            <div class="dash-card-sub">
                전일 대비: 
                <c:choose>
                    <c:when test="${summary.yesterdaySalesAmount == 0}">
                        -
                    </c:when>
                    <c:otherwise>
                        <c:set var="diff" value="${summary.todaySalesAmount - summary.yesterdaySalesAmount}" />
                        <c:out value="${diff}" />원
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- 오늘 주문 건수 -->
        <div class="dash-card">
            <div class="dash-card-title">오늘 주문 건수</div>
            <div class="dash-card-number">
                <c:out value="${summary.todayOrderCount}" />건
            </div>
            <div class="dash-card-sub">
                전일 대비: 
                <c:set var="d" value="${summary.todayOrderCount - summary.yesterdayOrderCount}" />
                <c:out value="${d}" />건
            </div>
        </div>

        <!-- 신규 가입자 -->
        <div class="dash-card">
            <div class="dash-card-title">신규 가입자</div>
            <div class="dash-card-number">
                <c:out value="${summary.todayNewMembers}" />명
            </div>
        </div>

        <!-- 방문자 -->
        <div class="dash-card">
            <div class="dash-card-title">오늘 방문자</div>
            <div class="dash-card-number">
                <c:out value="${summary.todayVisitors}" />명
            </div>
        </div>

        <!-- 미처리 문의 -->
        <div class="dash-card">
            <div class="dash-card-title">미처리 문의</div>
            <div class="dash-card-number">
                <c:out value="${summary.pendingQnaCount}" />건
            </div>
        </div>

    </div>
</div>
<jsp:include page="/WEB-INF/views/fragments/footer.jsp" />
</body>
</html>
