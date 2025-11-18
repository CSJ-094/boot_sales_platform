<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>결제 실패</title>
    <style>
        body { font-family: sans-serif; text-align: center; padding-top: 50px; }
        .error-box { max-width: 500px; margin: auto; padding: 20px; border: 1px solid #ddd; border-radius: 8px; }
        h1 { color: #dc3545; }
        p { color: #666; }
    </style>
</head>
<body>
    <div class="error-box">
        <h1>결제 실패</h1>
        <p>결제 처리 중 오류가 발생했습니다.</p>
        <p><strong>오류 메시지:</strong> ${message}</p>
        <p><strong>에러 코드:</strong> ${code}</p>
        <br>
        <a href="/">메인으로 돌아가기</a>
    </div>
</body>
</html>