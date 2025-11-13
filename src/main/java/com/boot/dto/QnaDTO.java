package com.boot.dto;

import lombok.Data;

import java.util.Date;
import java.util.List;

@Data
public class QnaDTO {
    private Long qnaId;
    private Long prodId;
    private String memberId;
    private String qnaTitle;
    private String qnaContent;
    private String qnaIsSecret;
    private Long qnaParentId;
    private Date qnaRegDate;
    private String memberName; // 작성자 이름 표시용
    private List<QnaDTO> replies; // 답변 목록

    // 목록 조회용 추가 필드
    private String prodName; // 상품명
    private String replied; // 답변 여부 ('Y'/'N')
}