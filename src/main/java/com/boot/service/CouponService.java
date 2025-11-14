package com.boot.service;

import com.boot.dto.CouponDTO;

import java.util.List;

public interface CouponService {
    // 쿠폰 등록
    void createCoupon(CouponDTO coupon);

    // 쿠폰 ID로 조회
    CouponDTO getCouponById(Long couponId);

    // 쿠폰 이름으로 조회 (새로 추가)
    CouponDTO getCouponByName(String couponName);

    // 모든 쿠폰 조회
    List<CouponDTO> getAllCoupons();

    // 활성화된 쿠폰 조회
    List<CouponDTO> getActiveCoupons();

    // 쿠폰 정보 업데이트
    void updateCoupon(CouponDTO coupon);

    // 쿠폰 삭제
    void deleteCoupon(Long couponId);
}
