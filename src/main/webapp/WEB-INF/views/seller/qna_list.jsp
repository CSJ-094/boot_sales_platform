<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>문의 관리</title>
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
            <div class="page-title">
                <h1>문의 관리</h1>
            </div>

            <c:if test="${not empty msg}">
                <div class="alert alert-success">${msg}</div>
            </c:if>

            <table class="table">
                <thead>
                    <tr>
                        <th style="width: 15%;">상품명</th>
                        <th>문의 제목</th>
                        <th style="width: 12%;">작성자</th>
                        <th style="width: 12%;">작성일</th>
                        <th style="width: 10%;">답변여부</th>
                    </tr>
                </thead>
                <tbody>
                    <c:if test="${empty qnaList}">
                        <tr><td colspan="5" style="text-align:center; padding:20px;">등록된 문의가 없습니다.</td></tr>
                    </c:if>
                    <c:forEach var="qna" items="${qnaList}">
                        <tr onclick="location.href='<c:url value='/seller/qna/${qna.qnaId}/reply'/>'" style="cursor:pointer;">
                            <td>${qna.prodName}</td>
                            <td>
                                ${qna.qnaTitle}
                                <c:if test="${qna.qnaIsSecret == 'Y'}"><span style="color: #888; font-size: 0.9em;"> (비밀글)</span></c:if>
                            </td>
                            <td>${qna.memberName}</td>
                            <td><fmt:formatDate value="${qna.qnaRegDate}" pattern="yyyy-MM-dd"/></td>
                            <td>
                                <c:if test="${qna.replied == 'Y'}"><span style="color: green; font-weight: bold;">완료</span></c:if>
                                <c:if test="${qna.replied == 'N'}"><span style="color: red;">대기</span></c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </section>
    </main>

    <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />
</body>
</html>
                        <tr>
                            <th style="width: 15%;">상품명</th>
                            <th>문의 제목</th>
                            <th style="width: 12%;">작성자</th>
                            <th style="width: 12%;">작성일</th>
                            <th style="width: 10%;">답변여부</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:if test="${empty qnaList}">
                            <tr><td colspan="5">등록된 문의가 없습니다.</td></tr>
                        </c:if>
                        <c:forEach var="qna" items="${qnaList}">
                            <tr onclick="location.href='<c:url value='/seller/qna/${qna.qnaId}/reply'/>'" style="cursor:pointer;">
                                <td>${qna.prodName}</td>
                                <td>
                                    ${qna.qnaTitle}
                                    <c:if test="${qna.qnaIsSecret == 'Y'}"><span style="color: #888; font-size: 0.9em;"> (비밀글)</span></c:if>
                                </td>
                                <td>${qna.memberName}</td>
                                <td><fmt:formatDate value="${qna.qnaRegDate}" pattern="yyyy-MM-dd"/></td>
                                <td>
                                    <c:if test="${qna.replied == 'Y'}"><span style="color: green; font-weight: bold;">완료</span></c:if>
                                    <c:if test="${qna.replied == 'N'}"><span style="color: red;">대기</span></c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
</body>
<script type="text/javascript" src="/js/supportChat.js"></script>
</html>