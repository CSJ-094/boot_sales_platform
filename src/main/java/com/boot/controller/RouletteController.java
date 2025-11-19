package com.boot.controller;

import com.boot.dto.CouponDTO;
import com.boot.service.CouponService;
import com.boot.service.PointService;
import com.boot.service.UserCouponService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

@Controller
@Slf4j
public class RouletteController {

    @Autowired
    private PointService pointService;

    @Autowired
    private CouponService couponService;

    @Autowired
    private UserCouponService userCouponService;

    @PostMapping("/api/spin-roulette")
    @ResponseBody
    public Map<String, Object> spinRoulette(HttpSession session) {
        String memberId = (String) session.getAttribute("memberId");
        Map<String, Object> response = new HashMap<>();

        if (memberId == null) {
            response.put("error", "로그인이 필요합니다.");
            return response;
        }

        String[] prizes = {"1000원", "꽝", "5% 할인", "꽝", "5000원", "꽝", "10% 할인", "꽝"};
        int randomIndex = new Random().nextInt(prizes.length);
        String resultPrize = prizes[randomIndex];

        // 룰렛 결과 처리
        try {
            switch (resultPrize) {
                case "1000원":
                    pointService.earnPoint(memberId, 1000, "룰렛 이벤트 당첨");
                    log.info("룰렛 당첨: {}님에게 1000 포인트 지급", memberId);
                    break;
                case "5000원":
                    pointService.earnPoint(memberId, 5000, "룰렛 이벤트 당첨");
                    log.info("룰렛 당첨: {}님에게 5000 포인트 지급", memberId);
                    break;
                case "5% 할인":
                    // issueRouletteCoupon(memberId, 쿠폰이름, 할인율, 최소주문금액, 최대할인금액)
                    issueRouletteCoupon(memberId, "룰렛 5% 할인 쿠폰", 5, 0, 10000);
                    break;
                case "10% 할인":
                    issueRouletteCoupon(memberId, "룰렛 10% 할인 쿠폰", 10, 0, 20000);
                    break;
                case "꽝":
                    log.info("룰렛 결과: {}님 꽝", memberId);
                    break;
            }
        } catch (Exception e) {
            log.error("룰렛 당첨 처리 중 오류 발생: memberId={}, prize={}", memberId, resultPrize, e);
            response.put("error", "당첨 처리 중 오류가 발생했습니다.");
            return response;
        }

        // 룰렛 시각적 결과 설정
        response.put("resultSegment", getSegmentForResult(resultPrize));
        response.put("prizeName", resultPrize);

        return response;
    }

    private void issueRouletteCoupon(String memberId, String couponName, int discountValue, int minPurchase, int maxDiscount) throws Exception {
        CouponDTO coupon = couponService.getCouponByName(couponName);
        if (coupon == null) {
            coupon = new CouponDTO();
            coupon.setCouponName(couponName);
            coupon.setCouponType("PERCENT");
            coupon.setDiscountValue(discountValue);
            coupon.setMinOrderAmount(minPurchase);
            coupon.setMaxDiscountAmount(maxDiscount);
            coupon.setIssueDate(new Date()); // 현재 날짜로 발행일 설정

            // 유효기간 30일 설정
            Calendar cal = Calendar.getInstance();
            cal.add(Calendar.DATE, 30);
            coupon.setExpirationDate(cal.getTime());

            coupon.setDescription("룰렛 이벤트 당첨 쿠폰");
            coupon.setIsActive("Y");

            couponService.createCoupon(coupon);
            log.info("신규 룰렛 쿠폰 생성: {}", couponName);
            coupon = couponService.getCouponByName(couponName); // 다시 조회하여 ID 확보
        }
        userCouponService.issueCouponToUser(memberId, coupon.getCouponId());
        log.info("룰렛 당첨: {}님에게 '{}' 쿠폰 지급", memberId, couponName);
    }

    private int getSegmentForResult(String prize) {
        Map<String, Integer> segmentMap = new HashMap<>();
        segmentMap.put("1000원", 2);
        segmentMap.put("5% 할인", 3);
        segmentMap.put("5000원", 5);
        segmentMap.put("10% 할인", 7);

        if (segmentMap.containsKey(prize)) {
            return segmentMap.get(prize);
        } else { // 꽝
            int[] blankSegments = {1, 4, 6, 8};
            return blankSegments[new Random().nextInt(blankSegments.length)];
        }
    }

    @GetMapping("/api/roulette/clear-flag")
    @ResponseBody
    public String clearRouletteFlag(HttpSession session) {
        session.removeAttribute("showRouletteEvent");
        return "ok";
    }
}
