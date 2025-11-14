package com.boot.service;

import com.boot.dao.CouponDAO;
import com.boot.dto.CouponDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CouponServiceImpl implements CouponService {

    private final CouponDAO couponDAO;

    @Override
    @Transactional
    public void createCoupon(CouponDTO coupon) {
        couponDAO.insertCoupon(coupon);
    }

    @Override
    public CouponDTO getCouponById(Long couponId) {
        return couponDAO.getCouponById(couponId);
    }

    @Override
    public CouponDTO getCouponByName(String couponName) { // 새로 추가된 메서드 구현
        return couponDAO.getCouponByName(couponName);
    }

    @Override
    public List<CouponDTO> getAllCoupons() {
        return couponDAO.getAllCoupons();
    }

    @Override
    public List<CouponDTO> getActiveCoupons() {
        return couponDAO.getActiveCoupons();
    }

    @Override
    @Transactional
    public void updateCoupon(CouponDTO coupon) {
        couponDAO.updateCoupon(coupon);
    }

    @Override
    @Transactional
    public void deleteCoupon(Long couponId) {
        couponDAO.deleteCoupon(couponId);
    }
}
