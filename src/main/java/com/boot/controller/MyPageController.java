package com.boot.controller;

import com.boot.dao.MemDAO;
import com.boot.dto.CouponDTO;
import com.boot.dto.MemDTO;
import com.boot.dto.OrdDTO;
import com.boot.dto.PointHistoryDTO;
import com.boot.dto.ProdDTO;
import com.boot.dto.UserCouponDTO;
import com.boot.service.CouponService;
import com.boot.service.LoginService;
import com.boot.service.OrderService;
import com.boot.service.PointService;
import com.boot.service.UserCouponService;
import com.boot.service.UserService; // UserService import 추가
import com.boot.service.WishlistService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Controller
@Slf4j
@RequestMapping("/mypage")
public class MyPageController {

    @Autowired
    private MemDAO memDAO;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private WishlistService wishlistService;

    @Autowired
    private OrderService orderService;

    @Autowired
    private UserCouponService userCouponService;
    @Autowired
    private PointService pointService;
    @Autowired
    private CouponService couponService;
    @Autowired
    private LoginService loginService;
    @Autowired
    private UserService userService; // UserService 주입

    private String getMemberIdOrRedirect(HttpSession session, RedirectAttributes redirectAttributes) {
        String memberId = (String) session.getAttribute("memberId");
        if (memberId == null) {
            redirectAttributes.addFlashAttribute("loginError", "로그인이 필요합니다.");
            return null;
        }
        return memberId;
    }

    @GetMapping
    public String myPage(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        String memberId = getMemberIdOrRedirect(session, redirectAttributes);
        if (memberId == null) {
            return "redirect:/login";
        }

        // 1. 회원 정보 조회
        MemDTO memberInfo = memDAO.getMemberInfo(memberId);
        model.addAttribute("memberInfo", memberInfo);

        // 2. 찜목록 조회
        List<ProdDTO> wishlist = wishlistService.getWishlistByMemberId(memberId);
        model.addAttribute("wishlist", wishlist);

        // 3. 주문 내역 조회 (주문 상세 포함)
        List<OrdDTO> orderList = orderService.getOrdersWithDetailsByMemberId(memberId);
        model.addAttribute("orderList", orderList);

        // 4. 사용자 쿠폰 조회
        List<UserCouponDTO> userCoupons = userCouponService.getUserCouponsByMemberId(memberId);
        model.addAttribute("userCoupons", userCoupons);

        // 5. 포인트 내역 조회
        List<PointHistoryDTO> pointHistory = pointService.getPointHistory(memberId);
        model.addAttribute("pointHistory", pointHistory);

        // 6. 현재 포인트 조회
        Integer currentPoint = pointService.getCurrentPoint(memberId);
        model.addAttribute("currentPoint", currentPoint);

        model.addAttribute("now", new Date());

        // 7. 발급 가능한 쿠폰 조회
        List<CouponDTO> allActiveCoupons = couponService.getActiveCoupons();
        
        Set<Long> possessedCouponIds = userCoupons.stream()
                                                .map(UserCouponDTO::getCouponId)
                                                .collect(Collectors.toSet());
        
        List<CouponDTO> claimableCoupons = allActiveCoupons.stream()
                                                        .filter(coupon -> !possessedCouponIds.contains(coupon.getCouponId()))
                                                        .collect(Collectors.toList());
        model.addAttribute("claimableCoupons", claimableCoupons);

        return "user/mypage";
    }

    @PostMapping("/user_info")
    public String mypage_update(@ModelAttribute MemDTO member, RedirectAttributes redirectAttributes) {
        log.info("@# mypage_update() - 정보 수정 요청: {}", member.getMemberId());

        // UserService의 updateUserInfo 메서드를 호출하여 회원 정보 수정 처리
        userService.updateUserInfo(member); // 메서드 호출 변경

        redirectAttributes.addFlashAttribute("updateSuccess", true);
        return "redirect:/mypage";
    }

    // 쿠폰 발급 기능
    @PostMapping("/claimCoupon")
    public String claimCoupon(@RequestParam("couponId") Long couponId,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        String memberId = getMemberIdOrRedirect(session, redirectAttributes);
        if (memberId == null) {
            return "redirect:/login";
        }

        try {
            userCouponService.issueCouponToUser(memberId, couponId);
            redirectAttributes.addFlashAttribute("couponMessage", "쿠폰이 성공적으로 발급되었습니다!");
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("couponError", e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("couponError", "쿠폰 발급 중 오류가 발생했습니다.");
        }

        return "redirect:/mypage#my-coupons";
    }

    // 찜목록 삭제 기능
    @PostMapping("/wishlist/remove")
    public String removeWishlist(@RequestParam("prodId") Long prodId,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        String memberId = (String) session.getAttribute("memberId");
        if (memberId == null) {
            redirectAttributes.addFlashAttribute("loginError", "로그인이 필요합니다.");
            return "redirect:/login";
        }

        try {
            wishlistService.removeProductFromWishlist(memberId, prodId);
            redirectAttributes.addFlashAttribute("message", "찜목록에서 상품이 삭제되었습니다.");
        } catch (Exception e) {
            log.error("찜목록 삭제 중 오류 발생: {}", e.getMessage());
            redirectAttributes.addFlashAttribute("message", "찜목록 삭제 중 오류가 발생했습니다.");
        }

        return "redirect:/mypage#wishlist";
    }
}
