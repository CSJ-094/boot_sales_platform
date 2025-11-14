<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문 완료</title>
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
        max-width: 800px;
        margin: 60px auto;
        padding: 40px;
        background-color: #fff;
        border-radius: 10px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.05);
        text-align: center;
    }
    .icon-success {
        font-size: 60px;
        color: #28a745;
        margin-bottom: 20px;
    }
    h1 {
        font-size: 32px;
        font-weight: 700;
        margin-bottom: 15px;
    }
    p {
        font-size: 18px;
        color: #666;
        margin-bottom: 30px;
    }
    .order-summary {
        text-align: left;
        border-top: 1px solid #eee;
        border-bottom: 1px solid #eee;
        padding: 20px 0;
        margin-bottom: 40px;
    }
    .summary-item {
        display: flex;
        justify-content: space-between;
        padding: 8px 0;
        font-size: 16px;
    }
    .summary-item span:first-child { font-weight: 500; }
    .button-group {
        display: flex;
        justify-content: center;
        gap: 15px;
    }
    .btn {
        display: inline-block;
        padding: 12px 30px;
        border: 1px solid transparent;
        border-radius: 5px;
        cursor: pointer;
        font-size: 16px;
        font-weight: 500;
        text-decoration: none;
        transition: all 0.3s;
    }
    .btn-primary {
        background-color: #007bff;
        border-color: #007bff;
        color: white;
    }
    .btn-primary:hover {
        background-color: #0056b3;
        border-color: #0056b3;
    }
    .btn-secondary {
        background-color: #6c757d;
        border-color: #6c757d;
        color: white;
    }
    .btn-secondary:hover {
        background-color: #5a6268;
        border-color: #545b62;
    }
</style>
<!-- Font Awesome for icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="container">
        <div class="icon-success">
            <i class="fas fa-check-circle"></i>
        </div>
        <h1>주문이 성공적으로 완료되었습니다.</h1>
        <p>저희 플랫폼을 이용해주셔서 감사합니다.</p>

        <div class="order-summary">
            <div class="summary-item">
                <span>주문 번호</span>
                <span>${order.ordId}</span>
            </div>
            <div class="summary-item">
                <span>주문 일자</span>
                <span><fmt:formatDate value="${order.ordDate}" pattern="yyyy-MM-dd HH:mm:ss" /></span>
            </div>
            <div class="summary-item">
                <span>총 결제 금액</span>
                <span><fmt:formatNumber value="${order.ordAmount + order.ordDfee - order.ordDiscount}" pattern="#,###" />원</span>
            </div>
        </div>

        <div class="button-group">
            <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">쇼핑 계속하기</a>
            <a href="${pageContext.request.contextPath}/mypage#order-history" class="btn btn-primary">주문 내역 확인</a>
        </div>
    </div>
</body>
</html>
