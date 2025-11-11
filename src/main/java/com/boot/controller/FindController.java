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
	
    /**
     * 아이디 찾기 페이지를 보여줍니다.
     */
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
	
    /**
     * 아이디 찾기 정보를 확인하고 결과를 반환합니다.
     * 파라미터를 HashMap에서 LoginDTO로 변경하고, Service의 DTO 기반 메서드를 호출합니다.
     */
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
    
    /**
     * 비밀번호 찾기 정보를 확인하고 결과를 반환합니다.
     * 파라미터를 HashMap에서 LoginDTO로 변경하고, Service의 DTO 기반 메서드를 호출합니다.
     */
	@PostMapping("findPwCheck")
	// ⚠️ HashMap 대신 LoginDTO를 파라미터로 받아 Service의 기조에 맞춥니다.
	public String findPwCheck(LoginDTO loginDTO, Model model) {
		log.info("@# findPwCheck() - 비밀번호 찾기 처리. ID: " + loginDTO.getMemberId() + 
				", Name: " + loginDTO.getMemberName() + ", Email: " + loginDTO.getMemberEmail());
		
		// (LoginService 인터페이스를 보면 findPw는 ArrayList<LoginDTO>를 반환해야 합니다.)
		ArrayList<LoginDTO> dtos = loginService.findPw(loginDTO);
		
		// 비밀번호를 찾았는지 확인합니다.
		if (dtos == null || dtos.isEmpty()) {
		    // 회원 정보를 찾지 못한 경우
		    model.addAttribute("findError", "입력하신 정보와 일치하는 회원 정보를 찾을 수 없습니다.");
			return "redirect:/login";
		} else {
			// 비밀번호 찾기 성공 (일반적으로 첫 번째 DTO만 사용)
			LoginDTO foundDto = dtos.get(0);
		    // **주의: 실제 서비스에서는 이메일/SMS로 임시 비밀번호를 발급하거나 재설정 페이지로 이동해야 합니다.**
			log.info("@# 회원 정보 찾기 성공. ID: {}", foundDto.getMemberId()); 
			
			model.addAttribute("member", foundDto);
			// 임시 비밀번호 발급 로직이나 재설정 페이지로 이동하는 것이 보안상 가장 좋습니다.
			return "find/findPwResult"; 
		}
	}
}
