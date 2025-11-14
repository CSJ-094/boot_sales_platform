package com.boot.controller;

import com.boot.dto.LoginDTO;
import com.boot.service.LoginService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/seller")
@Slf4j
public class SellerController {

    @Autowired
    private LoginService loginService; // LoginService 주입

    @GetMapping("/login")
    public String sellerLogin() {
        log.info("@# sellerLogin() - 판매자 로그인 페이지 요청");
        return "seller/login"; // 판매자 로그인 페이지 뷰 이름
    }

    // Spring Security가 판매자 로그인 처리를 담당하도록 이 메소드를 추가합니다.
    // 실제 인증 로직은 SecurityConfig와 UserDetailsService에서 처리됩니다.
    @PostMapping("/loginCheck")
    public String loginCheck() {
        log.info("@# loginCheck() - 판매자 로그인 요청 (Spring Security가 처리)");
        // 이 메소드는 Spring Security 필터 체인에 의해 가로채지므로,
        // 실제로는 여기에 도달하지 않거나, 성공 시 defaultSuccessUrl로 리다이렉트됩니다.
        // 실패 시에는 loginPage("/login?error") 등으로 리다이렉트됩니다.
        return "redirect:/mainpage"; // 임시 리다이렉트 (실제로는 SecurityConfig에서 처리)
    }

    // 판매자 회원가입 페이지 요청
    @GetMapping("/register")
    public String sellerRegister() {
        log.info("@# sellerRegister() - 판매자 회원가입 페이지 요청");
        return "seller/sellerRegister";
    }

    // 판매자 회원가입 폼 제출 처리
    @PostMapping("/registerOk")
    public String sellerRegisterOk(LoginDTO loginDTO) { // LoginDTO를 재활용
        log.info("@# sellerRegisterOk() - 판매자 회원가입 요청: {}", loginDTO.getSelId());
        loginService.writeSeller(loginDTO); // 판매자 회원가입 처리 (새로운 서비스 메소드 필요)
        return "redirect:/login"; // 회원가입 성공 후 로그인 페이지로 리다이렉트
    }
}