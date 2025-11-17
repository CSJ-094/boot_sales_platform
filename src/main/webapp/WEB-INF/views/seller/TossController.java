package com.boot.controller;

import com.boot.service.OrderService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.Reader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Base64;

@Controller
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/toss")
public class TossController {

    private final OrderService orderService;

    @GetMapping("/success")
    public String paymentSuccess(
            @RequestParam String paymentKey,
            @RequestParam String orderId,
            @RequestParam Long amount,
            HttpSession session,
            Model model) throws Exception {

        String memberId = (String) session.getAttribute("memberId");
        if (memberId == null) {
            return "redirect:/login";
        }

        // ⚠️ 시크릿 키는 실제 발급받은 키로 변경해야 합니다. (테스트용: test_sk_...)
        // 보안을 위해 외부 설정 파일(application.properties)에서 관리하는 것이 좋습니다.
        String secretKey = "test_sk_zXLkKEypNArWJ2A3g4vNq5vQ1Jlg";

        // 토스페이먼츠 결제 승인 API 호출
        URL url = new URL("https://api.tosspayments.com/v1/payments/confirm");
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setRequestProperty("Authorization", "Basic " + Base64.getEncoder().encodeToString((secretKey + ":").getBytes()));
        connection.setRequestProperty("Content-Type", "application/json");
        connection.setRequestMethod("POST");
        connection.setDoOutput(true);

        JSONObject obj = new JSONObject();
        obj.put("paymentKey", paymentKey);
        obj.put("orderId", orderId);
        obj.put("amount", amount);

        OutputStream outputStream = connection.getOutputStream();
        outputStream.write(obj.toString().getBytes("UTF-8"));

        int code = connection.getResponseCode();
        boolean isSuccess = code == 200;

        if (isSuccess) {
            // 1. 결제 승인 성공 시, 우리 DB에 주문 정보 저장
            orderService.createOrder(memberId); // 기존 주문 생성 로직 재사용

            // 2. 주문 완료 페이지로 이동
            // (실제로는 승인된 결제 정보를 모델에 담아 보여주는 것이 좋습니다)
            return "redirect:/order/complete?orderId=" + orderId;
        } else {
            // 3. 결제 승인 실패 시, 실패 페이지로 이동
            Reader reader = new InputStreamReader(connection.getErrorStream(), StandardCharsets.UTF_8);
            JSONParser parser = new JSONParser();
            JSONObject json = (JSONObject) parser.parse(reader);
            model.addAttribute("message", json.get("message"));
            model.addAttribute("code", json.get("code"));
            return "toss/fail";
        }
    }

    @GetMapping("/fail")
    public String paymentFail(@RequestParam String message, @RequestParam String code, Model model) {
        model.addAttribute("message", message);
        model.addAttribute("code", code);
        return "toss/fail";
    }
}