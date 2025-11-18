<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>주문 내역</title>
    <link rel="stylesheet" href="<c:url value='/css/header.css' />">
    <link rel="stylesheet" href="<c:url value='/css/sidebar.css' />" />
    <link rel="stylesheet" href="<c:url value='/css/sellerstyle.css' />" />
    <style>
        .empty-state {
            padding: 40px;
            text-align: center;
            color: #777;
            border: 1px dashed #ddd;
            border-radius: 8px;
            background: #fafafa;
        }

        .table-responsive {
            overflow-x: auto;
        }

        .status-badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 999px;
            background-color: #eef2ff;
            color: #3f51b5;
            font-weight: 600;
            font-size: 0.9rem;
        }

        .status-badge.배송중 {
            background-color: #fff3cd;
            color: #856404;
        }

        .status-badge.결제완료 {
            background-color: #d1ecf1;
            color: #0c5460;
        }

        .status-badge.구매확정 {
            background-color: #d4edda;
            color: #155724;
        }

		/* 송장번호 입력 폼: 위에 택배사, 아래 송장번호+버튼 */
		.tracking-form {
		    display: flex;
		    flex-direction: column;   /* 위/아래 두 줄 */
		    gap: 6px;
		    align-items: flex-start;
		    width: 100%;
		}

		/* 위 줄: 택배사 선택만 */
		.tracking-top {
		    width: 100%;
		}

		.tracking-top select {
		    padding: 6px 10px;
		    border: 1px solid #ddd;
		    border-radius: 4px;
		    font-size: 14px;
		    min-width: 120px;
		}

		/* 아래 줄: 송장번호 입력 + 등록 버튼 */
		.tracking-bottom {
		    display: flex;
		    width: 100%;
		    gap: 8px;
		    align-items: center;
		}

		.tooltip-wrap {
		    position: relative;
		    flex: 1; /* 아래 줄에서 폭 채우기 */
		}

		.tooltip-wrap input {
		    width: 100%;
		    padding: 6px 10px;
		    border: 1px solid #ddd;
		    border-radius: 4px;
		    font-size: 14px;
		}

		.tracking-form button {
		    padding: 6px 16px;
		    background-color: #b08d57;
		    color: white;
		    border: none;
		    border-radius: 4px;
		    cursor: pointer;
		    font-size: 14px;
		    white-space: nowrap;
		}

		.tracking-form button:hover {
		    background-color: #9a7748;
		}

        .tracking-number {
            color: #666;
            font-size: 0.9rem;
            margin-top: 4px;
        }

        .track-btn {
            padding: 4px 12px;
            background-color: #17a2b8;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.85rem;
            margin-left: 8px;
        }

        .track-btn:hover {
            background-color: #138496;
        }

        /* 모달 스타일 */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.4);
        }

        .modal-content {
            background-color: #fefefe;
            margin: 5% auto;
            padding: 20px;
            border: 1px solid #888;
            border-radius: 8px;
            width: 80%;
            max-width: 600px;
        }

        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }

        .close:hover,
        .close:focus {
            color: black;
        }

        .tracking-details {
            margin-top: 20px;
        }

        .tracking-detail-item {
            padding: 12px;
            border-bottom: 1px solid #eee;
        }

        .tracking-detail-item:last-child {
            border-bottom: none;
        }

        .tracking-detail-time {
            font-weight: bold;
            color: #333;
        }

        .tracking-detail-location {
            color: #666;
            margin-top: 4px;
        }

        .tracking-detail-status {
            color: #b08d57;
            margin-top: 4px;
        }

        .loading {
            text-align: center;
            padding: 20px;
            color: #666;
        }
		/* 송장번호 툴팁 */
		.tooltip-wrap {
		    position: relative;
		    flex: 1; /* tracking-form 안에서 나머지 폭 채우기 */
		}

		.tooltip-hint {
		    position: absolute;
		    left: 0;
		    top: calc(100% + 4px);
		    padding: 10px 14px;     /* 조금 넓게 */
		    background: #fff;
		    border: 1px solid #ddd;
		    border-radius: 6px;
		    font-size: 0.8rem;
		    color: #555;
		    line-height: 1.5;

		    width: 260px;           /* 박스 너비 고정 */
		    white-space: normal;    /* 문장 자연스럽게 줄바꿈 */
		    box-shadow: 0 2px 6px rgba(0,0,0,0.1);

		    opacity: 0;
		    visibility: hidden;
		    transition: opacity 0.15s ease;
		    z-index: 50;
		}


		/* 마우스 올리거나, 포커스되면 표시 */
		.tooltip-wrap:hover .tooltip-hint,
		.tooltip-wrap input:focus + .tooltip-hint {
		    opacity: 1;
		    visibility: visible;
		}

    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/fragments/header.jsp" />

