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
	private List<OrderDetailDTO> orderDetails;
}
