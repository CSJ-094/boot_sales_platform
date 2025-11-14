<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>나의 장바구니</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600;700;800&family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<c:url value='/css/header.css' />">
    <style>
        /* ==================== 0. 기본 스타일 & 초기화 (mainpage.jsp 기준) ==================== */
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Noto Sans KR', 'Montserrat', sans-serif;
            background-color: #f9f9f9; /* mainpage.jsp 배경색 */
            color: #333;
            line-height: 1.6;
            min-height: 100vh;

        }

        a {
            text-decoration: none;
            color: inherit;
            transition: color 0.3s ease;
        }
        a:hover {
            color: #b08d57; /* mainpage.jsp 강조색 */
        }

        ul {
            list-style: none;
        }

        /* ==================== 1. 헤더 스타일 (mypage.jsp에서 복사) ==================== */

        /* ==================== End of Header Styles ==================== */


        /* ==================== 2. 장바구니 본문 스타일 ==================== */
        .container {
            background-color: #ffffff;
            padding: 40px;
            border-radius: 4px; /* 둥근 박스 제거(작게) */
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            max-width: 1100px; /* 너비 확장 */
            margin: 50px auto;
            border: 1px solid #e0e0e0;
        }
        
        h1 {
            color: #2c2c2c; /* 헤더 색상과 통일 */
            margin-bottom: 30px;
            font-size: 28px;
            border-bottom: 3px solid #b08d57; /* 강조색 밑줄 */
            padding-bottom: 10px;
            text-align: left;
            font-weight: 600;
        }

        .message {
            padding: 15px;
            margin-bottom: 25px;
            border-radius: 4px;
            font-size: 1.1em;
            text-align: center;
            border: 1px solid #c3e6cb;
            background-color: #e6f7e9;
            color: #1a7c36;
        }
        
        .no-items {
            text-align: center;
            padding: 30px;
            margin-top: 20px;
            font-size: 1.2em;
            color: #777;
            border: 1px dashed #ccc;
            border-radius: 4px;
            background-color: #fcfcfc;
        }

        /* 장바구니 테이블 스타일 */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 25px;
            font-size: 15px;
        }
        
        th, td {
            padding: 15px;
            text-align: center;
            border-bottom: 1px solid #eee;
        }
        
        th {
            background-color: #4a4a4a; /* 어두운 색상으로 변경 */
            color: white;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.95em;
        }
        
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        
        tr:hover {
            background-color: #f1f1f1;
        }

        /* 수량 입력 필드 */
        .quantity-input {
            width: 60px;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
            text-align: center;
            margin-right: 5px;
            font-size: 14px;
        }
        
        /* 버튼 공통 스타일 */
        .cart-action-btn {
            padding: 8px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: background-color 0.3s;
        }

        /* 수량 수정 버튼 */
        .update-btn {
            background-color: #6c757d;
            color: white;
        }
        .update-btn:hover {
            background-color: #5a6268;
        }

        /* 삭제 버튼 */
        .remove-btn {
            background-color: #dc3545;
            color: white;
        }
        .remove-btn:hover {
            background-color: #c82333;
        }

        /* 총 가격 표시 */
        .total-price {
            text-align: right;
            margin-top: 30px;
            padding: 15px 20px;
            font-size: 1.5em;
            font-weight: 700;
            color: #2c2c2c;
            border-top: 2px solid #b08d57;
        }

        /* 하단 액션 버튼 그룹 */
        .action-buttons {
            text-align: center;
            margin-top: 40px;
            display: flex;
            justify-content: center;
            gap: 20px;
        }

        /* 쇼핑 계속하기 버튼 */
        .action-buttons .continue-shopping-btn { /* 새로운 클래스 추가 */
            padding: 12px 30px;
            font-size: 16px;
            font-weight: 600;
            border-radius: 4px;
            border: 1px solid #ccc;
            background-color: #f5f5f5; /* 기본 배경색 */
            color: #444; /* 기본 텍스트 색상 */
            transition: background-color 0.3s;
        }
        .action-buttons .continue-shopping-btn:hover {
            background-color: #e0e0e0;
        }
        
        /* 주문하기 버튼 (강조) */
        .action-buttons .order-btn { /* 클래스 선택자 변경 */
            padding: 12px 30px; /* 쇼핑 계속하기 버튼과 동일한 패딩 */
            font-size: 16px; /* 쇼핑 계속하기 버튼과 동일한 폰트 크기 */
            font-weight: 600; /* 쇼핑 계속하기 버튼과 동일한 폰트 굵기 */
            border-radius: 4px;
            background-color: #b08d57; /* 강조색 유지 */
            color: white; /* 텍스트 색상 흰색 유지 */
            border: 1px solid #b08d57;
            transition: background-color 0.3s;
        }
        
        .action-buttons .order-btn:hover {
            background-color: #a07d47;
            border-color: #a07d47;
        }

    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/fragments/header.jsp" />
    <div class="container">
        <h1>나의 장바구니</h1>

        <c:if test="${empty cartList}">
            <p class="no-items">장바구니에 담긴 상품이 없습니다.</p>
        </c:if>

        <c:if test="${not empty cartList}">
            <table>
                <thead>
                    <tr>
                        <th style="width: 50px;"><input type="checkbox" id="checkAll"></th> <%-- 전체 선택 체크박스 --%>
                        <th>상품명</th>
                        <th>판매가</th>
                        <th style="width: 150px;">수량</th>
                        <th style="width: 150px;">총 금액</th>
                        <th style="width: 80px;"></th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="cartItem" items="${cartList}">
                        <c:set var="itemTotalPrice" value="${cartItem.prodPrice * cartItem.cartQty}" />
                        <tr data-price="${cartItem.prodPrice}" data-qty="${cartItem.cartQty}"> <%-- 상품 가격과 수량 데이터 속성 추가 --%>
                            <td><input type="checkbox" name="selectedCartIds" value="${cartItem.cartId}"></td> <%-- 개별 상품 선택 체크박스 --%>
                            <td style="text-align: left;">
                                <a href="${pageContext.request.contextPath}/product/detail?id=${cartItem.prodId}">${cartItem.prodName}</a>
                            </td>
                            <td><fmt:formatNumber value="${cartItem.prodPrice}" type="currency" currencySymbol="₩" maxFractionDigits="0"/></td>
                            <td>
                                <form action="${pageContext.request.contextPath}/cart/update" method="post" style="display:flex; align-items:center; justify-content:center;">
                                    <input type="hidden" name="memberId" value="${memberId}">
                                    <input type="hidden" name="cartId" value="${cartItem.cartId}">
                                    <input type="number" name="cartQty" value="${cartItem.cartQty}" min="1" class="quantity-input">
                                    <button type="submit" class="cart-action-btn update-btn">수정</button>
                                </form>
                            </td>
                            <td><fmt:formatNumber value="${itemTotalPrice}" type="currency" currencySymbol="₩" maxFractionDigits="0"/></td>
                            <td>
                                <form action="${pageContext.request.contextPath}/cart/remove" method="post" style="display:inline;">
                                    <input type="hidden" name="memberId" value="${memberId}">
                                    <input type="hidden" name="cartId" value="${cartItem.cartId}">
                                    <button type="submit" class="cart-action-btn remove-btn">삭제</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <div class="total-price">
                총 장바구니 금액: <span id="selectedTotalPrice"><fmt:formatNumber value="${totalCartPrice}" type="currency" currencySymbol="₩" maxFractionDigits="0"/></span>
            </div>
        </c:if>

        <div class="action-buttons">
            <a href="${pageContext.request.contextPath}/" class="continue-shopping-btn">쇼핑 계속하기</a> <%-- 클래스 추가 --%>
            <c:if test="${not empty cartList}">
                <form id="unifiedOrderForm" action="${pageContext.request.contextPath}/order/form" method="get" style="display:inline;">
                    <input type="hidden" name="cartIds" id="selectedCartIdsInput">
                    <button type="button" class="btn order-btn" onclick="unifiedOrder()">주문하기</button> <%-- 클래스 변경 --%>
                </form>
            </c:if>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const checkAll = document.getElementById('checkAll');
            const itemCheckboxes = document.querySelectorAll('input[name="selectedCartIds"]');
            const quantityInputs = document.querySelectorAll('.quantity-input'); // 수량 입력 필드

            // 초기 로드 시 총 금액 계산
            calculateSelectedTotal();

            // 전체 선택/해제
            checkAll.addEventListener('change', function() {
                itemCheckboxes.forEach(checkbox => {
                    checkbox.checked = this.checked;
                });
                calculateSelectedTotal(); // 전체 선택/해제 시 총 금액 다시 계산
            });

            // 개별 선택 시 전체 선택 체크박스 상태 업데이트 및 총 금액 계산
            itemCheckboxes.forEach(checkbox => {
                checkbox.addEventListener('change', function() {
                    if (!this.checked) {
                        checkAll.checked = false;
                    } else {
                        const allChecked = Array.from(itemCheckboxes).every(item => item.checked);
                        checkAll.checked = allChecked;
                    }
                    calculateSelectedTotal(); // 개별 선택/해제 시 총 금액 다시 계산
                });
            });

            // 수량 변경 시 총 금액 다시 계산 (수정 버튼 클릭 시 반영되므로 여기서는 필요 없을 수 있음)
            // quantityInputs.forEach(input => {
            //     input.addEventListener('change', function() {
            //         calculateSelectedTotal();
            //     });
            // });
        });

        function calculateSelectedTotal() {
            let total = 0;
            document.querySelectorAll('input[name="selectedCartIds"]:checked').forEach(checkbox => {
                const row = checkbox.closest('tr'); // 체크박스가 속한 tr 요소
                const price = parseInt(row.dataset.price); // data-price 속성 값
                const qty = parseInt(row.dataset.qty);     // data-qty 속성 값
                total += price * qty;
            });
            document.getElementById('selectedTotalPrice').innerText = formatNumber(total) + '원';
        }

        function unifiedOrder() {
            const selectedCartIds = [];
            document.querySelectorAll('input[name="selectedCartIds"]:checked').forEach(checkbox => {
                selectedCartIds.push(checkbox.value);
            });

            const form = document.getElementById('unifiedOrderForm');
            const cartIdsInput = document.getElementById('selectedCartIdsInput');

            if (selectedCartIds.length === 0) {
                alert('주문할 상품을 하나 이상 선택해주세요.');
                return;
            }

            cartIdsInput.value = selectedCartIds.join(',');
            cartIdsInput.setAttribute('name', 'cartIds'); // name 속성 다시 설정
            form.submit();
        }

        function formatNumber(num) {
            return new Intl.NumberFormat('ko-KR').format(num);
        }
    </script>
</body>
</html>