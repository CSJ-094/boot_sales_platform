package com.boot.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import lombok.Data;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class TrackingDetailDTO {
	private String timeString; // 처리 시간
    private String where; // 현재 위치
    private String kind; // 배송 상태 (예: 간선하차, 배송출발)
    private String telno; // 담당 기사 연락처
    
    // (Getter, Setter는 Lombok이 생성)
}
