package com.boot.dao;

import org.apache.ibatis.annotations.Mapper;

import java.util.Map;

@Mapper
public interface AttendanceDAO {
    // 특정 날짜에 해당 회원의 출석 기록이 있는지 확인
    int countByMemberIdAndDate(Map<String, Object> params);

    // 출석 기록 추가
    void insertLog(Map<String, Object> params);
}
