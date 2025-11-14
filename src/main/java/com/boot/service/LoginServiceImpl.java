package com.boot.service;

import java.util.ArrayList;
import java.util.Random;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

import com.boot.dao.CartDAO;
import com.boot.dao.LoginDAO;
import com.boot.dao.UserCouponDAO;
import com.boot.dao.WishlistDAO;
import com.boot.dto.LoginDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;


import lombok.extern.slf4j.Slf4j;


@Service
@Slf4j
public class LoginServiceImpl implements LoginService {

	@Autowired
	private LoginDAO loginDAO;
	@Autowired
	private PasswordEncoder passwordEncoder;
	@Autowired
	private JavaMailSenderImpl mailSender;
	@Autowired
	private CartDAO cartDAO;
	@Autowired
	private WishlistDAO wishlistDAO;
	@Autowired
	private UserCouponDAO userCouponDAO;
	private int authNumber;


	//로그인 기능 (구매자)
	@Override
	public LoginDTO loginYn(LoginDTO loginDTO) {
		log.info("@# loginYn({})", loginDTO.getMemberId());
		
		LoginDTO resultDTO = loginDAO.loginYn(loginDTO.getMemberId());

		if (resultDTO != null && passwordEncoder.matches(loginDTO.getMemberPw(), resultDTO.getMemberPw()) && "ACTIVE".equals(resultDTO.getMemberStatus())) {
			return resultDTO;
		}

		return null;
	}

	// 판매자 로그인 기능
	@Override
	public LoginDTO loginSellerYn(LoginDTO loginDTO) {
		log.info("@# loginSellerYn({})", loginDTO.getSelId());

		LoginDTO resultDTO = loginDAO.sellerLoginYn(loginDTO.getSelId());

		if (resultDTO != null && passwordEncoder.matches(loginDTO.getSelPw(), resultDTO.getSelPw())) {
			return resultDTO;
		}

		return null;
	}

	//회원가입 기능 (구매자)
	@Override
    @Transactional
	public void write(LoginDTO loginDTO) {
		log.info("@# write({})", loginDTO.getMemberId());

        LoginDTO withdrawnMember = loginDAO.findWithdrawnMember(loginDTO.getMemberId());

        String encodedPw = "{bcrypt}" + passwordEncoder.encode(loginDTO.getMemberPw());
		loginDTO.setMemberPw(encodedPw);

        if (withdrawnMember != null) {
            log.info("탈퇴한 회원 재가입 처리: {}", loginDTO.getMemberId());
            loginDAO.rejoinMember(loginDTO);
        } else {
            log.info("신규 회원 가입 처리: {}", loginDTO.getMemberId());
            loginDAO.write(loginDTO);
        }
	}

	// 판매자 회원가입 기능
	@Override
	public void writeSeller(LoginDTO loginDTO) {
		log.info("@# writeSeller({})", loginDTO.getSelId());
		loginDTO.setSelPw("{noop}" + loginDTO.getSelPw());
		loginDAO.writeSeller(loginDTO);
	}

	//아이디 중복 확인 기능
	@Override
	public ArrayList<LoginDTO> idCheck(String memberId) {
		log.info("@# idCheck({})", memberId);
		return loginDAO.idCheck(memberId);
	}

	//이메일 중복 확인 기능
	@Override
	public ArrayList<LoginDTO> emailCheck(String memberEmail) {
		log.info("@# emailCheck({})", memberEmail);
		return loginDAO.emailCheck(memberEmail);
	}

	//아이디 찾기 기능
	@Override
	public ArrayList<LoginDTO> findId(LoginDTO loginDTO) {
		log.info("@# findId - Name: " + loginDTO.getMemberName() + ", Email: " + loginDTO.getMemberEmail());
		return loginDAO.findId(loginDTO);
	}

	//패스워드 찾기 기능
	@Override
	public ArrayList<LoginDTO> findPw(LoginDTO loginDTO) {
		log.info("@# findPw - ID: " + loginDTO.getMemberId() + ", Name: " + loginDTO.getMemberName() + ", Email: " + loginDTO.getMemberEmail());
		return loginDAO.findPw(loginDTO);
	}

	//임시 패스워드 보내기 기능
	@Override
	public void sendTempPw(LoginDTO loginDTO) {
		String tempPw = String.format("%06d", new Random().nextInt(999999));
		String encodedTempPw = "{bcrypt}" + passwordEncoder.encode(tempPw);
		loginDTO.setMemberPw(encodedTempPw);
		loginDAO.updatePw(loginDTO);

		String subject = "임시 비밀번호 안내";
		String content = "회원님의 임시 비밀번호는 " + tempPw + " 입니다. 로그인 후 반드시 비밀번호를 변경해주세요.";
		mailSend("pop5805pop@gmail.com", loginDTO.getMemberEmail(), subject, content);

		log.info("@# 임시 비밀번호 발송 완료: ID={}, Email={}", loginDTO.getMemberId(), loginDTO.getMemberEmail());
	}

	@Override
	public void makeRandomNumber() {
		Random r = new Random();
	    int checkNum = r.nextInt(888888) + 111111;
		log.info("생성된 인증번호 : {}", checkNum); 
		authNumber = checkNum;
	}

	@Override
	public String joinEmail(String email) {
		makeRandomNumber();
		String setFrom = "pop5805pop@gmail.com"; 
		String toMail = email;
		String title = "회원 가입 인증 이메일 입니다."; 
		String content = 
				"홈페이지를 방문해주셔서 감사합니다." + 	
                "<br><br>" + 
			    "인증 번호는 " + authNumber + "입니다." + 
			    "<br>" + 
			    "해당 인증번호를 인증번호 확인란에 기입하여 주세요.";
		
		mailSend(setFrom, toMail, title, content); 
		
		log.info("### 이메일 전송 시도: 인증번호 {}를 {}로 전송", authNumber, toMail);
		return Integer.toString(authNumber);
	}

	@Override
	public void mailSend(String setFrom, String toMail, String title, String content) {
		MimeMessage message = mailSender.createMimeMessage();
		try {
			MimeMessageHelper helper = new MimeMessageHelper(message,true,"utf-8");
			helper.setFrom(setFrom);
			helper.setTo(toMail);
			helper.setSubject(title);
			helper.setText(content,true);
			mailSender.send(message);
			log.info("@# 이메일 발송 성공: {}", toMail);
		} catch (MessagingException e) {
			log.error("메일 전송 중 오류 발생: {}", e.getMessage());
		}
	}

	@Override
    @Transactional
    public boolean withdrawMember(String memberId, String memberPw) {
        LoginDTO member = loginDAO.loginYn(memberId);
        if (member == null || !passwordEncoder.matches(memberPw, member.getMemberPw())) {
            return false;
        }

        int deactivatedRows = loginDAO.deactivateMember(memberId);
        if (deactivatedRows > 0) {
            cartDAO.clearCartByMemberId(memberId);
            wishlistDAO.clearWishlistByMemberId(memberId);
            userCouponDAO.deleteAllCouponsByMemberId(memberId);
            log.info("회원 탈퇴 처리 완료: {}", memberId);
            return true;
        }
        return false;
    }
}
