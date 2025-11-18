package com.boot.controller;

import java.util.List;
import java.util.Date;

import javax.servlet.http.HttpSession;

import com.boot.dto.CartDTO;
import com.boot.dto.OrdDTO;
import com.boot.service.CartService;
import com.boot.service.OrderService;
import com.boot.service.UserCouponService;
import com.boot.service.PointService;
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
    private CartService cartService;

    @Autowired
    private OrdDAO ordDAO;

    @Autowired
    private UserCouponService userCouponService;
    @Autowired
    private PointService pointService;

    @RequestMapping(value = "/form", method = RequestMethod.POST)
    public String showOrderForm(@RequestParam("selectedCartIds") List<Integer> selectedCartIds, HttpSession session, Model model) {
        String memberId = (String) session.getAttribute("memberId");
        if (memberId == null) {
            return "redirect:/login";
        }

        if (selectedCartIds == null || selectedCartIds.isEmpty()) {
            model.addAttribute("error", "주문할 상품을 선택해주세요.");
            return "redirect:/cart/list";
        }

        // 선택된 cartId에 해당하는 상품 목록만 조회
        List<CartDTO> cartItems = cartService.getCartListByCartIds(memberId, selectedCartIds);

        if (cartItems == null || cartItems.isEmpty()) {
            model.addAttribute("error", "주문할 상품 정보를 찾을 수 없습니다.");
            return "redirect:/cart/list";
        }

        session.setAttribute("cartItemsForOrder", cartItems);
        model.addAttribute("cartItems", cartItems);

        int totalAmount = cartItems.stream()
                .mapToInt(item -> item.getProdPrice() * item.getCartQty())
                .sum();
        model.addAttribute("totalAmount", totalAmount);

        final int SHIPPING_FEE = 3000;
        model.addAttribute("shippingFee", SHIPPING_FEE);

        model.addAttribute("userCoupons", userCouponService.getUserCouponsByMemberId(memberId));
        model.addAttribute("currentPoint", pointService.getCurrentPoint(memberId));
        model.addAttribute("now", new Date());

        return "order/orderForm";
    }

    @RequestMapping(value = "/create", method = RequestMethod.POST)
    public String createOrder(HttpSession session, RedirectAttributes redirectAttributes) {
        String memberId = (String) session.getAttribute("memberId");
        if (memberId == null) {
            return "redirect:/login";
        }

        try {
            OrdDTO newOrder = orderService.createOrder(memberId);
            return "redirect:/order/complete?orderId=" + newOrder.getOrdId();
        } catch (IllegalStateException e) {
            log.error("Order creation failed: {}", e.getMessage());
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/cart/list";
        } catch (Exception e) {
            log.error("Order creation failed due to unexpected error", e);
            redirectAttributes.addFlashAttribute("error", "주문 처리 중 예상치 못한 오류가 발생했습니다.");
            return "redirect:/cart/list";
        }
    }

    @RequestMapping(value = "/complete", method = RequestMethod.GET)
    public String showOrderComplete(@RequestParam("orderId") String orderId, Model model, HttpSession session) {
        String memberId = (String) session.getAttribute("memberId");
        OrdDTO order = ordDAO.getOrderByOrderId(orderId);

        if (order == null || memberId == null || !order.getOrdMemId().equals(memberId)) {
            return "redirect:/";
        }

        model.addAttribute("order", order);
        return "order/orderComplete";
    }

    @RequestMapping(value = "/confirm", method = RequestMethod.POST)
    public String confirmOrder(@RequestParam("orderId") String orderId, HttpSession session, RedirectAttributes redirectAttributes) {
        String memberId = (String) session.getAttribute("memberId");
        if (memberId == null) {
            return "redirect:/login";
        }

        try {
            orderService.confirmOrder(orderId, memberId);
            redirectAttributes.addFlashAttribute("message", "구매가 확정되었습니다.");
        } catch (Exception e) {
            log.error("주문 확정 중 오류 발생: {}", e.getMessage());
            redirectAttributes.addFlashAttribute("error", "처리 중 오류가 발생했습니다.");
        }
        return "redirect:/mypage";
    }
}
