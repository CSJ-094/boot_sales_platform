<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>공지사항 상세보기</title>
  <link rel="stylesheet" href="<c:url value='/css/sellerstyle.css' />" />
  <link rel="stylesheet" href="<c:url value='/css/header.css' />" />
</head>
<body>
	<jsp:include page="/WEB-INF/views/fragments/header.jsp" />
	<main class="mypage-body">
	    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp">
	        <jsp:param name="menu" value="notices"/>
	    </jsp:include>

    <!-- ▶ 여기부터 공지 상세 카드 레이아웃 -->
    <section class="mypage-content-area">
      <div class="notice-detail">

        <!-- 상단: 제목 + 작성자/작성일 -->
        <div class="notice-header">
          <h2 class="notice-title">${notice.NOT_TITLE}</h2>
          <div class="notice-meta">
            <span>작성자 ${notice.NOT_NAME}</span>
            <span class="divider">·</span>
            <span>작성일 <fmt:formatDate value="${notice.NOT_TIME}" pattern="yyyy-MM-dd HH:mm" /></span>
          </div>
        </div>

        <!-- 내용 박스 -->
        <div class="notice-content-box">
          <pre>${notice.NOT_CONTENT}</pre>
        </div>

        <!-- 하단 버튼 (가운데 정렬) -->
        <div class="notice-buttons">
          <a href="${pageContext.request.contextPath}/seller/notices" class="btn btn-outline">목록으로</a>
          <a href="${pageContext.request.contextPath}/seller/notices/modify?notNo=${notice.NOT_NO}" class="btn btn-primary">수정</a>

          <form action="${pageContext.request.contextPath}/seller/notices/delete"
                method="post" style="display:inline;">
            <input type="hidden" name="notNo" value="${notice.NOT_NO}" />
            <button type="submit" class="btn btn-ghost"
                    onclick="return confirm('정말 삭제하시겠습니까?');">삭제</button>
          </form>
        </div>

      </div>
    </section>
  </main>

  <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />
</body>
</html>
