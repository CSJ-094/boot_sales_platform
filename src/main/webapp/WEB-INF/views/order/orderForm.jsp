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
                                <img src="${pageContext.request.contextPath}/resources/images/${item.prodImage}" alt="${item.prodName}">
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

        <div class="text-center">
            <form action="${pageContext.request.contextPath}/order/create" method="post">
                <button type="submit" class="btn btn-primary">결제하기</button>
            </form>
        </div>
    </div>
</body>
</html>
