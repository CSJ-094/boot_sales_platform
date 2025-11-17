package com.boot.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.boot.dto.SalesStatDTO;
import com.boot.dto.VisitStatDTO;
import com.boot.service.DashboardService;

@Controller
@RequestMapping("/seller")
public class DashboardController {
	
	@Autowired
	private DashboardService dashboardService;

	@GetMapping("/dashboard")
	public String dashboard(Model model) {
		model.addAttribute("summary", dashboardService.getSummary());
		model.addAttribute("menu", "dashboard");
		model.addAttribute("recentOrders", dashboardService.getRecentOrders());
		 model.addAttribute("recentQna", dashboardService.getRecentQna());
		
		return "seller/dashboard";
	}
	
	// 매출 그래프 데이터
		@GetMapping("/dashboard/sales")
		@ResponseBody
		public List<SalesStatDTO> getSalesStats(@RequestParam(defaultValue = "day") String period) {
			switch (period) {
				case "week":
					return dashboardService.getWeeklySales();
				case "month":
					return dashboardService.getMonthlySales();
				case "day":
				default:
					return dashboardService.getDailySales();
			}
		}
	// 방문자 그래프 데이터
		@GetMapping("/dashboard/visitors")
		@ResponseBody
		public List<VisitStatDTO> getVisitorStats(@RequestParam(defaultValue = "day") String period) {
			switch (period) {
            case "week":
                return dashboardService.getWeeklyVisitors();
            case "month":
                return dashboardService.getMonthlyVisitors();
            case "day":
            default:
                return dashboardService.getDailyVisitors();
        }
	}
}
