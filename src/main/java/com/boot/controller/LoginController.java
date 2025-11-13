package com.boot.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
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
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;


import lombok.extern.slf4j.Slf4j;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@Slf4j
public class LoginController {

	@Autowired
	private SqlSession sqlSession;

	@Autowired
	private WishlistService wishlistService;

	@Autowired
	private OrderService orderService;

	@Autowired
	private MemDAO memDAO;

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

	@RequestMapping(value = "/login", method = RequestMethod.POST)
	public String login_process(
			@RequestParam("username") String username,
			@RequestParam("password") String password,
			@RequestParam("userType") String userType,
			HttpSession session,
			RedirectAttributes redirectAttributes) {

		log.info("@# login_process() - 로그인 시도: ID={}, UserType={}", username, userType);

		MemDTO member = memDAO.getUserById(username);

		if (member != null && member.getMemberPw().equals(password)) {
			// ⭐️ 세션 키 통일: memberId로 유지
			session.setAttribute("memberId", member.getMemberId());
			// ⭐️ 세션 키 통일: sessionName 대신 memberName 권장
			session.setAttribute("memberName", member.getMemberName());
			session.setAttribute("sessionUserType", userType);
			log.info("@# 로그인 성공: ID={}, UserType={}", username, userType);
			return "redirect:user/mypage";
		} else {
			redirectAttributes.addFlashAttribute("loginError", "아이디 또는 비밀번호가 일치하지 않습니다.");
			log.warn("@# 로그인 실패: ID={}", username);
			return "redirect:/login";
		}
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

	@RequestMapping(value = "/mypage", method = RequestMethod.GET)
	public String mypage_view(HttpSession session, Model model) {
		log.info("@# mypage_view() - 정보 조회 및 리스트 로드");

		String memberId = (String) session.getAttribute("memberId");

		// 로그인 체크
		if (memberId == null) {
			log.warn("@# mypage_view() - 세션 ID 없음. 로그인 페이지로 리다이렉트.");
			return "redirect:/login"; // 절대 경로 유지
		}

		// 1. 회원 정보 조회
		MemDAO memDao = sqlSession.getMapper(MemDAO.class);
		MemDTO memberInfo = memDao.getMemberInfo(memberId);


		if (memberInfo != null) {
			model.addAttribute("memberInfo", memberInfo);
		} else {
			log.error("@# 회원 정보 조회 실패: ID={}", memberId);
		}

		// 찜목록 조회 및 Model에 추가
		List<ProdDTO> wishlist = wishlistService.getWishlistByMemberId(memberId);
		model.addAttribute("wishlist", wishlist);

		// 주문 내역 조회 및 Model에 추가
		List<OrdDTO> orderList = orderService.getOrdersByMemberId(memberId);
		model.addAttribute("orderList", orderList);

		return "user/mypage"; // mypage.jsp 뷰를 반환
	}

	// 마이페이지 정보 수정 처리 (URL: /user_info)
	@PostMapping(value = "/user_info")
	public String mypage_update(@ModelAttribute MemDTO member, RedirectAttributes redirectAttributes) {
		log.info("@# mypage_update() - 정보 수정 요청", member);

		MemDAO dao = sqlSession.getMapper(MemDAO.class);

		dao.modify(member);
//		addFlashAttribute = 일회성으로 값 전달 후 사라짐.
		redirectAttributes.addFlashAttribute("updateSuccess", true);
		// ⭐️ 수정: 절대 경로로 리다이렉트
		return "redirect:/mypage";
	}
}
