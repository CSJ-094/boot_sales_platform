<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>리뷰 관리</title>
    <link rel="stylesheet" href="<c:url value='/css/sellerstyle.css' />">
    <link rel="stylesheet" href="<c:url value='/css/header.css' />">
</head>
<body>
    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />

    <main class="mypage-body">
        <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp">
            <jsp:param name="menu" value="reviews"/>
        </jsp:include>

        <section class="mypage-content-area">
            <div class="page-title"><h1>리뷰 관리</h1></div>
            <c:if test="${not empty msg}"><div class="alert alert-success">${msg}</div></c:if>

            <table class="table">
                <thead>
                    <tr>
                        <th style="width: 15%;">상품명</th>
                        <th>리뷰 내용</th>
                        <th style="width: 8%;">별점</th>
                        <th style="width: 12%;">작성자</th>
                        <th style="width: 12%;">작성일</th>
                        <th style="width: 10%;">답변여부</th>
                    </tr>
                </thead>
                <tbody>
                    <c:if test="${empty reviewList}"><td colspan="6" style="text-align:center; padding:20px;">등록된 리뷰가 없습니다.</td></c:if>
                    <c:forEach var="review" items="${reviewList}">
                        <tr onclick="location.href='<c:url value='/seller/reviews/${review.reviewId}/reply'/>'" style="cursor:pointer;">
                            <td>${review.prodName}</td>
                            <td class="text-left">${review.reviewContent}</td>
                            <td><span style="color: #f5b301;">${review.rating}</span> / 5</td>
                            <td>${review.memberName}</td>
                            <td><fmt:formatDate value="${review.reviewRegDate}" pattern="yyyy-MM-dd"/></td>
                            <td>
                                <c:if test="${review.replied == 'Y'}"><span style="color: green; font-weight: bold;">완료</span></c:if>
                                <c:if test="${review.replied == 'N'}"><span style="color: red;">대기</span></c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </section>
    </main>
    <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />
</body>
</html>