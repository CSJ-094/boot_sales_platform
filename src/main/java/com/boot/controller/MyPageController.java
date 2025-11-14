package com.boot.controller;

import com.boot.dto.CouponDTO;
import com.boot.dto.UserCouponDTO;
import com.boot.dto.PointHistoryDTO;
import com.boot.dto.WishlistDTO;
import com.boot.dto.OrdDTO;
import com.boot.service.CouponService;
import com.boot.service.UserCouponService;
import com.boot.service.PointService;
import com.boot.service.WishlistService;
import com.boot.service.OrderService;
import com.boot.service.LoginService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/mypage")
public class MyPageController {

    @Autowired
    private UserCouponService userCouponService;
    @Autowired
    private PointService pointService;
    @Autowired
    private CouponService couponService;
    @Autowired
    private WishlistService wishlistService;
    @Autowired
    private OrderService orderService;
    @Autowired
    private LoginService loginService;

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

        List<UserCouponDTO> userCoupons = userCouponService.getUserCouponsByMemberId(memberId);
        model.addAttribute("userCoupons", userCoupons);

        List<PointHistoryDTO> pointHistory = pointService.getPointHistory(memberId);
        model.addAttribute("pointHistory", pointHistory);

        Integer currentPoint = pointService.getCurrentPoint(memberId);
        model.addAttribute("currentPoint", currentPoint);

        model.addAttribute("now", new Date());

        List<CouponDTO> allActiveCoupons = couponService.getActiveCoupons();
        
        Set<Long> possessedCouponIds = userCoupons.stream()
                                                .map(UserCouponDTO::getCouponId)
                                                .collect(Collectors.toSet());
        
        List<CouponDTO> claimableCoupons = allActiveCoupons.stream()
                                                        .filter(coupon -> !possessedCouponIds.contains(coupon.getCouponId()))
                                                        .collect(Collectors.toList());
        model.addAttribute("claimableCoupons", claimableCoupons);

        List<WishlistDTO> wishlist = wishlistService.getWishlistByMemberId(memberId);
        model.addAttribute("wishlist", wishlist);

        List<OrdDTO> orderList = orderService.getOrdersWithDetailsByMemberId(memberId);
        model.addAttribute("orderList", orderList);

        return "user/mypage";
    }

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
            redirectAttributes.addFlashAttribute("message", "찜목록 삭제 중 오류가 발생했습니다.");
        }

        return "redirect:/mypage#wishlist";
    }

    @PostMapping("/withdraw")
    public String withdrawMember(@RequestParam("memberPw") String memberPw,
                                 HttpServletRequest request,
                                 HttpServletResponse response,
                                 RedirectAttributes redirectAttributes) {
        String memberId = (String) request.getSession().getAttribute("memberId");
        if (memberId == null) {
            return "redirect:/login";
        }

        boolean success = loginService.withdrawMember(memberId, memberPw);

        if (success) {
            new SecurityContextLogoutHandler().logout(request, response, SecurityContextHolder.getContext().getAuthentication());
            redirectAttributes.addFlashAttribute("message", "회원 탈퇴가 완료되었습니다.");
            return "redirect:/";
        } else {
            redirectAttributes.addFlashAttribute("error", "비밀번호가 일치하지 않습니다.");
            return "redirect:/mypage#member-info";
        }
    }
}
