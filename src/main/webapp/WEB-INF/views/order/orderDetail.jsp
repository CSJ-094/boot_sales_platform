<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>주문 상세 내역</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        #trackingResultModal {
            border: 1px solid #ccc;
            padding: 20px;
            margin-top: 20px;
            display: none; /* 초기에는 숨김 */
        }
        #trackingInfoBox table { width: 100%; border-collapse: collapse; }
        #trackingInfoBox th, #trackingInfoBox td { border: 1px solid #ddd; padding: 8px; text-align: left; }
    </style>
</head>
<body>

    <h2>주문 상세 정보</h2>
    
	<div id="orderInfo">
	    <p><strong>주문 번호:</strong> ${order.ordId}</p>
	    <p><strong>배송 상태:</strong> ${order.ordStatus}</p>
	    <p><strong>택배사 코드:</strong> ${order.deliveryCompany}</p> 
	    <p><strong>운송장 번호:</strong> ${order.trackingNumber}</p>
	    
	    <button id="trackDeliveryBtn"
	            data-code="${order.deliveryCompany}"  
	            data-invoice="${order.trackingNumber}"> 
	        📦 배송 조회 하기
	    </button>
	</div>

    <div id="trackingResultModal">
        <h3>배송 조회 결과 상세</h3>
        <div id="trackingInfoBox">
            조회 중...
        </div>
        <button id="closeModalBtn">닫기</button>
    </div>

    <script>
    $(document).ready(function() {
        
        // 1. 배송 조회 버튼 클릭 이벤트
        $("#trackDeliveryBtn").on("click", function() {
            
            var t_code = $(this).data("code");
            var t_invoice = $(this).data("invoice");

            // 운송장 정보가 없는 경우 (배송 준비 중 등)
            if (!t_code || !t_invoice) {
                $("#trackingInfoBox").html("<p><strong>⚠ 배송 정보 없음:</strong> 운송장 번호가 등록되지 않았습니다.</p>");
                $("#trackingResultModal").show();
                return;
            }

            // 조회 시작 메시지
            $("#trackingInfoBox").html("<p>배송 정보를 조회 중입니다... 잠시만 기다려주세요.</p>");
            $("#trackingResultModal").show();

            // 2. Ajax를 사용하여 Controller에 요청
            $.ajax({
                type: "GET",
                url: "/trackDelivery", // Controller의 매핑 경로
                data: {
                    t_code: t_code,
                    t_invoice: t_invoice
                },
                success: function(response) {
                    // 3. 조회 성공 시, JSON 데이터를 기반으로 HTML 생성
                    displayTrackingResult(response);
                },
                error: function(xhr) {
                    // 4. 조회 실패 시 (Controller에서 400 Bad Request 반환 등)
                    var errorMessage = xhr.responseText || "알 수 없는 오류가 발생했습니다.";
                    $("#trackingInfoBox").html("<p style='color: red;'>❌ 조회 실패: " + errorMessage + "</p>");
                }
            });
        });

        // 모달 닫기 버튼 이벤트
        $("#closeModalBtn").on("click", function() {
            $("#trackingResultModal").hide();
        });
        
        // 5. 배송 조회 결과를 HTML 테이블로 만드는 함수
        function displayTrackingResult(data) {
            var html = "";
            
            // 기본 정보
            html += "<h4>🚚 운송 정보</h4>";
            html += "<p>상품명: <strong>" + (data.itemName || '정보 없음') + "</strong></p>";
            html += "<p>운송장: <strong>" + (data.invoiceNo || '정보 없음') + "</strong></p>";
            html += "<p>수령인: <strong>" + (data.receiverName || '정보 없음') + "</strong> / 발송인: <strong>" + (data.senderName || '정보 없음') + "</strong></p>";
            html += "<p>배송 완료 여부: <strong style='color:" + (data.complete ? 'blue' : 'orange') + ";'>" + (data.complete ? '✅ 완료' : '진행 중...') + "</strong></p>";
            
            // 상세 내역 테이블
            html += "<hr><h4>⏱️ 배송 단계별 이력</h4>";
            
            if (data.trackingDetails && data.trackingDetails.length > 0) {
                html += "<table>";
                html += "<thead><tr><th>시간</th><th>배송 상태</th><th>현재 위치</th><th>담당자 연락처</th></tr></thead>";
                html += "<tbody>";
                
                // 최신 이력을 위로 보이도록 역순으로 반복
                for (var i = data.trackingDetails.length - 1; i >= 0; i--) {
                    var detail = data.trackingDetails[i];
                    
                    html += "<tr>";
                    html += "<td>" + (detail.timeString || '-') + "</td>";
                    html += "<td>" + (detail.kind || '-') + "</td>";
                    html += "<td>" + (detail.where || '-') + "</td>";
                    html += "<td>" + (detail.telno || '-') + "</td>";
                    html += "</tr>";
                }
                
                html += "</tbody></table>";
            } else {
                 html += "<p>상세 배송 이력이 없습니다.</p>";
            }

            $("#trackingInfoBox").html(html);
        }
    });
    </script>
</body>
</html>