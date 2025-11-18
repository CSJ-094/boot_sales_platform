package com.boot.controller;

import com.boot.service.AttendanceService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Controller
@Slf4j
public class AttendanceController {

    @Autowired
    private AttendanceService attendanceService;

    @PostMapping("/api/attendance/check-in")
    @ResponseBody
    public ResponseEntity<Map<String, String>> checkIn(HttpSession session) {
        String memberId = (String) session.getAttribute("memberId");
        Map<String, String> response = new HashMap<>();

        if (memberId == null) {
            response.put("status", "error");
            response.put("message", "로그인이 필요합니다.");
            return ResponseEntity.status(401).body(response);
        }

        try {
            String result = attendanceService.checkIn(memberId);
            if ("SUCCESS".equals(result)) {
                response.put("status", "success");
                response.put("message", "출석체크 완료! 10포인트가 적립되었습니다.");
                return ResponseEntity.ok(response);
            } else { // "ALREADY_CHECKED_IN"
                response.put("status", "already_checked_in");
                response.put("message", "오늘은 이미 출석체크를 완료했습니다.");
                return ResponseEntity.ok(response);
            }
        } catch (Exception e) {
            log.error("출석체크 처리 중 오류 발생: memberId={}", memberId, e);
            response.put("status", "error");
            response.put("message", "처리 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
            return ResponseEntity.status(500).body(response);
        }
    }
}
