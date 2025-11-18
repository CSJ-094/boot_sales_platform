package com.boot.service;

import com.boot.dto.PointHistoryDTO;

import java.util.List;

public interface PointService {
    // 포인트 적립
    void earnPoint(String memberId, Integer amount, String description);

    // 포인트 사용
    void usePoint(String memberId, Integer amount, String description);

    // 포인트 내역 조회
    List<PointHistoryDTO> getPointHistory(String memberId);

    // 현재 포인트 잔액 조회
    Integer getCurrentPoint(String memberId);
}