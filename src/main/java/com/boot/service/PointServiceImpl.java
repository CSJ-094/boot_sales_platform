package com.boot.service;

import com.boot.dao.LoginDAO;
import com.boot.dao.PointHistoryDAO;
import com.boot.dto.PointHistoryDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class PointServiceImpl implements PointService {

    private final PointHistoryDAO pointHistoryDAO;
    private final LoginDAO loginDAO; // USER_DB의 MEMBER_POINT 업데이트를 위해 LoginDAO 사용

    @Override
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void earnPoint(String memberId, Integer amount, String description) {
        if (amount <= 0) {
            throw new IllegalArgumentException("적립 포인트는 0보다 커야 합니다.");
        }

        // 1. 포인트 내역 추가
        PointHistoryDTO history = new PointHistoryDTO();
        history.setMemberId(memberId);
        history.setPointType("EARN");
        history.setAmount(amount);
        history.setDescription(description);
        pointHistoryDAO.insertPointHistory(history);

        // 2. 사용자 총 포인트 업데이트
        Integer currentPoint = loginDAO.getMemberPoint(memberId);
        if (currentPoint == null) {
            currentPoint = 0; // 처음 포인트 적립 시
        }
        loginDAO.updateMemberPoint(memberId, currentPoint + amount);
    }

    @Override
    @Transactional
    public void usePoint(String memberId, Integer amount, String description) {
        if (amount <= 0) {
            throw new IllegalArgumentException("사용 포인트는 0보다 커야 합니다.");
        }

        Integer currentPoint = loginDAO.getMemberPoint(memberId);
        if (currentPoint == null || currentPoint < amount) {
            throw new IllegalArgumentException("포인트가 부족합니다.");
        }

        // 1. 포인트 내역 추가 (사용은 음수로 기록)
        PointHistoryDTO history = new PointHistoryDTO();
        history.setMemberId(memberId);
        history.setPointType("USE");
        history.setAmount(-amount); // 사용은 음수로 기록
        history.setDescription(description);
        pointHistoryDAO.insertPointHistory(history);

        // 2. 사용자 총 포인트 업데이트
        loginDAO.updateMemberPoint(memberId, currentPoint - amount);
    }

    @Override
    public List<PointHistoryDTO> getPointHistory(String memberId) {
        return pointHistoryDAO.getPointHistoryByMemberId(memberId);
    }

    @Override
    public Integer getCurrentPoint(String memberId) {
        Integer currentPoint = loginDAO.getMemberPoint(memberId);
        return currentPoint != null ? currentPoint : 0;
    }
}
