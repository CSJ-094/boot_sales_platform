<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>아이디 찾기</title>
<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600;700;800&family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
<style>
/* ==================== mainpage.jsp 스타일에서 가져옴 ==================== */
* { box-sizing: border-box; margin: 0; padding: 0; }
body { 
    font-family: 'Noto Sans KR', 'Montserrat', sans-serif; 
    color: #333; 
    line-height: 1.6; 
    background-color: #f9f9f9; 
    min-height: 100vh;
    display: flex;
    flex-direction: column;
}
a { text-decoration: none; color: inherit; transition: color 0.3s ease; }
a:hover { color: #886030; }

/* ==================== 1. 헤더 (mainpage.jsp 기반) ==================== */
.main-header { 
    width: 100%; 
    background-color: #2c2c2c;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2); 
    padding: 10px 0 5px 0; 
    position: sticky; 
    top: 0;
    z-index: 100;
}

.header-top { 
    max-width: 1200px; 
    margin: 0 auto; 
    display: flex; 
    justify-content: flex-start;
    align-items: center; 
    padding: 0 20px 5px; 
}

.logo a { 
    font-family: 'Montserrat', sans-serif; 
    font-size: 18px; 
    font-weight: 800; 
    color: #ffffff; 
    letter-spacing: 1px;
    transition: color 0.3s ease;
}
.logo a:hover {
    color: #b08d57; 
}

/* ==================== 2. 콘텐츠 영역 스타일 ==================== */
.content-wrapper {
    flex-grow: 1;
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 50px 20px;
}
.container {
	width: 400px;
	padding: 30px;
    background-color: #ffffff;
    border-radius: 8px; 
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1); 
    border: 1px solid #e0e0e0; 
}

.form-title { 
	text-align: center;
	margin-bottom: 25px;
	color: #333;
    font-weight: 600;
    font-size: 1.8em;
    border-bottom: 2px solid #b08d57; 
    padding-bottom: 10px;
}

.form-group {
	margin-bottom: 15px;
	display: flex;
	align-items: center;
}

.form-group label {
	width: 100px;
	font-weight: 500;
    color: #555;
}

.form-group input {
	flex: 1;
	padding: 8px;
	border: 1px solid #ddd;
	border-radius: 4px;
    font-family: 'Noto Sans KR', sans-serif;
}

.form-actions {
	text-align: center;
	margin-top: 30px;
}
.form-actions button {
    padding: 10px 20px;
    background-color: #b08d57; /* 메인 페이지 호버 색상 */
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
	font-size: 16px;
    font-weight: 500;
    transition: background-color 0.3s, transform 0.1s;
}
.form-actions button:hover {
    background-color: #886030;
    transform: translateY(-1px);
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
    <header class="main-header">
        <div class="header-top">
            <div class="logo">
                <a href="/">MY MODERN SHOP</a>
            </div>
        </div>
    </header>
    <div class="content-wrapper">
        <div class="container">
            <h2 class="form-title">아이디 찾기</h2>
            <form id="findIdForm" method="post" action="findIdCheck">
                <div class="form-group">
                    <label for="memberName">이름</label> 
                    <input type="text" id="memberName" name="memberName" size="20" required>
                </div>
                
                <div class="form-group">
                    <label for="memberEmail">이메일</label> 
                    <input type="email" id="memberEmail" name="memberEmail" size="20" required>
                </div>
                
                <div class="form-actions">
                    <button type="submit">아이디 찾기</button>
                </div>
            </form>
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