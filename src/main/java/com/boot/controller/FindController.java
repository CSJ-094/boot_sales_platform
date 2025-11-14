package com.boot.controller;

import java.util.ArrayList;

import com.boot.dto.LoginDTO;
import com.boot.service.LoginService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

// DTO를 LoginDTO로 통일합니다. (MemDTO 대신)

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("find")
public class FindController {

    @Autowired
    private LoginService loginService;

    @RequestMapping("/findOption")
    public String findOption() {
        log.info("@# findOption() - 아이디/비밀번호 찾기 선택 페이지 요청");

        return "find/findOption";
    }

    @RequestMapping("findId")
    public String findId() {
        log.info("@# findId() - 아이디 찾기 페이지 요청");

        return "find/findId"; // findId.jsp로 이동
    }

    @RequestMapping("findPw")
    public String findPw() {
        log.info("@# findPw() - 비밀번호 찾기 페이지 요청");

        return "find/findPw"; // findPw.jsp로 이동
    }

    @RequestMapping("findIdCheck")
    public String findIdCheck(LoginDTO loginDTO, Model model) {
        log.info("@# findIdCheck() - 아이디 찾기 처리. Name: {}, Email: {}",
                loginDTO.getMemberName(), loginDTO.getMemberEmail());

        ArrayList<LoginDTO> dtos = loginService.findId(loginDTO);

        if (dtos == null || dtos.isEmpty()) {
            model.addAttribute("findError", "입력하신 정보와 일치하는 아이디를 찾을 수 없습니다.");
            return "redirect:/login";
        } else {
            log.info("@# 찾은 아이디 목록: {}", dtos.size());
            model.addAttribute("dtos", dtos);
            return "find/findIdResult"; // findIdResult.jsp로 이동
        }
    }

    @PostMapping("findPwCheck")
    public String findPwCheck(LoginDTO loginDTO, Model model) {
        log.info("@# findPwCheck() - 비밀번호 찾기 처리. ID: " + loginDTO.getMemberId() +
                ", Name: " + loginDTO.getMemberName() + ", Email: " + loginDTO.getMemberEmail());


        ArrayList<LoginDTO> dtos = loginService.findPw(loginDTO);
        if (dtos == null || dtos.isEmpty()) {
            model.addAttribute("findError", "입력하신 정보와 일치하는 회원 정보를 찾을 수 없습니다.");
            return "redirect:/login";
        } else {
            try {
                LoginDTO foundDto = dtos.get(0);
                model.addAttribute("member", foundDto);
                loginService.sendTempPw(dtos.get(0));
            } catch (Exception e) {
                log.error("@# 임시 비밀번호 전송 실패", e);
                model.addAttribute("findError", "임시 비밀번호 전송에 실패했습니다.");
                return "redirect:/login";
            }
            log.info("@# 임시 비밀번호 전송 성공");
            return "find/findPwResult";
        }
        //
    }
}


