package com.boot.service;

import com.boot.dao.AttendanceDAO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

@Service
@Slf4j
public class AttendanceService {

    @Autowired
    private AttendanceDAO attendanceDAO;

    @Autowired
    private PointService pointService;

    private static final int ATTENDANCE_POINT = 10; // 출석체크 시 지급할 포인트

    @Transactional
    public String checkIn(String memberId) {
        LocalDate today = LocalDate.now();
        
        Map<String, Object> params = new HashMap<>();
        params.put("memberId", memberId);
        params.put("checkInDate", today);

        // 1. 오늘 날짜로 이미 출석했는지 확인
        int count = attendanceDAO.countByMemberIdAndDate(params);
        if (count > 0) {
            log.info("{}님은 오늘 이미 출석했습니다.", memberId);
            return "ALREADY_CHECKED_IN";
        }

        // 2. 출석하지 않았다면, 출석 기록 추가
        attendanceDAO.insertLog(params);
        log.info("{}님의 출석을 기록했습니다.", memberId);

        // 3. 포인트 지급
        pointService.earnPoint(memberId, ATTENDANCE_POINT, "출석체크 포인트");
        log.info("{}님에게 출석체크 포인트 {}점을 지급했습니다.", memberId, ATTENDANCE_POINT);

        return "SUCCESS";
    }
}
