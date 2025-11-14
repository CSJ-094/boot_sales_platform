package com.boot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.boot.dto.SalesStatDTO;
import com.boot.dto.SellerDashboardDTO;
import com.boot.dto.VisitStatDTO;

@Mapper
public interface DashboardDAO {
	// 요약
	SellerDashboardDTO selectSummary();
	
	List<SalesStatDTO> selectDailySales();
	List<SalesStatDTO> selectWeeklySales();
	List<SalesStatDTO> selectMonthlySales();
	
	List<VisitStatDTO> selectDailyVisitors();
}
