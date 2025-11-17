<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>상품 검색 결과 - MY MODERN SHOP</title>
    <link rel="stylesheet" href="<c:url value='/css/header.css'/>">
    <style>
        /* 기존 스타일 유지 */
        body { font-family: 'Noto Sans KR', 'Montserrat', sans-serif; color: #333; line-height: 1.6; background-color: #f9f9f9; }
        .container { max-width: 1200px; margin: 30px auto; padding: 0 20px; }
        .search-title { font-size: 24px; color: #333; border-bottom: 2px solid #b08d57; padding-bottom: 12px; margin-bottom: 25px; font-weight: 600; }
        .search-title .keyword { color: #d64545; }
        .product-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 50px; }
        .product-item { background-color: #ffffff; border: 1px solid #e0e0e0; border-radius: 6px; overflow: hidden; text-align: center; transition: box-shadow 0.3s ease, transform 0.3s ease; }
        .product-item:hover { box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1); transform: translateY(-3px); }
        .product-img { width: 100%; padding-bottom: 100%; background-color: #f0f0f0; position: relative; }
        .product-img img { position: absolute; top: 0; left: 0; width: 100%; height: 100%; object-fit: cover; }
        .product-info { padding: 15px; }
        .product-info p { font-weight: 500; margin-bottom: 5px; font-size: 15px; }
        .product-info span { color: #d64545; font-weight: 700; font-size: 16px; }
        .no-result { text-align: center; padding: 50px 0; color: #777; font-size: 18px; }

        /* 새로운 검색/필터링/정렬 폼 스타일 */
        .search-form {
            background-color: #fff;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 30px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            align-items: flex-end;
        }
        .search-form .form-group {
            display: flex;
            flex-direction: column;
            min-width: 150px;
        }
        .search-form label {
            font-size: 14px;
            color: #555;
            margin-bottom: 5px;
            font-weight: 500;
        }
        .search-form input[type="text"],
        .search-form input[type="number"],
        .search-form select {
            padding: 8px 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
            width: 100%;
            box-sizing: border-box;
        }
        .search-form .price-range {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .search-form .price-range span {
            font-size: 14px;
            color: #555;
        }
        .search-form button {
            padding: 8px 20px;
            background-color: #b08d57;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: background-color 0.3s ease;
        }
        .search-form button:hover {
            background-color: #9a7a4a;
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

        <!-- 고급 검색 및 필터링/정렬 폼 -->
        <form action="<c:url value='/product/search'/>" method="GET" class="search-form">
            <div class="form-group">
                <label for="keyword">검색어</label>
                <input type="text" id="keyword" name="keyword" value="${condition.keyword}" placeholder="상품명 또는 설명">
            </div>

            <div class="form-group">
                <label>가격 범위</label>
                <div class="price-range">
                    <input type="number" id="minPrice" name="minPrice" value="${condition.minPrice}" placeholder="최소 가격">
                    <span>~</span>
                    <input type="number" id="maxPrice" name="maxPrice" value="${condition.maxPrice}" placeholder="최대 가격">
                </div>
            </div>

            <div class="form-group">
                <label for="category">카테고리</label>
                <select id="category" name="category">
                    <option value="">전체</option>
                    <%-- 실제 카테고리 목록은 DB에서 가져와서 동적으로 생성해야 합니다. --%>
                    <option value="1" <c:if test="${condition.category == '1'}">selected</c:if>>의류</option>
                    <option value="2" <c:if test="${condition.category == '2'}">selected</c:if>>신발</option>
                    <option value="3" <c:if test="${condition.category == '3'}">selected</c:if>>액세서리</option>
                    <option value="4" <c:if test="${condition.category == '4'}">selected</c:if>>가방</option>
                </select>
            </div>

            <div class="form-group">
                <label for="sortBy">정렬 기준</label>
                <select id="sortBy" name="sortBy">
                    <option value="prodId" <c:if test="${condition.sortBy == 'prodId'}">selected</c:if>>최신순</option>
                    <option value="prodName" <c:if test="${condition.sortBy == 'prodName'}">selected</c:if>>상품명</option>
                    <option value="prodPrice" <c:if test="${condition.sortBy == 'prodPrice'}">selected</c:if>>가격</option>
                    <option value="prodReg" <c:if test="${condition.sortBy == 'prodReg'}">selected</c:if>>등록일</option>
                </select>
            </div>

            <div class="form-group">
                <label for="sortOrder">정렬 순서</label>
                <select id="sortOrder" name="sortOrder">
                    <option value="desc" <c:if test="${condition.sortOrder == 'desc'}">selected</c:if>>내림차순</option>
                    <option value="asc" <c:if test="${condition.sortOrder == 'asc'}">selected</c:if>>오름차순</option>
                </select>
            </div>
            
            <button type="submit">검색</button>
        </form>

        <!-- 검색 결과가 있을 경우 -->
        <c:if test="${not empty searchResult}">
            <div class="product-grid">
                <c:forEach var="product" items="${searchResult}">
                    <a href="<c:url value='/product/detail?id=${product.prodId}'/>">
                        <div class="product-item">
                            <div class="product-img">
                                <%-- prodImgPath가 있으면 해당 이미지 사용, 없으면 기본 이미지 사용 --%>
                                <c:choose>
                                    <c:when test="${not empty product.prodImgPath}">
                                        <img src="<c:url value='${product.prodImgPath}'/>" alt="${product.prodName}">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="<c:url value="/img/default_product.png"/>" alt="${product.prodName}">
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="product-info">
                                <p>${product.prodName}</p>
                                <span><fmt:formatNumber value="${product.prodPrice}" type="number" maxFractionDigits="0"/>원</span>
                            </div>
                        </div>
                    </a>
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

    <!-- 푸터 포함 (푸터가 jsp로 분리되어 있다면 아래와 같이 사용) -->
    <%-- <jsp:include page="/WEB-INF/views/fragments/footer.jsp" /> --%>
</body>
</html>