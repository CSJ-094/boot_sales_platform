<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>문의 답변 작성</title>
    <link rel="stylesheet" href="<c:url value='/css/sellerstyle.css' />">
    <link rel="stylesheet" href="<c:url value='/css/header.css' />">
    
</head>
<body>
    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />

    <main class="mypage-body">
        <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp">
            <jsp:param name="menu" value="qna"/>
        </jsp:include>

        <section class="mypage-content-area">
            <h1>문의 답변 작성</h1>

            <div class="info-form">
                <h3>고객 문의 내용</h3>
                <table class="table-bordered" style="margin-top:15px; margin-bottom: 30px;">
                    <tr>
                        <th style="width:120px;">상품명</th>
                        <td>${question.prodName}</td>
                    </tr>
                    <tr>
                        <th>작성자</th>
                        <td>${question.memberName}</td>
                    </tr>
                    <tr>
                        <th>작성일</th>
                        <td><fmt:formatDate value="${question.qnaRegDate}" pattern="yyyy-MM-dd HH:mm"/></td>
                    </tr>
                    <tr>
                        <th>문의 제목</th>
                        <td>${question.qnaTitle}</td>
                    </tr>
                    <tr>
                        <th>문의 내용</th>
                        <td style="white-space: pre-wrap; min-height: 100px;">${question.qnaContent}</td>
                    </tr>
                </table>

                <%-- ⭐️ 기존 답변 내역 표시 --%>
                <c:if test="${not empty replies}">
                    <h3 style="margin-top: 30px;">기존 답변 내역</h3>
                    <div class="reply-history" style="margin-top: 15px;">
                        <c:forEach var="reply" items="${replies}">
                            <div class="reply-item" style="border: 1px solid #e9e9e9; padding: 15px; border-radius: 5px; margin-bottom: 10px;">
                                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                                    <span style="font-weight: 600;">판매자</span>
                                    <span style="font-size: 13px; color: #888;">
                                        <fmt:formatDate value="${reply.qnaRegDate}" pattern="yyyy-MM-dd HH:mm"/>
                                    </span>
                                </div>
                                <div style="white-space: pre-wrap;">${reply.qnaContent}</div>
                                <%-- 답변 삭제 버튼 (필요 시) --%>
                                <%--
                                <form action="<c:url value='/seller/qna/reply/delete'/>" method="post" style="text-align: right; margin-top: 10px;">
                                    <input type="hidden" name="qnaId" value="${reply.qnaId}">
                                    <button type="submit" class="btn-delete-small">삭제</button>
                                </form>
                                --%>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>

				<h3>답변 작성</h3>
				<form action="<c:url value='/seller/qna/reply'/>" method="post" style="margin-top:15px;">
				    <input type="hidden" name="qnaParentId" value="${question.qnaId}">
				    <input type="hidden" name="prodId" value="${question.prodId}">
				    <input type="hidden" name="qnaTitle" value="${question.qnaTitle}">

				    <div class="form-group">
				        <label for="qnaContent">답변 내용</label>
				        <textarea id="qnaContent" name="qnaContent" rows="8" required style="width:100%"></textarea>
				    </div>

				    <!-- 버튼 영역: 공통 .btn 스타일 + 가운데 정렬 -->
				    <div class="reply-form-actions">
				        <button type="submit" class="btn btn-primary">답변등록</button>
				        <a href="<c:url value='/seller/qna'/>" class="btn btn-outline">목록으로</a>
				    </div>
				</form>
            </div>
        </section>
    </main>

    <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />
</body>
</html>