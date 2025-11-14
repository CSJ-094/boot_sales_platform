<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600;700;800&family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<c:url value='/css/header.css' />">
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script>
    function daumZipCode() {
        new daum.Postcode(
            {
                oncomplete: function(data) {
                    var addr = '';
                    var extraAddr = '';

                    if (data.userSelectedType === 'R') {
                        addr = data.roadAddress;
                    } else {
                        addr = data.jibunAddress;
                    }

                    if (data.userSelectedType === 'R') {
                        if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
                            extraAddr += data.bname;
                        }
                        if (data.buildingName !== '' && data.apartment === 'Y') {
                            extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                        }
                        if (extraAddr !== '') {
                            extraAddr = ' (' + extraAddr + ')';
                        }
                    }

                    document.getElementById('zipcode').value = data.zonecode;
                    document.getElementById("MEMBER_ADDR_PRIMARY").value = addr + extraAddr;
                    document.getElementById("MEMBER_ADDR_DETAIL").focus();
                }
            }
        ).open();
    }
    </script>
    
    <style>
        /* ==================== 0. 기본 스타일 & 초기화 (mainpage.jsp 기준) ==================== */
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Noto Sans KR', 'Montserrat', sans-serif;
            background-color: #f9f9f9;
            color: #333;
            min-height: 100vh;
        }

        a {
            text-decoration: none;
            color: inherit;
            transition: color 0.3s ease;
        }
        a:hover {
            color: #b08d57;
        }

        ul {
            list-style: none;
        }

        /* ==================== 2. 바디 (마이페이지 메인 영역) 스타일 ==================== */
        .mypage-body {
            max-width: 1200px;
            margin: 50px auto;
            display: flex;
            gap: 30px;
            padding: 0 20px;
        }

        /* 왼쪽 사이드바 스타일 */
        .mypage-sidebar {
            flex-shrink: 0;
            width: 200px;
            background-color: #ffffff;
            padding: 10px 0;
            border-radius: 6px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
            border: 1px solid #e0e0e0;
        }

        .sidebar-title {
            font-size: 18px;
            font-weight: 700;
            padding: 15px 20px;
            margin-bottom: 10px;
            color: #2c2c2c;
            border-bottom: 1px solid #eee;
        }

        .mypage-sidebar a {
            display: block;
            padding: 12px 20px;
            font-size: 15px;
            color: #555;
            transition: background-color 0.2s, color 0.2s;
        }

        .mypage-sidebar a:hover {
            background-color: #f0f0f0;
            color: #333;
        }

        .mypage-sidebar a.active {
            background-color: #f0f0f0;
            color: #b08d57;
            font-weight: 700;
            border-left: 4px solid #b08d57;
            padding-left: 16px;
        }

        /* 오른쪽 콘텐츠 영역 스타일 */
        .mypage-content-area {
            flex-grow: 1;
            background-color: #ffffff;
            padding: 40px;
            border-radius: 6px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
            border: 1px solid #e0e0e0;
        }

        .mypage-content-area h2 {
            font-size: 26px;
            border-bottom: 3px solid #b08d57;
            padding-bottom: 10px;
            margin-bottom: 30px;
            color: #2c2c2c;
        }

        .content-panel {
            display: none;
        }

        .content-panel.active {
            display: block;
        }

        /* --- 회원 정보 폼 전용 스타일 --- */
        .info-form {
            max-width: 700px;
            margin-top: 20px;
            padding: 30px;
            border: 1px solid #e0e0e0;
            border-radius: 5px;
            background-color: #fcfcfc;
        }

        .form-group {
            margin-bottom: 20px;
        }
        
        .form-row {
            display: flex;
            align-items: center;
        }

        .form-group label {
            flex-shrink: 0;
            width: 120px;
            font-weight: 600;
            color: #333;
            margin-bottom: 0;
        }

        .form-group input[type="text"],
        .form-group input[type="email"],
        .form-group input[type="tel"],
        .form-group input[type="password"] {
            flex-grow: 1;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 15px;
            transition: border-color 0.3s;
            margin-top: 0;
        }
        
        .form-group input:focus {
             border-color: #b08d57;
        }

        #MEMBER_ID_VIEW {
            background-color: #f0f0f0;
            color: #777;
        }

        /* --- 주소 그룹 전용 스타일 --- */
        .address-group {
            margin-top: 20px;
        }
        .address-group .form-group {
            margin-bottom: 10px;
        }
        .address-zip-row {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-grow: 1;
        }
        
        .address-zip-row #zipcode {
            width: 100px;
            flex-grow: 0;
            background-color: #f0f0f0;
        }

        .address-search-btn {
            padding: 10px 15px;
            border: none;
            background-color: #6c757d;
            color: white;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 500;
            flex-shrink: 0;
            transition: background-color 0.3s;
            font-size: 15px;
        }

        .address-search-btn:hover {
            background-color: #5a6268;
        }

        #MEMBER_ADDR_PRIMARY {
            background-color: #f0f0f0;
            color: #777;
        }
        #MEMBER_ADDR_DETAIL {
            background-color: #ffffff;
            color: #333;
        }

        .button-group {
            text-align: center;
            margin-top: 40px;
        }

        .submit-btn, .reset-btn {
            padding: 10px 25px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
            margin: 0 10px;
            transition: background-color 0.3s;
        }

        .submit-btn {
            background-color: #2c2c2c;
            color: white;
        }

        .submit-btn:hover {
            background-color: #b08d57;
            color: #2c2c2c;
        }

        .reset-btn {
            background-color: #ccc;
            color: #333;
            border: 1px solid #bbb;
        }

        .reset-btn:hover {
            background-color: #bbb;
        }
        
        /* 테이블 및 공통 스타일 */
        .message {
            padding: 10px 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            font-size: 1em;
            text-align: center;
        }
        .message.success {
            background-color: #e6f7e9;
            color: #1a7c36;
            border: 1px solid #a9d4b6;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            border-radius: 8px;
            overflow: hidden;
        }
        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        th {
            background-color: #4a4a4a;
            color: white;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.9em;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        tr:hover {
            background-color: #f1f1f1;
        }
        .no-items {
            color: #888;
            margin-top: 30px;
            text-align: center;
            font-size: 1.1em;
            padding: 20px;
            border: 1px dashed #ccc;
            border-radius: 8px;
            background-color: #fff;
        }
        .action-btn {
            background-color: #6c757d;
            color: white;
            border: none;
            padding: 8px 12px;
            cursor: pointer;
            border-radius: 5px;
            font-size: 0.9em;
            transition: background-color 0.3s ease;
            margin-right: 5px; 
        }
        .action-btn:hover {
            background-color: #b08d57;
            color: #2c2c2c;
        }
        .remove-btn {
            background-color: #dc3545;
        }
        .remove-btn:hover {
            background-color: #c82333;
        }

        /* 쿠폰/포인트 섹션 스타일 */
        .coupon-point-summary {
            display: flex;
            justify-content: space-around;
            background-color: #f0f0f0;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }
        .summary-item {
            text-align: center;
            flex: 1;
            padding: 10px;
            border-right: 1px solid #e0e0e0;
        }
        .summary-item:last-child {
            border-right: none;
        }
        .summary-item .label {
            font-size: 15px;
            color: #666;
            margin-bottom: 8px;
        }
        .summary-item .value {
            font-size: 24px;
            font-weight: 700;
            color: #b08d57;
        }
        .coupon-item {
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
            background-color: #fff;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }
        .coupon-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }
        .coupon-name {
            font-size: 18px;
            font-weight: 600;
            color: #333;
        }
        .coupon-status {
            font-size: 13px;
            padding: 4px 8px;
            border-radius: 4px;
            font-weight: 500;
        }
        .coupon-status.available { background-color: #e6f7e9; color: #1a7c36; }
        .coupon-status.used { background-color: #f0f0f0; color: #888; }
        .coupon-status.expired { background-color: #ffe0e0; color: #d64545; }

        .coupon-details p {
            font-size: 14px;
            color: #555;
            margin-bottom: 5px;
        }
        .coupon-details .highlight {
            font-weight: 600;
            color: #b08d57;
        }
        .point-history-item {
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 10px;
            background-color: #fff;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .point-info {
            flex-grow: 1;
        }
        .point-description {
            font-size: 16px;
            font-weight: 500;
            color: #333;
            margin-bottom: 5px;
        }
        .point-date {
            font-size: 13px;
            color: #888;
        }
        .point-amount {
            font-size: 18px;
            font-weight: 700;
        }
        .point-amount.earn { color: #28a745; }
        .point-amount.use { color: #dc3545; }
        .point-amount.cancel { color: #6c757d; }

        /* 회원 탈퇴 섹션 스타일 */
        .withdraw-section {
            margin-top: 50px;
            padding: 30px;
            border: 1px solid #dc3545;
            border-radius: 5px;
            background-color: #fff6f6;
        }
        .withdraw-section h3 {
            color: #dc3545;
            font-size: 20px;
            margin-bottom: 15px;
        }
        .withdraw-section p {
            font-size: 14px;
            color: #555;
            margin-bottom: 20px;
        }
        .withdraw-btn {
            background-color: #dc3545;
            color: white;
        }
        .withdraw-btn:hover {
            background-color: #c82333;
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

    <main class="mypage-body">
        
        <aside class="mypage-sidebar">
            <nav>
                <ul>
                    <li class="sidebar-title">MY PAGE</li>
                    <li><a href="#member-info" class="active">회원 정보 수정</a></li>
                    <li><a href="#wishlist">찜목록 (Wishlist)</a></li>
                    <li><a href="#order-history">주문 내역</a></li>
                    <li><a href="#my-coupons">나의 쿠폰</a></li>
                    <li><a href="#my-points">나의 포인트</a></li>
                </ul>
            </nav>
        </aside>

        <section class="mypage-content-area">
      
            <h2 id="content-title">회원 정보 수정</h2>
            
            <div id="member-info-content" class="content-panel active">
                <div class="member-info-panel">
                    <form action="mypage/user_info" method="post" class="info-form">
                        
                        <div class="form-group">
                            <div class="form-row">
                                <label for="MEMBER_ID_VIEW">아이디</label>
                                <input type="text" id="MEMBER_ID_VIEW" value="${memberInfo.memberId}" disabled>
                            </div>
                            <input type="hidden" name="memberId" value="${memberInfo.memberId}">
                        </div>

                        <div class="form-group">
                            <div class="form-row">
                                <label for="MEMBER_PW">새 비밀번호</label>
                                <input type="password" id="MEMBER_PW" name="memberPw" placeholder="새 비밀번호를 입력해주세요 (변경 시에만 입력)" >
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <div class="form-row">
                                <label for="MEMBER_NAME">이름</label>
                                <input type="text" id="MEMBER_NAME" name="memberName" value="${memberInfo.memberName}" required>
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="form-row">
                                <label for="MEMBER_EMAIL">이메일</label>
                                <input type="email" id="MEMBER_EMAIL" name="memberEmail" value="${memberInfo.memberEmail}" required>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <div class="form-row">
                                <label for="MEMBER_PHONE">전화번호</label>
                                <input type="tel" id="MEMBER_PHONE" name="memberPhone" value="${memberInfo.memberPhone}" placeholder="예: 010-1234-5678">
                            </div>
                        </div>

                        <div class="address-group">
                            <div class="form-group">
                                <div class="form-row">
                                    <label for="zipcode">우편번호</label>
                                    <div class="address-zip-row">
                                        <input type="text" id="zipcode" name="memberZipcode" value="${memberInfo.memberZipcode}" placeholder="우편번호" readonly>
                                        <button type="button" class="address-search-btn" onclick="daumZipCode()">주소 검색</button>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <div class="form-row">
                                    <label for="MEMBER_ADDR_PRIMARY">기본 주소</label>
                                    <input type="text" id="MEMBER_ADDR_PRIMARY" name="memberAddr1" value="${memberInfo.memberAddr1}" placeholder="도로명 주소 (검색 결과)" readonly>
                                </div>
                            </div>

                            <div class="form-group">
                                <div class="form-row">
                                    <label for="MEMBER_ADDR_DETAIL">상세 주소</label>
                                    <input type="text" placeholder="상세 주소" name="memberAddr2" id="MEMBER_ADDR_DETAIL" value="${memberInfo.memberAddr2}">
                                </div>
                            </div>
                        </div>
                        <div class="button-group">
                            <button type="submit" class="submit-btn">정보 수정</button>
                            <button type="reset" class="reset-btn">취소</button>
                        </div>
                    </form>

                    <!-- 회원 탈퇴 섹션 추가 -->
                    <div class="withdraw-section">
                        <h3>회원 탈퇴</h3>
                        <p>회원 탈퇴를 원하시면, 현재 비밀번호를 입력하고 '회원 탈퇴' 버튼을 클릭하세요. 탈퇴 시 회원 정보 및 관련 데이터(장바구니, 찜 목록, 쿠폰)는 즉시 삭제되며 복구할 수 없습니다.</p>
                        <form action="<c:url value='/mypage/withdraw'/>" method="post" onsubmit="return confirm('정말로 탈퇴하시겠습니까?');">
                            <div class="form-group">
                                <div class="form-row">
                                    <label for="MEMBER_PW_WITHDRAW">비밀번호 확인</label>
                                    <input type="password" id="MEMBER_PW_WITHDRAW" name="memberPw" placeholder="현재 비밀번호를 입력하세요" required>
                                </div>
                            </div>
                            <div class="button-group">
                                <button type="submit" class="submit-btn withdraw-btn">회원 탈퇴</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <div id="wishlist-content" class="content-panel">
                
                <c:if test="${not empty message}">
                    <p class="message success">${message}</p>
                </c:if>

                <c:if test="${empty wishlist}">
                    <p class="no-items">찜목록에 담긴 상품이 없습니다.</p>
                </c:if>
                <c:if test="${not empty wishlist}">
                    <table>
                        <thead>
                            <tr>
                                <th style="width: 80px;">상품 ID</th>
                                <th>상품명</th>
                                <th style="width: 100px;">가격</th>
                                <th>판매자</th>
                                <th>재고</th>
                                <th style="width: 90px;">삭제</th>
                                <th style="width: 160px;">장바구니 이동</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="product" items="${wishlist}">
                                <tr>
                                    <td>${product.prodId}</td>
                                    <td>${product.prodName}</td>
                                    <td><fmt:formatNumber value="${product.prodPrice}" pattern="#,###" />원</td>
                                    <td>${product.prodSeller}</td>
                                    <td>${product.prodStock}</td>
                                    <td>
                                        <form action="/mypage/wishlist/remove" method="post" style="display:inline;">
                                            <input type="hidden" name="memberId" value="${sessionScope.memberId}">
                                            <input type="hidden" name="prodId" value="${product.prodId}">
                                            <button type="submit" class="action-btn remove-btn">삭제</button>
                                        </form>
                                    </td>
                                    <td>
                                        <form action="/cart/moveFromWishlist" method="post" style="display:inline;">
                                            <input type="hidden" name="memberId" value="${sessionScope.memberId}">
                                            <input type="hidden" name="prodId" value="${product.prodId}">
                                            <input type="hidden" name="cartQty" value="1"> 
                                            <button type="submit" class="action-btn">장바구니로 이동</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:if>
            </div>

            <div id="order-history-content" class="content-panel">

                <c:if test="${empty orderList}">
                    <p class="no-items">주문 내역이 없습니다.</p>
                </c:if>

                <c:if test="${not empty orderList}">
                    <table>
                        <thead>
                            <tr>
                                <th>주문정보</th>
                                <th>주문상품</th>
                                <th style="width: 120px;">주문 상태</th>
                                <th style="width: 120px;">관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="order" items="${orderList}">
                                <tr>
                                    <td>
                                        <strong>주문번호:</strong> ${order.ordId}<br>
                                        <strong>주문일:</strong> <fmt:formatDate value="${order.ordDate}" pattern="yyyy-MM-dd" /><br>
                                        <strong>결제금액:</strong> <fmt:formatNumber value="${order.ordAmount}" pattern="#,###" />원
                                    </td>
                                    <td>
                                        <ul style="list-style: none; padding: 0;">
                                            <c:forEach var="detail" items="${order.orderDetails}">
                                                <li style="margin-bottom: 5px;">
                                                    <a href="<c:url value='/products/detail?prodId=${detail.productId}'/>">${detail.prodName}</a> - ${detail.quantity}개
                                                    
                                                    <c:if test="${order.ordStatus == '구매확정'}">
                                                        <a href="<c:url value='/reviews/write?productId=${detail.productId}&orderId=${order.ordId}'/>" class="action-btn" style="margin-left: 10px; background-color: #b08d57;">리뷰쓰기</a>
                                                    </c:if>
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </td>
                                    <td>${order.ordStatus}</td>
                                    <td>
                                        <c:choose>
                                             <c:when test="${order.ordStatus == '배송완료'}">
                                                <form action="<c:url value='/order/confirm'/>" method="post" style="display:inline;">
                                                    <input type="hidden" name="orderId" value="${order.ordId}">
                                                    <button type="submit" class="action-btn" style="background-color: #28a745;">구매 확정</button>
                                                </form>
                                            </c:when>
                                            <c:when test="${order.ordStatus == '구매확정'}">
                                                완료
                                            </c:when>
                                            <c:otherwise>
                                                -
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:if>
            </div>

            <div id="my-coupons-content" class="content-panel">
                <div class="coupon-point-summary">
                    <div class="summary-item">
                        <div class="label">보유 쿠폰</div>
                        <div class="value">${fn:length(userCoupons)}개</div>
                    </div>
                </div>
                <c:if test="${empty userCoupons}">
                    <p class="no-items">보유하고 있는 쿠폰이 없습니다.</p>
                </c:if>
                <c:if test="${not empty userCoupons}">
                    <c:forEach var="userCoupon" items="${userCoupons}">
                        <div class="coupon-item">
                            <div class="coupon-header">
                                <div class="coupon-name">${userCoupon.couponName}</div>
                                <c:choose>
                                    <c:when test="${userCoupon.isUsed == 'Y'}">
                                        <span class="coupon-status used">사용 완료</span>
                                    </c:when>
                                    <c:when test="${userCoupon.expirationDate != null and userCoupon.expirationDate lt now}">
                                        <span class="coupon-status expired">기간 만료</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="coupon-status available">사용 가능</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="coupon-details">
                                <p>할인: 
                                    <c:choose>
                                        <c:when test="${userCoupon.couponType == 'PERCENT'}">
                                            <span class="highlight">${userCoupon.discountValue}%</span> 할인
                                            <c:if test="${userCoupon.maxDiscountAmount != null}"> (최대 <fmt:formatNumber value="${userCoupon.maxDiscountAmount}" pattern="#,###"/>원)</c:if>
                                        </c:when>
                                        <c:when test="${userCoupon.couponType == 'AMOUNT'}">
                                            <span class="highlight"><fmt:formatNumber value="${userCoupon.discountValue}" pattern="#,###"/>원</span> 할인
                                        </c:when>
                                    </c:choose>
                                </p>
                                <p>최소 주문 금액: <fmt:formatNumber value="${userCoupon.minOrderAmount}" pattern="#,###"/>원</p>
                                <p>유효 기간: 
                                    <c:choose>
                                        <c:when test="${userCoupon.expirationDate != null}">
                                            <fmt:formatDate value="${userCoupon.expirationDate}" pattern="yyyy-MM-dd"/>까지
                                        </c:when>
                                        <c:otherwise>
                                            제한 없음
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                                <p>설명: ${userCoupon.description}</p>
                            </div>
                        </div>
                    </c:forEach>
                </c:if>
            </div>

            <div id="my-points-content" class="content-panel">
                <div class="coupon-point-summary">
                    <div class="summary-item">
                        <div class="label">현재 포인트</div>
                        <div class="value"><fmt:formatNumber value="${currentPoint}" pattern="#,###"/> P</div>
                    </div>
                </div>
                <c:if test="${empty pointHistory}">
                    <p class="no-items">포인트 내역이 없습니다.</p>
                </c:if>
                <c:if test="${not empty pointHistory}">
                    <c:forEach var="history" items="${pointHistory}">
                        <div class="point-history-item">
                            <div class="point-info">
                                <div class="point-description">${history.description}</div>
                                <div class="point-date"><fmt:formatDate value="${history.changeDate}" pattern="yyyy-MM-dd HH:mm"/></div>
                            </div>
                            <div class="point-amount <c:if test="${history.pointType == 'EARN'}">earn</c:if><c:if test="${history.pointType == 'USE'}">use</c:if><c:if test="${history.pointType == 'CANCEL'}">cancel</c:if>">
                                <c:if test="${history.pointType == 'EARN'}">+</c:if>
                                <c:if test="${history.pointType == 'USE'}">-</c:if>
                                <c:if test="${history.pointType == 'CANCEL'}">±</c:if>
                                <fmt:formatNumber value="${history.amount}" pattern="#,###"/> P
                            </div>
                        </div>
                    </c:forEach>
                </c:if>
            </div>
            
        </section>
    </main>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const sidebarLinks = document.querySelectorAll('.mypage-sidebar a');
            const contentPanels = document.querySelectorAll('.content-panel');
            const mainTitle = document.querySelector('.mypage-content-area h2');

            const getHashId = () => window.location.hash.substring(1) || 'member-info';

            function activatePanel(targetId) {
                const panelId = targetId + '-content';
                sidebarLinks.forEach(link => {
                    const linkHash = link.getAttribute('href').substring(1);
                    if (linkHash === targetId) {
                        link.classList.add('active');
                        mainTitle.textContent = link.textContent;
                    } else {
                        link.classList.remove('active');
                    }
                });
                contentPanels.forEach(panel => {
                    if (panel.id === panelId) {
                        panel.classList.add('active');
                    } else {
                        panel.classList.remove('active');
                    }
                });
            }

            activatePanel(getHashId());
            sidebarLinks.forEach(link => {
                link.addEventListener('click', function(event) {
                    event.preventDefault();
                    const targetHash = this.getAttribute('href').substring(1);
                    activatePanel(targetHash);
                    window.history.pushState(null, null, this.href);
                });
            });

            window.addEventListener('popstate', function() {
                activatePanel(getHashId());
            });
        });
    </script>
    <c:if test="${updateSuccess}">
        <script> alert('정보 수정이 완료되었습니다.'); </script>
    </c:if>
</body>
</html>
