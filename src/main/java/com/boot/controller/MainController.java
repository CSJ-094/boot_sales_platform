package com.boot.controller;

import java.util.List;

import com.boot.dto.NoticeDTO;
import com.boot.dto.ProdDTO;
import com.boot.service.NoticeService;
import com.boot.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;


import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class MainController {
    
    @Autowired
    private ProductService productService;
    @Autowired
    private NoticeService noticeService;

    @GetMapping({"/", "/mainpage"})
    public String mainPage(Model model) {
        log.info("@# mainPage() - 메인 페이지 상품 목록 조회 시작");

        final int MANS_CAT_ID = 200; // DB에 맞게 수정
        final int WOMANS_CAT_ID = 100; // DB에 맞게 수정

        try {
            List<ProdDTO> mansList = productService.selectProductsByCategory(MANS_CAT_ID);
            model.addAttribute("mansRecommendList", mansList);
            log.info("@# 남성 추천 상품 {}개 조회 완료.", mansList.size());

            List<ProdDTO> womansList = productService.selectProductsByCategory(WOMANS_CAT_ID); 
            model.addAttribute("womansRecommendList", womansList); // JSP의 변수명(womansRecommendList) 확인
            log.info("@# 여성 인기 상품 {}개 조회 완료.", womansList.size());
            
            // 최근 공지 5개
            List<NoticeDTO> recentNotices = noticeService.getRecentNotices(5);
            model.addAttribute("recentNotices", recentNotices);
            log.info("@# 최근 공지 {}개 조회 완료.", recentNotices.size());
            
        } catch (Exception e) {
            log.error("메인 페이지 상품 조회 중 오류 발생: {}", e.getMessage());
            model.addAttribute("mansRecommendList", List.of());
            model.addAttribute("womansRecommendList", List.of());
            model.addAttribute("recentNotices", List.of());
        }
        
        return "mainpage";
    }
}