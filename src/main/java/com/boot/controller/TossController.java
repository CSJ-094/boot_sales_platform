package com.boot.controller;

import com.boot.service.OrderService;
import com.boot.dto.OrdDTO;
import com.boot.dto.CartDTO;
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
import java.util.List;

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

        // ⭐️ 1. 세션에서 주문할 상품 정보를 가져옵니다.
        List<CartDTO> cartItems = (List<CartDTO>) session.getAttribute("cartItemsForOrder");
        if (cartItems == null || cartItems.isEmpty()) {
            model.addAttribute("message", "주문 정보가 만료되었거나 유효하지 않습니다.");
            model.addAttribute("code", "EXPIRED_ORDER");
            return "toss/fail";
        }

        // ⭐️ 2. 결제 금액 위변조 검증: 세션의 상품 정보로 실제 결제 금액을 다시 계산하여 비교합니다.
        int totalProductPrice = cartItems.stream().mapToInt(item -> item.getProdPrice() * item.getCartQty()).sum();
        final int SHIPPING_FEE = 3000;
        long totalAmount = totalProductPrice + SHIPPING_FEE;

        if (totalAmount != amount) {
            model.addAttribute("message", "결제 금액이 일치하지 않습니다. (요청: " + amount + ", 실제: " + totalAmount + ")");
            model.addAttribute("code", "INVALID_AMOUNT");
            return "toss/fail";
        }

        String secretKey = "test_gsk_docs_OaPz8L5KdmQXkzRz3y47BMw6"; // 공용 테스트 시크릿 키

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
            orderService.createOrderFromCart(memberId, cartItems, orderId, paymentKey, amount);
            session.removeAttribute("cartItemsForOrder");
 
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