<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>상품 상세</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/sellerstyle.css" />
</head>
<body>
  <jsp:include page="/WEB-INF/views/fragments/header.jsp" />

  <main class="mypage-body">
    <aside class="mypage-sidebar">
      <nav>
        <ul>
          <li class="sidebar-title">판매자 마이페이지</li>
          <li><a href="${pageContext.request.contextPath}/seller/products" class="active">상품 관리</a></li>
          <li><a href="${pageContext.request.contextPath}/seller/members">회원 관리</a></li>
          <li><a href="${pageContext.request.contextPath}/seller/notices">공지사항</a></li>
        </ul>
      </nav>
    </aside>

    <section class="mypage-content-area">
      <h2>상품 상세 (#${product.prodId})</h2>
      
      <!-- 플래시 메시지 -->
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
          <div class="info-form">
            <div class="form-group"><label>상품명</label> ${product.prodName}</div>
            <div class="form-group"><label>가격</label> <fmt:formatNumber value="${product.prodPrice}" type="number" />원</div>
            <div class="form-group"><label>재고</label> ${product.prodStock}</div>
            <div class="form-group"><label>판매자</label> ${product.prodSeller}</div>
            <div class="form-group"><label>코드</label> ${product.prodCode}</div>
            <div class="form-group"><label>등록일</label> <fmt:formatDate value="${product.prodReg}" pattern="yyyy-MM-dd HH:mm" /></div>
                    <!-- 수정일: 있을 때만 노출 -->
        <c:if test="${not empty product.prodUpd}">
          <div class="form-group"><label>수정일</label> <fmt:formatDate value="${product.prodUpd}" pattern="yyyy-MM-dd HH:mm" /></div>
        </c:if>
            <div class="form-group"><label>설명</label> <pre style="white-space:pre-wrap">${product.prodDesc}</pre></div>
          </div>
          
        <!-- 버튼 영역: 수정 · 목록으로 · 삭제 (중앙정렬) -->
<div class="detail-actions">
  <a class="reset-btn" href="${pageContext.request.contextPath}/seller/products/${product.prodId}/edit">수정</a>
  <a class="reset-btn" href="${pageContext.request.contextPath}/seller/products">목록으로</a>
  <form action="${pageContext.request.contextPath}/seller/products/${product.prodId}/delete"
        method="post" class="inline-form"
        onsubmit="return confirm('정말 삭제하시겠습니까? 삭제 후 복구할 수 없습니다.');">
    <button type="submit" class="reset-btn">삭제</button>
  </form>
</div>

        </c:otherwise>
      </c:choose>
    </section>
  </main>

  <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />
</body>
</html>
