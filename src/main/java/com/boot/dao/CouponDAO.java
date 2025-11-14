package com.boot.dao;

import com.boot.dto.CouponDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface CouponDAO {
    // 쿠폰 등록
    int insertCoupon(CouponDTO coupon);

    // 쿠폰 ID로 조회
    CouponDTO getCouponById(@Param("couponId") Long couponId);

    // 쿠폰 이름으로 조회 (새로 추가)
    CouponDTO getCouponByName(@Param("couponName") String couponName);

    // 모든 쿠폰 조회
    List<CouponDTO> getAllCoupons();

    // 활성화된 쿠폰 조회
    List<CouponDTO> getActiveCoupons();

    // 쿠폰 정보 업데이트
    int updateCoupon(CouponDTO coupon);

    // 쿠폰 삭제
    int deleteCoupon(@Param("couponId") Long couponId);
}
