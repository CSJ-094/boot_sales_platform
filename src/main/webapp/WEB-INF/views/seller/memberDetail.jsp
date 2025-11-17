<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 상세</title>
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
      <h2>회원 상세</h2>

      <c:if test="${empty member}">
        <p>회원 정보를 찾을 수 없습니다.</p>
      </c:if>

	  <c:if test="${not empty member}">
	    <!-- 회원 정보 카드 -->
	    <div class="member-info-card">
	      <div class="info-form member-info-grid">
	        <div class="form-group">
	          <label>아이디</label> ${member.memberId}
	        </div>
	        <div class="form-group">
	          <label>이름</label> ${member.memberName}
	        </div>
	        <div class="form-group">
	          <label>이메일</label> ${member.memberEmail}
	        </div>
	        <div class="form-group">
	          <label>전화번호</label> ${member.memberPhone}
	        </div>
	        <div class="form-group">
	          <label>우편번호</label> ${member.memberZipcode}
	        </div>
	        <div class="form-group">
	          <label>상세주소</label> ${member.memberAddr1}
	        </div>
	        <div class="form-group">
	          <label>상세주소2</label> ${member.memberAddr2}
	        </div>
	      </div>
	    </div>

	    <!-- 구매 내역 -->
	    <h3 style="margin-top:30px;">의류 구매 내역</h3>
	    <c:choose>
	      <c:when test="${not empty orders}">
	        <table class="list-table">
	          <thead>
	            <tr>
	              <th>주문번호 / 상품내역</th>
	              <th>주문일</th>
	              <th>주문상태</th>
	              <th>총 결제금액</th>
	            </tr>
	          </thead>
	          <tbody>
	            <c:forEach var="order" items="${orders}">
	              <tr>
	                <td>
	                  <div class="order-id-text">${order.ordId}</div>

	                  <c:if test="${not empty order.orderDetails}">
	                    <ul class="order-prod-list">
	                      <c:forEach var="detail" items="${order.orderDetails}">
	                        <li>${detail.prodName} (${detail.quantity}개)</li>
	                      </c:forEach>
	                    </ul>
	                  </c:if>
	                </td>
	                <td>
	                  <fmt:formatDate value="${order.ordDate}" pattern="yyyy-MM-dd HH:mm:ss" />
	                </td>
	                <td>${order.ordStatus}</td>
	                <td>${order.ordAmount + order.ordDfee - order.ordDiscount}원</td>
	              </tr>
	            </c:forEach>
	          </tbody>
	        </table>
	      </c:when>
	      <c:otherwise>
	        <p>구매 내역이 없습니다.</p>
	      </c:otherwise>
	    </c:choose>
	  </c:if>

	  <!-- 버튼 영역: 다른 상세 페이지랑 통일 -->
	  <div class="detail-actions">
	    <a class="btn btn-outline"
	       href="${pageContext.request.contextPath}/seller/members">목록으로</a>
	  </div>
    </section>
  </main>

  <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />
</body>
</html>