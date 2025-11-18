<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>공지사항 상세보기 - MY MODERN SHOP</title>
  <link rel="stylesheet" href="<c:url value='/css/sellerstyle.css' />" />
  <link rel="stylesheet" href="<c:url value='/css/header.css' />" />

  <style>
    /* 프론트 공지 상세 레이아웃 래퍼만 추가 (디자인은 기존 notice-detail 스타일 재사용) */
    .front-notice-wrap {
      max-width: 1200px;
      margin: 40px auto;
      padding: 0 20px;
    }

    /* 버튼 가운데 정렬 폭 살짝 줄이기 */
    .notice-buttons {
      margin-top: 24px;
      text-align: center;
    }
  </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

<main class="front-notice-wrap">
  <!-- ▶ 판매자용과 동일한 카드 레이아웃 재사용 -->
  <div class="notice-detail">

    <!-- 상단: 제목 + 작성자/작성일 -->
    <div class="notice-header">
      <h2 class="notice-title">${notice.NOT_TITLE}</h2>
      <div class="notice-meta">
        <span>작성자 ${notice.NOT_NAME}</span>
        <span class="divider">·</span>
        <span>
          작성일
          <fmt:formatDate value="${notice.NOT_TIME}" pattern="yyyy-MM-dd HH:mm" />
        </span>
      </div>
    </div>

    <!-- 내용 박스 -->
    <div class="notice-content-box">
      <pre>${notice.NOT_CONTENT}</pre>
    </div>

    <!-- 하단 버튼 (가운데 정렬, 프론트는 목록만) -->
    <div class="notice-buttons">
      <a href="${pageContext.request.contextPath}/mainpage"
         class="btn btn-outline">뒤로 가기</a>
    </div>

  </div>
</main>
<jsp:include page="/WEB-INF/views/fragments/footer.jsp" />
</body>
</html>
