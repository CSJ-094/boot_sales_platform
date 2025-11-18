package com.boot.dao;

import com.boot.dto.UserCouponDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface UserCouponDAO {
    // 사용자에게 쿠폰 발급 (삽입)
    int insertUserCoupon(UserCouponDTO userCoupon);

    // 사용자 ID로 보유 쿠폰 목록 조회 (쿠폰 정보 조인)
    List<UserCouponDTO> getUserCouponsByMemberId(@Param("memberId") String memberId);

    // userCouponId로 특정 보유 쿠폰 조회
    UserCouponDTO getUserCouponById(@Param("userCouponId") Long userCouponId); // 추가

    // 사용자 ID와 쿠폰 ID로 특정 보유 쿠폰 조회
    UserCouponDTO getUserCouponByMemberIdAndCouponId(@Param("memberId") String memberId, @Param("couponId") Long couponId);

    // 사용자 보유 쿠폰 사용 처리 (usedDate, isUsed 업데이트)
    int updateUserCouponUsedStatus(UserCouponDTO userCoupon);

    // 사용자 보유 쿠폰 삭제
    int deleteUserCoupon(@Param("userCouponId") Long userCouponId);

    // 회원 탈퇴 시 해당 회원의 모든 쿠폰 삭제
    void deleteAllCouponsByMemberId(@Param("memberId") String memberId);
}
