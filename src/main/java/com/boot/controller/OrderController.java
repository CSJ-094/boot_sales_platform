package com.boot.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import com.boot.dto.CartDTO;
import com.boot.dto.OrdDTO;
import com.boot.service.CartService;
import com.boot.service.OrderService;
import com.boot.dao.OrdDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;


import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/order")
public class OrderController {

    @Autowired
    private OrderService orderService;

    @Autowired
    private CartService cartService; // 주문서에 상품 정보를 표시하기 위해 주입

    @Autowired
    private OrdDAO ordDAO; // 주문 정보 조회를 위해 추가

    /**
     * 주문서 작성 페이지를 보여줍니다.
     */
    @RequestMapping(value = "/form", method = RequestMethod.GET)
    public String showOrderForm(HttpSession session, Model model) {
        String memberId = (String) session.getAttribute("memberId");
        if (memberId == null) {
            return "redirect:/login"; // 로그인되어 있지 않으면 로그인 페이지로
        }

        // 장바구니에서 주문할 상품 목록을 가져와 모델에 추가
        List<CartDTO> cartItems = cartService.getCartListByMemberId(memberId);

        if (cartItems == null || cartItems.isEmpty()) {
            // 장바구니에 상품이 없으면 주문서로 이동할 수 없음
            model.addAttribute("error", "장바구니에 상품이 없습니다.");
            return "redirect:/cart/list"; 
        }

        model.addAttribute("cartItems", cartItems);
        
        // ⭐️ 총 상품 금액 계산
        int totalAmount = cartItems.stream()
                                   .mapToInt(item -> item.getProdPrice() * item.getCartQty())
                                   .sum();
        model.addAttribute("totalAmount", totalAmount);

        // 배송비 설정 (실제로는 DB에서 가져오거나 설정 파일에서 읽어오는 것이 좋음)
        final int SHIPPING_FEE = 3000;
        model.addAttribute("shippingFee", SHIPPING_FEE);
        
        return "order/orderForm"; // order/orderForm.jsp 뷰를 반환
    }

    /**
     * 주문을 생성하고 처리합니다.
     */
    @RequestMapping(value = "/create", method = RequestMethod.POST)
    public String createOrder(HttpSession session, RedirectAttributes redirectAttributes) {
        String memberId = (String) session.getAttribute("memberId");
        if (memberId == null) {
            return "redirect:/login"; // 로그인되어 있지 않으면 로그인 페이지로
        }

        try {
            OrdDTO newOrder = orderService.createOrder(memberId);
            // ⭐️ 주문 객체 대신 주문 ID를 파라미터로 전달
            return "redirect:/order/complete?orderId=" + newOrder.getOrdId();
        } catch (IllegalStateException e) {
            log.error("Order creation failed: {}", e.getMessage());
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/cart/list"; // 장바구니 페이지로 리다이렉트하여 오류 메시지 표시
        } catch (Exception e) {
            log.error("Order creation failed due to unexpected error", e);
            redirectAttributes.addFlashAttribute("error", "주문 처리 중 예상치 못한 오류가 발생했습니다.");
            return "redirect:/cart/list"; 
        }
    }

    /**
     * 주문 완료 페이지를 보여줍니다.
     */
    @RequestMapping(value = "/complete", method = RequestMethod.GET)
    public String showOrderComplete(@RequestParam("orderId") String orderId, Model model, HttpSession session) {
        String memberId = (String) session.getAttribute("memberId");
        OrdDTO order = ordDAO.getOrderByOrderId(orderId);

        // ⭐️ 주문 정보가 없거나, 다른 사람의 주문 정보에 접근하려는 경우 차단
        if (order == null || memberId == null || !order.getOrdMemId().equals(memberId)) {
            return "redirect:/"; // 메인 페이지로 리다이렉트
        }

        model.addAttribute("order", order);
        return "order/orderComplete"; // order/orderComplete.jsp 뷰를 반환
    }

    /**
     * 사용자가 주문을 '구매확정' 상태로 변경합니다.
     */
    @RequestMapping(value = "/confirm", method = RequestMethod.POST)
    public String confirmOrder(@RequestParam("orderId") String orderId, HttpSession session, RedirectAttributes redirectAttributes) {
        String memberId = (String) session.getAttribute("memberId");
        if (memberId == null) {
            return "redirect:/login";
        }

        try {
            // 서비스 계층에 주문 상태 변경 위임
            orderService.confirmOrder(orderId, memberId);
            redirectAttributes.addFlashAttribute("message", "구매가 확정되었습니다.");
        } catch (Exception e) {
            log.error("주문 확정 중 오류 발생: {}", e.getMessage());
            redirectAttributes.addFlashAttribute("error", "처리 중 오류가 발생했습니다.");
        }
        return "redirect:/mypage"; // 마이페이지로 리다이렉트
    }
}
