<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>공지사항 수정</title>
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
      <h2>공지사항 수정</h2>

      <form action="${pageContext.request.contextPath}/seller/notices/modify" method="post" class="info-form">
        <input type="hidden" name="NOT_NO" value="${notice.NOT_NO}" />

        <div class="form-group">
          <label>제목</label>
          <input type="text" name="NOT_TITLE" value="${notice.NOT_TITLE}" required style="width:100%;" />
        </div>

        <div class="form-group">
          <label>내용</label>
          <textarea name="NOT_CONTENT" rows="10" style="width:100%;" required>${notice.NOT_CONTENT}</textarea>
        </div>

        <div class="button-group">
          <button type="submit" class="submit-btn">수정하기</button>
          <a href="${pageContext.request.contextPath}/seller/notices/content_view?notNo=${notice.NOT_NO}" class="reset-btn">취소</a>
        </div>
      </form>
    </section>
  </main>

  <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />
</body>
</html>
