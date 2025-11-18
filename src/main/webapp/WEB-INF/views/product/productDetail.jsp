<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko">
<head>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <meta charset="UTF-8">
    <title>${product.prodName} - MY MODERN SHOP</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600;700;800&family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<c:url value='/css/header.css' />">
    <style>
        /* 기본 스타일 */
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Noto Sans KR', 'Montserrat', sans-serif;
            background-color: #f4f7f6;
            color: #333;
            line-height: 1.6;
        }
        a { text-decoration: none; color: inherit; }

        /* 페이지 컨테이너 */
        .detail-container {
            max-width: 1200px;
            margin: 40px auto;
        }

        /* 상품 기본 정보 섹션 */
        .product-summary {
            display: flex;
            gap: 30px;
            align-items: flex-start;
            background-color: #fff; /* ⭐️ 배경색 유지 */
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            margin-bottom: 40px;
        }
        .summary-image {
            flex: 1;
            max-width: 450px;
        }
        .summary-image img {
            width: 100%;
            height: auto;
            border-radius: 8px;
            border: 1px solid #eee;
        }
        .summary-details {
            flex: 1.5;
        }
        .summary-details h2 {
            font-size: 28px;
            font-weight: 600;
            margin-bottom: 15px;
        }
        .summary-details .seller-info {
            font-size: 14px;
            color: #888;
            margin-bottom: 20px;
        }
        .summary-details .price {
            font-size: 32px;
            font-weight: 700;
            color: #b08d57;
            margin-bottom: 20px;
        }
        .summary-details .stock-info {
            font-size: 14px;
            color: #555;
            margin-bottom: 25px;
        }

        /* 장바구니 폼 */
        .add-to-cart-form {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        .action-buttons {
            display: flex;
            gap: 10px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        .quantity-control {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .quantity-control label {
            font-weight: 500;
        }
        .quantity-control input[type="number"] {
            width: 60px;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
            text-align: center;
        }
        .action-buttons button {
            background-color: #333;
            color: white;
            border: none;
            padding: 15px 20px;
            cursor: pointer;
            border-radius: 4px;
            font-size: 16px;
            font-weight: 600;
            transition: background-color 0.3s ease;
            width: 100%; /* ⭐️ 버튼이 form의 너비를 꽉 채우도록 수정 */
        }
        .action-buttons button:hover {
            background-color: #555;
        }
        .btn-wishlist {
            background-color: #fff !important;
            color: #333 !important;
            border: 1px solid #ccc !important;
        }
        .btn-wishlist:hover {
            background-color: #f8f8f8 !important;
        }
        .btn-wishlist.wished { /* 찜 완료 상태 스타일 */
            background-color: #fff0f0 !important;
            border-color: #ffc2c2 !important;
        }

        /* 탭 네비게이션 */
        .tab-navigation {
            display: flex;
            border-bottom: 2px solid #ddd;
            padding: 0 20px; /* ⭐️ 좌우 여백 추가 */
            margin-bottom: 30px;
        }
        .tab-link {
            padding: 15px 30px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 500;
            color: #888;
            border-bottom: 3px solid transparent;
            transition: all 0.3s ease;
        }
        .tab-link.active {
            color: #333;
            border-bottom-color: #b08d57;
        }

        /* 탭 콘텐츠 */
        .tab-content {
            display: none;
            padding: 30px 40px; /* ⭐️ 여백 조정 */
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            min-height: 300px;
        }
        .tab-content.active {
            display: block;
        }
        .tab-content .content-placeholder {
            color: #999;
            text-align: center;
            padding-top: 50px;
        }
        .product-description-content {
            line-height: 1.8;
            font-size: 16px;
        }

        /* Q&A, 리뷰 공통 스타일 */
        .board-list { margin-bottom: 40px; }
        .board-item { padding: 20px 0; border-bottom: 1px solid #eee; }
        .board-item:last-child { border-bottom: none; }
        .board-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; }
        .board-author { font-weight: 600; }
        .board-date { font-size: 13px; color: #999; }
        .board-author-masked {
            font-size: 13px;
            color: #888;
            margin-top: 5px; /* ⭐️ 제목과의 간격 조정 */
        }
        .board-title {
            font-size: 17px;
            font-weight: 600;
            margin-bottom: 15px;
        }
        .board-content {
            margin-top: 20px; line-height: 1.7; color: #555; padding-left: 5px; /* ⭐️ 제목과의 간격 확보 */
        }
        .secret-qna { color: #888; font-style: italic; }
        .secret-qna .lock-icon { margin-right: 5px; }

        .write-section { padding: 25px; background-color: #f9f9f9; border-radius: 8px; border: 1px solid #e9e9e9; }
        .write-section h4 { font-size: 18px; font-weight: 600; margin-bottom: 20px; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; font-weight: 500; margin-bottom: 8px; }

        /* 리뷰 탭 스타일 */
        .review-list {
            margin-bottom: 40px;
        }
        .review-item {
            padding: 20px 0;
            border-bottom: 1px solid #eee;
        }
        .review-item:last-child {
            border-bottom: none;
        }
        .review-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }
        .review-author {
            font-weight: 600;
        }
        .review-date {
            font-size: 13px;
            color: #999;
        }
        .review-rating {
            color: #f5b301;
            font-size: 1.2em;
        }
        .review-content {
            margin-top: 10px;
            line-height: 1.7;
        }

        /* 답변 스타일 */
        .reply-item {
            margin-top: 20px;
            padding: 20px; /* ⭐️ 여백 조정 */
            background-color: #f8f9fa;
            border-left: 3px solid #b08d57;
            border-radius: 0 4px 4px 0;
        }
        .reply-header {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 8px;
        }
        .reply-author {
            font-weight: 600;
            color: #333;
        }
        .reply-badge {
            background-color: #b08d57;
            color: white;
            font-size: 11px;
            padding: 2px 6px;
            border-radius: 3px;
            font-weight: 500;
        }
        .reply-content {
            font-size: 15px;
        }

        /* Q&A 작성 폼 스타일 */
        .qna-form input[type="text"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .qna-form textarea {
            width: 100%;
            height: 120px;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-family: inherit;
            font-size: 15px;
            resize: vertical;
        }
        .secret-check { display: flex; align-items: center; gap: 8px; font-size: 14px; }
        .qna-form button { background-color: #b08d57; color: white; padding: 12px 25px; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; font-weight: 500; }

        /* 이전 페이지 링크 */
        .back-link-container {
            text-align: center;
            margin-top: 40px;
        }
        .back-link {
            display: inline-block;
            padding: 10px 25px;
            background-color: #6c757d;
            color: white;
            border-radius: 4px;
            transition: background-color 0.3s ease;
        }
        .back-link:hover {
            background-color: #5a6268;
        }
    </style>
</head>
<body>
    <%-- 헤더 프래그먼트 포함 --%>
    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />

    <div class="detail-container">
        <c:if test="${empty product}">
            <p class="no-items">상품 정보를 찾을 수 없습니다.</p>
        </c:if>

        <c:if test="${not empty product}">
            <%-- 상품 기본 정보 --%>
            <div class="product-summary">
                <div class="summary-image">
                    <img src="${pageContext.request.contextPath}${product.prodImgPath}" alt="${product.prodName}">
                </div>
                <div class="summary-details">
                    <h2>${product.prodName}</h2>
                    <p class="seller-info">판매자: ${product.prodSeller}</p>
                    <p class="price"><fmt:formatNumber value="${product.prodPrice}" type="number" maxFractionDigits="0"/>원</p>
                    <p class="stock-info">재고: ${product.prodStock}개</p>

                    <div class="quantity-control">
                        <label for="cartQty">수량:</label>
                        <input type="number" id="cartQty" name="cartQty" value="1" min="1" max="${product.prodStock}" form="cart-form">
                    </div>
                    <div class="action-buttons">
                        <form id="cart-form" action="${pageContext.request.contextPath}/cart/add" method="post" style="flex: 3;">
                            <input type="hidden" name="prodId" value="${product.prodId}">
                            <button type="submit">장바구니</button>
                        </form>
                        <c:choose>
                            <c:when test="${isWished}">
                                <%-- 찜한 상태일 때 --%>
                                <form action="${pageContext.request.contextPath}/wishlist/remove" method="post" style="flex: 1;">
                                    <input type="hidden" name="prodId" value="${product.prodId}">
                                    <button type="submit" class="btn-wishlist wished"><i class="fas fa-heart" style="color: #e53e3e;"></i> 찜 해제</button>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <%-- 찜하지 않은 상태일 때 --%>
                                <form action="${pageContext.request.contextPath}/wishlist/add" method="post" style="flex: 1;">
                                    <input type="hidden" name="prodId" value="${product.prodId}">
                                    <button type="submit" class="btn-wishlist"><i class="far fa-heart"></i> 찜하기</button>
                                </form>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <%-- 탭 네비게이션 --%>
            <div class="tab-navigation">
                <div class="tab-link active" onclick="openTab(event, 'description')">상품 상세정보</div>
                <div class="tab-link" onclick="openTab(event, 'reviews')">리뷰</div>
                <div class="tab-link" onclick="openTab(event, 'qna')">상품 문의</div>
            </div>

            <%-- 탭 콘텐츠 --%>
            <div id="description" class="tab-content active">
                <div class="product-description-content">
                    ${product.prodDesc}
                </div>
            </div>

            <div id="reviews" class="tab-content">
                <c:choose>
                    <c:when test="${not empty reviewList}">
                        <div class="review-list">
                            <c:forEach var="review" items="${reviewList}">
                                <div class="review-item">
                                    <div class="review-header">
                                        <span class="review-author">${review.memberName}</span>
                                        <span class="review-date"><fmt:formatDate value="${review.reviewRegDate}" pattern="yyyy-MM-dd"/></span>
                                    </div>
                                    <div class="review-rating">
                                        <c:forEach begin="1" end="${review.rating}">&#9733;</c:forEach> <%-- ★ --%>
                                    </div>
                                    <p class="review-content">${review.reviewContent}</p>

                                    <%-- 답변 표시 --%>
                                    <c:if test="${not empty review.replies}">
                                        <c:forEach var="reply" items="${review.replies}">
                                            <div class="reply-item">
                                                <div class="reply-header"><span class="reply-badge">판매자</span><span class="reply-author">${reply.memberName}</span></div>
                                                <p class="reply-content">${reply.reviewContent}</p>
                                            </div>
                                        </c:forEach>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p class="content-placeholder">아직 작성된 리뷰가 없습니다.</p>
                    </c:otherwise>
                </c:choose>
            </div>

            <div id="qna" class="tab-content">
                <div class="board-list">
                    <c:choose>
                        <c:when test="${not empty qnaList}">
                            <c:forEach var="qna" items="${qnaList}">
                                <div class="board-item">
                                    <div class="board-header">
                                        <span class="board-date"><fmt:formatDate value="${qna.qnaRegDate}" pattern="yyyy-MM-dd"/></span>
                                    </div>
                                    <%-- 비밀글 처리 --%>
                                    <c:choose>
                                        <c:when test="${qna.qnaIsSecret == 'Y' and qna.memberId != memberId and sessionScope.sessionUserType != 'seller'}">
                                            <p class="secret-qna"><span class="lock-icon">&#128274;</span>비밀글입니다.</p>
                                        </c:when>
                                        <c:otherwise>
                                            <h5 class="board-title">${qna.qnaTitle}</h5>
                                            <div class="board-author-masked" style="margin-bottom: 20px;"> <%-- ⭐️ 내용과의 간격 확보 --%>
                                                <%-- 작성자 이름 마스킹 처리 --%>
                                                <c:choose>
                                                    <c:when test="${fn:length(qna.memberName) > 2}">
                                                        ${fn:substring(qna.memberName, 0, 1)}*${fn:substring(qna.memberName, 2, fn:length(qna.memberName))}
                                                    </c:when>
                                                    <c:when test="${fn:length(qna.memberName) == 2}">
                                                        ${fn:substring(qna.memberName, 0, 1)}*
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${qna.memberName}
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <p class="board-content">${qna.qnaContent}</p>
                                        </c:otherwise>
                                    </c:choose>

                                    <%-- 답변 표시 --%>
                                    <c:if test="${not empty qna.replies}">
                                        <c:forEach var="reply" items="${qna.replies}">
                                            <div class="reply-item">
                                                <div class="reply-header"><span class="reply-badge">판매자</span></div>
                                                <p class="reply-content">${reply.qnaContent}</p>
                                            </div>
                                        </c:forEach>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <p class="content-placeholder">아직 등록된 상품 문의가 없습니다.</p>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="write-section qna-form">
                    <h4>상품 문의하기</h4>
                    <form action="<c:url value='/qna/add'/>" method="post">
                        <input type="hidden" name="prodId" value="${product.prodId}">
                        <div class="form-group"><label for="qnaTitle">제목</label><input type="text" id="qnaTitle" name="qnaTitle" required></div>
                        <div class="form-group"><label for="qnaContent">내용</label><textarea id="qnaContent" name="qnaContent" required></textarea></div>
                        <div class="form-group secret-check"><input type="checkbox" id="qnaIsSecret" name="qnaIsSecret" value="Y"><label for="qnaIsSecret">비밀글로 문의하기</label></div>
                        <button type="submit">문의 등록</button>
                    </form>
                </div>
            </div>
        </c:if>

        <div class="back-link-container">
            <a href="#" onclick="history.back();" class="back-link">이전 페이지로</a>
        </div>
    </div>

    <%-- 푸터 프래그먼트 포함 (푸터 파일이 있다면) --%>
    <%-- <jsp:include page="/WEB-INF/views/fragments/footer.jsp" /> --%>

    <script>
        function openTab(evt, tabName) {
            // 모든 탭 콘텐츠를 숨김
            var i, tabcontent, tablinks;
            tabcontent = document.getElementsByClassName("tab-content");
            for (i = 0; i < tabcontent.length; i++) {
                tabcontent[i].style.display = "none";
            }

            // 모든 탭 링크에서 'active' 클래스 제거
            tablinks = document.getElementsByClassName("tab-link");
            for (i = 0; i < tablinks.length; i++) {
                tablinks[i].className = tablinks[i].className.replace(" active", "");
            }

            // 클릭된 탭 콘텐츠를 보여주고, 링크에 'active' 클래스 추가
            document.getElementById(tabName).style.display = "block";
            evt.currentTarget.className += " active";
        }
    </script>
</body>
</html>
