package com.boot.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ProductSearchCondition {
    private String keyword;
    private Integer minPrice;
    private Integer maxPrice;
    private String category; // 카테고리 ID 또는 이름
    private String sortBy;   // 정렬 기준 (예: prodName, prodPrice, prodReg)
    private String sortOrder; // 정렬 순서 (예: asc, desc)
}