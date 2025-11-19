<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문서 작성</title>
<%-- ⭐️ 토스페이먼츠 '결제위젯' SDK로 변경 --%>
<script src="https://js.tosspayments.com/v1/payment-widget"></script>

<link rel="stylesheet" href="<c:url value='/css/header.css' />">
<link rel="stylesheet" href="<c:url value='/css/sellerstyle.css' />">
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
    /* 기존 .container 스타일은 mypage-content-area가 대체하므로 주석 처리 또는 삭제 */
    .mypage-content-area {
        /*max-width: 900px;*/ /* mypage-body에서 너비를 관리하므로 제거 */
        /*margin: 40px auto;*/
        /*padding: 30px;*/
        /*background-color: #fff;*/
        /*border-radius: 10px;*/
        /*box-shadow: 0 4px 20px rgba(0,0,0,0.05);*/
    }
    h1 {
        font-size: 28px;
        font-weight: 700;
        /* border-bottom: 2px solid #333; */ /* 밑줄 제거 */
        /* padding-bottom: 15px; */
        /* margin-bottom: 30px; */
    }
    h2 {
        font-size: 22px;
        font-weight: 500;
        margin-bottom: 20px;
        border-left: 4px solid #333;
        padding-left: 10px;
    }
    .order-section {
        margin-bottom: 40px;
        background-color: #fff;
        padding: 25px;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.03);
    }
    .order-section h3 {
        font-size: 18px;
        font-weight: 600;
        margin-bottom: 15px;
        border-bottom: 1px solid #eee;
        padding-bottom: 10px;
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
        color: #333;
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
    .text-center {
        text-align: center;
    }

    /* 쿠폰/포인트 섹션 스타일 */
    .discount-section {
        display: flex;
        flex-direction: column;
        gap: 15px;
    }
    .discount-group {
        display: flex;
        align-items: center;
        gap: 15px;
        padding: 10px 0;
        border-bottom: 1px dashed #eee;
    }
    .discount-group:last-of-type {
        border-bottom: none;
    }
    .discount-group label {
        font-weight: 500;
        color: #555;
        flex-basis: 100px;
        flex-shrink: 0;
    }
    .discount-group select,
    .discount-group input[type="number"] {
        flex-grow: 1;
        padding: 8px 10px;
        border: 1px solid #ccc;
        border-radius: 4px;
        font-size: 14px;
        max-width: 250px;
    }
    .discount-group button {
        padding: 8px 15px;
        background-color: #2c2c2c;
        color: white;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        font-size: 14px;
        font-weight: 500;
        transition: background-color 0.3s ease;
    }
    .discount-group button:hover {
        background-color: #b08d57;
        color: #2c2c2c;
    }
    .discount-group .info-text {
        font-size: 13px;
        color: #888;
        margin-left: 10px;
    }
    .discount-group .error-text {
        font-size: 13px;
        color: #d64545;
        margin-left: 10px;
    }
</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/fragments/header.jsp" />
	<main class="mypage-body">
	    <%-- 사이드바가 필요하다면 추가, 필요 없다면 mypage-body 클래스 제거 --%>
	    <%-- 
	    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp">
	        <jsp:param name="menu" value="someMenu"/>
	    </jsp:include>
	    --%>

    <section class="mypage-content-area">
        <h2>주문서 작성</h2>

        <div class="order-section">
            <h3>주문 상품</h3>
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
                                <img src="<c:url value='${item.prodImage}'/>" alt="${item.prodName}">
                                <div>${item.prodName}</div>
                            </td>
                            <td>${item.cartQty}개</td>
                            <td><fmt:formatNumber value="${item.prodPrice * item.cartQty}" pattern="#,###" />원</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <div class="order-section">
            <h3>할인 정보</h3>
            <div class="discount-section">
                <div class="discount-group">
                    <label for="couponSelect">쿠폰 사용</label>
                    <select id="couponSelect" name="selectedCouponId">
                        <option value="">쿠폰 선택 안 함</option>
                        <c:forEach var="uc" items="${userCoupons}">
                            <c:if test="${uc.isUsed == 'N' && (uc.expirationDate == null || uc.expirationDate.after(now))}">
                                <option value="${uc.userCouponId}"
                                        data-coupon-type="${uc.couponType}"
                                        data-discount-value="${uc.discountValue}"
                                        data-min-order-amount="${uc.minOrderAmount}"
                                        data-max-discount-amount="${uc.maxDiscountAmount}">
                                    ${uc.couponName}
                                    <c:if test="${uc.couponType == 'PERCENT'}">(${uc.discountValue}% 할인<c:if test="${uc.maxDiscountAmount != null}">, 최대 <fmt:formatNumber value="${uc.maxDiscountAmount}" pattern="#,###"/>원</c:if>)</c:if>
                                    <c:if test="${uc.couponType == 'AMOUNT'}">(<fmt:formatNumber value="${uc.discountValue}" pattern="#,###"/>원 할인)</c:if>
                                    <c:if test="${uc.couponType == 'SHIPPING'}">(무료 배송)</c:if>
                                    (최소 <fmt:formatNumber value="${uc.minOrderAmount}" pattern="#,###"/>원)
                                </option>
                            </c:if>
                        </c:forEach>
                    </select>
                    <span id="couponDiscountInfo" class="info-text"></span>
                    <span id="couponError" class="error-text"></span>
                </div>
                <div class="discount-group">
                    <label for="pointInput">포인트 사용</label>
                    <input type="number" id="pointInput" name="usedPoint" min="0" value="0" placeholder="사용할 포인트">
                    <button type="button" id="applyPointBtn">적용</button>
                    <span class="info-text">보유 포인트: <fmt:formatNumber value="${currentPoint}" pattern="#,###"/> P</span>
                    <span id="pointError" class="error-text"></span>
                </div>
            </div>
        </div>

        <div class="order-section">
            <h3>최종 결제 금액</h3>
            <div class="summary">
                <div class="summary-row">
                    <span>총 상품 금액</span>
                    <span id="displayTotalProductAmount"><fmt:formatNumber value="${totalAmount}" pattern="#,###" />원</span>
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
                    <span id="displayPointUsage">- <fmt:formatNumber value="0" pattern="#,###" />원</span>
                </div>
                <div class="summary-row total">
                    <span>총 결제 금액</span>
                    <span id="displayFinalAmount"><fmt:formatNumber value="${totalAmount + shippingFee}" pattern="#,###" />원</span>
                </div>
            </div>
        </div>

        <div class="order-section">
            <h3>결제 수단</h3>
            <%-- 결제 위젯이 렌더링될 영역 --%>
            <div id="payment-method"></div>
        </div>

        <div class="text-center">
            <%-- 기존 form 태그를 제거하고, API 호출 버튼으로 변경 --%>
            <button id="payment-button" class="btn btn-primary">결제하기</button>
        </div>
    </section>
  </main>

    <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

    <script src="<c:url value='/js/jquery.js'/>"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const clientKey = "test_gck_docs_Ovk5rk1EwkEbP0W43n07xlzm";
            const paymentWidget = PaymentWidget(clientKey, PaymentWidget.ANONYMOUS);
            const orderId = "ORD-" + new Date().getTime() + "-" + "${sessionScope.memberId}".substring(0, 4);
            const orderName = "${cartItems[0].prodName}${fn:length(cartItems) > 1 ? ' 외 '.concat(fn:length(cartItems) - 1).concat('건') : ''}";
            const originalTotalProductAmount = ${totalAmount};
            const originalShippingFee = ${shippingFee};
            const currentPoint = ${currentPoint};

            let finalPaymentAmount = originalTotalProductAmount + originalShippingFee;
            let appliedCouponDiscount = 0;
            let appliedPointUsage = 0;
            let selectedUserCouponId = null; // 선택된 userCouponId 저장

            let paymentMethodsWidget; // 결제 수단 위젯 인스턴스를 저장할 변수 선언

            // 금액 업데이트 함수
            function updatePaymentAmounts() {
                let tempTotalProductAmount = originalTotalProductAmount; // 총 상품 금액은 할인 전 금액으로 시작
                let tempShippingFee = originalShippingFee;
                let tempCouponDiscount = 0;
                let tempPointUsage = 0;

                // 1. 쿠폰 할인 적용
                const selectedOption = $('#couponSelect option:selected');
                if (selectedOption.val() !== "") {
                    const couponType = selectedOption.data('coupon-type');
                    const discountValue = selectedOption.data('discount-value');
                    const minOrderAmount = selectedOption.data('min-order-amount');
                    const maxDiscountAmount = selectedOption.data('max-discount-amount');

                    if (tempTotalProductAmount >= minOrderAmount) { // 총 상품 금액 기준으로 최소 주문 금액 확인
                        if (couponType === 'PERCENT') {
                            tempCouponDiscount = tempTotalProductAmount * (discountValue / 100);
                            if (maxDiscountAmount && tempCouponDiscount > maxDiscountAmount) {
                                tempCouponDiscount = maxDiscountAmount;
                            }
                        } else if (couponType === 'AMOUNT') {
                            tempCouponDiscount = discountValue;
                        } else if (couponType === 'SHIPPING') { // ⭐️ 무료 배송 쿠폰 처리
                            tempShippingFee = 0;
                        }
                        $('#couponError').text('');
                        selectedUserCouponId = selectedOption.val(); // userCouponId 저장
                    } else {
                        $('#couponError').text('최소 주문 금액 ' + minOrderAmount.toLocaleString() + '원 이상 시 사용 가능합니다.');
                        selectedUserCouponId = null;
                        // 쿠폰이 적용되지 않았으므로 할인 금액 초기화
                        tempCouponDiscount = 0;
                    }
                } else {
                    $('#couponError').text('');
                    selectedUserCouponId = null;
                }
                appliedCouponDiscount = Math.floor(tempCouponDiscount); // 소수점 제거

                // 2. 포인트 사용 적용 (쿠폰 할인 후 금액에 대해)
                const usedPoint = parseInt($('#pointInput').val()) || 0;
                // 포인트 사용 가능 금액은 (총 상품 금액 + 배송비 - 쿠폰 할인)
                const amountAvailableForPoint = tempTotalProductAmount + tempShippingFee - appliedCouponDiscount;

                if (usedPoint > 0) {
                    if (usedPoint > currentPoint) {
                        $('#pointError').text('보유 포인트를 초과하여 사용할 수 없습니다.');
                        tempPointUsage = 0;
                    } else if (usedPoint > amountAvailableForPoint) {
                        $('#pointError').text('결제 금액보다 많은 포인트를 사용할 수 없습니다.');
                        tempPointUsage = amountAvailableForPoint; // 결제 금액까지만 사용
                        $('#pointInput').val(tempPointUsage); // 입력 필드 값도 조정
                    } else {
                        $('#pointError').text('');
                        tempPointUsage = usedPoint;
                    }
                } else {
                    $('#pointError').text('');
                }
                appliedPointUsage = tempPointUsage;

                // 3. 최종 금액 계산
                finalPaymentAmount = tempTotalProductAmount + tempShippingFee - appliedCouponDiscount - appliedPointUsage;
                if (finalPaymentAmount < 0) finalPaymentAmount = 0; // 최종 금액이 음수가 되는 것을 방지

                // 4. 화면 업데이트
                $('#displayTotalProductAmount').text(originalTotalProductAmount.toLocaleString() + '원');
                $('#displayShippingFee').text(tempShippingFee.toLocaleString() + '원'); // ⭐️ 수정된 배송비로 업데이트
                $('#displayCouponDiscount').text('- ' + appliedCouponDiscount.toLocaleString() + '원');
                $('#displayPointUsage').text('- ' + appliedPointUsage.toLocaleString() + '원');
                $('#displayFinalAmount').text(finalPaymentAmount.toLocaleString() + '원');

                // 5. 토스 결제 위젯 금액 업데이트
                if (paymentMethodsWidget) { // 위젯 인스턴스가 준비되었는지 확인
                    paymentMethodsWidget.updateAmount(finalPaymentAmount);
                }
            }

            // 결제 위젯 렌더링 (Promise 체인 제거)
            paymentMethodsWidget = paymentWidget.renderPaymentMethods(
                "#payment-method",
                { value: finalPaymentAmount },
                { variantKey: "DEFAULT" }
            );
            
            // 위젯 렌더링 후 초기 금액 설정 및 이벤트 리스너 연결
            updatePaymentAmounts(); // 초기 금액 계산 및 위젯에 반영

            // '결제하기' 버튼 클릭 이벤트 리스너 (이전과 동일하게 paymentWidget 사용)
            document.getElementById("payment-button").addEventListener("click", function () {
                console.log("'결제하기' 버튼 클릭됨. 결제를 요청합니다.");
                
                paymentWidget.requestPayment({
                    orderId: orderId,
                    orderName: orderName,
                    successUrl: window.location.origin + "${pageContext.request.contextPath}/toss/success",
                    failUrl: window.location.origin + "${pageContext.request.contextPath}/toss/fail",
                    customerName: "${sessionScope.memberName}"
                    // ⭐️ metadata의 값이 null인 경우 오류가 발생하므로, 빈 문자열로 대체합니다.
                    , metadata: {
                        selectedUserCouponId: selectedUserCouponId || '',
                        usedPoint: appliedPointUsage
                    } 
                }).catch(function (error) {
                    console.error("결제 요청 실패:", error);
                    if (error.code === 'USER_CANCEL') {
                        console.log('결제가 취소되었습니다.');
                    } else {
                        alert('결제 중 오류가 발생했습니다: ' + error.message);
                    }
                });
            });

            // 이벤트 리스너 연결 (이들은 updatePaymentAmounts를 호출하므로, 위젯 준비 여부를 updatePaymentAmounts 내에서 확인)
            $('#couponSelect').on('change', updatePaymentAmounts);
            $('#applyPointBtn').on('click', updatePaymentAmounts);
            $('#pointInput').on('change', function() {
                let val = parseInt($(this).val());
                if (isNaN(val) || val < 0) {
                    $(this).val(0);
                }
                updatePaymentAmounts();
            });
        });
    </script>
</body>
</html>
