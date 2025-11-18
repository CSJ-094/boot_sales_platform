package com.boot.dto;

import java.sql.Timestamp;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class OrdDTO {
	private String ordId;
	private String ordMemId;
	private Timestamp ordDate;
	private int ordAmount;
	private int ordDfee;
	private int ordDiscount;
	private String ordStatus;
	private String ordPaymentKey; // 토스페이먼츠 결제 키를 저장할 필드

	// 8. DELIVERY_COMPANY (택배사 코드)
    private String deliveryCompany; 
    // 9. TRACKING_NUMBER (운송장 번호)
    private String trackingNumber;
    
	// DB 컬럼과 관계 없는, 조회 결과를 담기 위한 필드
	private List<OrderDetailDTO> orderDetails;

	// 주문 총액(상품금액 + 배송비 - 할인)을 계산해서 반환하는 getter
	public int getOrdTotal() {
		return this.ordAmount + this.ordDfee - this.ordDiscount;
	}
}
