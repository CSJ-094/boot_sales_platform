<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문서 작성</title>
<style>
    @import url('https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap');
    body {
        font-family: 'Noto Sans KR', sans-serif;
        background-color: #f8f9fa;
        color: #333;
        line-height: 1.6;
        margin: 0;
        padding: 20px;
    }
    .container {
        max-width: 900px;
        margin: 40px auto;
        padding: 30px;
        background-color: #fff;
        border-radius: 10px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.05);
    }
    h1 {
        font-size: 28px;
        font-weight: 700;
        border-bottom: 2px solid #333;
        padding-bottom: 15px;
        margin-bottom: 30px;
    }
    h2 {
        font-size: 22px;
        font-weight: 500;
        margin-bottom: 20px;
        border-left: 4px solid #007bff;
        padding-left: 10px;
    }
    .order-section {
        margin-bottom: 40px;
    }
    .product-table {
        width: 100%;
        border-collapse: collapse;
        margin-bottom: 20px;
    }
    .product-table th, .product-table td {
        border-bottom: 1px solid #dee2e6;
        padding: 15px 10px;
        text-align: left;
    }
    .product-table th {
        background-color: #f8f9fa;
        font-weight: 500;
    }
    .product-table td.product-info {
        display: flex;
        align-items: center;
    }
    .product-table img {
        width: 60px;
        height: 60px;
        border-radius: 5px;
        margin-right: 15px;
    }
    .summary {
        background-color: #f8f9fa;
        padding: 25px;
        border-radius: 8px;
        text-align: right;
    }
    .summary-row {
        display: flex;
        justify-content: space-between;
        font-size: 18px;
        margin-bottom: 10px;
    }
    .summary-row.total {
        font-size: 24px;
        font-weight: 700;
        color: #007bff;
        border-top: 1px solid #ddd;
        padding-top: 15px;
        margin-top: 15px;
    }
    .btn {
        display: inline-block;
        padding: 12px 30px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 18px;
        font-weight: 500;
        text-decoration: none;
        transition: background-color 0.3s;
    }
    .btn-primary {
        background-color: #007bff;
        color: white;
    }
    .btn-primary:hover {
        background-color: #0056b3;
    }
    .btn-secondary { /* 새로 추가된 버튼 스타일 */
        background-color: #6c757d;
        color: white;
        margin-right: 10px; /* 결제하기 버튼과의 간격 */
    }
    .btn-secondary:hover {
        background-color: #5a6268;
    }
    .text-center {
        text-align: center;
    }

    /* 쿠폰/포인트 섹션 */
    .discount-section {
        margin-bottom: 40px;
        padding: 20px;
        background-color: #f0f8ff;
        border-radius: 8px;
        border: 1px solid #e0e8f0;
    }
    .discount-section h2 {
        border-left-color: #17a2b8;
    }
    .form-group {
        margin-bottom: 15px;
    }
    .form-group label {
        display: block;
        margin-bottom: 8px;
        font-weight: 500;
    }
    .form-group select, .form-group input[type="number"] {
        width: 100%;
        padding: 10px;
        border: 1px solid #ced4da;
        border-radius: 5px;
        font-size: 16px;
    }
    .form-group input[type="number"] {
        max-width: 200px;
    }
    .current-point-display {
        font-size: 14px;
        color: #6c757d;
        margin-top: 5px;
    }
    .apply-btn {
        padding: 8px 15px;
        background-color: #28a745;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 15px;
        margin-left: 10px;
    }
    .apply-btn:hover {
        background-color: #218838;
    }
