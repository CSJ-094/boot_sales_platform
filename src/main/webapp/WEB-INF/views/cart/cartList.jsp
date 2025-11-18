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
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Noto Sans KR', 'Montserrat', sans-serif; background-color: #f9f9f9; color: #333; line-height: 1.6; min-height: 100vh; }
        a { text-decoration: none; color: inherit; transition: color 0.3s ease; }
        a:hover { color: #b08d57; }
        ul { list-style: none; }
        .container { background-color: #ffffff; padding: 40px; border-radius: 4px; box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08); max-width: 1100px; margin: 50px auto; border: 1px solid #e0e0e0; }
        h1 { color: #2c2c2c; margin-bottom: 30px; font-size: 28px; border-bottom: 3px solid #b08d57; padding-bottom: 10px; text-align: left; font-weight: 600; }
        .no-items { text-align: center; padding: 30px; margin-top: 20px; font-size: 1.2em; color: #777; border: 1px dashed #ccc; border-radius: 4px; background-color: #fcfcfc; }
        table { width: 100%; border-collapse: collapse; margin-top: 25px; font-size: 15px; }
        th, td { padding: 15px; text-align: center; border-bottom: 1px solid #eee; vertical-align: middle; }
        th { background-color: #4a4a4a; color: white; font-weight: 600; text-transform: uppercase; font-size: 0.95em; }
        tr:nth-child(even) { background-color: #f9f9f9; }
        .product-info { display: flex; align-items: center; text-align: left; }
        .product-info img { width: 80px; height: 80px; object-fit: cover; margin-right: 15px; border: 1px solid #eee; }
        .quantity-input { width: 60px; padding: 8px; border: 1px solid #ccc; border-radius: 4px; text-align: center; margin-right: 5px; font-size: 14px; }
        .cart-action-btn { padding: 8px 15px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; font-weight: 500; transition: background-color 0.3s; }
        .update-btn { background-color: #6c757d; color: white; }
        .update-btn:hover { background-color: #5a6268; }
        .remove-btn { background-color: #dc3545; color: white; }
        .remove-btn:hover { background-color: #c82333; }
        .total-price { text-align: right; margin-top: 30px; padding: 15px 20px; font-size: 1.5em; font-weight: 700; color: #2c2c2c; border-top: 2px solid #b08d57; }
        .action-buttons { text-align: center; margin-top: 40px; display: flex; justify-content: center; gap: 20px; }
        .action-buttons a, .action-buttons button { padding: 12px 30px; font-size: 16px; font-weight: 600; border-radius: 4px; border: 1px solid #ccc; transition: background-color 0.3s; }
        .order-btn { background-color: #b08d57 !important; color: #2c2c2c !important; border: 1px solid #b08d57 !important; }
        .order-btn:hover { background-color: #a07d47 !important; }
        .action-buttons a:not(.order-btn) { background-color: #f5f5f5; color: #444; }
        .action-buttons a:not(.order-btn):hover { background-color: #e0e0e0; }
        .item-checkbox, #checkAll { width: 20px; height: 20px; }
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
            <form id="orderForm" action="${pageContext.request.contextPath}/order/form" method="post">
                <table>
                    <thead>
                        <tr>
                            <th style="width: 40px;"><input type="checkbox" id="checkAll" checked></th>
                            <th>상품 정보</th>
                            <th>판매가</th>
                            <th style="width: 180px;">수량</th>
                            <th style="width: 150px;">총 금액</th>
                            <th style="width: 100px;">삭제</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="cartItem" items="${cartList}" varStatus="status">
                            <c:set var="itemTotalPrice" value="${cartItem.prodPrice * cartItem.cartQty}" />
                            <tr data-price="${itemTotalPrice}" data-cart-id="${cartItem.cartId}" data-unit-price="${cartItem.prodPrice}">
                                <td><input type="checkbox" class="item-checkbox" name="selectedCartIds" value="${cartItem.cartId}" checked></td>
                                <td>
                                    <div class="product-info">
                                        <a href="${pageContext.request.contextPath}/product/detail?id=${cartItem.prodId}">
                                            <img src="${pageContext.request.contextPath}${cartItem.prodImage}" alt="${cartItem.prodName}">
                                        </a>
                                        <a href="${pageContext.request.contextPath}/product/detail?id=${cartItem.prodId}">${cartItem.prodName}</a>
                                    </div>
                                </td>
                                <td><fmt:formatNumber value="${cartItem.prodPrice}" type="currency" currencySymbol="₩" maxFractionDigits="0"/></td>
                                <td>
                                    <div style="display:flex; align-items:center; justify-content:center;">
                                        <input type="number" name="cartQty" value="${cartItem.cartQty}" min="1" class="quantity-input" data-cart-id="${cartItem.cartId}">
                                        <button type="button" class="cart-action-btn update-btn" data-cart-id="${cartItem.cartId}">수정</button>
                                    </div>
                                </td>
                                <td class="item-total-price"><fmt:formatNumber value="${itemTotalPrice}" type="currency" currencySymbol="₩" maxFractionDigits="0"/></td>
                                <td>
                                    <button type="button" class="cart-action-btn remove-btn" data-cart-id="${cartItem.cartId}">삭제</button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                <div class="total-price">
                    총 주문 금액: <span id="totalOrderPrice"></span>
                </div>
            </form>
        </c:if>

        <div class="action-buttons">
            <a href="${pageContext.request.contextPath}/">쇼핑 계속하기</a>
            <c:if test="${not empty cartList}">
                <button type="submit" form="orderForm" class="order-btn">주문하기</button>
            </c:if>
        </div>
    </div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const checkAll = document.getElementById('checkAll');
    const itemCheckboxes = document.querySelectorAll('.item-checkbox');
    const totalOrderPriceSpan = document.getElementById('totalOrderPrice');

    function updateTotalPrice() {
        let total = 0;
        itemCheckboxes.forEach(checkbox => {
            if (checkbox.checked) {
                const row = checkbox.closest('tr');
                total += Number(row.dataset.price);
            }
        });
        totalOrderPriceSpan.textContent = '₩' + total.toLocaleString();
    }

    if (checkAll) {
        checkAll.addEventListener('change', function() {
            itemCheckboxes.forEach(checkbox => {
                checkbox.checked = this.checked;
            });
            updateTotalPrice();
        });
    }

    itemCheckboxes.forEach(checkbox => {
        checkbox.addEventListener('change', function() {
            if (!this.checked) {
                checkAll.checked = false;
            } else {
                const allChecked = Array.from(itemCheckboxes).every(cb => cb.checked);
                if (allChecked) {
                    checkAll.checked = true;
                }
            }
            updateTotalPrice();
        });
    });

    document.querySelector('table')?.addEventListener('click', function(e) {
        if (e.target.classList.contains('update-btn')) {
            const cartId = e.target.dataset.cartId;
            const row = e.target.closest('tr');
            const quantityInput = row.querySelector('.quantity-input');
            const cartQty = quantityInput.value;

            const form = new FormData();
            form.append('cartId', cartId);
            form.append('cartQty', cartQty);

            fetch('${pageContext.request.contextPath}/cart/update', {
                method: 'POST',
                body: new URLSearchParams(form)
            }).then(response => {
                if (response.ok) {
                    alert('수량이 수정되었습니다.');
                    
                    // 화면 즉시 업데이트
                    const unitPrice = Number(row.dataset.unitPrice);
                    const newPrice = unitPrice * Number(cartQty);
                    
                    row.dataset.price = newPrice; // 행의 데이터 가격 업데이트
                    row.querySelector('.item-total-price').textContent = '₩' + newPrice.toLocaleString(); // 셀의 텍스트 업데이트
                    
                    updateTotalPrice(); // 전체 총액 다시 계산
                } else {
                    alert('수량 수정에 실패했습니다.');
                }
            });
        }

        if (e.target.classList.contains('remove-btn')) {
            if (!confirm('정말로 삭제하시겠습니까?')) return;

            const cartId = e.target.dataset.cartId;
            const row = e.target.closest('tr');
            const form = new FormData();
            form.append('cartId', cartId);

            fetch('${pageContext.request.contextPath}/cart/remove', {
                method: 'POST',
                body: new URLSearchParams(form)
            }).then(response => {
                if (response.ok) {
                    alert('상품이 삭제되었습니다.');
                    row.remove(); // 행을 즉시 삭제
                    updateTotalPrice(); // 전체 총액 다시 계산
                } else {
                    alert('삭제에 실패했습니다.');
                }
            });
        }
    });

    if (totalOrderPriceSpan) {
        updateTotalPrice();
    }
});
</script>
</body>
</html>