<main class="mypage-body">
    <jsp:include page="/WEB-INF/views/fragments/sidebar.jsp">
        <jsp:param name="menu" value="orders"/>
    </jsp:include>

    <section class="mypage-content-area">
        <header class="page-header">
            <div class="page-title">
                <h2>주문 내역</h2>
                <p>사용자 구매 주문 기준으로 판매자 상품만 모아서 보여줍니다.</p>
            </div>
        </header>

        <c:if test="${not empty msg}">
            <div class="alert success" style="margin-bottom:16px; padding:12px; background-color:#d4edda; color:#155724; border-radius:4px;">
                ${msg}
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="alert error" style="margin-bottom:16px; padding:12px; background-color:#f8d7da; color:#721c24; border-radius:4px;">
                ${error}
            </div>
        </c:if>

        <c:if test="${empty orders}">
            <div class="empty-state">
                <p>아직 판매된 주문이 없습니다.</p>
            </div>
        </c:if>

        <c:if test="${not empty orders}">
            <div class="table-responsive">
                <table class="table">
                    <thead>
                    <tr>
                        <th>주문번호</th>
                        <th>구매자</th>
                        <th>상품수량</th>
                        <th>결제금액</th>
                        <th>주문일시</th>
                        <th>상태</th>
                        <th>송장번호</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="order" items="${orders}">
                        <tr>
                            <td>${order.orderId}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty order.buyerName}">
                                        <strong>${order.buyerName}</strong>
                                    </c:when>
                                    <c:otherwise>
                                        <strong>익명 사용자</strong>
                                    </c:otherwise>
                                </c:choose>
                                <br/>
                                <small>${order.buyerId}</small>
                            </td>
                            <td>${order.totalQuantity}</td>
                            <td><fmt:formatNumber value="${order.totalAmount}" type="number" />원</td>
                            <td><fmt:formatDate value="${order.orderDate}" pattern="yyyy-MM-dd HH:mm" /></td>
                            <td>
                                <span class="status-badge ${order.orderStatus}">${order.orderStatus}</span>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty order.trackingNumber}">
                                        <div class="tracking-number">
                                            <strong>${order.deliveryCompany != null ? order.deliveryCompany : ''} ${order.trackingNumber}</strong>
                                            <button class="track-btn" onclick="trackDelivery('${order.deliveryCompany}', '${order.trackingNumber}', '${order.orderId}')">
                                                배송추적
                                            </button>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <c:if test="${order.orderStatus == '결제완료'}">
											<form class="tracking-form"
											      action="${pageContext.request.contextPath}/seller/orders/${order.orderId}/tracking"
											      method="post">

											    <!-- 위 줄: 택배사 선택만 -->
											    <div class="tracking-top">
											        <select name="deliveryCompany"
											                id="deliveryCompany_${order.orderId}"
											                required
											                onchange="updateTrackingPlaceholder('${order.orderId}')">
											            <option value="">택배사 선택</option>
											            <option value="04">CJ대한통운 (12자리)</option>
											            <option value="05">한진택배 (10자리)</option>
											            <option value="08">로젠택배 (10자리)</option>
											            <option value="01">우체국택배 (13자리)</option>
											            <option value="23">경동택배</option>
											            <option value="46">CU편의점택배</option>
											            <option value="24">대신택배</option>
											            <option value="16">한의사랑택배</option>
											            <option value="17">천일택배</option>
											            <option value="18">건영택배</option>
											            <option value="25">일양로지스</option>
											            <option value="26">합동택배</option>
											            <option value="27">한서호남택배</option>
											            <option value="28">GS25</option>
											            <option value="33">동부익스프레스</option>
											        </select>
											    </div>

											    <!-- 아래 줄: 송장번호 입력칸 + 등록 버튼 -->
											    <div class="tracking-bottom">
											        <div class="tooltip-wrap">
											            <input type="text"
											                   name="trackingNumber"
											                   id="trackingNumber_${order.orderId}"
											                   placeholder="송장번호 입력 (예: 123456789012)"
											                   required />
											            <div class="tooltip-hint">
											                ※ 실제 배송된 송장번호를 입력하세요.<br>
											                배송 추적 API로 유효성 검증이 진행됩니다.
											            </div>
											        </div>

											        <button type="submit">등록</button>
											    </div>
											</form>


                                        </c:if>
                                        <c:if test="${order.orderStatus != '결제완료'}">
                                            <span style="color:#999; font-size:0.9rem;">-</span>
                                        </c:if>
                                    </c:otherwise>
                                </c:choose>

                                <%-- '배송중' 상태일 때 '배송완료 처리' 버튼 추가 --%>
                                <c:if test="${order.orderStatus == '배송중'}">
                                    <form action="${pageContext.request.contextPath}/seller/orders/complete" method="post" style="display: inline-block; margin-left: 8px;" onsubmit="return confirm('해당 주문을 배송완료 처리하시겠습니까?');">
                                        <input type="hidden" name="orderId" value="${order.orderId}">
                                        <button type="submit" class="btn btn-success btn-sm" style="padding: 4px 12px; font-size: 0.85rem; background-color: #28a745; border:none; cursor:pointer;">배송완료 처리</button>
                                    </form>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>
    </section>