</style>
</head>
<body>
    <div class="container">
        <h1>주문서 작성</h1>

        <div class="order-section">
            <h2>주문 상품</h2>
            <table class="product-table">
                <thead>
                    <tr>
                        <th>상품 정보</th>
                        <th>수량</th>
                        <th>상품 금액</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${cartItems}">
                        <tr>
                            <td class="product-info">
                                <%-- prodImage가 있으면 해당 이미지 사용, 없으면 기본 이미지 사용 --%>
                                <c:choose>
                                    <c:when test="${not empty item.prodImage}">
                                        <img src="<c:url value='${item.prodImage}'/>" alt="${item.prodName}">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="<c:url value="/img/default_product.png"/>" alt="${item.prodName}">
                                    </c:otherwise>
                                </c:choose>
                                <div>${item.prodName}</div>
                            </td>
                            <td>${item.cartQty}개</td>
                            <td><fmt:formatNumber value="${item.prodPrice * item.cartQty}" pattern="#,###" />원</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <%-- 쿠폰 및 포인트 적용 섹션 --%>
        <div class="order-section discount-section">
            <h2>할인 적용</h2>
            <div class="form-group">
                <label for="couponSelect">쿠폰 선택</label>
                <select id="couponSelect" name="couponSelect" onchange="calculateFinalAmount()">
                    <option value="">쿠폰 선택 안 함</option>
                    <c:forEach var="userCoupon" items="${availableCoupons}">
                        <c:if test="${userCoupon.isUsed == 'N' and (userCoupon.expirationDate == null or userCoupon.expirationDate ge now)}">
                            <option value="${userCoupon.userCouponId}"
                                    data-coupon-type="${userCoupon.couponType}"
                                    data-discount-value="${userCoupon.discountValue}"
                                    data-min-order-amount="${userCoupon.minOrderAmount}"
                                    data-max-discount-amount="${userCoupon.maxDiscountAmount}">
                                ${userCoupon.couponName} 
                                (<c:if test="${userCoupon.couponType == 'PERCENT'}">${userCoupon.discountValue}% 할인</c:if>
                                <c:if test="${userCoupon.couponType == 'AMOUNT'}"><fmt:formatNumber value="${userCoupon.discountValue}" pattern="#,###"/>원 할인</c:if>)
                            </option>
                        </c:if>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group">
                <label for="pointToUse">포인트 사용</label>
                <input type="number" id="pointToUse" name="pointToUse" value="0" min="0" max="${currentPoint}" onchange="calculateFinalAmount()">
                <div class="current-point-display">현재 보유 포인트: <fmt:formatNumber value="${currentPoint}" pattern="#,###"/> P</div>
            </div>
        </div>

        <div class="order-section">
            <h2>최종 결제 금액</h2>
            <div class="summary">
                <div class="summary-row">
                    <span>총 상품 금액</span>
                    <span id="displayTotalAmount"><fmt:formatNumber value="${totalAmount}" pattern="#,###" />원</span>
                </div>
                <div class="summary-row">
                    <span>배송비</span>
                    <span id="displayShippingFee"><fmt:formatNumber value="${shippingFee}" pattern="#,###" />원</span>
                </div>
                <div class="summary-row">
                    <span>쿠폰 할인</span>
                    <span id="displayCouponDiscount">- <fmt:formatNumber value="0" pattern="#,###" />원</span>
                </div>
                <div class="summary-row">
                    <span>포인트 사용</span>
                    <span id="displayPointDiscount">- <fmt:formatNumber value="0" pattern="#,###" />원</span>
                </div>
                <div class="summary-row total">
                    <span>총 결제 금액</span>
                    <span id="displayFinalAmount"><fmt:formatNumber value="${totalAmount + shippingFee}" pattern="#,###" />원</span>
                </div>
            </div>
        </div>

        <div class="text-center">
            <button type="button" class="btn btn-secondary" onclick="history.back()">이전으로 돌아가기</button> <%-- 이전으로 돌아가기 버튼 추가 --%>
            <form action="${pageContext.request.contextPath}/order/create" method="post" id="orderForm" style="display:inline;">
                <input type="hidden" name="selectedUserCouponId" id="selectedUserCouponId" value="">
                <input type="hidden" name="usedPointAmount" id="usedPointAmount" value="0">
                <input type="hidden" name="finalPaymentAmount" id="finalPaymentAmount" value="${totalAmount + shippingFee}">
                <button type="submit" class="btn btn-primary">결제하기</button>
            </form>
        </div>
    </div>

    <script>
        // JSP에서 전달받은 초기 값
        const initialTotalAmount = ${totalAmount};
        const initialShippingFee = ${shippingFee};
        const currentPoint = ${currentPoint};

        document.addEventListener('DOMContentLoaded', function() {
            calculateFinalAmount(); // 페이지 로드 시 초기 금액 계산
        });

        function calculateFinalAmount() {
            let currentTotalAmount = initialTotalAmount;
            let currentShippingFee = initialShippingFee;
            let couponDiscount = 0;
            let pointDiscount = 0;

            // 1. 쿠폰 할인 계산
            const couponSelect = document.getElementById('couponSelect');
            const selectedOption = couponSelect.options[couponSelect.selectedIndex];
            const userCouponId = selectedOption.value;

            if (userCouponId) {
                const couponType = selectedOption.dataset.couponType;
                const discountValue = parseInt(selectedOption.dataset.discountValue);
                const minOrderAmount = parseInt(selectedOption.dataset.minOrderAmount);
                const maxDiscountAmount = selectedOption.dataset.maxDiscountAmount ? parseInt(selectedOption.dataset.maxDiscountAmount) : null;

                // 최소 주문 금액 조건 확인
                if (currentTotalAmount >= minOrderAmount) {
                    if (couponType === 'PERCENT') {
                        couponDiscount = Math.floor(currentTotalAmount * (discountValue / 100));
                        if (maxDiscountAmount && couponDiscount > maxDiscountAmount) {
                            couponDiscount = maxDiscountAmount;
                        }
                    } else if (couponType === 'AMOUNT') {
                        couponDiscount = discountValue;
                    }
                } else {
                    alert(`선택하신 쿠폰은 최소 ${minOrderAmount}원 이상 주문 시 사용 가능합니다.`);
                    couponSelect.value = ""; // 쿠폰 선택 초기화
                    couponDiscount = 0;
                }
            }
            
            // 2. 포인트 사용 계산
            const pointToUseInput = document.getElementById('pointToUse');
            let requestedPointToUse = parseInt(pointToUseInput.value);

            // 입력된 포인트가 유효한지 검증
            if (isNaN(requestedPointToUse) || requestedPointToUse < 0) {
                requestedPointToUse = 0;
            }
            if (requestedPointToUse > currentPoint) {
                requestedPointToUse = currentPoint;
                pointToUseInput.value = currentPoint; // 최대 보유 포인트로 자동 조정
            }
            // 포인트는 100원 단위로 사용 가능 (예시)
            // if (requestedPointToUse % 100 !== 0) {
            //     requestedPointToUse = Math.floor(requestedPointToUse / 100) * 100;
            //     pointToUseInput.value = requestedPointToUse;
            // }
            pointDiscount = requestedPointToUse;

            // 3. 최종 금액 계산
            let finalAmount = currentTotalAmount + currentShippingFee - couponDiscount - pointDiscount;
            if (finalAmount < 0) { // 최종 결제 금액이 음수가 되지 않도록
                finalAmount = 0;
            }

            // 4. UI 업데이트
            document.getElementById('displayTotalAmount').innerText = formatNumber(currentTotalAmount) + '원';
            document.getElementById('displayShippingFee').innerText = formatNumber(currentShippingFee) + '원';
            document.getElementById('displayCouponDiscount').innerText = '- ' + formatNumber(couponDiscount) + '원';
            document.getElementById('displayPointDiscount').innerText = '- ' + formatNumber(pointDiscount) + '원';
            document.getElementById('displayFinalAmount').innerText = formatNumber(finalAmount) + '원';

            // 5. Hidden 필드 업데이트 (폼 제출 시 사용)
            document.getElementById('selectedUserCouponId').value = userCouponId;
            document.getElementById('usedPointAmount').value = pointDiscount;
            document.getElementById('finalPaymentAmount').value = finalAmount;
        }

        function formatNumber(num) {
            return new Intl.NumberFormat('ko-KR').format(num);
        }
    </script>
</body>
</html>
