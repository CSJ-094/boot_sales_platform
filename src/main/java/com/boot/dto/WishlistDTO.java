package com.boot.dto;

import lombok.Data;

@Data
public class WishlistDTO {
    private int wishlistId;
    private String memberId;
    private Long prodId;

    // 마이페이지 찜 목록 표시를 위한 추가 필드
    private String prodName;
    private int prodPrice;
    private String prodImgPath;
    private String prodSeller; // 추가
    private int prodStock;     // 추가
}
