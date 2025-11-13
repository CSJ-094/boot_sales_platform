package com.boot.controller;

import com.boot.dto.ProdDTO;
import com.boot.dto.QnaDTO;
import com.boot.dto.ReviewDTO;
import com.boot.service.OrderService;
import com.boot.service.ProductService;
import com.boot.service.ReviewService;
import com.boot.service.QnaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;


import java.util.List;
import javax.servlet.http.HttpSession;
@Controller
@RequestMapping("/products")
public class ProductController {

    @Autowired
    private ProductService productService;

    @Autowired
    private OrderService orderService; // 구매 이력 확인을 위해 추가

    @Autowired
    private ReviewService reviewService; // 리뷰 조회를 위해 추가

    @Autowired
    private QnaService qnaService; // 상품 문의 조회를 위해 추가

    // 상품 상세 페이지 조회
    @GetMapping("/detail")
    public String getProductDetail(@RequestParam("prodId") Integer prodId, Model model, HttpSession session) {
        ProdDTO product = productService.getProductById(prodId);
        model.addAttribute("product", product);

        String memberId = (String) session.getAttribute("memberId");
        model.addAttribute("memberId", memberId);

        // 로그인한 경우, 해당 상품 구매 이력 확인
        boolean hasPurchased = false;
        if (memberId != null) {
            // '구매확정' 상태인 주문에 이 상품이 포함되어 있는지 확인
            hasPurchased = orderService.hasUserPurchasedProduct(memberId, prodId.longValue());
        }
        model.addAttribute("hasPurchased", hasPurchased);

        // 리뷰 목록 조회
        List<ReviewDTO> reviewList = reviewService.getReviewsByProductId(prodId.longValue());
        model.addAttribute("reviewList", reviewList);

        // 상품 문의 목록 조회
        List<QnaDTO> qnaList = qnaService.getQnaByProductId(prodId.longValue());
        model.addAttribute("qnaList", qnaList);

        return "product/productDetail";
    }
}