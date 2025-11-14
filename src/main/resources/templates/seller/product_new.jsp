<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>신규 상품 등록</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/sellerstyle.css" />
</head>
<body>
    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />

    <main class="mypage-body">
        <aside class="mypage-sidebar">
            <nav>
                <ul>
                    <li class="sidebar-title">판매자 마이페이지</li>
                    <li><a href="${pageContext.request.contextPath}/seller/products" class="active">상품 관리</a></li>
                    <li><a href="${pageContext.request.contextPath}/seller/members">회원 관리</a></li>
                    <li><a href="${pageContext.request.contextPath}/seller/notices">공지사항</a></li>
                </ul>
            </nav>
        </aside>

        <section class="mypage-content-area">
            <h2>신규 상품 등록</h2>

            <form action="${pageContext.request.contextPath}/seller/products" method="post" accept-charset="UTF-8" class="product-form" enctype="multipart/form-data">
                <div class="form-group">
                    <label for="prod_name">상품명</label>
                    <input type="text" id="prod_name" name="prodName" required />
                </div>
                <div class="form-group">
   				<label for="prod_file">상품 이미지</label><br />
    
    			<div class="file-upload-wrapper">
       			<input type="file" id="prod_file" name="uploadFile" class="custom-file-input" accept="image/*" required />
        
        		<label for="prod_file" class="custom-file-label">파일선택</label>
        
        		<span id="fileNameDisplay" class="file-name-display">선택된 파일 없음</span>
        
        		<div class="image-preview-container">
            		<img id="imagePreview" src="#" alt="이미지 미리보기" style="display: none; max-width: 200px; max-height: 200px; margin-top: 10px; border: 1px solid #ddd;"/>
        		</div>
    			</div>
    
    <small style="color:#777;">* JPEG, PNG 등 이미지 파일만 허용됩니다.</small>
</div>
                <div class="form-group">
                    <label for="prod_price">가격 (원)</label>
                    <input type="number" id="prod_price" name="prodPrice" required min="0" step="1" />
                </div>
                <div class="form-group">
                    <label for="prod_stock">재고</label>
                    <input type="number" id="prod_stock" name="prodStock" required min="0" step="1" />
                </div>
                <div class="form-group">
                    <label for="prod_desc">상품 설명</label>
                    <textarea id="prod_desc" name="prodDesc" rows="4" maxlength="4000"></textarea>
                </div>
                 <div class="form-group">
                    <label for="prod_code"></label>
                    <p class="hint">* 상품 코드는 등록 시 자동 부여됩니다.</p>
                </div>
                <section class="product-categories">
                    <h3>카테고리</h3>
                    <p class="help">여러 개 선택 가능 · 대표 1개 지정</p>
                    <div class="cat-accordion">
                        <c:forEach var="top" items="${categories}">
    					<%-- 1단계(depth=1) 카테고리를 그룹(details)의 제목으로 사용 --%>
    					<c:if test="${top.depth == 1}">
      			  <details class="cat-group">
            			<summary class="cat-summary">
                		<span>${top.catName}</span>
            			</summary>

            		<ul class="cat-sublist">
                	<c:forEach var="sub" items="${categories}">
                    <%-- 2단계(depth=2) 카테고리이면서 현재 1단계의 자식인 항목을 하위 목록으로 출력 --%>
                    <c:if test="${sub.depth == 2 && sub.catParent == top.catId}">
                        <li class="cat-subitem">
                            <label class="cat-label">
                                <input type="checkbox" name="catIds" value="${sub.catId}" class="cat-check" <c:if test="${checkedMap[sub.catId]}">checked</c:if> />
                                <span>${sub.catName}</span>
                            </label>
                            <label class="main-radio">
   							 <input type="radio" name="mainCatId" value="${sub.catId}" class="cat-main" <c:if test="${mainCatIdStr == sub.catId}">checked</c:if> />
  							  대표
							</label>
                        </li>
                    </c:if>
                </c:forEach>
            </ul>
        </details>
    </c:if>
</c:forEach>
                    </div>
                </section>

                <c:if test="${not empty sessionScope.seller.selId}">
                    <input type="hidden" name="prodSeller" value="${sessionScope.seller.selId}">
                </c:if>

                <div class="button-group">
                    <button type="submit" class="btn-submit">등록</button>
                    <a href="${pageContext.request.contextPath}/seller/products" class="reset-btn">목록으로</a>
                </div>
            </form>
        </section>
    </main>

    <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />
    
    <script>
(function(){
    const checks = document.querySelectorAll('.cat-check');
    const mains  = document.querySelectorAll('.cat-main');
    
    function syncRadios(){
        checks.forEach((chk,i)=>{
            const r=mains[i];
            r.disabled=!chk.checked;
            if(!chk.checked && r.checked) r.checked=false;
        });
        const anyChecked=[...checks].some(c=>c.checked);
        const anyMain=[...mains].some(r=>r.checked);
        if(anyChecked && !anyMain){
            const i=[...checks].findIndex(c=>c.checked);
            if(i>=0) mains[i].checked=true;
        }
    }
    syncRadios();
    checks.forEach(chk=>chk.addEventListener('change', syncRadios));
    
    const form=document.querySelector('form.product-form');
    if(form){
        form.addEventListener('submit', e=>{
            const selected=[...checks].filter(c=>c.checked).length;
            if(selected===0){
                e.preventDefault(); alert('카테고리를 최소 1개 선택해 주세요.');
            }
        });
    }
})();
    </script>
    <script>
document.addEventListener('DOMContentLoaded', function() {
    const customFileInput = document.getElementById('prod_file'); // ID 변경: prod_file
    const fileNameDisplay = document.getElementById('fileNameDisplay');
    const imagePreview = document.getElementById('imagePreview');

    customFileInput.addEventListener('change', function(event) {
        const file = event.target.files[0];
        
        if (file) {
            fileNameDisplay.textContent = file.name;
            
            const reader = new FileReader();
            reader.onload = function(e) {
                imagePreview.src = e.target.result;
                imagePreview.style.display = 'block';
            };
            reader.readAsDataURL(file);
        } else {
            fileNameDisplay.textContent = '선택된 파일 없음';
            imagePreview.src = '#';
            imagePreview.style.display = 'none';
        }
    });
});
</script>
</body>
</html>