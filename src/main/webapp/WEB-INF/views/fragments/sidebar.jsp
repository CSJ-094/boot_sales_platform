<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--<link rel="stylesheet" href="<c:url value='/css/sidebar.css' />">--%>
<aside class="mypage-sidebar">
    <nav>
        <ul>
            <li class="sidebar-title">판매자 마이페이지</li>

            <li>
                <a href="<c:url value='/seller/dashboard' />"
                   class="sidebar-link${param.menu eq 'dashboard' ? ' active' : ''}">
                    대시보드
                </a>
            </li>

            <li>
                <a href="<c:url value='/seller/products' />"
                   class="sidebar-link${param.menu eq 'products' ? ' active' : ''}">
                    상품 관리
                </a>
            </li>
			
			<li>
			    <a href="<c:url value='/seller/orders' />"
			       class="sidebar-link${param.menu eq 'orders' ? ' active' : ''}">
			        주문 내역
			    </a>
			</li>
			
            <li>
                <a href="<c:url value='/seller/members' />"
                   class="sidebar-link${param.menu eq 'members' ? ' active' : ''}">
                    회원 관리
                </a>
            </li>

            <li>
                <a href="<c:url value='/seller/qna' />"
                   class="sidebar-link${param.menu eq 'qna' ? ' active' : ''}">
                    문의 관리
                </a>
            </li>

            <li>
                <a href="<c:url value='/seller/reviews' />"
                   class="sidebar-link${param.menu eq 'reviews' ? ' active' : ''}">
                    리뷰 관리
                </a>
            </li>

            <li>
                <a href="<c:url value='/seller/notices' />"
                   class="sidebar-link${param.menu eq 'notices' ? ' active' : ''}">
                    공지사항
                </a>
            </li>
        </ul>
    </nav>
</aside>