<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>상품 수정</title>
    <link rel="stylesheet" href=<c:url value='/css/sellerstyle.css' />/>
    <link rel="stylesheet" href="<c:url value='/css/header.css' />">
</head>
<body>
	<jsp:include page="/WEB-INF/views/fragments/header.jsp" />
	<main class="mypage-body">
	    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp">
	        <jsp:param name="menu" value="products"/>
	    </jsp:include>

	<section class="mypage-content-area">
	  <h2>상품 수정 (#${product.prodId})</h2>

	  <form action="${pageContext.request.contextPath}/seller/products/${product.prodId}/edit"
	        method="post"
	        enctype="multipart/form-data"
	        class="product-edit-form">

	    <!-- 상단 2열: 왼쪽 이미지, 오른쪽 기본 정보 -->
	    <div class="prod-edit-grid">

			<!-- LEFT: 이미지 편집 -->
			      <section class="prod-image-edit">
			        <h3>상품 이미지</h3>

			        <div class="prod-image-wrapper">
			          <!-- 이미지 박스 -->
			          <div class="current-image-box">
			            <c:choose>
			              <c:when test="${not empty product.prodImgPath}">
			                <img id="product-preview"
			                     src="${pageContext.request.contextPath}${product.prodImgPath}"
			                     alt="${product.prodName}">
			              </c:when>
			              <c:otherwise>
			                <!-- 기본 placeholder 이미지는 프로젝트에 맞게 경로 수정 -->
			                <img id="product-preview"
			                     src="<c:url value='/images/product-placeholder.png'/>"
			                     alt="상품 이미지 없음">
			              </c:otherwise>
			            </c:choose>

			            <!-- X 버튼 (항상 존재) -->
			            <button type="button"
			                    class="img-delete-btn"
			                    id="btn-image-delete"
			                    title="대표 이미지 삭제">×</button>
			          </div>

			          <!-- 삭제 여부를 서버로 넘기는 hidden -->
			          <input type="hidden" name="deleteImage" id="deleteImageFlag" value="false">

			          <!-- 하단 작은 버튼/파일명 -->
			          <div class="image-footer">
			            <label class="image-upload-small">
			              이미지 변경
			              <input type="file"
			                     id="uploadFile"
			                     name="uploadFile"
			                     accept="image/*">
			            </label>
			            <span class="file-name-small" id="fileNameDisplay">선택된 파일 없음</span>
			          </div>
			        </div>
			      </section>

	      <!-- RIGHT: 기본 정보 -->
		  <section class="prod-basic-edit">
		    <h3>기본 정보</h3>

		    <div class="product-form-column">
		      <div class="form-group">
		        <label>상품명</label>
		        <input type="text" name="prodName" value="${product.prodName}" required />
		      </div>

		      <div class="form-group">
		        <label>가격(원)</label>
		        <input type="number" name="prodPrice" value="${product.prodPrice}" required min="0" step="1" />
		      </div>

		      <div class="form-group">
		        <label>재고</label>
		        <input type="number" name="prodStock" value="${product.prodStock}" required min="0" step="1" />
		      </div>

		      <div class="form-group">
		        <label>상품 코드</label>
		        <input type="text" value="${product.prodCode}" readonly />
		      </div>

		      <div class="form-group">
		        <label>상품 설명</label>
		        <textarea name="prodDesc" rows="5">${product.prodDesc}</textarea>
		      </div>
		    </div>
		  </section>

	    </div> <!-- /prod-edit-grid -->

	    <!-- 카테고리 영역: 기존 코드 그대로 유지 -->
	    <section class="product-categories prod-category-edit">
	      <h3>카테고리</h3>
	      <p class="help cat-hint">여러 개 선택 가능 · 대표 1개 지정</p>

	      <div class="cat-accordion">
	        <c:forEach var="top" items="${categories}">
	          <c:if test="${top.depth == 1}">
	            <details class="cat-group" open>
	              <summary class="cat-summary">
	                <span>${top.catName}</span>
	              </summary>

	              <ul class="cat-sublist">
	                <c:forEach var="sub" items="${categories}">
	                  <c:if test="${sub.depth == 2 && sub.catParent == top.catId}">
	                    <li class="cat-subitem">
	                      <label class="cat-label">
	                        <input type="checkbox" name="catIds" value="${sub.catId}" class="cat-check"
	                               <c:if test="${checkedMap[sub.catId]}">checked</c:if> />
	                        <span>${sub.catName}</span>
	                      </label>

	                      <label class="main-radio">
	                        <input type="radio" name="mainCatId" value="${sub.catId}" class="cat-main"
	                               <c:if test="${mainCatIdStr == sub.catId}">checked</c:if> />
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

	    <div class="button-group detail-actions">
	      <button type="submit" class="btn btn-primary">저장</button>
	      <a href="${pageContext.request.contextPath}/seller/products/${product.prodId}" class="btn btn-ghost">취소</a>
	    </div>
	  </form>
	</section>
	</main>

  <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />
  <script>
  (function(){
    // ===== 카테고리 라디오/체크 동기화 =====
    const checks = document.querySelectorAll('.cat-check');
    const mains  = document.querySelectorAll('.cat-main');

    function syncRadios(){
      checks.forEach((chk,i)=>{
        const r = mains[i];
        r.disabled = !chk.checked;
        if (!chk.checked && r.checked) r.checked = false;
      });
      const anyChecked = [...checks].some(c=>c.checked);
      const anyMain    = [...mains].some(r=>r.checked);
      if (anyChecked && !anyMain){
        const i = [...checks].findIndex(c=>c.checked);
        if (i >= 0) mains[i].checked = true;
      }
    }
    checks.forEach(chk=>chk.addEventListener('change', syncRadios));
    syncRadios();

    // ===== 이미지 업로드 / 삭제 =====
    const previewImg   = document.getElementById('product-preview');
    const fileInput    = document.getElementById('uploadFile');
    const deleteBtn    = document.getElementById('btn-image-delete');
    const deleteFlag   = document.getElementById('deleteImageFlag');
    const fileNameSpan = document.getElementById('fileNameDisplay');

    // 원본 이미지 src (없으면 placeholder로)
    const placeholderSrc = '<c:url value="/images/product-placeholder.png"/>';
    const originalSrc = previewImg ? previewImg.getAttribute('src') : placeholderSrc;

    function setFileName(text){
      if (fileNameSpan) fileNameSpan.textContent = text;
    }

    // 파일 선택 시: 미리보기 변경 + 파일명 표시 + 삭제 플래그 해제
    if (fileInput && previewImg) {
      fileInput.addEventListener('change', function(){
        const file = this.files && this.files[0];
        if (file) {
          const url = URL.createObjectURL(file);
          previewImg.src = url;
          setFileName(file.name);
          deleteFlag.value = 'false';  // 새 파일 올리면 삭제 체크는 의미 없게
        } else {
          // 선택 취소했을 때
          previewImg.src = originalSrc || placeholderSrc;
          setFileName('선택된 파일 없음');
        }
      });
    }

    // X 버튼 클릭 시: 이미지 제거 + 파일 입력 초기화 + 삭제 플래그 on
    if (deleteBtn && previewImg) {
      deleteBtn.addEventListener('click', function(e){
        e.preventDefault();
        previewImg.src = placeholderSrc;
        if (fileInput) fileInput.value = '';
        setFileName('선택된 파일 없음');
        deleteFlag.value = 'true';   // 서버에 "이미지 삭제"라고 알림
      });
    }
  })();
  </script>


</body>
</html>
