package com.boot.controller;

import com.boot.dto.QnaDTO;
import com.boot.service.QnaService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;

@Controller
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/qna")
public class QnaController {

    private final QnaService qnaService;

    @PostMapping("/add")
    public String addQuestion(QnaDTO qnaDTO, HttpSession session, RedirectAttributes redirectAttributes) {
        String memberId = (String) session.getAttribute("memberId");
        if (memberId == null) {
            return "redirect:/login";
        }
        qnaDTO.setMemberId(memberId);

        // 비밀글 체크박스가 체크되지 않으면 'N'으로 설정
        if (qnaDTO.getQnaIsSecret() == null) {
            qnaDTO.setQnaIsSecret("N");
        }

        qnaService.addQuestion(qnaDTO);
        redirectAttributes.addFlashAttribute("message", "상품 문의가 등록되었습니다.");
        return "redirect:/product/detail?id=" + qnaDTO.getProdId() + "#qna";
    }
}