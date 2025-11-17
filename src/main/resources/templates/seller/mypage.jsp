<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>판매자 마이페이지</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/sellerstyle.css" />
</head>
<body>
	<!-- 공통 header include -->
<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

	<main class="mypage-body">
		<aside class="mypage-sidebar">
			<nav>
				<ul>
					<li class="sidebar-title">판매자 마이페이지</li>
					<li><a href="${pageContext.request.contextPath}/seller/seller/products" class="active">상품 관리</a></li>
					<li><a href="${pageContext.request.contextPath}/seller/orders">주문 내역</a></li>
					<li><a href="${pageContext.request.contextPath}/seller/members">회원 관리</a></li>
					<li><a href="#notice-board">공지사항</a></li>
				</ul>
			</nav>
		</aside>

		<section class="mypage-content-area">
<jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

<script>
document.querySelectorAll('.mypage-sidebar a').forEach(tab => {
  tab.addEventListener('click', function(e) {
    const href = this.getAttribute('href') || '';
    // 해시(#)로 시작하는 링크만 탭 전환 처리
    if (href.startsWith('#')) {
      e.preventDefault();
      document.querySelectorAll('.mypage-sidebar a').forEach(a => a.classList.remove('active'));
      this.classList.add('active');
      document.querySelectorAll('.content-panel').forEach(panel => panel.classList.remove('active'));
      const id = href.replace('#', '') + '-content';
      const target = document.getElementById(id);
      if (target) target.classList.add('active');
    }
    // URL(예: /seller/members)은 기본 동작(페이지 이동) 그대로 둠
  });
});
</script>
</body>
</html>