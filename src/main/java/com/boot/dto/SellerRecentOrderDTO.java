package com.boot.dto;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class SellerRecentOrderDTO {
	 private Timestamp ordDate;     // 주문일
	    private String ordId;          // 주문번호
	    private String buyerName;      // 주문자 이름
	    private int ordAmount;         // 결제 금액
	    private String ordStatus;      // 주문 상태(결제완료/배송중/배송완료/취소 등 - 값은 프로젝트에 따라 다름)
}
