package com.boot.controller;

import com.boot.dto.CouponDTO; // CouponDTO 임포트 추가
import com.boot.dto.ProdDTO;
import com.boot.dto.ReviewDTO;
import com.boot.service.CouponService; // CouponService 임포트 추가
import com.boot.service.PointService;
import com.boot.service.ProductService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.util.Date; // Date 임포트 추가

@Controller
@Slf4j
@RequestMapping("/reviews")
public class ReviewController {

    @Autowired
    private ProductService productService;

    @Autowired
    private com.boot.service.ReviewService reviewService;

    @Autowired
    private PointService pointService;

    @Autowired
    private CouponService couponService; // CouponService 주입

    @GetMapping("/write")
    public String showReviewWriteForm(@RequestParam("productId") Long productId,
                                      @RequestParam("orderId") String orderId,
                                      HttpSession session, Model model) {
        String memberId = (String) session.getAttribute("memberId");
        if (memberId == null) {
            return "redirect:/login";
        }

        // 리뷰할 상품 정보 조회
        ProdDTO product = productService.getProductById(productId);
        model.addAttribute("product", product);
        model.addAttribute("orderId", orderId);

        return "user/writereview";
    }

    @PostMapping("/add")
    public String addReview(@RequestParam("productId") Long productId,
                            @RequestParam("memberId") String memberId,
                            @RequestParam("rating") int rating,
                            @RequestParam("content") String content,
                            RedirectAttributes redirectAttributes) {

        ReviewDTO reviewDTO = new ReviewDTO();
        reviewDTO.setProdId(productId);
        reviewDTO.setMemberId(memberId);
        reviewDTO.setRating(rating);
        reviewDTO.setReviewContent(content);

        reviewService.addReview(reviewDTO);
        log.info("@# 리뷰 등록 완료: 상품 ID={}, 작성자={}", productId, memberId);
        redirectAttributes.addFlashAttribute("message", "리뷰가 성공적으로 등록되었습니다.");

        return "redirect:/mypage#order-history";
    }

    // ⭐️ 테스트용: 특정 사용자에게 포인트 지급
    // 이 엔드포인트는 실제 운영 환경에서는 반드시 제거하거나 보안을 강화해야 합니다.
    @GetMapping("/giveTestPoint")
    public String giveTestPoint(@RequestParam("memberId") String memberId,
                                @RequestParam(value = "amount", defaultValue = "10000000") Integer amount,
                                RedirectAttributes redirectAttributes) {
        try {
            pointService.earnPoint(memberId, amount, "테스트용 포인트 지급");
            redirectAttributes.addFlashAttribute("message", memberId + "님에게 " + amount + " 포인트가 지급되었습니다.");
            log.info("테스트용 포인트 지급: memberId={}, amount={}", memberId, amount);
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "포인트 지급 중 오류가 발생했습니다: " + e.getMessage());
            log.error("테스트용 포인트 지급 오류: memberId={}, amount={}, error={}", memberId, amount, e.getMessage());
        }
        return "redirect:/mypage#my-points";
    }

    // ⭐️ 테스트용: 두 가지 새로운 쿠폰 추가
    // 이 엔드포인트는 실제 운영 환경에서는 반드시 제거하거나 보안을 강화해야 합니다.
    @GetMapping("/addTestCoupons")
    public String addTestCoupons(RedirectAttributes redirectAttributes) {
        try {
            // 1. 15% 할인 쿠폰 (최대 2만원 할인)
            CouponDTO coupon1 = new CouponDTO();
            coupon1.setCouponName("장바구니 15% 할인 (최대 2만원)");
            coupon1.setCouponType("PERCENT");
            coupon1.setDiscountValue(15);
            coupon1.setMinOrderAmount(0); // 최소 주문 금액 없음
            coupon1.setExpirationDate(new Date(System.currentTimeMillis() + (1000L * 60 * 60 * 24 * 30))); // 30일 후 만료
            coupon1.setMaxDiscountAmount(20000);
            coupon1.setIsActive("Y");
            coupon1.setDescription("장바구니 상품에 15% 할인 적용, 최대 2만원까지 할인됩니다.");
            couponService.createCoupon(coupon1);

            // 2. 3만원 이상 구매 시 3천원 추가 할인 쿠폰
            CouponDTO coupon2 = new CouponDTO();
            coupon2.setCouponName("3만원 이상 구매 시 3천원 할인");
            coupon2.setCouponType("AMOUNT");
            coupon2.setDiscountValue(3000);
            coupon2.setMinOrderAmount(30000); // 3만원 이상 구매 시
            coupon2.setExpirationDate(new Date(System.currentTimeMillis() + (1000L * 60 * 60 * 24 * 30))); // 30일 후 만료
            coupon2.setMaxDiscountAmount(null); // 최대 할인 금액 없음
            coupon2.setIsActive("Y");
            coupon2.setDescription("3만원 이상 구매 시 3천원 즉시 할인됩니다.");
            couponService.createCoupon(coupon2);

            redirectAttributes.addFlashAttribute("message", "테스트 쿠폰 2종이 성공적으로 추가되었습니다.");
            log.info("테스트 쿠폰 2종 추가 완료.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "테스트 쿠폰 추가 중 오류가 발생했습니다: " + e.getMessage());
            log.error("테스트 쿠폰 추가 오류: {}", e.getMessage(), e);
        }
        return "redirect:/mypage#my-coupons"; // 마이페이지 쿠폰 탭으로 리다이렉트
    }
}
