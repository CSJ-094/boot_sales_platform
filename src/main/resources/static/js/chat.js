document.addEventListener("DOMContentLoaded", function () {

    // 채팅방 (GPT / 상담원)
    const chatRooms = [
        { id: "room1", name: "Eric", apiUrl: "/api/chat", type: "gpt" },
        { id: "room2", name: "상담원 채팅방", apiUrl: "/api/support", type: "support" }
    ];

    let currentRoom = chatRooms[0];
    let sse = null;   // 상담원용 SSE 연결

    // --- 채팅 버튼 ---
    const chatButton = document.createElement("button");
    chatButton.innerText = "💬";
    chatButton.style.position = "fixed";
    chatButton.style.bottom = "24px";
    chatButton.style.right = "24px";
    chatButton.style.width = "64px";
    chatButton.style.height = "64px";
    chatButton.style.borderRadius = "50%";
    chatButton.style.background = "linear-gradient(145deg, #6366F1, #4F46E5)";
    chatButton.style.color = "white";
    chatButton.style.fontSize = "26px";
    chatButton.style.border = "none";
    chatButton.style.cursor = "pointer";
    chatButton.style.zIndex = "1000";
    document.body.appendChild(chatButton);

    // --- 채팅창 ---
    const chatWindow = document.createElement("div");
    chatWindow.style.position = "fixed";
    chatWindow.style.bottom = "100px";
    chatWindow.style.right = "24px";
    chatWindow.style.width = "360px";
    chatWindow.style.height = "520px";
    chatWindow.style.background = "#1E1E2F";
    chatWindow.style.border = "1px solid #2D2D3A";
    chatWindow.style.borderRadius = "16px";
    chatWindow.style.display = "none";
    chatWindow.style.flexDirection = "column";
    chatWindow.style.overflow = "hidden";
    chatWindow.style.boxShadow = "0 10px 25px rgba(0,0,0,0.5)";
    chatWindow.style.zIndex = "1000";
    chatWindow.style.color = "#E4E4E7";
    chatWindow.style.fontFamily = "Inter, Pretendard, sans-serif";
    document.body.appendChild(chatWindow);

    // --- 헤더 + 방전환 ---
    const header = document.createElement("div");
    header.style.background = "#2A2A3C";
    header.style.color = "#E4E4E7";
    header.style.padding = "12px 16px";
    header.style.display = "flex";
    header.style.justifyContent = "space-between";
    header.style.alignItems = "center";

    const titleSpan = document.createElement("span");
    titleSpan.innerText = currentRoom.name;

    const switchBtn = document.createElement("button");
    switchBtn.innerText = "상담원 연결";
    switchBtn.style.background = "none";
    switchBtn.style.border = "1px solid #6366F1";
    switchBtn.style.color = "#E4E4E7";
    switchBtn.style.padding = "4px 8px";
    switchBtn.style.cursor = "pointer";
    switchBtn.style.borderRadius = "6px";

    const closeBtn = document.createElement("button");
    closeBtn.innerText = "✕";
    closeBtn.style.background = "none";
    closeBtn.style.border = "none";
    closeBtn.style.color = "#E4E4E7";
    closeBtn.style.fontSize = "20px";
    closeBtn.style.cursor = "pointer";

    header.appendChild(titleSpan);
    header.appendChild(switchBtn);
    header.appendChild(closeBtn);
    chatWindow.appendChild(header);

    // --- 메시지 영역 ---
    const messageArea = document.createElement("div");
    messageArea.style.flex = "1";
    messageArea.style.padding = "12px";
    messageArea.style.overflowY = "auto";
    chatWindow.appendChild(messageArea);

    // --- 입력창 ---
    const inputBox = document.createElement("div");
    inputBox.style.display = "flex";
    inputBox.style.borderTop = "1px solid #2D2D3A";
    inputBox.style.background = "#2A2A3C";
    inputBox.innerHTML = `
        <input type="text" placeholder="메시지를 입력하세요"
               style="flex:1;padding:10px 12px;background:transparent;color:#E4E4E7;
                      border:none;outline:none;font-size:14px;">
        <button style="background:#6366F1;color:white;border:none;padding:10px 16px;
                       cursor:pointer;font-weight:500;">전송</button>
    `;
    chatWindow.appendChild(inputBox);

    const sendBtn = inputBox.querySelector("button");
    const inputField = inputBox.querySelector("input");

    // --- 메시지 출력 ---
    function appendMessage(role, text) {
        const msg = document.createElement("div");
        msg.style.margin = "8px 0";
        msg.style.display = "flex";
        msg.style.justifyContent = role === "user" ? "flex-end" : "flex-start";

        const bubble = document.createElement("div");
        bubble.style.padding = "10px 14px";
        bubble.style.borderRadius = "14px";
        bubble.style.maxWidth = "75%";
        bubble.style.fontSize = "14px";
        bubble.style.lineHeight = "1.5";

        if (role === "user") {
            bubble.style.background = "#6366F1";
            bubble.style.color = "white";
        } else {
            bubble.style.background = "#2D2D3A";
            bubble.style.color = "#E4E4E7";
        }

        bubble.innerHTML = text.replace(/\n/g, "<br>");
        msg.appendChild(bubble);
        messageArea.appendChild(msg);
        messageArea.scrollTop = messageArea.scrollHeight;
    }

    // --- GPT 메시지 전송 ---
    async function sendToGPT(msg) {
        const res = await fetch("/api/chat", {
            method: "POST",
            headers: {"Content-Type": "application/json"},
            body: JSON.stringify({ message: msg })
        });

        const data = await res.json();
        appendMessage("assistant", data.answer);
    }

    // --- 상담원에게 메시지 전송 ---
    async function sendToSupport(msg) {
		await fetch("/api/support", {
		    method: "POST",
		    headers: { "Content-Type": "application/json" },
		    body: JSON.stringify({
		        sender: "customer",
		        msg: msg
		    })
		});

    }

    // --- 상담원 메시지 수신(SSE) ---
	// --- 상담원 메시지 수신(SSE) ---
	function connectSSE() {
	    if (sse) sse.close();

	    sse = new EventSource("/api/support/stream");

	    sse.onmessage = (event) => {
	        try {
	            const chat = JSON.parse(event.data);

	            // null 메시지는 무시
	            if (chat.sender === "customer") return;

	            // sender 기반으로 말풍선 정렬
	            const role = chat.sender === "customer" ? "user" : "assistant";

	            appendMessage(role, chat.msg);
	        } catch (e) {
	            console.error("Invalid SSE message:", event.data);
	        }
	    };

	    sse.onerror = () => {
	        console.log("SSE 연결 종료됨");
	    };
	}


    function disconnectSSE() {
        if (sse) {
            sse.close();
            sse = null;
        }
    }

    // --- 메시지 전송 ---
    async function sendMessage() {
        const msg = inputField.value.trim();
        if (!msg) return;

        appendMessage("user", msg);
        inputField.value = "";

        if (currentRoom.type === "gpt") {
            sendToGPT(msg);
        } else {
            sendToSupport(msg);
        }
    }

    // --- 채팅 버튼 열기 ---
    chatButton.addEventListener("click", () => {
        chatWindow.style.display = "flex";
        chatButton.style.display = "none";

        appendMessage("system",
            `환영합니다 고객님, 안녕하세요! 🌙 도움이 필요하시면 도움이라고 말씀해주세요!`
        );

        // GPT 방이 기본이므로 SSE OFF
        disconnectSSE();
    });

    // --- 닫기 ---
    closeBtn.addEventListener("click", () => {
        chatWindow.style.display = "none";
        chatButton.style.display = "block";
        disconnectSSE();
    });

    // --- 전송 이벤트 ---
    sendBtn.addEventListener("click", sendMessage);
    inputField.addEventListener("keydown", (e) => {
        if (e.key === "Enter") sendMessage();
    });

    // --- 방 전환 ---
    switchBtn.addEventListener("click", () => {

        const nextIndex = (chatRooms.indexOf(currentRoom) + 1) % chatRooms.length;
        currentRoom = chatRooms[nextIndex];

        titleSpan.innerText = currentRoom.name;
        messageArea.innerHTML = "";

        if (currentRoom.type === "support") {
            appendMessage("system", "상담원 연결되었습니다. 잠시만 기다려주세요.");
            connectSSE();
        } else {
            appendMessage("system", "환영합니다 고객님, 안녕하세요! 🌙 도움이 필요하시면 도움이라고 말씀해주세요!");
            disconnectSSE();
        }
    });
});
