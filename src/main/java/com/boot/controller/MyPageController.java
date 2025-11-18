package com.boot.controller;

import com.boot.dto.MemDTO;
import com.boot.dto.OrdDTO;
import com.boot.dto.ProdDTO;
import com.boot.dto.TrackingResponseDTO;
import com.boot.service.DeliveryService;
import com.boot.service.OrderService;
import com.boot.service.UserService;
import com.boot.service.WishlistService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@Slf4j
@RequiredArgsConstructor // ⭐️ final 필드에 대한 생성자를 자동으로 생성합니다.
@RequestMapping("/mypage")
public class MyPageController {

    // ⭐️ 생성자 주입 방식으로 변경
    private final UserService userService;
    private final WishlistService wishlistService;
    private final OrderService orderService;
    private final DeliveryService deliveryService;

    @GetMapping
    public String mypage_view(HttpSession session, Model model) {
        log.info("@# mypage_view() - 정보 조회 및 리스트 로드");

        String memberId = (String) session.getAttribute("memberId");

        if (memberId == null) {
            log.warn("@# mypage_view() - 세션 ID 없음. 로그인 페이지로 리다이렉트.");
            return "redirect:/login";
        }

        // 1. 회원 정보 조회 (DAO -> Service)
        MemDTO memberInfo = userService.getUserById(memberId);
        model.addAttribute("memberInfo", memberInfo);

        // 2. 찜목록 조회
        List<ProdDTO> wishlist = wishlistService.getWishlistByMemberId(memberId);
        model.addAttribute("wishlist", wishlist);

        // 3. 주문 내역 조회 (주문 상세 포함)
        List<OrdDTO> orderList = orderService.getOrdersWithDetailsByMemberId(memberId);
        model.addAttribute("orderList", orderList);

        return "user/mypage";
    }

    @PostMapping("/user_info")
    public String mypage_update(@ModelAttribute MemDTO member, RedirectAttributes redirectAttributes) {
        log.info("@# mypage_update() - 정보 수정 요청: {}", member.getMemberId());
        
        // ⭐️ 회원 정보 수정 로직을 서비스 계층으로 위임
        userService.updateUserInfo(member);
        
        redirectAttributes.addFlashAttribute("updateSuccess", true);
        return "redirect:/mypage";
    }

    /**
     * 배송 추적 API를 호출하고 결과를 JSON으로 반환합니다.
     */
    @GetMapping("/trackDelivery")
    @ResponseBody
    public ResponseEntity<TrackingResponseDTO> trackDelivery(@RequestParam("t_code") String t_code,
                                                             @RequestParam("t_invoice") String t_invoice) {
        try {
            TrackingResponseDTO trackingInfo = deliveryService.getTrackingInfo(t_code, t_invoice);
            return ResponseEntity.ok(trackingInfo);
        } catch (Exception e) {
            log.error("배송 추적 오류: code={}, invoice={}", t_code, t_invoice, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }
}
