package com.boot.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.boot.dao.MemDAO;
import com.boot.dto.MemDTO;
import com.boot.dto.OrdDTO;
import com.boot.dto.ProdDTO;
import com.boot.service.OrderService;
import com.boot.service.WishlistService;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import lombok.extern.slf4j.Slf4j;
import java.util.List;

@Controller
@Slf4j
public class pscontroller {

	@Autowired
	private SqlSession sqlSession;

	@Autowired
	private WishlistService wishlistService;

	@Autowired
	private OrderService orderService;

	@Autowired
	private MemDAO memDAO;

	// ⭐️ 수정: View 이름을 'login/login'으로 통일
	// 로그인 화면 이동 (URL: /login)
	@RequestMapping(value = "/login", method = RequestMethod.GET)
	public String login_view() {
		log.info("@# login_view() - 로그인 페이지 요청");
		return "login/login"; // login/login.jsp 뷰를 반환
	}

	// 로그인 처리 (URL: /login)

	@RequestMapping(value = "/login", method = RequestMethod.POST)
	public String login_process(@RequestParam("username") String username,
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
	// 마이페이지 뷰 (URL: /mypage)
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
	@RequestMapping(value = "/user_info", method = RequestMethod.POST)
	public String mypage_update(HttpServletRequest request, Model model) {
		log.info("@# mypage_update() - 정보 수정 요청");

		MemDTO member = new MemDTO();
		// ... (파라미터 설정 로직 생략) ...

		MemDAO dao = sqlSession.getMapper(MemDAO.class);

		dao.modify(member);

		// ⭐️ 수정: 절대 경로로 리다이렉트
		return "redirect:user/mypage";
	}
}