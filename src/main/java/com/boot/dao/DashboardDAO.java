package com.boot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.boot.dto.SalesStatDTO;
import com.boot.dto.SellerDashboardDTO;
import com.boot.dto.SellerRecentOrderDTO;
import com.boot.dto.SellerRecentQnaDTO;
import com.boot.dto.VisitStatDTO;

@Mapper
public interface DashboardDAO {
	// 요약
	SellerDashboardDTO selectSummary();
	
	List<SalesStatDTO> selectDailySales(); // 일별 매출 (최근 7일)
	List<SalesStatDTO> selectWeeklySales(); // 주별 매출 (최근 8주)
	List<SalesStatDTO> selectMonthlySales(); // 월별 매출 (최근 6개월)
	
	List<VisitStatDTO> selectDailyVisitors();
	List<VisitStatDTO> selectWeeklyVisitors();
	List<VisitStatDTO> selectMonthlyVisitors();
	
	 List<SellerRecentOrderDTO> selectRecentOrders(); //최근 주문 10건
	 List<SellerRecentQnaDTO> selectRecentQna();      //최근 문의 10건
}
