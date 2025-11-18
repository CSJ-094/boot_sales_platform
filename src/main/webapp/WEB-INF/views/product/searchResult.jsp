<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>상품 검색 결과 - MY MODERN SHOP</title>
    <link rel="stylesheet" href="<c:url value="/css/header.css"/>">
    <style>
        body {
            font-family: 'Noto Sans KR', 'Montserrat', sans-serif;
            color: #333;
            line-height: 1.6;
            background-color: #f9f9f9;
        }
        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }
        .search-title {
            font-size: 24px;
            color: #333;
            border-bottom: 2px solid #b08d57;
            padding-bottom: 12px;
            margin-bottom: 25px;
            font-weight: 600;
        }
        .search-title .keyword {
            color: #d64545;
        }
        .product-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 50px;
        }
        .product-item {
            background-color: #ffffff;
            border: 1px solid #e0e0e0;
            border-radius: 6px;
            overflow: hidden;
            text-align: center;
            transition: box-shadow 0.3s ease, transform 0.3s ease;
        }
        .product-item:hover {
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            transform: translateY(-3px);
        }
        .product-img {
            width: 100%;
            padding-bottom: 100%;
            background-color: #f0f0f0;
            position: relative;
        }
        .product-img img {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .product-info {
            padding: 15px;
        }
        .product-info p {
            font-weight: 500;
            margin-bottom: 5px;
            font-size: 15px;
        }
        .product-info span {
            color: #d64545;
            font-weight: 700;
            font-size: 16px;
        }
        .no-result {
            text-align: center;
            padding: 50px 0;
            color: #777;
            font-size: 18px;
        }

        /* 필터 UI 스타일 */
        .filter-section {
            background-color: #ffffff;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 30px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
        }
        .filter-form {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            align-items: flex-end;
        }
        .filter-group {
            display: flex;
            flex-direction: column;
            min-width: 150px;
        }
        .filter-group label {
            font-weight: 600;
            margin-bottom: 8px;
            color: #555;
            font-size: 14px;
        }
        .filter-group input[type="number"],
        .filter-group select {
            padding: 8px 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
            width: 100%;
            min-width: 100px;
        }
        .price-range {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .price-range span {
            font-size: 14px;
            color: #555;
        }
        .filter-button {
            padding: 10px 20px;
            background-color: #2c2c2c;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 15px;
            font-weight: 600;
            transition: background-color 0.3s ease;
        }
        .filter-button:hover {
            background-color: #b08d57;
            color: #2c2c2c;
        }
    </style>
</head>
<body>
    <!-- 헤더 포함 -->
    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />

    <div class="container">
        <!-- 검색 결과 제목 -->
        <h4 class="search-title">
            '<span class="keyword">${condition.keyword}</span>'에 대한 검색 결과
        </h4>

        <!-- 필터 섹션 -->
        <section class="filter-section">
            <form action="<c:url value='/product/search'/>" method="get" class="filter-form">
                <!-- 기존 검색어 유지 -->
                <input type="hidden" name="keyword" value="${condition.keyword}">

                <!-- 가격 필터 -->
                <div class="filter-group">
                    <label for="minPrice">가격 범위</label>
                    <div class="price-range">
                        <input type="number" id="minPrice" name="minPrice" placeholder="최소" value="${condition.minPrice}">
                        <span>-</span>
                        <input type="number" id="maxPrice" name="maxPrice" placeholder="최대" value="${condition.maxPrice}">
                    </div>
                </div>

                <!-- 카테고리 필터 -->
                <div class="filter-group">
                    <label for="category">카테고리</label>
                    <select id="category" name="category">
                        <option value="">전체</option>
                        <c:forEach var="cat" items="${categories}">
                            <c:if test="${cat.catParent != null}"> <%-- 최상위 카테고리(부모가 없는)는 제외 --%>
                                <option value="${cat.catId}" ${condition.category == cat.catId ? 'selected' : ''}>
                                    <c:if test="${cat.depth > 1}">
                                        <c:forEach begin="1" end="${cat.depth - 1}">
                                            &nbsp;&nbsp;&nbsp;
                                        </c:forEach>
                                    </c:if>
                                    ${cat.catName}
                                </option>
                            </c:if>
                        </c:forEach>
                    </select>
                </div>

                <!-- 정렬 옵션 -->
                <div class="filter-group">
                    <label for="sortBy">정렬 기준</label>
                    <select id="sortBy" name="sortBy">
                        <option value="prodReg" ${condition.sortBy == 'prodReg' ? 'selected' : ''}>최신순</option>
                        <option value="prodPrice" ${condition.sortBy == 'prodPrice' ? 'selected' : ''}>가격순</option>
                        <option value="prodName" ${condition.sortBy == 'prodName' ? 'selected' : ''}>이름순</option>
                    </select>
                </div>
                <div class="filter-group">
                    <label for="sortOrder">정렬 방향</label>
                    <select id="sortOrder" name="sortOrder">
                        <option value="desc" ${condition.sortOrder == 'desc' ? 'selected' : ''}>내림차순</option>
                        <option value="asc" ${condition.sortOrder == 'asc' ? 'selected' : ''}>오름차순</option>
                    </select>
                </div>

                <button type="submit" class="filter-button">필터 적용</button>
            </form>
        </section>

        <!-- 검색 결과가 있을 경우 -->
        <c:if test="${not empty searchResult}">
            <div class="product-grid">
                <c:forEach var="product" items="${searchResult}">
                    <div class="product-item">
                        <a href="<c:url value="/product/detail?id=${product.prodId}"/>">
                            <div class="product-img">
                                <img src="<c:url value="${product.prodImgPath}"/>" alt="${product.prodName}" onerror="this.src='<c:url value="/img/default_product.png"/>';">
                            </div>
                            <div class="product-info">
                                <p>${product.prodName}</p>
                                <span><fmt:formatNumber value="${product.prodPrice}" pattern="#,###"/>원</span>
                            </div>
                        </a>
                    </div>
                </c:forEach>
            </div>
        </c:if>

        <!-- 검색 결과가 없을 경우 -->
        <c:if test="${empty searchResult}">
            <div class="no-result">
                <p>아쉽게도 '<span class="keyword">${condition.keyword}</span>'에 대한 검색 결과가 없습니다.</p>
                <p>다른 검색어로 다시 시도해 보세요.</p>
            </div>
        </c:if>
    </div>

    <!-- 푸터 포함 -->
    <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />
</body>
</html>