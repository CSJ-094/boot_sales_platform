package com.boot.controller;

import com.boot.service.WishlistService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Controller
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/wishlist")
public class WishlistController {

    private final WishlistService wishlistService;

    @PostMapping("/add")
    public String addWishlist(HttpSession session,
                              @RequestParam("prodId") Integer prodId,
                              RedirectAttributes redirectAttributes,
                              HttpServletRequest request) {

        String memberId = (String) session.getAttribute("memberId");
        if (memberId == null) {
            redirectAttributes.addFlashAttribute("loginError", "로그인이 필요합니다.");
            return "redirect:/login";
        }

        try {
            wishlistService.addWishlist(memberId, prodId);
            redirectAttributes.addFlashAttribute("message", "상품을 찜 목록에 추가했습니다.");
        } catch (Exception e) {
            // 데이터베이스 제약 조건(PK 중복 등) 위반 시 예외가 발생할 수 있습니다.
            log.error("찜하기 추가 중 오류 발생: {}", e.getMessage());
            redirectAttributes.addFlashAttribute("errorMessage", "이미 찜한 상품이거나, 처리 중 오류가 발생했습니다.");
        }

        // 이전 페이지(상품 상세 페이지)로 리다이렉트
        String referer = request.getHeader("Referer");
        return "redirect:" + (referer != null ? referer : "/");
    }

    @PostMapping("/remove")
    public String removeWishlist(HttpSession session,
                                 @RequestParam("prodId") Integer prodId,
                                 RedirectAttributes redirectAttributes,
                                 HttpServletRequest request) {

        String memberId = (String) session.getAttribute("memberId");
        if (memberId == null) {
            // 비로그인 사용자는 이 경로에 접근할 수 없지만, 안전장치로 추가
            return "redirect:/login";
        }

        try {
            wishlistService.removeWishlist(memberId, prodId);
            redirectAttributes.addFlashAttribute("message", "상품을 찜 목록에서 제거했습니다.");
        } catch (Exception e) {
            log.error("찜하기 삭제 중 오류 발생: {}", e.getMessage());
            redirectAttributes.addFlashAttribute("errorMessage", "처리 중 오류가 발생했습니다.");
        }

        String referer = request.getHeader("Referer");
        return "redirect:" + (referer != null ? referer : "/");
    }
}