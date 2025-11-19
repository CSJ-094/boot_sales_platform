<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600;700;800&family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<c:url value='/css/header.css' />">
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
                        // MEMBER_ADDR_PRIMARY는 기본 주소, MEMBER_ADDR_DETAIL은 상세 주소
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
            font-family: 'Noto Sans KR', 'Montserrat', sans-serif;/* ⭐️ mainpage.jsp 폰트 적용 [cite: 178] */
            background-color: #f9f9f9;/* ⭐️ mainpage.jsp 배경색 적용 [cite: 178] */
            color: #333;
            min-height: 100vh;
        }

        a {
            text-decoration: none;
            color: inherit;
            transition: color 0.3s ease;
        }
        a:hover {
            color: #b08d57; [cite_start]/* ⭐️ mainpage.jsp 강조색 적용 [cite: 184] */
        }

        ul {
            list-style: none;
        }

        /* ==================== 1. 헤더 스타일 (mainpage.jsp 기준) ==================== */

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

        /* 현재 선택된 메뉴 강조 */
        .mypage-sidebar a.active {
            background-color: #f0f0f0;
            color: #b08d57; /* ⭐️ 강조색 적용 */
            font-weight: 700;
            border-left: 4px solid #b08d57; /* ⭐️ 강조색 선 추가 */
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
            border-bottom: 3px solid #b08d57; /* ⭐️ 강조색 적용 */
            padding-bottom: 10px;
            margin-bottom: 30px;
            color: #2c2c2c;
        }

        /* **숨김 처리** */
        .content-panel {
            display: none;
        }

        /* **활성화된 콘텐츠** */
        .content-panel.active {
            display: block;
        }


        /* --- 회원 정보 폼 전용 스타일 (수정됨) --- */
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
        
        .form-row { /* ⭐️ 입력 필드와 라벨을 수평으로 정렬 */
            display: flex;
            align-items: center;
        }

        .form-group label {
            flex-shrink: 0;
            width: 120px; /* ⭐️ 라벨 너비 고정 */
            font-weight: 600;
            color: #333;
            margin-bottom: 0;
        }

        /* 기본 입력 필드 스타일 */
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


        /* 수정 불가능한 아이디 필드 스타일 */
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
            flex-grow: 1; /* 나머지 공간을 모두 차지 */
        }
        
        /* 우편번호 입력 필드 */
        .address-zip-row #zipcode {
            width: 100px; /* 우편번호 필드 너비 조정 */
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

        /* 기본 주소 필드 (읽기 전용) */
        #MEMBER_ADDR_PRIMARY {
            background-color: #f0f0f0;
            color: #777;
        }
        /* 상세주소 (입력 가능) */
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
            background-color: #2c2c2c; /* ⭐️ 강조색 적용 */
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
        
        
        /* ⭐️ Wishlist Table & Button Styles ⭐️ */
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
            background-color: #4a4a4a; /* ⭐️ 어두운 배경색 적용 */
            color: white;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.9em;
        }
        th { text-align: center; } /* ⭐️ 헤더 텍스트 가운데 정렬 */

        /* 주문 내역 테이블 셀 가운데 정렬 (상품정보 제외) */
        #order-history-content td {
            text-align: center;
            vertical-align: middle; /* 세로 정렬도 중앙으로 */
        }
        #order-history-content td:nth-child(2) { /* 2번째 열(상품정보)만 왼쪽 정렬 */
            text-align: left;
        }

        /* 찜목록 테이블 셀 가운데 정렬 (상품명 제외) */
        #wishlist-content td {
            text-align: center;
            vertical-align: middle;
        }
        #wishlist-content td:nth-child(2) { /* 2번째 열(상품명)만 왼쪽 정렬 */
            text-align: left;
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
            background-color: #b08d57; /* ⭐️ 강조색 적용 */
            color: #2c2c2c;
        }
        .remove-btn {
            background-color: #dc3545;
        }
        .remove-btn:hover {
            background-color: #c82333;
        }
        .mypage-sidebar a.withdraw {
            color: #d9534f;
            font-weight: 700;
        }

        .mypage-sidebar a.withdraw:hover {
            background-color: #ffe5e5;
            color: #c9302c;
        }

        .withdraw-warning{
            color:#666;
            margin-bottom:20px;
        }
        .withdraw-btn{
            background:#d9534f;
            color:#fff;
            padding:12px 25px;
            border:none;
            border-radius:6px;
            font-size:16px;
            cursor:pointer;
        }
        /* ⭐️ End of Wishlist Styles ⭐️ */
		/* ... 기존 스타일 ... */
		        
		        /* 🚨 배송 조회 모달 스타일 추가 🚨 */
		        #trackingModal {
		            border: 1px solid #b08d57; 
		            background-color: #ffffff;
		            padding: 25px;
		            border-radius: 8px;
		            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
		            display: none; 
		            position: fixed; 
		            top: 50%; left: 50%;
		            transform: translate(-50%, -50%);
		            width: 550px;
		            max-height: 80vh;
		            overflow-y: auto;
		            z-index: 1000;
		        }
		        #trackingModal .modal-content {
		            background-color: #fefefe;
		            margin: auto;
		            padding: 20px;
		            border: 1px solid #888;
		            width: 80%;
		            box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2),0 6px 20px 0 rgba(0,0,0,0.19);
		            animation-name: animatetop;
		            animation-duration: 0.4s;
		        }
		        @keyframes animatetop {
		            from {top: -300px; opacity: 0}
		            to {top: 0; opacity: 1}
		        }
		        #trackingModal .close {
		            color: #aaa;
		            float: right;
		            font-size: 28px;
		            font-weight: bold;
		        }
		        #trackingModal .close:hover,
		        #trackingModal .close:focus {
		            color: black;
		            text-decoration: none;
		            cursor: pointer;
		        }
		        #trackingContent { margin-top: 15px; }
		        #trackingContent table { width: 100%; border-collapse: collapse; margin-top: 15px; }
		        #trackingContent th, #trackingContent td { border: 1px solid #e0e0e0; padding: 10px; text-align: left; font-size: 0.9em; }
		        .loading { color: #b08d57; font-style: italic; text-align: center; padding: 20px; }
		        .tracking-detail-item {
		            border-bottom: 1px dashed #eee;
		            padding: 10px 0;
		            display: flex;
		            justify-content: space-between;
		            align-items: center;
		        }
		        .tracking-detail-item:last-child { border-bottom: none; }
		        .tracking-detail-time { font-weight: bold; color: #555; flex-basis: 30%; }
		        .tracking-detail-location { flex-basis: 40%; color: #777; }
		        .tracking-detail-status { font-weight: bold; color: #b08d57; flex-basis: 30%; text-align: right; }
		        /* 쿠폰/포인트 관련 스타일 */
		        .point-summary {
		            background-color: #f8f8f8;
		            border: 1px solid #eee;
		            padding: 15px 20px;
		            margin-bottom: 20px;
		            border-radius: 5px;
		            font-size: 1.1em;
		            text-align: center;
		        }
		        .point-summary span {
		            font-weight: 700;
		            color: #b08d57;
		            margin-left: 10px;
		        }
		        .coupon-claim-form {
		            display: inline-block;
		            margin-left: 10px;
		        }
		        .coupon-claim-btn {
		            background-color: #2c2c2c; /* 기존 초록색에서 테마의 어두운 색상으로 변경 */
		            color: white;
		            border: none;
		            padding: 8px 15px; /* 패딩 조정 */
		            border-radius: 5px; /* 둥근 모서리 */
		            cursor: pointer;
		            font-size: 0.95em; /* 폰트 크기 조정 */
		            font-weight: 600; /* 폰트 굵기 */
		            transition: background-color 0.3s ease, color 0.3s ease, box-shadow 0.3s ease;
		            box-shadow: 0 2px 5px rgba(0,0,0,0.1); /* 미세한 그림자 */
		        }
		        .coupon-claim-btn:hover {
		            background-color: #b08d57; /* 호버 시 강조색 */
		            color: #2c2c2c; /* 호버 시 글자색 변경 */
		            box-shadow: 0 4px 8px rgba(0,0,0,0.15); /* 호버 시 그림자 강조 */
		        }
		        .expired {
		            color: #999;
		            text-decoration: line-through;
		        }
		        .expired .coupon-claim-btn {
		            background-color: #ccc;
		            cursor: not-allowed;
		            box-shadow: none;
		        }
		        .expired .coupon-claim-btn:hover {
		            background-color: #ccc;
		            color: #666;
		            box-shadow: none;
		        }
		    </style>
    </style>
</head>
<body>
<c:if test="${not empty msg}">
    <script>
        alert("${msg}");
    </script>
</c:if>
<c:if test="${not empty couponMessage}">
    <script>
        alert("${couponMessage}");
    </script>
</c:if>
<c:if test="${not empty couponError}">
    <script>
        alert("${couponError}");
    </script>
</c:if>

<jsp:include page="/WEB-INF/views/fragments/header.jsp" />
<%-- 룰렛 팝업을 페이지에 포함시킵니다. --%>

    <main class="mypage-body">
        
        <aside class="mypage-sidebar">
            <nav>
                <ul>
                    <li class="sidebar-title">MY PAGE</li>
                    <li><a href="#member-info" class="active">회원 정보 수정</a></li>
                    <li><a href="#wishlist">찜목록 (Wishlist)</a></li>
                    <li><a href="#order-history">주문 내역</a></li>
                    <li><a href="#my-coupons">내 쿠폰</a></li> <%-- 쿠폰 메뉴 추가 --%>
                    <li><a href="#my-points">내 포인트</a></li> <%-- 포인트 메뉴 추가 --%>
                    <li><a href="#deleteUser" class="withdraw">회원 탈퇴</a></li> <%-- 포인트 메뉴 추가 --%>
                    <li class="separator"></li>
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
                    <c:choose>
                        <c:when test="${sessionScope.userType != 'kakao'}">
                        <div class="form-group">
                            <div class="form-row">
                                <label for="MEMBER_PW">새 비밀번호</label>
                                <input type="password" id="MEMBER_PW" name="memberPw" placeholder="새 비밀번호를 입력해주세요 (변경 시에만 입력)" >
                            </div>
                        </div>
                        </c:when>
                    </c:choose>

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
                                            <input type="hidden" name="memberId" value="${param.memberId}">
                                            <input type="hidden" name="prodId" value="${product.prodId}">
                                            <button type="submit" class="action-btn remove-btn">삭제</button>
                                        </form>
                                    </td>
                                    <td>
                                        <form action="/cart/moveFromWishlist" method="post" style="display:inline;">
                                            <input type="hidden" name="memberId" value="${param.memberId}">
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
                                <th style="width: 150px;">주문날짜</th>
                                <th>상품정보</th>
                                <th style="width: 120px;">금액</th>
                                <th style="width: 110px;">주문 상태</th>
                                <th style="width: 150px;">관리</th>
                                <th style="width: 120px;">배송조회</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="order" items="${orderList}">
                                <tr>
                                    <td>
                                        <fmt:formatDate value="${order.ordDate}" pattern="yyyy-MM-dd" />
                                    </td>
                                    <td>
                                        <ul style="list-style: none; padding: 0; max-height: 150px; overflow-y: auto;">
                                            <c:forEach var="detail" items="${order.orderDetails}">
                                                <li style="display: flex; align-items: center; margin-bottom: 10px;">
                                                    <img src="<c:url value='${detail.prodImage}'/>" alt="${detail.prodName}" style="width: 50px; height: 50px; object-fit: cover; margin-right: 10px; border-radius: 4px;">
                                                    <a href="<c:url value='/product/detail?id=${detail.productId}'/>">${detail.prodName}</a>
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </td>
                                    <td><fmt:formatNumber value="${order.ordAmount}" pattern="#,###" />원</td>
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
                                                <%-- 모든 상품에 대한 리뷰 작성 여부를 확인하기 위한 변수 --%>
                                                <c:set var="allReviewed" value="${true}" />
                                                <c:forEach var="detail" items="${order.orderDetails}">
                                                    <c:if test="${!detail.hasReview}">
                                                        <c:set var="allReviewed" value="${false}" />
                                                        <div style="margin-bottom: 5px;">
                                                            <a href="<c:url value='/reviews/write?productId=${detail.productId}&orderId=${order.ordId}'/>" class="action-btn" style="background-color: #b08d57;">리뷰 쓰기</a>
                                                        </div>
                                                    </c:if>
                                                </c:forEach>

                                                <%-- 모든 상품의 리뷰가 작성되었다면 완료 메시지 표시 --%>
                                                <c:if test="${allReviewed}">
                                                    <span style="color: #888; font-size: 0.9em;">리뷰 작성 완료</span>
                                                </c:if>
                                            </c:when>
                                            <c:otherwise>
                                                -
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <button type="button" class="action-btn delivery-track-btn"
                                                data-code="${order.deliveryCompany}"
                                                data-invoice="${order.trackingNumber}">🚚 조회</button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:if>
            </div>
                <div id="deleteUser-content" class="content-panel">
                <p class="withdraw-warning">
                    탈퇴 시 모든 회원 정보가 삭제되며 복구가 불가능합니다.
                </p>
                <form action="${pageContext.request.contextPath}/mypage/deleteUser"
                      method="post"
                      onsubmit="return confirm('정말 탈퇴하시겠습니까?');">
                    <button type="submit" class="withdraw-btn">
                        회원 탈퇴
                    </button>
                </form>
            </div>

            <!-- 내 쿠폰 -->
            <div id="my-coupons-content" class="content-panel">
                <c:if test="${not empty couponMessage}">
                    <script>alert("${couponMessage}");</script>
                </c:if>
                <c:if test="${not empty couponError}">
                    <script>alert("${couponError}");</script>
                </c:if>
                <c:if test="${empty userCoupons}">
                    <p class="no-items">보유한 쿠폰이 없습니다.</p>
                </c:if>
                <c:if test="${not empty userCoupons}">
                    <table>
                        <thead>
                            <tr>
                                <th>쿠폰명</th>
                                <th>할인</th>
                                <th>최소 주문 금액</th>
                                <th>유효 기간</th>
                                <th>상태</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="uc" items="${userCoupons}">
                                <tr class="${uc.isUsed == 'Y' or (uc.expirationDate != null and uc.expirationDate.before(now))} ? 'expired' : ''">
                                    <td>${uc.couponName}</td>
                                    <td>
                                        <c:if test="${uc.couponType == 'PERCENT'}">${uc.discountValue}%</c:if>
                                        <c:if test="${uc.couponType == 'AMOUNT'}"><fmt:formatNumber value="${uc.discountValue}" pattern="#,###"/>원</c:if>
                                    </td>
                                    <td><fmt:formatNumber value="${uc.minOrderAmount}" pattern="#,###"/>원 이상</td>
                                    <td><fmt:formatDate value="${uc.expirationDate}" pattern="yyyy-MM-dd"/></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${uc.isUsed == 'Y'}">사용 완료</c:when>
                                            <c:when test="${uc.isUsed == 'N' and (uc.expirationDate == null or uc.expirationDate.after(now))}">사용 가능</c:when>
                                            <c:when test="${uc.isUsed == 'N' and uc.expirationDate != null and uc.expirationDate.before(now)}">기간 만료</c:when>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:if>

                <h3>발급 가능한 쿠폰</h3>
                <c:if test="${empty claimableCoupons}">
                    <p class="no-items">현재 발급 가능한 쿠폰이 없습니다.</p>
                </c:if>
                <c:if test="${not empty claimableCoupons}">
                    <table>
                        <thead>
                            <tr>
                                <th>쿠폰명</th>
                                <th>할인</th>
                                <th>최소 주문 금액</th>
                                <th>유효 기간</th>
                                <th>발급</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="coupon" items="${claimableCoupons}">
                                <tr>
                                    <td>${coupon.couponName}</td>
                                    <td>
                                        <c:if test="${coupon.couponType == 'PERCENT'}">${coupon.discountValue}%</c:if>
                                        <c:if test="${coupon.couponType == 'AMOUNT'}"><fmt:formatNumber value="${coupon.discountValue}" pattern="#,###"/>원</c:if>
                                    </td>
                                    <td><fmt:formatNumber value="${coupon.minOrderAmount}" pattern="#,###"/>원 이상</td>
                                    <td><fmt:formatDate value="${coupon.expirationDate}" pattern="yyyy-MM-dd"/></td>
                                    <td>
                                        <form action="<c:url value='/mypage/claimCoupon'/>" method="post" class="coupon-claim-form">
                                            <input type="hidden" name="couponId" value="${coupon.couponId}">
                                            <button type="submit" class="coupon-claim-btn">쿠폰 받기</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:if>
            </div>

            <!-- 내 포인트 -->
            <div id="my-points-content" class="content-panel">
                <div class="point-summary">
                    <strong>현재 보유 포인트:</strong>
                    <span><fmt:formatNumber value="${currentPoint}" pattern="#,###"/> P</span>
                </div>
                <c:if test="${empty pointHistory}">
                    <p class="no-items">포인트 적립/사용 내역이 없습니다.</p>
                </c:if>
                <c:if test="${not empty pointHistory}">
                    <table>
                        <thead>
                            <tr>
                                <th>날짜</th>
                                <th>유형</th>
                                <th>변동</th>
                                <th>내용</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="history" items="${pointHistory}">
                                <tr>
                                    <td><fmt:formatDate value="${history.changeDate}" pattern="yyyy-MM-dd HH:mm"/></td>
                                    <td>${history.pointType == 'EARN' ? '적립' : '사용'}</td>
                                    <td>
                                        <c:if test="${history.amount > 0}">+</c:if><fmt:formatNumber value="${history.amount}" pattern="#,###"/>
                                    </td>
                                    <td>${history.description}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:if>
            </div>
            
        </section>
    </main>

    <%-- ⭐️ 배송 추적 결과를 보여줄 모달 창 HTML 추가 --%>
    <div id="trackingModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeTrackingModal()">&times;</span>
            <h2>배송 추적 정보</h2>
            <div id="trackingContent">
                <div class="loading">배송 정보를 조회하는 중...</div>
            </div>
        </div>
    </div>

    <script>
        // 배송 추적 관련 함수들을 DOMContentLoaded 외부로 이동하여 전역적으로 접근 가능하게 함
        function trackDelivery(deliveryCompany, trackingNumber) {
            const modal = document.getElementById('trackingModal');
            const content = document.getElementById('trackingContent');

            if (!deliveryCompany || !trackingNumber || deliveryCompany === 'null' || trackingNumber === 'null') {
                content.innerHTML = '<div style="color: orange; padding: 20px; text-align: center;">운송장 정보가 없습니다.</div>';
                modal.style.display = 'block';
                return;
            }

            modal.style.display = 'block';
            content.innerHTML = '<div class="loading">배송 정보를 조회하는 중...</div>';

            fetch('${pageContext.request.contextPath}/trackDelivery?t_code=' + deliveryCompany + '&t_invoice=' + trackingNumber)
                .then(response => response.json())
                .then(data => {
                    if (data && data.trackingDetails) {
                        displayTrackingInfo(data);
                    } else {
                        content.innerHTML = '<div style="color: red; padding: 20px; text-align: center;">배송 정보를 조회할 수 없습니다. 송장번호를 확인해주세요.</div>';
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    content.innerHTML = '<div style="color: red; padding: 20px; text-align: center;">배송 정보 조회 중 오류가 발생했습니다.</div>';
                });
        }

        function displayTrackingInfo(data) {
            const content = document.getElementById('trackingContent');
            let html = '<div class="tracking-details">';

            if (data.complete) {
                html += '<div style="background-color: #d4edda; padding: 10px; border-radius: 4px; margin-bottom: 15px;"><strong>배송 완료</strong></div>';
            }

            if (data.trackingDetails && data.trackingDetails.length > 0) {
                html += '<h3 style="margin-top: 20px;">배송 내역</h3>';
                data.trackingDetails.reverse().forEach(function(detail) { // 최신순으로 정렬
                    html += '<div class="tracking-detail-item">';
                    html += '<div class="tracking-detail-time">' + (detail.timeString || '') + '</div>';
                    html += '<div class="tracking-detail-location">' + (detail.where || '') + '</div>';
                    html += '<div class="tracking-detail-status">' + (detail.kind || '') + '</div>';
                    html += '</div>';
                });
            } else {
                html += '<p style="color: #666;">아직 배송 내역이 없습니다.</p>';
            }

            html += '</div>';
            content.innerHTML = html;
        }

        function closeTrackingModal() {
            document.getElementById('trackingModal').style.display = 'none';
        }


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

            // '🚚 조회' 버튼에 이벤트 리스너 추가 (jQuery 대신 일반 JS 사용)
            document.querySelectorAll('.delivery-track-btn').forEach(button => {
                button.addEventListener('click', function() {
                    const deliveryCompany = this.getAttribute('data-code');
                    const trackingNumber = this.getAttribute('data-invoice');
                    trackDelivery(deliveryCompany, trackingNumber);
                });
            });
        });
    </script>
    <c:if test="${updateSuccess}">
        <script> alert('정보 수정이 완료되었습니다.'); </script>
    </c:if>
</body>
</html>
