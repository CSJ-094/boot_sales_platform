<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 관리</title>
  <link rel="stylesheet" href=<c:url value='/css/sellerstyle.css' />/>
  <link rel="stylesheet" href="<c:url value='/css/header.css' />">
</head>
<body>
	<jsp:include page="/WEB-INF/views/fragments/header.jsp" />
	<main class="mypage-body">
	    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp">
	        <jsp:param name="menu" value="members"/>
	    </jsp:include>

    <section class="mypage-content-area">
      <h2>회원 관리</h2>

      <c:if test="${empty users}">
        <p>등록된 회원이 없습니다.</p>
      </c:if>

      <c:if test="${not empty users}">
        <table>
          <thead>
            <tr>
              <th>아이디</th>
              <th>이름</th>
              <th>이메일</th>
              <th>전화번호</th>
              <th>상세</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="u" items="${users}">
              <tr>
                <td>${u.memberId}</td>
                <td>${u.memberName}</td>
                <td>${u.memberEmail}</td>
                <td>${u.memberPhone}</td>
                <td>
                  <a href="${pageContext.request.contextPath}/seller/members/${u.memberId}">보기</a>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </c:if>
    </section>
  </main>

  <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />
</body>
</html>