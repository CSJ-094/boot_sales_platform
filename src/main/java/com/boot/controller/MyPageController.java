package com.boot.controller;

import com.boot.dao.MemDAO;
import com.boot.dto.MemDTO;
import com.boot.dto.OrdDTO;
import com.boot.dto.ProdDTO;
import com.boot.service.OrderService;
import com.boot.service.WishlistService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@Slf4j
@RequestMapping("/mypage")
public class MyPageController {

    @Autowired
    private MemDAO memDAO;

    @Autowired
    private WishlistService wishlistService;

    @Autowired
    private OrderService orderService;

    @GetMapping
    public String mypage_view(HttpSession session, Model model) {
        log.info("@# mypage_view() - 정보 조회 및 리스트 로드");

        String memberId = (String) session.getAttribute("memberId");

        if (memberId == null) {
            log.warn("@# mypage_view() - 세션 ID 없음. 로그인 페이지로 리다이렉트.");
            return "redirect:/login";
        }

        // 1. 회원 정보 조회
        MemDTO memberInfo = memDAO.getMemberInfo(memberId);
        model.addAttribute("memberInfo", memberInfo);

        // 2. 찜목록 조회
        List<ProdDTO> wishlist = wishlistService.getWishlistByMemberId(memberId);
        model.addAttribute("wishlist", wishlist);

        // 3. 주문 내역 조회 (주문 상세 포함)
        List<OrdDTO> orderList = orderService.getOrdersWithDetailsByMemberId(memberId);
        model.addAttribute("orderList", orderList);

        return "user/mypage";
    }

    @PostMapping("/user_info")
    public String mypage_update(@ModelAttribute MemDTO member, RedirectAttributes redirectAttributes) {
        log.info("@# mypage_update() - 정보 수정 요청: {}", member.getMemberId());

        memDAO.modify(member);
        redirectAttributes.addFlashAttribute("updateSuccess", true);
        return "redirect:/mypage";
    }
}
