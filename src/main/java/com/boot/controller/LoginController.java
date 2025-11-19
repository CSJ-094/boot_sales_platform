package com.boot.controller;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpSession;

import com.boot.dao.MemDAO;
import com.boot.dto.*;
import com.boot.service.CouponService; // 추가
import com.boot.service.LoginService;
import com.boot.service.OrderService;
import com.boot.service.PointService; // 추가
import com.boot.service.UserCouponService; // 추가
import com.boot.service.WishlistService;
import org.apache.ibatis.session.SqlSession;
import org.apache.tomcat.util.http.parser.HttpParser;
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

	@Autowired // 추가
	private PointService pointService; // 추가

	@Autowired // 추가
	private CouponService couponService; // 추가

	@Autowired // 추가
	private UserCouponService userCouponService; // 추가

	@RequestMapping("login")
	public String login() { // HttpServletRequest, HttpSession 파라미터 제거
		log.info("@# login()");
		// 자동 로그인 쿠키 확인 로직 제거
		return "login/login";
	}


	// 로그인 여부 판단
	@RequestMapping(value = "login_yn", method = RequestMethod.POST)
	public String login_yn(LoginDTO loginDTO, HttpSession session, Model model, RedirectAttributes redirectAttributes) { // rememberMe, HttpServletResponse 파라미터 제거
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
				// 룰렛 이벤트 플래그를 FlashAttribute에 추가 (리다이렉트 후 1회만 유효)
				redirectAttributes.addFlashAttribute("showRouletteEvent", true);
	            log.info("@# 로그인 성공");

				// 자동 로그인 처리 로직 제거
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
	public String logout(HttpSession session) { // HttpServletResponse 파라미터 제거
		log.info("@# logout() - 세션 무효화 및 로그아웃 처리");
		String memberId = (String) session.getAttribute("memberId");

		// 자동 로그인 쿠키 삭제 및 DB 토큰 삭제 로직 제거

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

	// 회원가입 처리 (boot_sales_platform-A의 로직으로 업데이트)
	@PostMapping("/registerOk")
	public String registerOk(LoginDTO loginDTO) {
		log.info("@# registerOk() - 회원가입 요청: {}", loginDTO.getMemberId());

		service.write(loginDTO); // 회원가입 처리

		// ⭐️ 회원가입 시 포인트 적립
		final int REGISTRATION_POINT = 5000; // 5,000 포인트 적립
		pointService.earnPoint(loginDTO.getMemberId(), REGISTRATION_POINT, "회원가입 축하 포인트");
		log.info("회원가입 축하 포인트 지급: memberId={}, amount={}", loginDTO.getMemberId(), REGISTRATION_POINT);

		// ⭐️ 회원가입 시 쿠폰 자동 지급
		issueWelcomeCoupons(loginDTO.getMemberId());

		return "redirect:/login"; // 회원가입 성공 후 로그인 페이지로 리다이렉트
	}

	private void issueWelcomeCoupons(String memberId) {
		try {
			// 1. 15% 할인 쿠폰 (최대 2만원)
			createAndIssueCoupon(memberId, "신규가입 15% 할인", "PERCENT", 15, 0, 20000, 30, "신규 회원 대상 15% 할인 쿠폰");

			// 2. 3만원 이상 구매 시 3천원 추가 할인 쿠폰
			createAndIssueCoupon(memberId, "신규가입 3천원 할인", "AMOUNT", 3000, 30000, null, 30, "3만원 이상 구매 시 3천원 할인");

			// 3. 무료 배송 쿠폰
			createAndIssueCoupon(memberId, "신규가입 무료배송", "SHIPPING", 0, 0, null, 30, "배송비 무료 쿠폰 (1회)");

		} catch (Exception e) {
			log.error("회원가입 쿠폰 발급 중 오류 발생: memberId={}", memberId, e);
		}
	}

	private void createAndIssueCoupon(String memberId, String couponName, String couponType, int discountValue, int minOrderAmount, Integer maxDiscountAmount, int validityDays, String description) throws Exception {
		// 동일한 이름의 쿠폰이 있는지 확인 (중복 생성 방지)
		CouponDTO existingCoupon = couponService.getCouponByName(couponName);
		Long couponId;

		if (existingCoupon == null) {
			CouponDTO newCoupon = new CouponDTO();
			newCoupon.setCouponName(couponName);
			newCoupon.setCouponType(couponType);
			newCoupon.setDiscountValue(discountValue);
			newCoupon.setMinOrderAmount(minOrderAmount);
			newCoupon.setMaxDiscountAmount(maxDiscountAmount);
			newCoupon.setDescription(description);
			newCoupon.setIsActive("Y");
			newCoupon.setIssueDate(new Date());

			Calendar cal = Calendar.getInstance();
			cal.add(Calendar.DATE, validityDays);
			newCoupon.setExpirationDate(cal.getTime());

			couponService.createCoupon(newCoupon);
			couponId = newCoupon.getCouponId(); // MyBatis useGeneratedKeys에 의해 ID가 설정됨
			log.info("신규 환영 쿠폰 생성: {}", couponName);
		} else {
			couponId = existingCoupon.getCouponId();
			log.info("기존 환영 쿠폰 사용: {}", couponName);
}

		userCouponService.issueCouponToUser(memberId, couponId);
		log.info("쿠폰 발급 완료: memberId={}, couponName={}", memberId, couponName);
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

//	=================카카오 로그인 구현=================

	@GetMapping("api/v1/oauth2/kakao")
	public String KakaoCallback(@RequestParam String code, HttpSession session, RedirectAttributes redirectAttributes) {
		log.info("@# 카카오 인증 확인용 로그 = " + code);

		String accessToken = service.getAccessToken(code);

		KakaoUserInfo userInfo= service.getUserInfo(accessToken);

		LoginDTO loginCheck = service.kakaoLoginProcess(userInfo);

		session.setAttribute("memberId", loginCheck.getMemberId());
		session.setAttribute("memberName", loginCheck.getMemberName());
        session.setAttribute("userType", "kakao");
        session.setAttribute("kakaoAccessToken", accessToken);

		// 카카오 로그인 시에도 룰렛 이벤트를 FlashAttribute에 추가
		redirectAttributes.addFlashAttribute("showRouletteEvent", true);

        //카카오 로그인 시 주소가 초기값이면 정보 수정 페이지로 넘어가게 하기.
        if("default".equals(loginCheck.getMemberAddr1())){
            redirectAttributes.addFlashAttribute("msg", "주소를 입력해주세요!");
            return "redirect:/mypage#member-info";
        }

		return "redirect:/";
	}

    //카카오 회원 탈퇴
    @PostMapping("/mypage/deleteUser")
    public String deleteUser(HttpSession session) {

        String userType = (String) session.getAttribute("userType");
        String accessToken = (String) session.getAttribute("kakaoAccessToken");
        String memberId = (String) session.getAttribute("memberId");

        if("kakao".equals(userType)) {
            if(accessToken != null) {
                service.kakaoUnlink(accessToken);
            }
            service.deleteKakaoUser(memberId);
        }else {
            service.deleteUser(memberId);
        }

        session.invalidate();

        return "redirect:/";

    }
}
