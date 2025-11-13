<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>리뷰 답변 작성</title>
    <link rel="stylesheet" href="<c:url value='/css/sellerstyle.css' />">
    <link rel="stylesheet" href="<c:url value='/css/header.css' />">
    <style>
        .button-group .btn-submit, .button-group .reset-btn { display: inline-block; min-width: 100px; padding: 10px 20px; font-size: 15px; font-weight: 500; text-align: center; border-radius: 4px; cursor: pointer; transition: background-color 0.3s, color 0.3s; }
        .button-group .btn-submit { background-color: #333; color: white; border: 1px solid #333; }
        .button-group .reset-btn { background-color: #f8f9fa; color: #6c757d; border: 1px solid #ccc; }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />

    <main class="mypage-body">
        <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp">
            <jsp:param name="menu" value="reviews"/>
        </jsp:include>

        <section class="mypage-content-area">
            <h1>리뷰 답변 작성</h1>

            <div class="info-form">
                <h3>고객 리뷰 내용</h3>
                <table class="table-bordered" style="margin-top:15px; margin-bottom: 30px;">
                    <tr><th style="width:120px;">상품명</th><td>${review.prodName}</td></tr>
                    <tr><th>작성자</th><td>${review.memberName}</td></tr>
                    <tr><th>작성일</th><td><fmt:formatDate value="${review.reviewRegDate}" pattern="yyyy-MM-dd HH:mm"/></td></tr>
                    <tr><th>별점</th><td><span style="color: #f5b301;">${review.rating}</span> / 5</td></tr>
                    <tr><th>리뷰 내용</th><td style="white-space: pre-wrap; min-height: 100px;">${review.reviewContent}</td></tr>
                </table>

                <h3>답변 작성</h3>
                <form action="<c:url value='/seller/reviews/reply'/>" method="post" style="margin-top:15px;">
                    <input type="hidden" name="reviewParentId" value="${review.reviewId}">
                    <input type="hidden" name="prodId" value="${review.prodId}">

                    <div class="form-group">
                        <label for="reviewContent">답변 내용</label>
                        <textarea id="reviewContent" name="reviewContent" rows="8" required style="width:100%"></textarea>
                    </div>

                    <div class="button-group" style="text-align: right; margin-top: 20px;">
                        <button type="submit" class="btn-submit">답변등록</button>
                        <a href="<c:url value='/seller/reviews'/>" class="reset-btn">목록으로</a>
                    </div>
                </form>
            </div>
        </section>
    </main>

    <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />
</body>
</html>