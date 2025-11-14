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

	// DB 컬럼과 관계 없는, 조회 결과를 담기 위한 필드
	private List<OrderDetailDTO> orderDetails;
}
