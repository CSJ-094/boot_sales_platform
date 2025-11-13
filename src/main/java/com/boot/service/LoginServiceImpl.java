package com.boot.service;

import java.util.ArrayList;
import java.util.Random;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

import com.boot.dao.LoginDAO;
import com.boot.dto.LoginDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;



import lombok.extern.slf4j.Slf4j;


@Service
@Slf4j
public class LoginServiceImpl implements LoginService {

	@Autowired
	private LoginDAO loginDAO;
	@Autowired
	private PasswordEncoder passwordEncoder; // 이메일 인증 기능 사용을 위해 추가
	@Autowired
	private JavaMailSenderImpl mailSender; 
	private int authNumber; // 인증번호 저장 변수


	//로그인 기능
	@Override
	public LoginDTO loginYn(LoginDTO loginDTO) {
		log.info("@# loginYn({})", loginDTO.getMemberId());
		return loginDAO.loginYn(loginDTO);
	}

	//회원가입 기능
	@Override
	public void write(LoginDTO loginDTO) {
		log.info("@# write({})", loginDTO.getMemberId());

		String encodedPw = passwordEncoder.encode(loginDTO.getMemberPw());
		loginDTO.setMemberPw(encodedPw);
		loginDAO.write(loginDTO);
	}

	//아이디 중복 확인 기능
	@Override
	public ArrayList<LoginDTO> idCheck(LoginDTO loginDTO) {
		log.info("@# idCheck({})", loginDTO.getMemberId());
		return loginDAO.idCheck(loginDTO);
	}

	//이메일 중복 확인 기능
	@Override
	public ArrayList<LoginDTO> emailCheck(LoginDTO loginDTO) {
		log.info("@# emailCheck({})", loginDTO.getMemberEmail());
		return loginDAO.emailCheck(loginDTO);
	}

//	↑ 회원가입 및 로그인 관련 ================================================ ↓ 찾기 기능 관련

	//아이디 찾기 기능
	@Override
	public ArrayList<LoginDTO> findId(LoginDTO loginDTO) {
		// 로그 인자가 3개 이상일 때 문자열 연결(+)을 사용합니다.
		log.info("@# findId - Name: " + loginDTO.getMemberName() + ", Email: " + loginDTO.getMemberEmail());
		return loginDAO.findId(loginDTO);
	}

	//패스워드 찾기 기능
	@Override
	public ArrayList<LoginDTO> findPw(LoginDTO loginDTO) {
		// 로그 인자가 3개 이상일 때 문자열 연결(+)을 사용합니다. (이전 FindController에서 오류가 발생했던 원인)
		log.info("@# findPw - ID: " + loginDTO.getMemberId() + ", Name: " + loginDTO.getMemberName() + ", Email: " + loginDTO.getMemberEmail());
		return loginDAO.findPw(loginDTO);
	}

	//임시 패스워드 보내기 기능
	@Override
	public void sendTempPw(LoginDTO loginDTO) {
		//임시 패스워드에 6자리의 999999까지의 랜덤 값 설정
		String tempPw = String.format("%06d", new Random().nextInt(999999));
		String encodedTempPw = passwordEncoder.encode(tempPw); //암호화
		loginDTO.setMemberPw(encodedTempPw);
		loginDAO.updatePw(loginDTO);

		String subject = "임시 비밀번호 안내";
		String content = "회원님의 임시 비밀번호는 " + tempPw + " 입니다. 로그인 후 반드시 비밀번호를 변경해주세요.";
		mailSend("pop5805pop@gmail.com", loginDTO.getMemberEmail(), subject, content);

		log.info("@# 임시 비밀번호 발송 완료: ID={}, Email={}", loginDTO.getMemberId(), loginDTO.getMemberEmail());
	}

	// ===================================================================
	// 3. 이메일 인증 기능 
	// ===================================================================
	
	// 6자리 난수 생성
	@Override
	public void makeRandomNumber() {
		// 난수의 범위 111111 ~ 999999 (6자리 난수)
		Random r = new Random();
	    int checkNum = r.nextInt(888888) + 111111;
		log.info("생성된 인증번호 : {}", checkNum); 
		authNumber = checkNum;
	}

	// 인증 메일 내용 작성 및 발송
	@Override
	public String joinEmail(String email) {
		makeRandomNumber();
		// [주의] 실제 사용하는 이메일로 setFrom 값을 변경해야 합니다.
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
		return Integer.toString(authNumber);
	}

	// 메일 발송 실제 로직
	@Override
	public void mailSend(String setFrom, String toMail, String title, String content) {
		MimeMessage message = mailSender.createMimeMessage();
		// true 매개값을 전달하면 multipart 형식의 메세지 전달이 가능.문자 인코딩 설정도 가능하다.
		try {
			MimeMessageHelper helper = new MimeMessageHelper(message,true,"utf-8");
			helper.setFrom(setFrom);
			helper.setTo(toMail);
			helper.setSubject(title);
			// true 전달 > html 형식으로 전송 , 작성하지 않으면 단순 텍스트로 전달.
			helper.setText(content,true);
			mailSender.send(message);
			log.info("@# 이메일 발송 성공: {}", toMail);
		} catch (MessagingException e) {
			log.error("메일 전송 중 오류 발생: {}", e.getMessage());
		}
	}

}
