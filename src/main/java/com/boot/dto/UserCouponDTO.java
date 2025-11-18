package com.boot.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class UserCouponDTO {
    private Long userCouponId;
    private String memberId;
    private Long couponId;
    private Date issueDate;
    private Date usedDate;
    private String isUsed; // Y, N

    // JOIN을 통해 가져올 쿠폰 정보
    private String couponName;
    private String couponType;
    private Integer discountValue;
    private Integer minOrderAmount;
    private Date expirationDate;
    private Integer maxDiscountAmount;
    private String description;
}