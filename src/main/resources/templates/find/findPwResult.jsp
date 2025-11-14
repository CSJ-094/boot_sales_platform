<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html lang="ko">
<head>
    <title>비밀번호 찾기 결과</title>
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
    text-align: center;
}

.result-box { 
    width: 500px;
    padding: 40px; 
    border: 1px solid #e0e0e0; 
    border-radius: 8px; 
    background-color: #fff; 
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
}
h2 { 
    color: #333; 
    margin-bottom: 25px; 
    font-size: 1.8em;
    font-weight: 600;
    border-bottom: 2px solid #b08d57; 
    padding-bottom: 10px;
}
p { 
    color: #666; 
    margin-bottom: 20px; 
    line-height: 1.8;
}
.highlight { 
    color: #b08d57; /* 메인 페이지 호버 색상 */
    font-weight: bold;
}
.login-link { 
    display: inline-block;
    padding: 10px 20px; 
    background-color: #2c2c2c; /* 헤더 배경색 */
    color: white; 
    text-decoration: none; 
    border-radius: 5px; 
    transition: background-color 0.3s;
    font-weight: 500;
    margin-top: 20px;
}
.login-link:hover { 
    background-color: #555;
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
        <div class="result-box">
            <c:choose>
                <c:when test="${not empty member}">
                    <h2>비밀번호 재설정 완료</h2>
                    <p>
                        회원님의 정보가 확인되었습니다.
                        <br>
                        새로운 **임시 비밀번호**는 회원 정보에 등록된 이메일 주소 <span class="highlight">(${dtos[0].memberEmail})</span>로 발송되었습니다.
                    </p>
                    <p>
                        임시 비밀번호로 로그인 후 반드시 <span class="highlight">비밀번호를 변경</span>해 주세요.
                    </p>
                </c:when>
                <c:otherwise>
                    <h2>일치하는 회원 정보가 없습니다.</h2>
                    <p>
                        입력하신 아이디, 이름, 이메일 정보가 일치하는 회원이 없습니다.
                    </p>
                </c:otherwise>
            </c:choose>
            
            <div style="margin-top: 30px;">
                <a href='<c:url value="/login"/>' class="login-link">로그인 페이지로</a>
            </div>
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