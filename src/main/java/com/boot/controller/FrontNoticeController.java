package com.boot.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.boot.dto.NoticeDTO;
import com.boot.service.NoticeService;

@Controller
@RequestMapping("/notices") // ★ seller 안 붙임 (구매자용)
public class FrontNoticeController {

    @Autowired
    private NoticeService noticeService;

    // 목록
    @GetMapping
    public String list(Model model) {
        List<NoticeDTO> noticeList = noticeService.list();
        model.addAttribute("noticeList", noticeList);
        return "front/notice_list";  // 아래에서 만들 JSP
    }

    // 상세
    @GetMapping("/view")
    public String view(@RequestParam("notNo") int notNo, Model model) {
        NoticeDTO notice = noticeService.contentView(notNo);
        if (notice == null) {
            return "redirect:/notices";
        }
        model.addAttribute("notice", notice);
        return "front/notice_detail";
    }
}