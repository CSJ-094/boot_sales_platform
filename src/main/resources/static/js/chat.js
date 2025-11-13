// chatbot.js
// JSP 메인페이지에서 <script src="/static/js/chatbot.js"></script> 로 연결하세요.

document.addEventListener("DOMContentLoaded", function () {
    let username = null;

    // --- 1️⃣ 로그인 세션 유저 가져오기 ---
    async function loadUser() {
        try {
            const res = await fetch("/api/session-user", { credentials: "include" });
            if (res.ok) {
                const data = await res.json();
                username = data.username;
            }
        } catch (e) {
            console.error("세션 사용자 불러오기 실패:", e);
        }
    }

    // --- 2️⃣ 챗봇 UI 구성 ---
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
    chatButton.style.boxShadow = "0 6px 16px rgba(0,0,0,0.4)";
    chatButton.style.zIndex = "1000";
    chatButton.style.transition = "transform 0.2s ease, box-shadow 0.2s ease";
    chatButton.onmouseover = () => {
        chatButton.style.transform = "scale(1.08)";
        chatButton.style.boxShadow = "0 8px 20px rgba(99,102,241,0.6)";
    };
    chatButton.onmouseout = () => {
        chatButton.style.transform = "scale(1)";
        chatButton.style.boxShadow = "0 6px 16px rgba(0,0,0,0.4)";
    };

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

    // 헤더
    const header = document.createElement("div");
    header.style.background = "#2A2A3C";
    header.style.color = "#E4E4E7";
    header.style.padding = "12px 16px";
    header.style.display = "flex";
    header.style.justifyContent = "space-between";
    header.style.alignItems = "center";
    header.style.fontWeight = "600";
    header.innerHTML = `
        <span>Eric</span>
        <button id="chatCloseBtn" style="
            background:none;
            border:none;
            color:#E4E4E7;
            font-size:20px;
            cursor:pointer;
            transition:color 0.2s;
        ">✕</button>
    `;
    chatWindow.appendChild(header);

    // 메시지 영역
    const messageArea = document.createElement("div");
    messageArea.style.flex = "1";
    messageArea.style.padding = "12px";
    messageArea.style.overflowY = "auto";
    messageArea.style.background = "#1E1E2F";
    chatWindow.appendChild(messageArea);

    // 입력창
    const inputBox = document.createElement("div");
    inputBox.style.display = "flex";
    inputBox.style.borderTop = "1px solid #2D2D3A";
    inputBox.style.background = "#2A2A3C";
    inputBox.innerHTML = `
        <input id="chatInput" type="text" placeholder="메시지를 입력하세요"
               style="flex:1;padding:10px 12px;background:transparent;color:#E4E4E7;
                      border:none;outline:none;font-size:14px;">
        <button id="chatSend"
                style="background:#6366F1;color:white;border:none;padding:10px 16px;
                       cursor:pointer;font-weight:500;border-radius:0 0 10px 0;
                       transition:background 0.2s;">전송</button>
    `;
    chatWindow.appendChild(inputBox);

    // 페이지에 추가
    document.body.appendChild(chatButton);
    document.body.appendChild(chatWindow);

    // --- 3️⃣ 이벤트 처리 ---

    // 열기
    chatButton.addEventListener("click", async function () {
       
        chatWindow.style.display = "flex";
        chatButton.style.display = "none";
        appendMessage("system", `${username}님, 안녕하세요! 🌙 무엇을 도와드릴까요?`);
    });

    // 닫기
    document.addEventListener("click", function (e) {
        if (e.target.id === "chatCloseBtn") {
            chatWindow.style.display = "none";
            chatButton.style.display = "block";
        }
    });

    // 전송 버튼
    document.getElementById("chatSend").addEventListener("click", sendMessage);

    // 엔터키로도 전송
    document.getElementById("chatInput").addEventListener("keydown", function (e) {
        if (e.key === "Enter") sendMessage();
    });

    // --- 4️⃣ 메시지 처리 ---

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
        } else if (role === "assistant") {
            bubble.style.background = "#2D2D3A";
            bubble.style.color = "#E4E4E7";
        } else {
            bubble.style.background = "#3B3B4F";
            bubble.style.color = "#C0C0C0";
            bubble.style.fontStyle = "italic";
        }

        bubble.textContent = text;
        msg.appendChild(bubble);
        messageArea.appendChild(msg);
        messageArea.scrollTop = messageArea.scrollHeight;
    }

    async function sendMessage() {
        const input = document.getElementById("chatInput");
        const msg = input.value.trim();
        if (!msg) return;
        appendMessage("user", msg);
        input.value = "";

        try {
            const res = await fetch("/api/chat", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                credentials: "include",
                body: JSON.stringify({ message: msg })
            });

            if (!res.ok) {
                appendMessage("system", "⚠️ 서버 오류가 발생했습니다.");
                return;
            }

            const data = await res.json();
            appendMessage("assistant", data.answer);
        } catch (e) {
            appendMessage("system", "❌ 네트워크 오류가 발생했습니다.");
            console.error(e);
        }
    }
});
