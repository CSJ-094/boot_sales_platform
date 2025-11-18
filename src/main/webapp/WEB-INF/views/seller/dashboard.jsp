<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
    <title>판매자 대시보드</title>
	<link rel="stylesheet" href="<c:url value='/css/sellerstyle.css' />" />
	<link rel="stylesheet" href="<c:url value='/css/dashboard.css' />" />
	<link rel="stylesheet" href="<c:url value='/css/header.css' />" />
</head>
<body>
	<jsp:include page="/WEB-INF/views/fragments/header.jsp" />
	<main class="mypage-body">
	    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp">
	        <jsp:param name="menu" value="dashboard"/>
	    </jsp:include>
	
		<!-- 공통 레이아웃 박스: 상품 관리랑 동일 -->
		<section class="mypage-content-area">

		    <!-- 제목 영역 (상품 관리 화면이랑 맞춤) -->
		    <header class="mypage-head">
		        <h2 class="mypage-title">판매자 대시보드</h2>
		        <div class="mypage-title-line"></div>
		    </header>

		    <!-- 여기부터 대시보드 전용 내용 -->
		    <div class="dash-wrap">
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

		        <!-- ==== 그래프 2열 섹션 ==== -->
		        <section class="dash-section">
		            <div class="dash-graph-grid">

		                <!-- 매출 그래프 카드 -->
		                <div class="dash-card dash-card-large">
		                    <div class="dash-card-header">

		                        <!-- 1줄: 제목 + 탭 -->
		                        <div class="dash-card-header-top">
		                            <h3>매출 그래프</h3>
		                            <div class="dash-tabs">
		                                <button type="button" class="sales-tab active" data-period="day">일</button>
		                                <button type="button" class="sales-tab" data-period="week">주</button>
		                                <button type="button" class="sales-tab" data-period="month">월</button>
		                            </div>
		                        </div>

		                        <!-- 2줄: 전일 대비 -->
		                        <div class="dash-trend">
		                            <span id="salesTrendLabel" class="dash-trend-label">전일 대비</span>
		                            <span id="salesTrendValue" class="dash-trend-value neutral">-</span>
		                        </div>

		                    </div>

		                    <div class="dash-card-body">
		                        <canvas id="salesChart"></canvas>
		                    </div>
		                </div>

		                <!-- 방문자 그래프 카드 -->
		                <div class="dash-card dash-card-large">
		                    <div class="dash-card-header">

		                        <!-- 1줄: 제목 + 탭 -->
		                        <div class="dash-card-header-top">
		                            <h3>방문자 그래프</h3>
		                            <div class="dash-tabs">
		                                <button type="button" class="visitor-tab active" data-period="day">일</button>
		                                <button type="button" class="visitor-tab" data-period="week">주</button>
		                                <button type="button" class="visitor-tab" data-period="month">월</button>
		                            </div>
		                        </div>

		                        <!-- 2줄: 전일 대비 -->
		                        <div class="dash-trend">
		                            <span id="visitorTrendLabel" class="dash-trend-label">전일 대비</span>
		                            <span id="visitorTrendValue" class="dash-trend-value neutral">-</span>
		                        </div>

		                    </div>

		                    <div class="dash-card-body">
		                        <canvas id="visitorChart"></canvas>
		                    </div>
		                </div>

		            </div>
		        </section>

		        <!-- 최근 주문 섹션 -->
				<section class="dash-panel dash-recent dash-recent-orders">
				    <div class="dash-panel-header">
				        <h3>최근 주문</h3>
				        <div class="dash-filter">
				            <button type="button" class="filter-btn order-filter-btn is-active" data-status="ALL">전체</button>
				            <button type="button" class="filter-btn order-filter-btn" data-status="결제완료">결제완료</button>
				            <button type="button" class="filter-btn order-filter-btn" data-status="배송중">배송중</button>
				            <button type="button" class="filter-btn order-filter-btn" data-status="취소">취소</button>
				        </div>
				    </div>

		            <c:if test="${empty recentOrders}">
		                <p class="dash-empty">최근 주문이 없습니다.</p>
		            </c:if>

		            <c:if test="${not empty recentOrders}">
		                <table class="dash-table">
		                    <thead>
		                    <tr>
		                        <th>주문일</th>
		                        <th>주문번호</th>
		                        <th>주문자</th>
		                        <th>금액</th>
		                        <th>상태</th>
		                    </tr>
		                    </thead>
		                    <tbody>
		                    <c:forEach var="o" items="${recentOrders}">
		                        <tr data-status="${o.ordStatus}">
		                            <td><fmt:formatDate value="${o.ordDate}" pattern="yyyy-MM-dd" /></td>
		                            <td>${o.ordId}</td>
		                            <td>${o.buyerName}</td>
		                            <td><fmt:formatNumber value="${o.ordAmount}" type="number" />원</td>
		                            <td>
		                                <c:choose>
		                                    <c:when test="${o.ordStatus == '결제대기'}">
		                                        <span class="badge badge-pending">결제대기</span>
		                                    </c:when>
		                                    <c:when test="${o.ordStatus == '결제완료'}">
		                                        <span class="badge badge-pay">결제완료</span>
		                                    </c:when>
		                                    <c:when test="${o.ordStatus == '배송중'}">
		                                        <span class="badge badge-ship">배송중</span>
		                                    </c:when>
		                                    <c:when test="${o.ordStatus == '배송완료'}">
		                                        <span class="badge badge-done">배송완료</span>
		                                    </c:when>
		                                    <c:when test="${o.ordStatus == '취소'}">
		                                        <span class="badge badge-cancel">취소</span>
		                                    </c:when>
		                                    <c:when test="${o.ordStatus == '구매확정'}">
		                                        <span class="badge badge-confirm">구매확정</span>
		                                    </c:when>
		                                    <c:otherwise>
		                                        <span class="badge badge-etc">${o.ordStatus}</span>
		                                    </c:otherwise>
		                                </c:choose>
		                            </td>
		                        </tr>
		                    </c:forEach>
		                    </tbody>
		                </table>
		            </c:if>
		        </section>

		        <!-- 최근 문의 섹션 -->
		        <section class="dash-panel dash-recent dash-recent-qna">
		            <div class="dash-panel-header">
		                <h3>최근 문의</h3>
		                <div class="dash-filter">
		                    <button type="button" class="filter-btn qna-filter-btn is-active" data-status="ALL">전체</button>
		                    <button type="button" class="filter-btn qna-filter-btn" data-status="답변대기">답변대기</button>
		                    <button type="button" class="filter-btn qna-filter-btn" data-status="답변완료">답변완료</button>
		                </div>
		            </div>

		            <c:if test="${empty recentQna}">
		                <p class="dash-empty">최근 문의가 없습니다.</p>
		            </c:if>

		            <c:if test="${not empty recentQna}">
		                <table class="dash-table">
		                    <thead>
		                    <tr>
		                        <th>문의일</th>
		                        <th>상품명</th>
		                        <th>작성자</th>
		                        <th>제목</th>
		                        <th>상태</th>
		                    </tr>
		                    </thead>
		                    <tbody>
		                    <c:forEach var="q" items="${recentQna}">
		                        <tr data-status="${q.status}">
		                            <td><fmt:formatDate value="${q.qnaDate}" pattern="yyyy-MM-dd" /></td>
		                            <td>${q.prodName}</td>
		                            <td>${q.memberId}</td>
		                            <td class="qna-title-cell">
		                                <a href="<c:url value='/seller/qna/${q.qnaId}' />">
		                                    ${q.title}
		                                </a>
		                            </td>
		                            <td>
		                                <c:choose>
		                                    <c:when test="${q.status == '답변대기'}">
		                                        <span class="badge badge-pending">답변대기</span>
		                                    </c:when>
		                                    <c:when test="${q.status == '답변완료'}">
		                                        <span class="badge badge-done">답변완료</span>
		                                    </c:when>
		                                    <c:otherwise>
		                                        <span class="badge badge-etc">${q.status}</span>
		                                    </c:otherwise>
		                                </c:choose>
		                            </td>
		                        </tr>
		                    </c:forEach>
		                    </tbody>
		                </table>
		            </c:if>
		        </section>

		    </div>
		</section>
	</main>

	<jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

	<!-- 페이지 전용 JS -->
	<script>
	    const ctxPath = '<c:url value="/" />'.replace(/\/$/, '');
	</script>
	<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
	<script src="<c:url value='/js/dashboard-sales.js' />"></script>
	<script src="<c:url value='/js/dashboard-visitors.js' />"></script>
	<script src="<c:url value='/js/dashboard-recent.js' />"></script>
</body>
</html>
