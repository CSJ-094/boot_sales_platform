package com.boot.controller;

import com.boot.dto.ProdDTO;
import com.boot.dto.QnaDTO;
import com.boot.dto.ReviewDTO;
import com.boot.dto.ProductSearchCondition;
import com.boot.service.OrderService;
import com.boot.service.ProductService;
import com.boot.service.ReviewService;
import com.boot.service.QnaService;
import com.boot.service.WishlistService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpSession;
@Controller
@RequestMapping("/product")
public class ProductController {

    @Autowired
    private ProductService productService;

    @Autowired
    private OrderService orderService;

    @Autowired
    private ReviewService reviewService;

    @Autowired
    private QnaService qnaService;

    @Autowired
    private WishlistService wishlistService;

    // 상품 상세 페이지 조회
    @GetMapping("/detail")
    public String getProductDetail(@RequestParam("id") Long prodId, Model model, HttpSession session) { // 파라미터 이름을 id로 변경, prodId 타입을 Long으로 변경
        ProdDTO product = productService.getProductById(prodId);
        model.addAttribute("product", product);

        String memberId = (String) session.getAttribute("memberId");
        model.addAttribute("memberId", memberId);

        // 로그인한 경우, 해당 상품 구매 이력 확인
        boolean hasPurchased = false;
        if (memberId != null) {
            // '구매확정' 상태인 주문에 이 상품이 포함되어 있는지 확인
            hasPurchased = orderService.hasUserPurchasedProduct(memberId, prodId); // prodId 타입을 Long으로 변경
        }
        model.addAttribute("hasPurchased", hasPurchased);

        // 리뷰 목록 조회
        List<ReviewDTO> reviewList = reviewService.getReviewsByProductId(prodId); // prodId 타입을 Long으로 변경
        model.addAttribute("reviewList", reviewList);

        // 상품 문의 목록 조회
        List<QnaDTO> qnaList = qnaService.getQnaByProductId(prodId); // prodId 타입을 Long으로 변경
        model.addAttribute("qnaList", qnaList);

        // ⭐️ 로그인한 경우, 해당 상품이 찜목록에 있는지 확인
        boolean isWished = false;
        if (memberId != null) {
            isWished = wishlistService.isProductInWishlist(memberId, prodId); // 메서드 이름 변경, prodId 타입을 Long으로 변경
        }
        model.addAttribute("isWished", isWished);

        return "product/productDetail";
    }

    // 상품 검색 기능 (ProductSearchCondition을 파라미터로 받도록 변경)
    @GetMapping("/search")
    public String searchProducts(ProductSearchCondition condition, Model model) {
        List<ProdDTO> searchResult = productService.searchProducts(condition);
        model.addAttribute("searchResult", searchResult);
        model.addAttribute("condition", condition); // 검색 조건을 뷰로 전달
        return "product/searchResult"; // 검색 결과 페이지로 이동
    }

    // 찜목록 추가/삭제 토글 기능 (AJAX 요청 처리)
    @PostMapping("/toggleWishlist")
    @ResponseBody // JSON 응답을 위해 추가
    public ResponseEntity<?> toggleWishlist(@RequestParam("prodId") Long prodId, // prodId 타입을 Long으로 변경
                                            @RequestParam("isWished") boolean isWished,
                                            HttpSession session) {
        String memberId = (String) session.getAttribute("memberId");
        if (memberId == null) {
            // 로그인되어 있지 않으면 401 Unauthorized 응답
            return ResponseEntity.status(401).body(Map.of("message", "로그인이 필요합니다."));
        }

        try {
            if (isWished) { // 현재 찜 상태이면 찜 해제
                wishlistService.removeProductFromWishlist(memberId, prodId); // 메서드 이름 변경
                return ResponseEntity.ok(Map.of("message", "찜목록에서 제거되었습니다.", "isWished", false));
            } else { // 현재 찜 상태가 아니면 찜하기
                wishlistService.addProductToWishlist(memberId, prodId); // 메서드 이름 변경
                return ResponseEntity.ok(Map.of("message", "찜목록에 추가되었습니다.", "isWished", true));
            }
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("message", e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(500).body(Map.of("message", "찜목록 처리 중 오류가 발생했습니다."));
        }
    }
}
