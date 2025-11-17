package com.boot.controller;

import java.util.ArrayList;

import javax.servlet.http.HttpSession;

import com.boot.dto.CouponDTO; // CouponDTO 임포트 추가
import com.boot.dto.LoginDTO;
import com.boot.service.LoginService;
import com.boot.service.PointService;
import com.boot.service.CouponService; // CouponService 임포트 추가
import com.boot.service.UserCouponService; // UserCouponService 임포트 추가
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class LoginController {

	@Autowired
	private LoginService service;

	@Autowired
	private PointService pointService;

	@Autowired
	private CouponService couponService; // CouponService 주입

	@Autowired
	private UserCouponService userCouponService; // UserCouponService 주입

	@RequestMapping("/login")
	public String login() {
		log.info("@# login");

		return "login/login";
	}

	@RequestMapping("/logout")
	public String logout(HttpSession session) {
		log.info("@# logout");

		session.invalidate();

		return "redirect:login";
	}

	@GetMapping("/register")
	public String register() {
		log.info("@# register");

		return "login/register";
	}

	@PostMapping("/registerOk") // 기존의 /write 매핑을 /registerOk로 변경
	public String registerOk(LoginDTO loginDTO) {
		log.info("@# registerOk() - 회원가입 요청: {}", loginDTO.getMemberId());

		service.write(loginDTO); // 회원가입 처리

		// ⭐️ 회원가입 시 포인트 적립
		final int REGISTRATION_POINT = 5000; // 5,000 포인트 적립
		pointService.earnPoint(loginDTO.getMemberId(), REGISTRATION_POINT, "회원가입 축하 포인트");
		log.info("회원가입 축하 포인트 지급: memberId={}, amount={}", loginDTO.getMemberId(), REGISTRATION_POINT);

		// ⭐️ 회원가입 시 쿠폰 자동 지급
		try {
			// 1. 15% 할인 쿠폰 (최대 2만원 할인)
			CouponDTO coupon1 = couponService.getCouponByName("장바구니 15% 할인 (최대 2만원)");
			if (coupon1 != null) {
				userCouponService.issueCouponToUser(loginDTO.getMemberId(), coupon1.getCouponId());
				log.info("회원가입 쿠폰 지급: memberId={}, couponName={}", loginDTO.getMemberId(), coupon1.getCouponName());
			} else {
				log.warn("쿠폰 '장바구니 15% 할인 (최대 2만원)'을 찾을 수 없습니다. 먼저 쿠폰을 생성해야 합니다.");
			}

			// 2. 3만원 이상 구매 시 3천원 추가 할인 쿠폰
			CouponDTO coupon2 = couponService.getCouponByName("3만원 이상 구매 시 3천원 할인");
			if (coupon2 != null) {
				userCouponService.issueCouponToUser(loginDTO.getMemberId(), coupon2.getCouponId());
				log.info("회원가입 쿠폰 지급: memberId={}, couponName={}", loginDTO.getMemberId(), coupon2.getCouponName());
			} else {
				log.warn("쿠폰 '3만원 이상 구매 시 3천원 할인'을 찾을 수 없습니다. 먼저 쿠폰을 생성해야 합니다.");
			}
		} catch (Exception e) {
			log.error("회원가입 시 쿠폰 지급 중 오류 발생: {}", e.getMessage(), e);
		}

		return "redirect:/login"; // 회원가입 성공 후 로그인 페이지로 리다이렉트
	}

	@RequestMapping("/id_check")
	@ResponseBody
	public String id_check(@RequestParam("memberId") String memberId) {
		log.info("@# id_check with id: {}", memberId);

		ArrayList<LoginDTO> dtos = service.idCheck(memberId);

		if (dtos.isEmpty()) {
			return "y";
		} else {
			return "n";
		}
	}

	@RequestMapping("/email_check")
	@ResponseBody
	public String email_check(@RequestParam("memberEmail") String memberEmail) {
		log.info("@# email_check with email: {}", memberEmail);

		ArrayList<LoginDTO> dtos = service.emailCheck(memberEmail);

		if (dtos.isEmpty()) {
			return "y";
		} else {
			return "n";
		}
	}

	@PostMapping("/mailCheck")
	@ResponseBody
	public String mailCheck(@RequestParam("email") String email) {
		log.info("@# mailCheck with email: {}", email);
		return service.joinEmail(email);
	}
}
