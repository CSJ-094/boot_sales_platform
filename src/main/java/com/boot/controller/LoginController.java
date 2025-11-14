package com.boot.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import com.boot.dao.MemDAO;
import com.boot.dto.LoginDTO;
import com.boot.dto.MemDTO;
import com.boot.dto.OrdDTO;
import com.boot.dto.ProdDTO;
import com.boot.service.LoginService;
import com.boot.service.OrderService;
import com.boot.service.WishlistService;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;


import lombok.extern.slf4j.Slf4j;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@Slf4j
public class LoginController {


	@Autowired
	private MemDAO memDAO;

	@Autowired
	private LoginService service;

	@Autowired
	private PasswordEncoder passwordEncoder;

	@RequestMapping("login")
	public String login() {
		log.info("@# login()");
		return "login/login";
	}


	// 로그인 여부 판단
	@RequestMapping(value = "login_yn", method = RequestMethod.POST)
	public String login_yn(LoginDTO loginDTO, HttpSession session, Model model) {
	    log.info("@# login_yn() - ID: {}", loginDTO.getMemberId());

		//1. DB에서 아이디 조회
	    LoginDTO resultDTO = service.loginYn(loginDTO);


	    if (resultDTO != null) {
	        String db_pw = resultDTO.getMemberPw(); // Security를 이용해 암호화 된 비밀번호
	        String in_pw = loginDTO.getMemberPw(); // 페이지에서 입력한 비밀번호

	        if (passwordEncoder.matches(in_pw, db_pw)) { //matches를 이용해 값 비교. in_pw가 항상 앞에
	            session.setAttribute("memberId", loginDTO.getMemberId());
	            session.setAttribute("memberName", resultDTO.getMemberName());
				session.setAttribute("userType", "customer");
	            log.info("@# 로그인 성공");
	            return "redirect:/"; // 메인 페이지로 리다이렉트
	        } else {
	            model.addAttribute("loginResult", "비밀번호가 일치하지 않습니다.");
	            log.info("@# 비밀번호 불일치");
	            return "login/login";
	        }
	    } else {
	        model.addAttribute("loginResult", "아이디가 존재하지 않습니다.");
	        log.info("@# 아이디 없음");
	        return "login/login";
	    }
	}

	// 로그아웃
	@RequestMapping("/logout")
	public String logout(HttpSession session) {
		log.info("@# logout() - 세션 무효화 및 로그아웃 처리");
		// 세션 무효화
		session.invalidate();
		// 메인 페이지로 리다이렉트
		return "redirect:/";
	}


	// 등록 화면 이동
	@RequestMapping("register")
	public String register() {
		log.info("@# register()");
		return "login/register";
	}

	// 회원가입 처리
	@RequestMapping("/registerOk")
	public String registerOk(LoginDTO loginDTO) {
		log.info("@# registerOk()");
		service.write(loginDTO);
		return "login/login";
	}

	// 아이디 중복 확인 (Ajax)
	@RequestMapping("/idCheck")
	@ResponseBody
	public Boolean idCheck(LoginDTO loginDTO) {
		log.info("@# idCheck() - 아이디: {}", loginDTO.getMemberId());

		Boolean result = true; // 기본값: 사용 가능 (중복 아님)
		ArrayList<LoginDTO> dtos = service.idCheck(loginDTO);

		if (dtos != null && !dtos.isEmpty()) {
			// 아이디가 존재함 -> 사용 불가능 (false)
			result = false;
		}
		return result;
	}

	// 이메일 중복 확인 (Ajax)
	@RequestMapping("/emailCheck")
	@ResponseBody
	public Boolean emailCheck(LoginDTO loginDTO) {
		log.info("@# emailCheck(LoginDTO) - 이메일: {}", loginDTO.getMemberEmail());

		Boolean result = true; // 기본값: 사용 가능 (중복 아님)
		ArrayList<LoginDTO> dtos = service.emailCheck(loginDTO);

		if (dtos != null && !dtos.isEmpty()) {
			// 이메일이 존재함 -> 사용 불가능 (false)
			result = false;
		}
		return result;
	}

	@PostMapping("/mailCheck")
	@ResponseBody
	public String mailCheck(@RequestParam String email) {
		System.out.println("이메일 인증 요청이 들어옴!");
		System.out.println("이메일 인증 이메일 : " + email);
		return service.joinEmail(email);
	}
}
