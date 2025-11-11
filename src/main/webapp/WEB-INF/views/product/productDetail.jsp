<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>상품 상세</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 40px;
            background-color: #f4f7f6;
            color: #333;
            line-height: 1.6;
        }
        .container {
            background-color: #ffffff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            max-width: 800px;
            margin: 20px auto;
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        h1 {
            color: #2c3e50;
            margin-bottom: 25px;
            font-size: 2.5em;
            border-bottom: 2px solid #e0e0e0;
            padding-bottom: 15px;
            text-align: center;
        }
        .product-info {
            display: flex;
            gap: 30px;
            align-items: flex-start;
        }
        .product-image {
            flex: 1;
            max-width: 300px;
            border: 1px solid #eee;
            border-radius: 8px;
            overflow: hidden;
        }
        .product-image img {
            width: 100%;
            height: auto;
            display: block;
        }
        .product-details {
            flex: 2;
            text-align: left;
        }
        .product-details h2 {
            font-size: 2em;
            color: #34495e;
            margin-top: 0;
            margin-bottom: 10px;
        }
        .product-details p {
            margin-bottom: 8px;
            font-size: 1.1em;
        }
        .product-details .price {
            font-size: 1.8em;
            color: #e74c3c;
            font-weight: bold;
            margin-bottom: 15px;
        }
        .product-details .description {
            margin-top: 20px;
            padding-top: 15px;
            border-top: 1px dashed #eee;
            font-size: 1em;
            color: #555;
        }
        .add-to-cart-form {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        .add-to-cart-form label {
            font-weight: bold;
            font-size: 1.1em;
        }
        .add-to-cart-form input[type="number"] {
            width: 60px;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 1em;
            text-align: center;
        }
        .add-to-cart-form button {
            background-color: #6c757d; /* 회색 */
            color: white;
            border: none;
            padding: 10px 20px;
            cursor: pointer;
            border-radius: 5px;
            font-size: 1.1em;
            transition: background-color 0.3s ease;
        }
        .add-to-cart-form button:hover {
            background-color: #5a6268;
        }
        .back-link {
            display: inline-block;
            margin-top: 30px;
            padding: 10px 20px;
            background-color: #6c757d;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s ease;
        }
        .back-link:hover {
            background-color: #5a6268;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>상품 상세 정보</h1>

        <c:if test="${empty product}">
            <p class="no-items">상품 정보를 찾을 수 없습니다.</p>
        </c:if>
        <c:if test="${not empty product}">
            <div class="product-info">
                <div class="product-image">
                    <img src="https://via.placeholder.com/300x300?text=Product+Image" alt="${product.prodName}">
                </div>
                <div class="product-details">
                    <h2>${product.prodName}</h2>
                    <p><strong>판매자:</strong> ${product.prodSeller}</p>
                    <p class="price"><fmt:formatNumber value="${product.prodPrice}" type="currency" currencySymbol="₩"/></p>
                    <p><strong>재고:</strong> ${product.prodStock}개</p>
                    <p class="description">${product.prodDesc}</p>

                    <form action="/cart/add" method="post" class="add-to-cart-form">
                        <input type="hidden" name="memberId" value="${memberId}">
                        <input type="hidden" name="prodId" value="${product.prodId}">
                        <label for="cartQty">수량:</label>
                        <input type="number" id="cartQty" name="cartQty" value="1" min="1" max="${product.prodStock}">
                        <button type="submit">장바구니에 추가</button>
                    </form>
                </div>
            </div>
        </c:if>

        <p><a href="#" onclick="history.back();" class="back-link">이전 페이지로</a></p>
    </div>
</body>
</html>