</main>

<jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

<!-- 배송 추적 모달 -->
<div id="trackingModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeTrackingModal()">&times;</span>
        <h2>배송 추적 정보</h2>
        <div id="trackingContent">
            <div class="loading">배송 정보를 조회하는 중...</div>
        </div>
    </div>
</div>

<script>
function trackDelivery(deliveryCompany, trackingNumber, orderId) {
    const modal = document.getElementById('trackingModal');
    const content = document.getElementById('trackingContent');
    
    modal.style.display = 'block';
    content.innerHTML = '<div class="loading">배송 정보를 조회하는 중...</div>';
    
    // 배송 추적 API 호출
    fetch('${pageContext.request.contextPath}/trackDelivery?t_code=' + deliveryCompany + '&t_invoice=' + trackingNumber)
        .then(response => response.json())
        .then(data => {
            if (data.complete !== undefined) {
                displayTrackingInfo(data);
            } else {
                content.innerHTML = '<div style="color: red; padding: 20px;">배송 정보를 조회할 수 없습니다. 송장번호를 확인해주세요.</div>';
            }
        })
        .catch(error => {
            console.error('Error:', error);
            content.innerHTML = '<div style="color: red; padding: 20px;">배송 정보 조회 중 오류가 발생했습니다.</div>';
        });
}

function displayTrackingInfo(data) {
    const content = document.getElementById('trackingContent');
    let html = '<div class="tracking-details">';
    
    if (data.complete) {
        html += '<div style="background-color: #d4edda; padding: 10px; border-radius: 4px; margin-bottom: 15px;">';
        html += '<strong>배송 완료</strong>';
        html += '</div>';
    }
    
    if (data.itemName) {
        html += '<p><strong>상품명:</strong> ' + data.itemName + '</p>';
    }
    if (data.receiverName) {
        html += '<p><strong>수령인:</strong> ' + data.receiverName + '</p>';
    }
    if (data.senderName) {
        html += '<p><strong>발송인:</strong> ' + data.senderName + '</p>';
    }
    
    if (data.trackingDetails && data.trackingDetails.length > 0) {
        html += '<h3 style="margin-top: 20px;">배송 내역</h3>';
        data.trackingDetails.forEach(function(detail) {
            html += '<div class="tracking-detail-item">';
            html += '<div class="tracking-detail-time">' + (detail.timeString || '') + '</div>';
            html += '<div class="tracking-detail-location">' + (detail.where || '') + '</div>';
            html += '<div class="tracking-detail-status">' + (detail.kind || '') + '</div>';
            if (detail.telno) {
                html += '<div style="color: #666; margin-top: 4px;">연락처: ' + detail.telno + '</div>';
            }
            html += '</div>';
        });
    } else {
        html += '<p style="color: #666;">배송 내역이 없습니다.</p>';
    }
    
    html += '</div>';
    content.innerHTML = html;
}

function closeTrackingModal() {
    document.getElementById('trackingModal').style.display = 'none';
}

// 모달 외부 클릭 시 닫기
window.onclick = function(event) {
    const modal = document.getElementById('trackingModal');
    if (event.target == modal) {
        modal.style.display = 'none';
    }
}

// 택배사 선택에 따라 송장번호 placeholder 업데이트
function updateTrackingPlaceholder(orderId) {
    const select = document.getElementById('deliveryCompany_' + orderId);
    const input = document.getElementById('trackingNumber_' + orderId);
    const selectedValue = select.value;
    
    const placeholders = {
        '04': 'CJ대한통운 송장번호 (12자리 숫자)',
        '05': '한진택배 송장번호 (10자리 숫자)',
        '08': '로젠택배 송장번호 (10자리 숫자)',
        '01': '우체국택배 송장번호 (13자리 숫자)',
        '23': '경동택배 송장번호',
        '46': 'CU편의점택배 송장번호',
        '24': '대신택배 송장번호',
        '16': '한의사랑택배 송장번호',
        '17': '천일택배 송장번호',
        '18': '건영택배 송장번호',
        '25': '일양로지스 송장번호',
        '26': '합동택배 송장번호',
        '27': '한서호남택배 송장번호',
        '28': 'GS25 송장번호',
        '33': '동부익스프레스 송장번호'
    };
    
    if (placeholders[selectedValue]) {
        input.placeholder = placeholders[selectedValue];
    } else {
        input.placeholder = '송장번호 입력';
    }
}

</script>
</body>
</html>
