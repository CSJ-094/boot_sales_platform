<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>상품 상세</title>
  <link rel="stylesheet" href="<c:url value='/css/sellerstyle.css' />">
  <link rel="stylesheet" href="<c:url value='/css/header.css' />">
</head>
<body>
	<jsp:include page="/WEB-INF/views/fragments/header.jsp" />
	<main class="mypage-body">
	    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp">
	        <jsp:param name="menu" value="products"/>
	    </jsp:include>

      <section class="mypage-content-area">
        <h2>상품 상세 (#${product.prodId})</h2>

        <!-- 메시지 -->
        <c:if test="${not empty msg}">
          <div class="alert success">${msg}</div>
        </c:if>
        <c:if test="${not empty error}">
          <div class="alert danger">${error}</div>
        </c:if>

        <c:choose>
          <c:when test="${empty product}">
            <p>상품 정보를 찾을 수 없습니다.</p>
          </c:when>

          <c:otherwise>

            <!-- ⭐ 이미지 + 기본정보 2단 배치 -->
            <div class="prod-detail-layout">

              <!-- LEFT: 이미지 -->
              <div class="prod-img-box">
                <c:choose>
                  <c:when test="${not empty product.prodImgPath}">
                    <img src="${pageContext.request.contextPath}${product.prodImgPath}" alt="${product.prodName}">
                  </c:when>
                  <c:otherwise>
                    <div class="prod-img-placeholder">
                      등록된 대표 이미지가 없습니다.
                    </div>
                  </c:otherwise>
                </c:choose>
              </div>

              <!-- RIGHT: 정보 -->
              <div class="prod-info-box">

                <h3>${product.prodName}</h3>

                <p class="prod-price">
                  <fmt:formatNumber value="${product.prodPrice}" type="number" />원
                </p>

                <p>재고: <strong>${product.prodStock}</strong> 개</p>
                <p>판매자: ${product.prodSeller}</p>
                <p>상품 코드: ${product.prodCode}</p>
                <p>등록일:
                  <fmt:formatDate value="${product.prodReg}" pattern="yyyy-MM-dd HH:mm" />
                </p>

                <c:if test="${not empty product.prodUpd}">
                  <p>수정일:
                    <fmt:formatDate value="${product.prodUpd}" pattern="yyyy-MM-dd HH:mm" />
                  </p>
                </c:if>

              </div>
            </div>

            <!-- 상세 설명 -->
            <div class="prod-desc-card">
              <h4>상품 설명</h4>
              <pre class="prod-desc">${product.prodDesc}</pre>
            </div>

			            <div class="detail-actions">
			              <a class="btn btn-primary"
			                 href="${pageContext.request.contextPath}/seller/products/${product.prodId}/edit">
			                수정
			              </a>

			              <a class="btn btn-outline"
			                 href="${pageContext.request.contextPath}/seller/products">
			                목록으로
			              </a>
			              <form action="${pageContext.request.contextPath}/seller/products/${product.prodId}/delete"
			                    method="post"
			                    class="inline-form"
			                    onsubmit="return confirm('정말 삭제하시겠습니까? 삭제 후 복구할 수 없습니다.');">
			                <button type="submit" class="btn red">삭제</button>
			              </form>
			            </div>

          </c:otherwise>
        </c:choose>

      </section>
    </main>

    <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />
  </body>
  </html>