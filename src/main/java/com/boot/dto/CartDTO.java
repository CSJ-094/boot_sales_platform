package com.boot.dto;

import lombok.Data;
import java.util.Date;

/**
 * CART_DB 테이블과 매핑되는 DTO.
 * 장바구니 항목 정보를 담으며, 목록 조회 시 상품 정보도 함께 담기 위해 확장되었습니다.
 */
@Data
public class CartDTO {
    private int cartId;     // 장바구니 ID (PRIMARY KEY)
    private String memberId; // 회원 ID (FK)
    private long prodId;     // 상품 ID (FK)
    private int cartQty;    // 장바구니에 담긴 상품 수량
    private Date regDate;    // 장바구니에 담은 날짜

    // 장바구니 목록 조회 시 JOIN을 통해 가져올 상품 정보 필드
    private String prodName;    // 상품명
    private int prodPrice;      // 상품 가격
    private String prodSeller;  // 상품 판매자
    private String prodImage; // 상품 이미지 URL
    private String prodImgPath;
}
