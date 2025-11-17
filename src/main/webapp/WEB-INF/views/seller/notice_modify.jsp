<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>공지사항 수정</title>
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
      <h2>공지사항 수정</h2>

      <div class="notice-form-card">
        <form action="${pageContext.request.contextPath}/seller/notices/modify"
              method="post"
              class="info-form notice-form">

          <input type="hidden" name="NOT_NO" value="${notice.NOT_NO}" />

          <div class="form-group">
            <label for="NOT_TITLE">제목</label>
            <input type="text"
                   id="NOT_TITLE"
                   name="NOT_TITLE"
                   value="${notice.NOT_TITLE}"
                   required />
          </div>

          <div class="form-group textarea-group">
            <label for="NOT_CONTENT">내용</label>
            <textarea id="NOT_CONTENT"
                      name="NOT_CONTENT"
                      rows="15"
                      required>${notice.NOT_CONTENT}</textarea>
          </div>

          <div class="notice-form-actions">
            <button type="submit" class="btn btn-primary">수정하기</button>
            <a href="${pageContext.request.contextPath}/seller/notices/content_view?notNo=${notice.NOT_NO}"
               class="btn btn-outline">취소</a>
          </div>
        </form>
      </div>
    </section>
  </main>

  <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />
</body>
</html>
