package com.boot.service;

import java.util.ArrayList;
import java.util.Random;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

import com.boot.dao.LoginDAO;
import com.boot.dto.KakaoUserInfo;
import com.boot.dto.LoginDTO;
// import com.boot.dto.CustomUserDetails; // CustomUserDetails import 제거
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
// import org.springframework.security.core.userdetails.UserDetails; // UserDetails import 제거
// import org.springframework.security.core.userdetails.UsernameNotFoundException; // UsernameNotFoundException import 제거
// import org.springframework.security.core.userdetails.User; // User import 제거
// import org.springframework.security.core.authority.SimpleGrantedAuthority; // SimpleGrantedAuthority import 제거
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;



import lombok.extern.slf4j.Slf4j;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;

// import java.util.Collections; // Collections import 제거


@Service
@Slf4j
public class LoginServiceImpl implements LoginService {

	@Autowired
	private SqlSession sqlSession;

	@Autowired
	private LoginDAO loginDAO;
	@Autowired
	private PasswordEncoder passwordEncoder;
	@Autowired
	private JavaMailSenderImpl mailSender; 
	private int authNumber;


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
		String encodedTempPw = passwordEncoder.encode(tempPw);
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
		Random r = new Random();
	    int checkNum = r.nextInt(888888) + 111111;
		log.info("생성된 인증번호 : {}", checkNum); 
		authNumber = checkNum;
	}

	// 인증 메일 내용 작성 및 발송
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
		return Integer.toString(authNumber);
	}

	// 메일 발송 실제 로직
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

    // Kakao AccessToken 받아오기.
	@Override
	public String getAccessToken(String code) {
		String tokenUri = "https://kauth.kakao.com/oauth/token";
		RestTemplate rt = new RestTemplate();
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

		MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
		params.add("grant_type", "authorization_code");
		params.add("client_id", "c9021fed6c1ed7e7f03682f69d5f67ca");
		params.add("redirect_uri", "http://localhost:8484/api/v1/oauth2/kakao");
		params.add("code", code);

		HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(params, headers);
		log.info("코드 요청: {}", code);
		try {
			ResponseEntity<String> response = rt.postForEntity(tokenUri, request, String.class);
			log.info("카카오 서버에서 Post 받은 Access Token : {}", response.getBody());

			JsonObject json = JsonParser.parseString(response.getBody()).getAsJsonObject();
			String accessToken = json.get("access_token").getAsString();
			log.info("@# LoginServiceImpl - getAccessToken 메소드 - accessToken 확인로그: {}", accessToken);
			return accessToken;

		} catch (HttpClientErrorException e) {
			log.error("Access token request failed with status: {} and body: {}", e.getStatusCode(), e.getResponseBodyAsString());
			throw new RuntimeException("Access Token 못얻어옴.", e);
		}
	}

	@Override
	public KakaoUserInfo getUserInfo(String accessToken) {
		String requestUri = "https://kapi.kakao.com/v2/user/me";
		RestTemplate rt = new RestTemplate();
		HttpHeaders headers = new HttpHeaders();
		headers.add("Authorization", "Bearer " + accessToken);
		headers.add("Content-Type", "application/x-www-form-urlencoded;charset=utf-8");

		HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(headers);
		ResponseEntity<String> response = rt.postForEntity(requestUri, request, String.class);

		JsonObject obj = JsonParser.parseString(response.getBody()).getAsJsonObject();
		KakaoUserInfo user = new KakaoUserInfo();

		user.setId(obj.get("id").getAsLong());
		user.setNickname(obj.get("properties").getAsJsonObject().get("nickname").getAsString());
		user.setEmail(obj.get("kakao_account").getAsJsonObject().get("email").getAsString());
		return user;
	}

	@Transactional
	@Override
	public LoginDTO kakaoLoginProcess(KakaoUserInfo userInfo) {
		LoginDTO exist = loginDAO.findByEmail(userInfo.getEmail());
		
		//재가입 로직

		LoginDTO deletedCheck = loginDAO.findDeletedByEmail(userInfo.getEmail());
		log.info("@# deletedCheck = {} ",deletedCheck);
		if(deletedCheck != null) {
			loginDAO.reactivateUser(userInfo.getEmail());
			return loginDAO.findByEmail(userInfo.getEmail());
		}

		if(exist == null) {

//			DELETED 계정인지 검사하고 DELETED 계정이면 ACTIVE로 활성화


			LoginDTO newUser = new LoginDTO();
			newUser.setMemberId("kakao_"+userInfo.getId());
			newUser.setMemberEmail(userInfo.getEmail());
			newUser.setMemberName(userInfo.getNickname());
			newUser.setMemberPw("default");
			newUser.setMemberPhone("default");
			newUser.setMemberZipcode("default");
			newUser.setMemberAddr1("default");
			newUser.setMemberAddr2("default");
			newUser.setSocialLogin("kakao");

			loginDAO.write(newUser);
			exist = newUser;

		}
		return exist;
	}

    @Override
    public void kakaoUnlink(String accessToken){
        String unlinkUri = "https://kapi.kakao.com/v1/user/unlink";
        RestTemplate rt = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + accessToken);

        HttpEntity<String> request = new HttpEntity<>(headers);
        try{
            ResponseEntity<String> response = rt.postForEntity(unlinkUri, request, String.class);
                log.info("회원 탈퇴 성공: {}",response.getBody());
        }catch(HttpClientErrorException e){
            log.error("회원 탈퇴 실패 및 오류메시지 로그 확인용: {}",e.getResponseBodyAsString());
            e.printStackTrace();
        }
    }

    @Override
    public void deleteUser(String memberId) {
        loginDAO.deleteUser(memberId);
    }
	public void deleteKakaoUser(String memberId){
		loginDAO.deleteKakaoUser(memberId);
	}

    @Override
	public LoginDTO findByEmail(String email) {
		return loginDAO.findByEmail(email);
	}

    // UserDetailsService의 loadUserByUsername 구현 제거
    // @Override
    // public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
    //     LoginDTO loginDTO = new LoginDTO();
    //     loginDTO.setMemberId(username);
    //     LoginDTO user = loginDAO.loginYn(loginDTO);
    //
    //     if (user == null) {
    //         throw new UsernameNotFoundException("User not found with username: " + username);
    //     }
    //
    //     return new CustomUserDetails(user);
    // }
}
