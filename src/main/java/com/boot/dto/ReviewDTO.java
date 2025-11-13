package com.boot.dto;

import lombok.Data;

import java.util.Date;
import java.util.List;

@Data
public class ReviewDTO {
    private Long reviewId;
    private Long prodId;
    private String memberId;
    private String reviewContent;
    private int rating;
    private Long reviewParentId;
    private Date reviewRegDate;
    private Date reviewUpdDate;

    // 계층 구조 및 화면 표시를 위한 추가 필드
    private String memberName; // 작성자 이름
    private List<ReviewDTO> replies; // 답변 목록

    // 목록 조회용 추가 필드
    private String prodName; // 상품명
    private String replied; // 답변 여부 ('Y'/'N')
}