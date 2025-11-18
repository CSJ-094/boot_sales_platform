package com.boot.controller;

import com.boot.dao.CategoryDAO; // CategoryDAO import 추가
import com.boot.dto.CategoryDTO; // CategoryDTO import 추가
import com.boot.dto.ProdDTO;
import com.boot.dto.QnaDTO;
import com.boot.dto.ReviewDTO;
import com.boot.dto.ProductSearchCondition;
import com.boot.service.OrderService;
import com.boot.service.ProductService;
import com.boot.service.QnaService;
import com.boot.service.ReviewService;
import com.boot.service.WishlistService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/product")
@RequiredArgsConstructor
public class ProductController {

    private final ProductService productService;
    private final OrderService orderService;
    private final ReviewService reviewService;
    private final QnaService qnaService;
    private final WishlistService wishlistService;
    private final CategoryDAO categoryDAO; // CategoryDAO 주입

    // 상품 상세 페이지 조회
    @GetMapping("/detail")
    public String getProductDetail(@RequestParam("id") Long prodId, Model model, HttpSession session) {
        ProdDTO product = productService.getProductById(prodId);
        model.addAttribute("product", product);

        String memberId = (String) session.getAttribute("memberId");
        model.addAttribute("memberId", memberId);

        boolean hasPurchased = false;
        boolean isWished = false;
        if (memberId != null) {
            hasPurchased = orderService.hasUserPurchasedProduct(memberId, prodId);
            isWished = wishlistService.isProductInWishlist(memberId, prodId);
        }
        model.addAttribute("hasPurchased", hasPurchased);
        model.addAttribute("isWished", isWished);

        // 리뷰 목록 조회
        List<ReviewDTO> reviewList = reviewService.getReviewsByProductId(prodId);
        model.addAttribute("reviewList", reviewList);

        // 상품 문의 목록 조회
        List<QnaDTO> qnaList = qnaService.getQnaByProductId(prodId);
        model.addAttribute("qnaList", qnaList);

        return "product/productDetail";
    }

    // 상품 검색 기능
    @GetMapping("/search")
    public String searchProducts(ProductSearchCondition condition, Model model) {
        List<ProdDTO> searchResult = productService.searchProducts(condition);
        model.addAttribute("searchResult", searchResult);
        model.addAttribute("condition", condition);
        
        // 모든 카테고리 목록을 모델에 추가
        List<CategoryDTO> categories = categoryDAO.selectTreeFlat();
        model.addAttribute("categories", categories);

        return "product/searchResult";
    }

    // 찜목록 추가/삭제 토글 기능 (AJAX 요청 처리)
    @PostMapping("/toggleWishlist")
    @ResponseBody
    public ResponseEntity<?> toggleWishlist(@RequestParam("prodId") Long prodId,
                                            @RequestParam("isWished") boolean isWished,
                                            HttpSession session) {
        String memberId = (String) session.getAttribute("memberId");
        if (memberId == null) {
            return ResponseEntity.status(401).body(Map.of("message", "로그인이 필요합니다."));
        }

        try {
            if (isWished) {
                wishlistService.removeProductFromWishlist(memberId, prodId);
                return ResponseEntity.ok(Map.of("message", "찜목록에서 제거되었습니다.", "isWished", false));
            } else {
                wishlistService.addProductToWishlist(memberId, prodId);
                return ResponseEntity.ok(Map.of("message", "찜목록에 추가되었습니다.", "isWished", true));
            }
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("message", e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(500).body(Map.of("message", "찜목록 처리 중 오류가 발생했습니다."));
        }
    }
}
