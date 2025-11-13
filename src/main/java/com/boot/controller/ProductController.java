package com.boot.controller;

import com.boot.dto.ProdDTO;
import com.boot.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;


import javax.servlet.http.HttpSession;
@Controller
@RequestMapping("/product/product")
public class ProductController {

    @Autowired
    private ProductService productService;

    // 상품 상세 페이지 조회
    @GetMapping("/detail")
    public String getProductDetail(@RequestParam("prodId") Integer prodId, Model model, HttpSession session) {
        ProdDTO product = productService.getProductById(prodId);
        model.addAttribute("product", product);

        // ⭐️ 실제 로그인 세션에서 memberId를 가져옴 (없으면 null)
        String memberId = (String) session.getAttribute("memberId");
        model.addAttribute("memberId", memberId); // memberId가 null이면 로그아웃 상태

        return "product/productDetail";
    }
}