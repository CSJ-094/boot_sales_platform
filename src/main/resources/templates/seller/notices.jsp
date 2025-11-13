<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>공지사항 목록</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/sellerstyle.css" />
</head>
<body>

<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

<main class="mypage-body">
  <aside class="mypage-sidebar">
    <nav>
      <ul>
        <li class="sidebar-title">판매자 마이페이지</li>
        <li><a href="${pageContext.request.contextPath}/seller/products">상품 관리</a></li>
        <li><a href="${pageContext.request.contextPath}/seller/members">회원 관리</a></li>
          <li><a href="${pageContext.request.contextPath}/seller/notices" class="active">공지사항</a></li>
      </ul>
    </nav>
  </aside>

  <section class="mypage-content-area">
    <h2>공지사항 목록</h2>

    <!-- 플래시 메시지 -->
    <c:if test="${not empty message}">
      <div class="alert success" style="margin-bottom:16px;">${message}</div>
    </c:if>

    <!-- 등록 버튼 -->
    <div style="text-align:right; margin-bottom:15px;">
      <a href="${pageContext.request.contextPath}/seller/notices/write"
         class="btn btn-primary">공지사항 등록</a>
    </div>

    <!-- 목록 테이블 -->
    <table class="table">
      <thead>
        <tr>
          <th style="width:10%;">번호</th>
          <th style="width:50%;">제목</th>
          <th style="width:20%;">작성자</th>
          <th style="width:20%;">작성일</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="notice" items="${noticeList}">
          <tr>
            <td>${notice.NOT_NO}</td>
            <td class="text-left">
              <a href="${pageContext.request.contextPath}/seller/notices/content_view?notNo=${notice.NOT_NO}">
                <b>${notice.NOT_TITLE}</b>
              </a>
            </td>
            <td>${notice.NOT_NAME}</td>
            <td>
              <c:choose>
                <c:when test="${not empty notice.NOT_TIME}">
                  <fmt:formatDate value="${notice.NOT_TIME}" pattern="yyyy-MM-dd HH:mm" />
                </c:when>
                <c:otherwise>-</c:otherwise>
              </c:choose>
            </td>
          </tr>
        </c:forEach>

        <c:if test="${empty noticeList}">
          <tr>
            <td colspan="4" style="text-align:center; padding:20px;">등록된 공지사항이 없습니다.</td>
          </tr>
        </c:if>
      </tbody>
    </table>
  </section>
</main>
<jsp:include page="/WEB-INF/views/fragments/footer.jsp" />
</body>
</html>
