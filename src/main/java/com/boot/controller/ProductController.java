package com.boot.controller;

import com.boot.dto.ProdDTO;
import com.boot.dto.QnaDTO;
import com.boot.dto.ReviewDTO;
import com.boot.service.OrderService;
import com.boot.service.ProductService;
import com.boot.service.QnaService;
import com.boot.service.ReviewService;
import com.boot.service.WishlistService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;


import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/products")
@RequiredArgsConstructor
public class ProductController {

    private final ProductService productService;
    private final OrderService orderService;
    private final ReviewService reviewService;
    private final QnaService qnaService;
    private final WishlistService wishlistService;

    // 상품 상세 페이지 조회
    @GetMapping("/detail")
    public String getProductDetail(@RequestParam("prodId") Integer prodId, Model model, HttpSession session) {
        ProdDTO product = productService.getProductById(prodId);
        model.addAttribute("product", product);

        String memberId = (String) session.getAttribute("memberId");
        model.addAttribute("memberId", memberId);

        boolean hasPurchased = false;
        boolean isWished = false;
        if (memberId != null) {
            // '구매확정' 상태인 주문에 이 상품이 포함되어 있는지 확인
            hasPurchased = orderService.hasUserPurchasedProduct(memberId, prodId.longValue());
            // 찜 목록에 있는지 확인
            isWished = wishlistService.isProductInWishlist(memberId, prodId);
        }
        model.addAttribute("hasPurchased", hasPurchased);
        model.addAttribute("isWished", isWished); // ⭐️ 찜 상태를 모델에 추가

        // 리뷰 목록 조회
        List<ReviewDTO> reviewList = reviewService.getReviewsByProductId(prodId.longValue());
        model.addAttribute("reviewList", reviewList);

        // 상품 문의 목록 조회
        List<QnaDTO> qnaList = qnaService.getQnaByProductId(prodId.longValue());
        model.addAttribute("qnaList", qnaList);

        return "product/productDetail";
    }
}