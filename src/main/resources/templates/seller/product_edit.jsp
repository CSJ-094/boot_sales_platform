<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>


<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>상품 수정</title>
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
      <h2>상품 수정 (#${product.prodId})</h2>

      <form action="${pageContext.request.contextPath}/seller/products/${product.prodId}/edit" method="post" class="product-form">
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
          <textarea name="prodDesc" rows="6">${product.prodDesc}</textarea>
        </div>
<section class="product-categories">
    <h3>카테고리</h3>
    <p class="help">여러 개 선택 가능 · 대표 1개 지정</p>

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
		

        <div class="button-group">
          <button type="submit" class="btn-submit">저장</button>
          <a href="${pageContext.request.contextPath}/seller/products/${product.prodId}" class="reset-btn">취소</a>
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
  checks.forEach(chk=>chk.addEventListener('change', syncRadios));
})();
</script>
</body>
</html>
