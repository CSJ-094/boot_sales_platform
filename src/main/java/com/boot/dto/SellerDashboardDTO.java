package com.boot.dto;

import lombok.Data;

@Data
public class SellerDashboardDTO {
	// 오늘
    private int todayOrderCount;        // 오늘 주문 건수
    private long todaySalesAmount;      // 오늘 매출액
    private int todayNewMembers;        // 오늘 신규 가입자 수
    private int todayVisitors;          // 오늘 방문자 수
    private int pendingQnaCount;        // 미처리 문의 수

    // 어제
    private int yesterdayOrderCount;    // 어제 주문 건수
    private long yesterdaySalesAmount;  // 어제 매출액

    // 필요하면 전일 대비 증감/증감률 이런 건 나중에 추가
}