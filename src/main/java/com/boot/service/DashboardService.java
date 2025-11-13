package com.boot.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.dao.DashboardDAO;
import com.boot.dto.SalesStatDTO;
import com.boot.dto.SellerDashboardDTO;
import com.boot.dto.VisitStatDTO;

@Service
public class DashboardService {
	
	@Autowired
	private DashboardDAO dashboardDAO;
	
	// 요약 정보 가져오기
    public SellerDashboardDTO getSummary() {
        return dashboardDAO.selectSummary();
    }

    // 일간 매출 통계
    public List<SalesStatDTO> getDailySales() {
        return dashboardDAO.selectDailySales();
    }

    // 주간 매출 통계
    public List<SalesStatDTO> getWeeklySales() {
        return dashboardDAO.selectWeeklySales();
    }

    // 월간 매출 통계
    public List<SalesStatDTO> getMonthlySales() {
        return dashboardDAO.selectMonthlySales();
    }

    // 방문자 통계
    public List<VisitStatDTO> getDailyVisitors() {
        return dashboardDAO.selectDailyVisitors();
    }
	
}
