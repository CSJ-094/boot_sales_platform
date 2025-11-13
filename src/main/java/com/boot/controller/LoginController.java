package com.boot.controller;

import java.util.ArrayList;

import javax.servlet.http.HttpSession;

import com.boot.dto.LoginDTO;
import com.boot.service.LoginService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;


import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class LoginController {
	
	@Autowired
	private LoginService service;

	// ===================================================================
	// 1. 로그인/회원가입 기능
	// ===================================================================

	// 로그인 화면 이동
	@RequestMapping("login")
	public String login() {
		log.info("@# login()");
		return "login/login";
	}

	// 로그인 여부 판단
	@RequestMapping(value = "login_yn", method = RequestMethod.POST)
	public String login_yn(LoginDTO loginDTO, HttpSession session, Model model) {
	    log.info("@# login_yn() - ID: {}", loginDTO.getMemberId());
	    
	    LoginDTO resultDTO = service.loginYn(loginDTO);
	    
	    if (resultDTO != null) {
	        String db_pw = resultDTO.getMemberPw();
	        String in_pw = loginDTO.getMemberPw();
	        
	        if (db_pw.equals(in_pw)) {
	            session.setAttribute("memberId", loginDTO.getMemberId());
	            session.setAttribute("memberName", resultDTO.getMemberName());
	            
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
}
