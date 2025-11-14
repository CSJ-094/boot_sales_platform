package com.boot.controller;

import java.util.List;

import com.boot.dto.NoticeDTO;
import com.boot.service.NoticeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;


@Controller
@RequestMapping("/seller/notices")
public class NoticeController {

 @Autowired
 private NoticeService noticeService;

 // 공지사항 목록 조회
 @GetMapping
 public String list(Model model) {
     List<NoticeDTO> noticeList = noticeService.list();
     model.addAttribute("noticeList", noticeList);
     return "seller/notices"; // 목록 JSP
 }
 
 // 공지사항 등록 폼 보여주기: GET /mypage/write_view
 @GetMapping("/write")
 public String showWriteForm() {
     return "seller/notice_write";  
 }
 
 // 공지사항 등록 처리
 @PostMapping
 public String write(NoticeDTO noticeDTO, RedirectAttributes ra) {
     noticeService.write(noticeDTO);
     
     ra.addFlashAttribute("message", "공지사항이 성공적으로 등록되었습니다.");
     // 등록 후 목록 페이지로 리다이렉트
     return "redirect:/seller/notices"; 
 }

 // 공지사항 상세 보기
 @GetMapping("/content_view")
 public String contentView(@RequestParam("notNo") int notNo, Model model) {
     NoticeDTO notice = noticeService.contentView(notNo);
     if (notice == null) {
         return "redirect:/seller/notices";
     }
     model.addAttribute("notice", notice);
     return "seller/notice_detail";
 }
 
// 수정폼 보여주기
@GetMapping("/modify")
public String showModifyForm(@RequestParam("notNo") int notNo, Model model) {
  NoticeDTO notice = noticeService.contentView(notNo);
  if (notice == null) {
      return "redirect:/seller/notices";
  }
  model.addAttribute("notice", notice);
  return "seller/notice_modify";  // JSP 파일명
}

 // 공지사항 수정 처리
 @PostMapping("/modify")
 public String modify(NoticeDTO noticeDTO, RedirectAttributes ra) {
     noticeService.modify(noticeDTO); 
     ra.addFlashAttribute("message", noticeDTO.getNOT_NO() + "번 공지사항이 수정되었습니다.");
     return "redirect:/seller/notices?notNo=" + noticeDTO.getNOT_NO();
 }

 // 공지사항 삭제 처리: 
 @PostMapping("/delete")
 public String delete(@RequestParam("notNo") int notNo, RedirectAttributes ra) {
     
     noticeService.delete(notNo);
     ra.addFlashAttribute("message", "공지사항이 삭제되었습니다.");
     return "redirect:/seller/notices";
 }
}
