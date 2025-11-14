<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>리뷰 작성 - MY MODERN SHOP</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600;700;800&family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<c:url value='/css/header.css' />">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Noto Sans KR', 'Montserrat', sans-serif;
            background-color: #f4f7f6;
            color: #333;
            line-height: 1.6;
        }
        a { text-decoration: none; color: inherit; }

        .review-container {
            max-width: 800px;
            margin: 50px auto;
            padding: 40px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        }

        .review-container h1 {
            font-size: 26px;
            font-weight: 600;
            margin-bottom: 30px;
            padding-bottom: 15px;
            border-bottom: 2px solid #333;
        }

        /* 리뷰 대상 상품 정보 */
        .product-to-review {
            display: flex;
            align-items: center;
            gap: 20px;
            padding: 20px;
            background-color: #f9f9f9;
            border-radius: 6px;
            margin-bottom: 30px;
        }
        .product-to-review img {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 4px;
        }
        .product-to-review .product-name {
            font-size: 18px;
            font-weight: 500;
        }

        /* 리뷰 작성 폼 */
        .review-form-group {
            margin-bottom: 25px;
        }
        .review-form-group label {
            display: block;
            font-weight: 500;
            margin-bottom: 10px;
            font-size: 16px;
        }

        /* 별점 평가 스타일 */
        .star-rating {
            display: flex;
            flex-direction: row-reverse;
            justify-content: flex-end;
            font-size: 2.5em;
        }
        .star-rating input[type="radio"] {
            display: none;
        }
        .star-rating label {
            color: #ddd;
            cursor: pointer;
            transition: color 0.2s;
        }
        .star-rating input[type="radio"]:checked ~ label,
        .star-rating label:hover,
        .star-rating label:hover ~ label {
            color: #f5b301;
        }

        textarea {
            width: 100%;
            height: 150px;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-family: inherit;
            font-size: 15px;
            resize: vertical;
        }

        .button-group {
            text-align: right;
            margin-top: 30px;
        }
        .button-group button {
            padding: 12px 30px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
        }
        .submit-btn {
            background-color: #333;
            color: white;
        }
        .cancel-btn {
            background-color: #eee;
            color: #555;
            margin-right: 10px;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />

    <div class="review-container">
        <h1>리뷰 작성</h1>

        <div class="product-to-review">
            <img src="${pageContext.request.contextPath}${product.prodImgPath}" alt="${product.prodName}">
            <span class="product-name">${product.prodName}</span>
        </div>

        <form action="<c:url value='/reviews/add'/>" method="post">
            <input type="hidden" name="productId" value="${product.prodId}">
            <input type="hidden" name="orderId" value="${orderId}">
            <input type="hidden" name="memberId" value="${memberId}">

            <div class="review-form-group">
                <label>상품은 만족스러우셨나요?</label>
                <div class="star-rating">
                    <input type="radio" id="5-stars" name="rating" value="5" required/><label for="5-stars">&#9733;</label>
                    <input type="radio" id="4-stars" name="rating" value="4" /><label for="4-stars">&#9733;</label>
                    <input type="radio" id="3-stars" name="rating" value="3" /><label for="3-stars">&#9733;</label>
                    <input type="radio" id="2-stars" name="rating" value="2" /><label for="2-stars">&#9733;</label>
                    <input type="radio" id="1-star" name="rating" value="1" /><label for="1-star">&#9733;</label>
                </div>
            </div>

            <div class="review-form-group">
                <label for="reviewContent">상세한 리뷰를 작성해주세요.</label>
                <textarea id="reviewContent" name="content" placeholder="상품에 대한 솔직한 리뷰를 남겨주세요. (최소 10자 이상)" required minlength="10"></textarea>
            </div>

            <div class="button-group">
                <button type="button" class="cancel-btn" onclick="history.back()">취소</button>
                <button type="submit" class="submit-btn">리뷰 등록</button>
            </div>
        </form>
    </div>
</body>
</html>