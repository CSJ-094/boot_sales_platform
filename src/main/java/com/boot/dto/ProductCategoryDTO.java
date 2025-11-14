package com.boot.dto;

import java.util.Date;

import lombok.Data;

@Data
public class ProductCategoryDTO {
    private Long prodId;		//상품 ID(PRODUCT_DB.PROD_ID)
    private Long catId;			//카테고리 ID(CATEGORY_DB.CAT_ID)
    private String isMain;		//대표 카테고리 여부
    private Date pcReg;			//매핑 등록일
}