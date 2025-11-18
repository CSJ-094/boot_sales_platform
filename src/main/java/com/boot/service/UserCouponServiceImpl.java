package com.boot.service;

import com.boot.dao.UserCouponDAO;
import com.boot.dto.UserCouponDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class UserCouponServiceImpl implements UserCouponService {

    private final UserCouponDAO userCouponDAO;

    @Override
    @Transactional
    public void issueCouponToUser(String memberId, Long couponId) {
        // 이미 해당 쿠폰을 가지고 있는지 확인 (UQ_USER_COUPON 제약조건 위반 방지)
        UserCouponDTO existingCoupon = userCouponDAO.getUserCouponByMemberIdAndCouponId(memberId, couponId);
        if (existingCoupon != null) {
            throw new IllegalArgumentException("이미 보유하고 있는 쿠폰입니다.");
        }

        UserCouponDTO userCoupon = new UserCouponDTO();
        userCoupon.setMemberId(memberId);
        userCoupon.setCouponId(couponId);
        userCouponDAO.insertUserCoupon(userCoupon);
    }

    @Override
    public List<UserCouponDTO> getUserCouponsByMemberId(String memberId) {
        return userCouponDAO.getUserCouponsByMemberId(memberId);
    }

    @Override
    public UserCouponDTO getUserCouponById(Long userCouponId) {
        return userCouponDAO.getUserCouponById(userCouponId);
    }

    @Override
    @Transactional
    public void useUserCoupon(Long userCouponId, String memberId) {
        UserCouponDTO userCoupon = new UserCouponDTO();
        userCoupon.setUserCouponId(userCouponId);
        userCoupon.setMemberId(memberId); // 보안을 위해 memberId도 함께 전달
        int updatedRows = userCouponDAO.updateUserCouponUsedStatus(userCoupon);
        if (updatedRows == 0) {
            throw new IllegalArgumentException("쿠폰 사용에 실패했습니다. 이미 사용되었거나 유효하지 않은 쿠폰입니다.");
        }
    }

    @Override
    @Transactional
    public void deleteUserCoupon(Long userCouponId) {
        userCouponDAO.deleteUserCoupon(userCouponId);
    }
}
