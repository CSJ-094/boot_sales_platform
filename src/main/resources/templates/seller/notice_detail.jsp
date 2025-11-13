<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>공지사항 상세보기</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/sellerstyle.css">
</head>
<body>
  <jsp:include page="/WEB-INF/views/fragments/header.jsp" />

  <main class="mypage-body">
    <aside class="mypage-sidebar">
      <nav>
        <ul>
          <li class="sidebar-title">판매자 마이페이지</li>
          <li><a href="${pageContext.request.contextPath}/seller/products" >상품 관리</a></li>
          <li><a href="${pageContext.request.contextPath}/seller/members">회원 관리</a></li>
          <li><a href="${pageContext.request.contextPath}/seller/notices" class="active">공지사항</a></li>
        </ul>
      </nav>
    </aside>

    <section class="mypage-content-area">
      <h2>공지사항 상세 보기</h2>

      <div class="info-form">
        <div class="form-group"><label>제목</label> ${notice.NOT_TITLE}</div>
        <div class="form-group"><label>작성자</label> ${notice.NOT_NAME}</div>
        <div class="form-group">
          <label>작성일</label>
          <fmt:formatDate value="${notice.NOT_TIME}" pattern="yyyy-MM-dd HH:mm" />
        </div>
        <div class="form-group">
          <label>내용</label>
          <pre style="white-space:pre-wrap">${notice.NOT_CONTENT}</pre>
        </div>
      </div>

      <div class="button-group" style="margin-top:20px;">
        <a href="${pageContext.request.contextPath}/seller/notices" class="btn-submit">목록으로</a>
        <a href="${pageContext.request.contextPath}/seller/notices/modify?notNo=${notice.NOT_NO}" class="btn-submit">수정</a>

        <form action="${pageContext.request.contextPath}/seller/notices/delete" method="post" style="display:inline;">
          <input type="hidden" name="notNo" value="${notice.NOT_NO}" />
          <button type="submit" class="reset-btn" onclick="return confirm('정말 삭제하시겠습니까?');">삭제</button>
        </form>
      </div>
    </section>
  </main>

  <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />
</body>
</html>
