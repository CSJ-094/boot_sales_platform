<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>판매자 마이페이지</title>
<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600;700;800&family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">

<style>
/* ==================== 전역 설정 및 폰트 ==================== */
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
/* ⭐️ 유저 메인 페이지 강조색 (#886030, #b08d57) 적용 */
a:hover { color: #886030; } 
ul { list-style: none; }
input:focus, textarea:focus, button:focus { outline-color: #b08d57; }

/* ==================== 1. 헤더 (공통 헤더 포함 가정) ==================== */
/* (header.jsp 파일의 스타일이 여기서 깨지지 않도록, 충돌 가능성이 있는 부분은 최소화) */


/* ==================== 2. 바디 & 2단 레이아웃 ==================== */
.mypage-body {
    display: flex;
    max-width: 1200px;
    width: 100%;
    margin: 30px auto; 
    padding: 0 20px;
    flex-grow: 1;
}

/* 사이드바 스타일 */
.mypage-sidebar {
    width: 220px;
    flex-shrink: 0;
    background-color: #ffffff;
    border: 1px solid #e0e0e0;
    border-radius: 6px; 
    box-shadow: 0 2px 5px rgba(0,0,0,0.05);
    height: fit-content;
    margin-right: 20px; 
}
.mypage-sidebar nav ul { list-style: none; padding: 0; }
.sidebar-title {
    font-size: 1.1em;
    font-weight: 700;
    color: #333;
    padding: 15px 20px 10px;
    border-bottom: 2px solid #b08d57; /* ⭐️ 유저 강조색 적용 */
    margin-bottom: 5px;
}
.mypage-sidebar nav ul li a {
    display: block;
    padding: 10px 20px;
    color: #495057;
    font-size: 0.95em;
    transition: all 0.2s;
}
.mypage-sidebar nav ul li a:hover {
    background-color: #f1f1f1;
    color: #b08d57; /* ⭐️ 유저 강조색 적용 */
}
.mypage-sidebar nav ul li a.active {
    background-color: #b08d57; /* ⭐️ 유저 강조색 적용 */
    color: #ffffff;
    font-weight: 500;
    border-radius: 0 6px 6px 0;
    margin-right: -1px; 
}

/* 콘텐츠 영역 */
.mypage-content-area {
    flex-grow: 1;
}

.content-panel {
    background-color: #ffffff;
    padding: 30px;
    border-radius: 6px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05); 
    border: 1px solid #e0e0e0;
    margin-bottom: 30px;
    display: none;
}
.content-panel.active { display: block; }

/* 섹션 제목 스타일 */
.mypage-content-area h2 {
    font-size: 24px; 
    color: #333; 
    border-bottom: 2px solid #b08d57; /* ⭐️ 유저 강조색 적용 */
    padding-bottom: 12px; 
    margin-bottom: 25px; 
    font-weight: 600;
}
.mypage-content-area h3 {
    font-size: 1.3em;
    color: #495057;
    margin-top: 20px;
    margin-bottom: 15px;
    padding-left: 5px;
    border-left: 3px solid #b08d57; /* ⭐️ 유저 강조색 적용 */
}

/* Form Styles */
.product-form div, .notice-form div { margin-bottom: 15px; }
.product-form label, .notice-form label {
    display: block;
    font-weight: 500;
    margin-bottom: 5px;
    color: #495057;
}
.product-form input[type="text"], 
.product-form input[type="number"], 
.product-form textarea,
.notice-form input[type="text"], 
.notice-form textarea {
    width: 100%;
    padding: 10px;
    border: 1px solid #ccc;
    border-radius: 5px;
    box-sizing: border-box;
}
.product-form textarea, .notice-form textarea { resize: vertical; }

/* ⭐️ 버튼 스타일 (유저 메인 페이지 디자인 톤 일치) */
.product-form button, .notice-form button {
    padding: 8px 18px;
    border: 1px solid transparent;
    border-radius: 3px;
    cursor: pointer;
    font-weight: 500;
    font-size: 14px;
    transition: all 0.3s;
}
.product-form button[type="submit"], .notice-form button[type="submit"] {
    background-color: #b08d57; /* ⭐️ 유저 강조색 */
    color: white;
}
.product-form button[type="submit"]:hover, .notice-form button[type="submit"]:hover {
    background-color: #886030; /* ⭐️ 유저 강조색 진하게 */
    color: white;
}
.product-form button[type="reset"], .notice-form button[type="reset"] {
    background-color: #f8f9fa;
    color: #6c757d;
    border-color: #ccc;
}
.product-form button[type="reset"]:hover, .notice-form button[type="reset"]:hover {
    background-color: #e9ecef;
}

/* Table Styles */
table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
    font-size: 0.95em;
}
table th, table td {
    border: 1px solid #ddd;
    padding: 12px;
    text-align: left;
}
table th {
    background-color: #f1f1f1;
    font-weight: 600;
    color: #333;
}
table tbody tr:nth-child(even) {
    background-color: #f9f9f9;
}
table button {
    padding: 4px 8px;
    font-size: 12px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    margin-right: 5px;
}
table button:first-of-type { background-color: #ffc107; color: #333; }
table button:last-of-type { background-color: #dc3545; color: white; }

/* Notice List Style */
#notice-board-content ul { list-style: disc; padding-left: 20px; }
#notice-board-content ul li {
    margin-bottom: 10px;
    padding-bottom: 5px;
    border-bottom: 1px dotted #eee;
    display: flex;
    justify-content: space-between;
}
#notice-board-content ul li a { color: #b08d57; }
#notice-board-content ul li span { font-size: 0.85em; color: #999; }
</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

	<main class="mypage-body">
		<aside class="mypage-sidebar">
			<nav>
				<ul>
					<li class="sidebar-title">판매자 마이페이지</li>
					<li><a href="${pageContext.request.contextPath}/seller/products" class="active">상품 관리</a></li>
					<li><a href="${pageContext.request.contextPath}/seller/orders">주문 관리</a></li>
					<li><a href="${pageContext.request.contextPath}/seller/members">회원 관리</a></li>
					<li><a href="#notice-board">공지사항</a></li>
				</ul>
			</nav>
		</aside>

		<section class="mypage-content-area">

			<div id="products-content" class="content-panel active">
				<h2>상품 관리</h2>

				<section class="product-registration">
					<h3>신규 상품 등록</h3>
					<form action="${pageContext.request.contextPath}/seller/products" method="post" accept-charset="UTF-8" class="product-form">
						<div>
							<label for="prod_name">상품명</label><br /> 
							<input type="text" id="prod_name" name="prodName" required />
						</div>
						<div>
							<label for="prod_price">가격 (원)</label><br /> 
							<input type="number" id="prod_price" name="prodPrice" required pattern="[0-9]+"
								title="숫자만 입력하세요" />
						</div>
						<div>
							<label for="prod_stock">재고</label><br /> 
							<input type="number" id="prod_stock" name="prodStock" required pattern="[0-9]+"
								title="숫자만 입력하세요" />
						</div>
						<div>
							<label for="prod_desc">상품 설명</label><br />
							<textarea id="prod_desc" name="prod_desc" rows="4" maxlength="4000"></textarea>
						</div>
						
						<c:if test="${not empty sessionScope.seller.selId}">
							<input type="hidden" name="prodSeller" value="${sessionScope.seller.selId}">
						</c:if>
						
						<div>
							<button type="submit">상품 등록</button>
							<button type="reset">초기화</button>
						</div>
					</form>
				</section>

				<hr style="margin: 30px 0; border: 0; border-top: 1px solid #eee;" />

				<h3>등록된 상품 목록</h3>
				<table>
					<thead>
						<tr>
							<th>상품명</th>
							<th>가격</th>
							<th>재고</th>
							<th>등록일</th>
							<th>관리</th>
						</tr>
					</thead>
					<tbody>
						<c:choose>
							<c:when test="${not empty prodList}">
								<c:forEach var="prod" items="${prodList}">
									<tr>
										<td>${prod.prodName}</td>
										<td>${prod.prodPrice}원</td>
										<td>${prod.prodStock}</td>
										<td>${prod.prodRegDate}</td>
										<td>
											<button>수정</button>
											<button>삭제</button>
										</td>
									</tr>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<tr>
									<td colspan="5" style="text-align: center; color: #777;">등록된 상품이 없습니다.</td>
								</tr>
							</c:otherwise>
						</c:choose>
						<tr>
							<td>여름 반팔 티셔츠</td>
							<td>19,000원</td>
							<td>120</td>
							<td>2025-10-01</td>
							<td>
								<button>수정</button>
								<button>삭제</button>
							</td>
						</tr>
					</tbody>
				</table>
			</div>

			<div id="orders-content" class="content-panel">
				<h2>주문/배송 관리</h2>
				<p>주문 내역 테이블이 표시될 영역입니다.</p>
			</div>

			<div id="members-content" class="content-panel">
				<h2>회원 관리</h2>
				<p>해당 판매자의 상품을 구매한 회원 목록</p>
				<table>
					<thead>
						<tr>
							<th>회원명</th>
							<th>이메일</th>
							<th>전화번호</th>
							<th>최근 주문일</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>홍길동</td>
							<td>hong@example.com</td>
							<td>010-1111-2222</td>
							<td>2025-10-05</td>
						</tr>
					</tbody>
				</table>
			</div>

			<div id="notice-board-content" class="content-panel">
				<h2>공지사항</h2>
				<ul>
					<li><a href="#">[중요] 추석 연휴 배송 안내</a> <span>2025-09-20</span></li>
					<li><a href="#">[공지] 신규 카테고리 오픈</a> <span>2025-09-10</span></li>
				</ul>
				<hr style="margin: 20px 0; border: 0; border-top: 1px solid #eee;" />
				<section class="notice-write">
					<h3>공지사항 글쓰기</h3>
					<form action="#" method="post" class="notice-form">
						<div>
							<label for="notice_title">제목</label><br /> 
							<input type="text" id="notice_title" name="notice_title" required />
						</div>
						<div>
							<label for="notice_content">내용</label><br />
							<textarea id="notice_content" name="notice_content" rows="6" required></textarea>
						</div>
						<div>
							<button type="submit">등록</button>
							<button type="reset">초기화</button>
						</div>
					</form>
				</section>
			</div>
		</section>
	</main>

	<jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

<script>
document.addEventListener('DOMContentLoaded', function() {
    const sidebarLinks = document.querySelectorAll('.mypage-sidebar a');
    const contentPanels = document.querySelectorAll('.content-panel');
    
    sidebarLinks.forEach(tab => {
        tab.addEventListener('click', function(e) {
            const href = this.getAttribute('href') || '';
            
            // 해시(#)로 시작하거나, 현재 페이지와 같은 페이지 내의 탭을 전환하는 경우
            if (href.startsWith('#') || href.startsWith('${pageContext.request.contextPath}/seller/')) {
                e.preventDefault();
                
                let targetId;

                if (href.startsWith('#')) {
                    // #notice-board -> notice-board-content
                    targetId = href.replace('#', '') + '-content';
                } else {
                    // URL을 기반으로 ID 유추 (products -> products-content)
                    const pathSegment = href.split('/').pop().split('?')[0]; 
                    targetId = pathSegment + '-content';
                }

                // 1. Sidebar Active 클래스 처리
                sidebarLinks.forEach(a => a.classList.remove('active'));
                this.classList.add('active');
                
                // 2. Content Panel Active 클래스 처리
                contentPanels.forEach(panel => panel.classList.remove('active'));
                const target = document.getElementById(targetId);
                if (target) {
                    target.classList.add('active');
                    // 탭 전환 시 URL 해시 변경
                    history.pushState(null, null, '#'+targetId.replace('-content',''));
                }
            }
        });
    });
    
    // 페이지 로드 시 해시를 기반으로 초기 탭 설정
    function activateTabFromHash() {
        const hash = window.location.hash.replace('#', '');
        let initialTargetId = hash ? hash + '-content' : 'products-content'; 
        
        // 유효한 ID가 아니면 기본 탭(products-content)으로 설정
        if (initialTargetId === '-content') {
            initialTargetId = 'products-content';
        }
        
        const initialPanel = document.getElementById(initialTargetId);
        if (initialPanel) {
            contentPanels.forEach(panel => panel.classList.remove('active'));
            initialPanel.classList.add('active');
            
            // 해당 사이드바 링크 활성화
            sidebarLinks.forEach(a => {
                const linkHref = a.getAttribute('href');
                const linkPathSegment = linkHref.split('/').pop().split('?')[0];
                
                if (linkHref.includes(hash) || linkPathSegment === initialTargetId.replace('-content', '')) {
                    sidebarLinks.forEach(a => a.classList.remove('active'));
                    a.classList.add('active');
                }
            });
        }
    }
    
    activateTabFromHash();
    window.addEventListener('hashchange', activateTabFromHash);
});
</script>
</body>
</html>