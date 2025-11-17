package com.boot.controller;
import com.boot.dto.CartDTO;
import com.boot.service.CartService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import javax.servlet.http.HttpSession;
import java.util.List;
@Controller
@RequestMapping("/cart")
public class CartController {
    @Autowired
    private CartService cartService;
    // :별:️ 공통: 세션에서 memberId를 가져오고 로그인 여부를 확인하는 유틸리티 메서드
    private String getMemberIdOrRedirect(HttpSession session, RedirectAttributes redirectAttributes) {
        String memberId = (String) session.getAttribute("memberId");
        if (memberId == null) {
            redirectAttributes.addFlashAttribute("loginError", "로그인이 필요합니다.");
            // (B) 로그인 페이지로의 리다이렉트 경로는 보통 /login 이나 /member/login 등 입니다.
            // 여기서는 경로 리턴만 하고, 실제 리다이렉트는 호출하는 메서드에서 합니다.
        }
        return memberId;
    }
    // 장바구니 목록 조회 (GET /cart/list)
    @GetMapping("/list")
    public String getCartList(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        // 1. 세션에서 memberId를 가져오고 로그인 여부 확인
        String memberId = getMemberIdOrRedirect(session, redirectAttributes);
        if (memberId == null) {
            // (C) 로그인 페이지 경로를 정확하게 확인하여 수정해야 합니다.
            return "redirect:/login/login"; // 예: /login 경로가 로그인 폼을 보여주는 컨트롤러 매핑이라고 가정
        }
        // 2. 장바구니 목록 조회 (로그인 상태)
        List<CartDTO> cartList = cartService.getCartListByMemberId(memberId);
        // 3. 총 장바구니 금액 계산
        int totalCartPrice = 0;
        if (cartList != null) {
            for (CartDTO cartItem : cartList) {
                totalCartPrice += cartItem.getProdPrice() * cartItem.getCartQty();
            }
        }
        model.addAttribute("cartList", cartList);
        model.addAttribute("memberId", memberId);
        model.addAttribute("totalCartPrice", totalCartPrice); // :별:️ 총 금액을 모델에 추가
        // (D) View 이름 수정: 'cart' 폴더 안의 'cartList.jsp'를 의도했다면
        return "cart/cartList";
    }
    // 장바구니에 상품 추가 (POST /cart/add)
    @PostMapping("/add")
    public String addCart(HttpSession session,
                          @RequestParam("prodId") Integer prodId,
                          @RequestParam(value = "cartQty", defaultValue = "1") int cartQty,
                          RedirectAttributes redirectAttributes) {
        // 1. 세션에서 memberId를 가져오고 로그인 여부 확인
        String memberId = getMemberIdOrRedirect(session, redirectAttributes);
        if (memberId == null) {
            // (C) 로그인 페이지 경로를 정확하게 확인하여 수정해야 합니다.
            return "redirect:/login";
        }
        // 2. 장바구니 추가 로직...
        try {
            cartService.addCart(memberId, prodId, cartQty);
            redirectAttributes.addFlashAttribute("message", "상품이 장바구니에 추가되었습니다.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "장바구니 추가 중 오류가 발생했습니다: " + e.getMessage());
        }
        // 3. 장바구니 목록 페이지로 리다이렉트
        return "redirect:/cart/list";
    }
    // 장바구니 상품 수량 변경 (POST /cart/update)
    @PostMapping("/update")
    public String updateCart(@RequestParam("cartId") int cartId,
                             HttpSession session,
                             @RequestParam("cartQty") int cartQty,
                             RedirectAttributes redirectAttributes) {
        String memberId = getMemberIdOrRedirect(session, redirectAttributes);
        if (memberId == null) {
            return "redirect:/login";
        }
        // 2. 수량 변경 로직
        try {
            cartService.updateCartQuantity(cartId, memberId, cartQty);
            redirectAttributes.addFlashAttribute("message", "장바구니 수량이 변경되었습니다.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "수량 변경 중 오류가 발생했습니다: " + e.getMessage());
        }
        return "redirect:/cart/list";
    }
    // 장바구니 상품 삭제 (POST /cart/remove)
    @PostMapping("/remove")
    public String removeCart(@RequestParam("cartId") int cartId,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        String memberId = getMemberIdOrRedirect(session, redirectAttributes);
        if (memberId == null) {
            return "redirect:/login/login";
        }
        // 2. 삭제 로직
        try {
            cartService.deleteCart(cartId, memberId);
            redirectAttributes.addFlashAttribute("message", "장바구니에서 상품이 삭제되었습니다.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "상품 삭제 중 오류가 발생했습니다: " + e.getMessage());
        }
        // 장바구니 목록 페이지로 리다이렉트
        return "redirect:/cart/list";
    }
    // 찜목록 상품을 장바구니로 이동 (POST /cart/moveFromWishlist)
    @PostMapping("/moveFromWishlist")
    public String moveFromWishlist(HttpSession session,
                                   @RequestParam("prodId") Integer prodId,
                                   @RequestParam(value = "cartQty", defaultValue = "1") int cartQty,
                                   RedirectAttributes redirectAttributes) {
        String memberId = getMemberIdOrRedirect(session, redirectAttributes);
        if (memberId == null) {
            // (C) 로그인 페이지 경로를 정확하게 확인하여 수정해야 합니다.
            return "redirect:/login/login";
        }
        // 2. 이동 로직
        try {
            cartService.moveWishlistItemToCart(memberId, prodId, cartQty);
            redirectAttributes.addFlashAttribute("message", "찜목록 상품이 장바구니로 이동되었습니다.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "상품 이동 중 오류가 발생했습니다: " + e.getMessage());
        }
        // 장바구니 목록 페이지로 리다이렉트
        return "redirect:/cart/list";
    }
}