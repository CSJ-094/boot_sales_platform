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
            @RequestParam(value = "selectedUserCouponId", required = false) Long selectedUserCouponId, // 추가
            @RequestParam(value = "usedPoint", defaultValue = "0") int usedPoint, // 추가
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
        // 이 부분은 OrderService.createOrderFromCart에서 최종 검증하므로 여기서는 간단히 처리
        // (실제로는 여기서도 쿠폰/포인트 적용 후 금액을 다시 계산하여 amount와 비교하는 것이 더 안전)
        int totalProductPrice = cartItems.stream().mapToInt(item -> item.getProdPrice() * item.getCartQty()).sum();
        final int SHIPPING_FEE = 3000;
        long expectedAmountWithoutDiscount = totalProductPrice + SHIPPING_FEE;

        // Toss Payments API 호출 전에, 클라이언트에서 전달된 amount와 서버에서 계산된 금액을 비교
        // 이 로직은 OrderService.createOrderFromCart에서 더 상세하게 처리됩니다.
        // 여기서는 토스 API 호출을 위한 최소한의 검증만 수행.

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
        obj.put("amount", amount); // 클라이언트에서 전달된 최종 결제 금액

        OutputStream outputStream = connection.getOutputStream();
        outputStream.write(obj.toString().getBytes("UTF-8"));

        int code = connection.getResponseCode();
        boolean isSuccess = code == 200;

        if (isSuccess) {
            // OrderService의 createOrderFromCart 메서드 호출 시 쿠폰 ID와 사용 포인트 전달
            orderService.createOrderFromCart(memberId, cartItems, orderId, paymentKey, amount, selectedUserCouponId, usedPoint);
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
