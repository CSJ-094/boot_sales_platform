package com.boot.dto;

import java.util.Date;

import lombok.Data;

@Data
public class SellerRecentQnaDTO {
	private Date qnaDate;    // 문의일
    private Long qnaId;      // 문의 ID
    private String prodName; // 상품명
    private String memberId; // 작성자 ID
    private String title;    // 제목
    private String status;   // 상태 (답변대기/답변완료 등)
}
