package com.boot.controller;

import java.util.List;

import com.boot.dto.ProdDTO;
import com.boot.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;


import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/category") // /category로 시작하는 요청 처리
@Slf4j
public class CategoryController {

    @Autowired
    private ProductService productService;

    // MANS 카테고리 페이지 처리
    @GetMapping("/mans")
    public String mansCategoryPage(Model model) {
        
        final int MANS_CAT_ID = 200; // DB에 맞게 수정
        
        try {
            // ⭐️ 전체 상품을 가져오는 메서드 호출
            List<ProdDTO> mansList = productService.getAllProdsByCatId(MANS_CAT_ID);
            
            // JSP가 요구하는 변수명 mansList에 담아서 전달
            model.addAttribute("mansList", mansList); 
            log.info("@# MANS 카테고리 전체 상품 {}개 조회 완료.", mansList.size());
            
        } catch (Exception e) {
            log.error("MANS 카테고리 상품 조회 중 오류 발생: {}", e.getMessage());
            model.addAttribute("mansList", List.of());
        }
        
        // 뷰 이름을 "category/mans"로 가정합니다. (-> /WEB-INF/views/category/mans.jsp)
        return "category/mans"; 
    }
}