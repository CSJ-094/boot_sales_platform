<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>공지사항 등록</title>
  <link rel="stylesheet" href="<c:url value='/css/sellerstyle.css' />" />
  <link rel="stylesheet" href="<c:url value='/css/header.css' />">
</head>
<body>
  <jsp:include page="/WEB-INF/views/fragments/header.jsp" />

  <main class="mypage-body">
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp">
      <jsp:param name="menu" value="notices"/>
    </jsp:include>

    <section class="mypage-content-area">
      <h2>공지사항 등록</h2>

      <div class="notice-form-card">
        <form action="${pageContext.request.contextPath}/seller/notices"
              method="post"
              class="info-form notice-form">

          <div class="form-group">
            <label for="NOT_TITLE">제목</label>
            <input type="text" id="NOT_TITLE" name="NOT_TITLE" required />
          </div>

          <div class="form-group">
            <label for="NOT_NAME">작성자</label>
            <input type="text" id="NOT_NAME" name="NOT_NAME" required />
          </div>

          <div class="form-group textarea-group">
            <label for="NOT_CONTENT">내용</label>
            <textarea id="NOT_CONTENT"
                      name="NOT_CONTENT"
                      rows="15"
                      maxlength="4000"
                      required></textarea>
          </div>

          <div class="notice-form-actions">
            <button type="submit" class="btn btn-primary">등록하기</button>
            <a href="${pageContext.request.contextPath}/seller/notices"
               class="btn btn-outline">취소</a>
          </div>
        </form>
      </div>
    </section>
  </main>

  <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />
</body>
</html>
