package com.boot.dao;

import com.boot.dto.PointHistoryDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface PointHistoryDAO {
    // 포인트 내역 추가
    int insertPointHistory(PointHistoryDTO pointHistory);

    // 사용자 ID로 포인트 내역 조회
    List<PointHistoryDTO> getPointHistoryByMemberId(@Param("memberId") String memberId);

    // 특정 포인트 내역 조회 (필요시)
    PointHistoryDTO getPointHistoryById(@Param("pointId") Long pointId);
}