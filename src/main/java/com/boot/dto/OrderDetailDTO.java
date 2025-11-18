package com.boot.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class OrderDetailDTO {
    private int orderDetailId; // 주문 상세 번호 (PK, Sequence)
    private String orderId;      // 주문 번호 (FK: ORDER_DB.ORD_ID)
    private long productId;       // 상품 번호 (FK: PRODUCT_DB.PROD_ID)
    private int quantity;        // 주문 수량
    private int price;           // 주문 당시 상품 가격 (개당 가격)
    private String prodName;
    private String prodImage;    // 상품 이미지 경로
    private boolean hasReview;
}
