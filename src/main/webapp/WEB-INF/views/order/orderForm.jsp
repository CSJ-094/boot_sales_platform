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
<script src="<c:url value='/js/jquery.js'/>"></script>
<link rel="stylesheet" href="<c:url value='/css/header.css' />">
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
    .text-center {
        text-align: center;
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
            <h2>최종 결제 금액</h2>
            <div class="summary">
                <div class="summary-row">
                    <span>총 상품 금액</span>
                    <span><fmt:formatNumber value="${totalAmount}" pattern="#,###" />원</span>
                </div>
                <div class="summary-row">
                    <span>배송비</span>
                    <span><fmt:formatNumber value="${shippingFee}" pattern="#,###" />원</span>
                </div>
                <div class="summary-row total">
                    <span>총 결제 금액</span>
                    <span><fmt:formatNumber value="${totalAmount + shippingFee}" pattern="#,###" />원</span>
                </div>
            </div>
        </div>

        <div class="order-section">
            <h2>결제 수단</h2>
            <%-- 결제 위젯이 렌더링될 영역 --%>
            <div id="payment-method"></div>
        </div>

        <div class="text-center">
            <%-- 기존 form 태그를 제거하고, API 호출 버튼으로 변경 --%>
            <button id="payment-button" class="btn btn-primary">결제하기</button>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            console.log("DOM 로드 완료. 토스페이먼츠 스크립트 초기화를 시작합니다.");

            const clientKey = "test_gck_docs_Ovk5rk1EwkEbP0W43n07xlzm";
            // ⭐️ [디버깅] 주입된 클라이언트 키를 콘솔에서 확인합니다.
            console.log("사용 중인 클라이언트 키:", clientKey);

            const paymentWidget = PaymentWidget(clientKey, PaymentWidget.ANONYMOUS);

            console.log("결제 위젯 객체:", paymentWidget);

            // ⭐️ 서버에서 생성된 고유한 주문번호를 사용합니다.
            const orderId = "${orderId}";

            // ⭐️ 서버에서 계산된 최종 금액을 사용합니다.
            const amount = ${totalAmount + shippingFee};

            // 상품명 (첫 번째 상품명 외 N건 형식)
            const orderName = "${cartItems[0].prodName}" + "${fn:length(cartItems) > 1 ? ' 외 ' + (fn:length(cartItems) - 1) + '건' : ''}";

            console.log("결제 위젯 렌더링을 시도합니다. (결제 금액: " + amount + ")");
            // 결제 위젯 렌더링
            paymentWidget.renderPaymentMethods(
                "#payment-method",
                { value: amount },
                { variantKey: "DEFAULT" }
            );

            // '결제하기' 버튼 클릭 이벤트
            document.getElementById("payment-button").addEventListener("click", function () {
                console.log("'결제하기' 버튼 클릭됨. 결제를 요청합니다.");
                // 1. 서버에 미리 주문 정보를 생성하고, 검증된 금액을 받아오는 로직 (권장)
                //    (현재는 클라이언트에서 금액을 바로 사용하지만, 보안에 취약할 수 있습니다.)

                // 2. 결제 요청
                paymentWidget.requestPayment({
                    orderId: orderId,
                    orderName: orderName,
                    successUrl: window.location.origin + "${pageContext.request.contextPath}/toss/success", // 성공 시 이동할 우리 서버의 URL
                    failUrl: window.location.origin + "${pageContext.request.contextPath}/toss/fail",     // 실패 시 이동할 우리 서버의 URL
                    customerName: "${sessionScope.memberName}",
                    // customerEmail: "${memberInfo.memberEmail}" // 회원 정보에 이메일이 있다면 추가
                }).catch(function (error) {
                    console.error("결제 요청 실패:", error);
                    // 결제창 호출 실패 처리
                    if (error.code === 'USER_CANCEL') {
                        // 사용자가 결제를 취소한 경우
                        console.log('결제가 취소되었습니다.');
                    } else {
                        // 기타 에러
                        alert('결제 중 오류가 발생했습니다: ' + error.message);
                    }
                });
            });
        });
    </script>
</body>
</html>
