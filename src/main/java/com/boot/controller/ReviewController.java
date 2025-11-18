package com.boot.controller;

import com.boot.dto.ProdDTO;
import com.boot.dto.ReviewDTO;
import com.boot.service.ProductService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;

@Controller
@Slf4j
@RequestMapping("/reviews")
public class ReviewController {

    @Autowired
    private ProductService productService;

    @Autowired
    private com.boot.service.ReviewService reviewService;

    @GetMapping("/write")
    public String showReviewWriteForm(@RequestParam("productId") Long productId, // Integer -> Long 변경
                                      @RequestParam("orderId") String orderId,
                                      HttpSession session, Model model) {
        String memberId = (String) session.getAttribute("memberId");
        if (memberId == null) {
            return "redirect:/login";
        }

        // 리뷰할 상품 정보 조회
        ProdDTO product = productService.getProductById(productId);
        model.addAttribute("product", product);
        model.addAttribute("orderId", orderId);

        return "user/writereview";
    }

    @PostMapping("/add")
    public String addReview(@RequestParam("productId") Long productId,
                            @RequestParam("memberId") String memberId,
                            @RequestParam("rating") int rating,
                            @RequestParam("content") String content,
                            RedirectAttributes redirectAttributes) {

        ReviewDTO reviewDTO = new ReviewDTO();
        reviewDTO.setProdId(productId);
        reviewDTO.setMemberId(memberId);
        reviewDTO.setRating(rating);
        reviewDTO.setReviewContent(content);

        reviewService.addReview(reviewDTO);
        log.info("@# 리뷰 등록 완료: 상품 ID={}, 작성자={}", productId, memberId);
        redirectAttributes.addFlashAttribute("message", "리뷰가 성공적으로 등록되었습니다.");

        return "redirect:/mypage#order-history";
    }
}
