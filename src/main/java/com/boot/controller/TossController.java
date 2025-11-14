package com.boot.controller;

import com.boot.service.OrderService;
import com.boot.dto.OrdDTO;
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
            @RequestParam("paymentKey") String paymentKey,
            @RequestParam("orderId") String orderId,
            @RequestParam("amount") Long amount,
            HttpSession session,
            Model model) throws Exception {

        String memberId = (String) session.getAttribute("memberId");
        if (memberId == null) {
            return "redirect:/login";
        }

        // 1. ⭐️ DB에서 주문 정보를 조회하여 유효성을 검증합니다.
        OrdDTO order = orderService.getOrderByOrderId(orderId);
        if (order == null) {
            model.addAttribute("message", "존재하지 않는 주문입니다.");
            model.addAttribute("code", "INVALID_ORDER");
            return "toss/fail";
        }

        // 2. ⭐️ 결제 금액 위변조 검증: 요청된 금액과 DB에 저장된 실제 주문 금액을 비교합니다.
        long totalAmount = order.getOrdAmount() + order.getOrdDfee();
        if (totalAmount != amount) {
            model.addAttribute("message", "결제 금액이 일치하지 않습니다. (요청:" + amount + ", 실제:" + totalAmount + ")");
            model.addAttribute("code", "INVALID_AMOUNT");
            // 💡 실제 운영에서는 금액 불일치 시 결제를 강제 취소하는 로직을 추가해야 합니다.
            return "toss/fail";
        }

        // ⚠️ 시크릿 키는 application.yml 또는 .properties 파일에서 관리하세요.
        String secretKey = "test_gsk_docs_OaPz8L5KdmQXkzRz3y47BMw6"; // 공용 테스트 시크릿 키

        // 3. 토스페이먼츠 결제 승인 API 호출
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
            // 4. ⭐️ 결제 승인 성공 시, 주문 상태를 '결제완료'로 업데이트합니다.
            orderService.confirmPayment(orderId, paymentKey, amount);
 
            return "redirect:/order/complete?orderId=" + orderId;
        } else {
            Reader reader = new InputStreamReader(connection.getErrorStream(), StandardCharsets.UTF_8);
            JSONParser parser = new JSONParser();
            JSONObject json = (JSONObject) parser.parse(reader);
            model.addAttribute("message", json.get("message"));
            model.addAttribute("code", json.get("code"));
            return "toss/fail";
        }
    }

    @GetMapping("/fail")
    public String paymentFail(@RequestParam("message") String message, @RequestParam("code") String code, Model model) {
        model.addAttribute("message", message);
        model.addAttribute("code", code);
        return "toss/fail";
    }
}