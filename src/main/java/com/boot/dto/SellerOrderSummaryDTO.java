package com.boot.dto;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SellerOrderSummaryDTO {
	private String orderId;
	private String buyerId;
	private String buyerName;
	private Timestamp orderDate;
	private String orderStatus;
	private int totalQuantity;
	private int totalAmount;
	private String trackingNumber; // 송장번호
	private String deliveryCompany; // 택배사 코드
}

