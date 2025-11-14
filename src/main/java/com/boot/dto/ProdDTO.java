package com.boot.dto;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * PRODUCT_DB 테이블과 매핑되는 DTO.
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class ProdDTO {
	private Long prodId;
	private String prodSeller;
	private String prodName;
	private int prodPrice;
	private int prodStock;
	private String prodDesc;
	private String prodCode;
	private Timestamp prodReg;
	private Timestamp prodUpd;
	private String prodImgPath;
}