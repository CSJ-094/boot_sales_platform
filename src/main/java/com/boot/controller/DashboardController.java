package com.boot.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.boot.service.DashboardService;

@Controller
@RequestMapping("/seller")
public class DashboardController {
	
	@Autowired
	private DashboardService dashboardService;

	@GetMapping("/dashboard")
	public String dashboard(Model model) {
		model.addAttribute("summary", dashboardService.getSummary());
//		model.addAttribute("dailySales", dashboardService.getDailySales());
//		model.addAttribute("dailyVisitors", dashboardService.getDailyVisitors());
		
		model.addAttribute("menu", "dashboard");
		
		return "seller/dashboard";
	}
}
