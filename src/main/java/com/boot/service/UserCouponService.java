package com.boot.service;

import com.boot.dto.UserCouponDTO;

import java.util.List;

public interface UserCouponService {
    // 사용자에게 쿠폰 발급
    void issueCouponToUser(String memberId, Long couponId);

    // 사용자 ID로 보유 쿠폰 목록 조회
    List<UserCouponDTO> getUserCouponsByMemberId(String memberId);

    // userCouponId로 특정 보유 쿠폰 조회
    UserCouponDTO getUserCouponById(Long userCouponId); // 추가

    // 사용자 보유 쿠폰 사용 처리
    void useUserCoupon(Long userCouponId, String memberId);

    // 사용자 보유 쿠폰 삭제
    void deleteUserCoupon(Long userCouponId);
}
