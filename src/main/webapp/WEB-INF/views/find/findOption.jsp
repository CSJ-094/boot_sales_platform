<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>회원 정보 찾기</title>
<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600;700;800&family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<c:url value='/css/header.css' />">
<style>
/* ==================== mainpage.jsp 스타일에서 가져옴 ==================== */
* { box-sizing: border-box; margin: 0; padding: 0; }
body { 
    font-family: 'Noto Sans KR', 'Montserrat', sans-serif; 
    color: #333; 
    line-height: 1.6; 
    background-color: #f9f9f9; /* 메인 페이지와 동일한 배경색 */
    min-height: 100vh;
    display: flex;
    flex-direction: column;
}
a { text-decoration: none; color: inherit; transition: color 0.3s ease; }
a:hover { color: #886030; }

/* ==================== 2. 콘텐츠 영역 스타일 ==================== */
.content-wrapper {
    flex-grow: 1;
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 50px 20px;
}

.container {
    width: 450px;
    padding: 40px;
    background-color: #ffffff;
    border-radius: 8px; /* 메인 페이지 상품 박스 (6px)와 유사하게 */
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1); /* 상품 hover 효과와 유사 */
    border: 1px solid #e0e0e0; /* 상품 item 테두리와 유사 */
    text-align: center;
}
.form-title {
    color: #333;
    font-size: 1.8em;
    margin-bottom: 30px;
    font-weight: 600;
    border-bottom: 2px solid #b08d57; /* 메인 페이지 추천 상품 제목 border와 유사 */
    padding-bottom: 10px;
}
.button-group {
    display: flex;
    justify-content: space-between;
    gap: 20px;
}
.btn {
    flex: 1;
    padding: 15px 20px;
    font-size: 1.1em;
    font-weight: 500;
    cursor: pointer;
    border: none;
    border-radius: 5px; 
    transition: background-color 0.3s, transform 0.1s;
    text-decoration: none;
    color: #fff;
    display: block;
}
.btn-id {
    background-color: #b08d57; /* 메인 페이지 호버 색상 */
}
.btn-pw {
    background-color: #886030; /* 메인 페이지 a:hover 색상 */
}
.btn:hover {
    filter: brightness(1.2);
    transform: translateY(-1px);
}
.btn:active {
    transform: translateY(0);
}
.back-link {
    display: block;
    margin-top: 30px;
    color: #6c757d;
    text-decoration: none;
    font-size: 0.9em;
}
.back-link:hover {
    color: #b08d57;
}

/* ==================== 3. 푸터 (mainpage.jsp 기반) ==================== */
.main-footer { 
    background-color: #e0e0e0; 
    color: #666; 
    padding: 25px 0; 
    margin-top: auto; 
    font-size: 13px; 
    border-top: 1px solid #d0d0d0;
    box-shadow: 0 -2px 8px rgba(0, 0, 0, 0.05);
}
.footer-content { 
    max-width: 1200px; 
    margin: 0 auto; 
    padding: 0 20px; 
    text-align: center;
}
.footer-content p {
    margin-bottom: 4px;
}
</style>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/header.jsp" />
    <div class="content-wrapper">
        <div class="container">
            <h2 class="form-title">회원 정보 찾기</h2>
            <div class="button-group">
                <a href="findId" class="btn btn-id">아이디 찾기</a>
                <a href="findPw" class="btn btn-pw">비밀번호 찾기</a>
            </div>
            <a href='<c:url value="/login"/>' class="back-link">로그인 페이지로 돌아가기</a>
        </div>
    </div>

    <footer class="main-footer">
        <div class="footer-content">
            <p class="company-info">© 2025 MY MODERN SHOP. All Rights Reserved.</p>
            <p>대표자: 김모던 | 사업자 등록번호: 123-45-67890 | 고객센터: 1588-XXXX</p>
        </div>
    </footer>
    </body>
</html>