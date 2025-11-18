<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>룰렛 이벤트</title>
    <style>
        #roulette-popup {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.6); /* 배경 어둡게 */
            z-index: 1000;
            justify-content: center;
            align-items: center;
            font-family: 'Noto Sans KR', 'Montserrat', sans-serif;
        }
        #roulette-content {
            background-color: #ffffff;
            padding: 25px 30px;
            border-radius: 12px; /* 둥근 모서리 */
            text-align: center;
            max-width: 450px;
            width: 90%;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.15); /* 부드러운 그림자 */
        }
        #roulette-content h2 {
            font-size: 22px;
            font-weight: 600;
            color: #333;
            margin-bottom: 15px;
        }
        #canvas {
            margin: 20px auto;
            display: block;
        }
        .roulette-buttons {
            display: flex;
            justify-content: center;
            gap: 10px; /* 버튼 사이 간격 */
            margin-top: 20px;
        }
        #spin_button, #close_button {
            padding: 12px 25px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            border: none;
            border-radius: 8px; /* 둥근 모서리 */
            transition: background-color 0.3s ease, color 0.3s ease;
        }
        #spin_button {
            background-color: #2c2c2c; /* 메인 버튼 색상 */
            color: white;
        }
        #spin_button:hover {
            background-color: #b08d57; /* 호버 시 포인트 색상 */
        }
        #close_button {
            background-color: #e0e0e0; /* 보조 버튼 색상 */
            color: #555;
        }
        #close_button:hover {
            background-color: #c7c7c7;
        }
    </style>
</head>
<body>

<div id="roulette-popup">
    <div id="roulette-content">
        <h2>로그인 환영! 룰렛을 돌려 쿠폰을 받으세요!</h2>
        <canvas id="canvas" width="400" height="400"></canvas>
        <div class="roulette-buttons">
            <button id="spin_button" onclick="startSpin();">룰렛 돌리기!</button>
            <button id="close_button" onclick="closeRoulettePopup(true);">다음에 할게요</button>
        </div>
    </div>
</div>

<%-- ⭐️ 라이브러리 로드 (로컬 경로로 수정) --%>
<script src="<c:url value='/js/gsap.min.js'/>"></script>
<script src="<c:url value='/js/Winwheel.min.js'/>"></script>

<script>
    let theWheel = null;
    let wheelSpinning = false;
    const roulettePopup = document.getElementById('roulette-popup');

    function initializeRoulette() {
        if (theWheel) return;

        theWheel = new Winwheel({
            'canvasId': 'canvas',
            'numSegments': 8,
            'outerRadius': 180,
            'textFontSize': 16,
            'textFillStyle': '#333', // 텍스트 색상
            'segments': [
                {'fillStyle': '#f5f5f5', 'text': '꽝'},
                {'fillStyle': '#e0e0e0', 'text': '1000원'},
                {'fillStyle': '#f5f5f5', 'text': '꽝'},
                {'fillStyle': '#b08d57', 'text': '5% 할인', 'textFillStyle': 'white'},
                {'fillStyle': '#f5f5f5', 'text': '꽝'},
                {'fillStyle': '#e0e0e0', 'text': '5000원'},
                {'fillStyle': '#f5f5f5', 'text': '꽝'},
                {'fillStyle': '#c7a573', 'text': '10% 할인', 'textFillStyle': 'white'}
            ],
            'animation': {
                'type': 'spinToStop',
                'duration': 7, // 회전 시간 증가
                'spins': 10,   // 회전 수 증가
                'callbackFinished': alertPrize,
                'callbackAfter': drawTriangle
            },
            'pins': {
                'number': 16, // 핀 추가로 생동감 부여
                'fillStyle': 'silver',
                'outerRadius': 4,
            }
        });
        drawTriangle();
    }

    function drawTriangle() {
        if (!theWheel) return;
        let ctx = theWheel.ctx;
        ctx.strokeStyle = '#444';
        ctx.fillStyle   = '#b08d57'; // 포인터 색상을 포인트 색상으로 변경
        ctx.lineWidth   = 2;
        ctx.beginPath();
        ctx.moveTo(175, 5);
        ctx.lineTo(225, 5);
        ctx.lineTo(200, 45);
        ctx.lineTo(175, 5);
        ctx.stroke();
        ctx.fill();
    }

    function startSpin() {
        if (wheelSpinning || !theWheel) return;
        wheelSpinning = true;
        document.getElementById('spin_button').disabled = true;

        fetch('<c:url value="/api/spin-roulette"/>', { method: 'POST' })
            .then(response => response.ok ? response.json() : Promise.reject(response))
            .then(data => {
                let stopAt = theWheel.getRandomForSegment(data.resultSegment);
                theWheel.animation.stopAngle = stopAt;
                theWheel.startAnimation();
            })
            .catch(error => {
                console.error('룰렛 돌리기 오류:', error);
                alert('룰렛 결과 처리 중 오류가 발생했습니다. 다시 시도해주세요.');
                wheelSpinning = false;
                document.getElementById('spin_button').disabled = false;
                closeRoulettePopup(false);
            });
    }

    function alertPrize(indicatedSegment) {
        const resultText = indicatedSegment.text;
        if (resultText === '꽝') {
            alert("아쉽지만 다음 기회에!");
        } else {
            alert("축하합니다! '" + resultText + "'에 당첨되셨습니다!");
        }
        
        closeRoulettePopup(true);
        theWheel.stopAnimation(false);
        theWheel.rotationAngle = 0;
        theWheel.draw();
        drawTriangle();
        wheelSpinning = false;
        document.getElementById('spin_button').disabled = false;
    }

    function showRoulettePopup() {
        if (roulettePopup) roulettePopup.style.display = 'flex';
        if (!theWheel) initializeRoulette();
    }

    function closeRoulettePopup(shouldClearFlag) {
        if (roulettePopup) roulettePopup.style.display = 'none';
        wheelSpinning = false;
        document.getElementById('spin_button').disabled = false;

        if (shouldClearFlag) {
            fetch('<c:url value="/api/roulette/clear-flag"/>')
                .then(response => console.log("룰렛 플래그 제거 요청 완료"))
                .catch(error => console.error('플래그 제거 오류:', error));
        }
    }

    (function() {
        let showEvent = ${showRouletteEvent == true};
        if (showEvent) {
            window.addEventListener('load', showRoulettePopup);
        }
    })();
</script>

</body>
</html>
