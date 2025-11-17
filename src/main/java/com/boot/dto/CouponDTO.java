package com.boot.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class CouponDTO {
    private Long couponId;
    private String couponName;
    private String couponType; // PERCENT, AMOUNT
    private Integer discountValue;
    private Integer minOrderAmount;
    private Date expirationDate;
    private Date issueDate;
    private Integer maxDiscountAmount;
    private String isActive; // Y, N
    private String description;
}