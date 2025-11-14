<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 상세</title>
 <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/sellerstyle.css" />
</head>
<body>
  <jsp:include page="/WEB-INF/views/fragments/header.jsp" />

  <main class="mypage-body">
    <aside class="mypage-sidebar">
      <nav>
        <ul>
          <li class="sidebar-title">판매자 마이페이지</li>
          <li><a href="${pageContext.request.contextPath}/seller/mypage">상품 관리</a></li>
          <li><a class="active" href="${pageContext.request.contextPath}/seller/members" class="active">회원 관리</a></li>
          <li><a href="${pageContext.request.contextPath}/seller/notices">공지사항</a></li>
        </ul>
      </nav>
    </aside>

    <section class="mypage-content-area">
      <h2>회원 상세</h2>

      <c:if test="${empty user}">
        <p>회원 정보를 찾을 수 없습니다.</p>
      </c:if>

      <c:if test="${not empty user}">
        <div class="info-form">
          <div class="form-group"><label>아이디</label> ${user.memberId}</div>
          <div class="form-group"><label>이름</label> ${user.memberName}</div>
          <div class="form-group"><label>이메일</label> ${user.memberEmail}</div>
          <div class="form-group"><label>전화번호</label> ${user.memberPhone}</div>
          <div class="form-group"><label>우편번호</label> ${user.memberZipcode}</div>
          <div class="form-group"><label>상세주소</label> ${user.memberAddr1}</div>
          <div class="form-group"><label>상세주소2</label> ${user.memberAddr2}</div>
        </div>

        <h3 style="margin-top:30px;">의류 구매 내역</h3>
        <!-- TODO: 주문/주문상세 테이블 연동 후 목록 표시 예정 -->
        <p>구매 내역 기능은 추후 연동 예정입니다.</p>
      </c:if>

      <div class="button-group" style="margin-top:20px;">
        <a class="submit-btn" href="${pageContext.request.contextPath}/seller/members">목록으로</a>
      </div>
    </section>
  </main>

  <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />
</body>
</html>