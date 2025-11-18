package com.boot.service;

import com.boot.dto.KakaoUserInfo;
import com.boot.dto.LoginDTO;
// import org.springframework.security.core.userdetails.UserDetailsService; // UserDetailsService import 제거

import java.util.ArrayList;
// import java.util.Date; // Date import 제거 (사용하지 않으므로)

public interface LoginService { // UserDetailsService 상속 제거

    public LoginDTO loginYn(LoginDTO loginDTO);
    public void write(LoginDTO loginDTO);
    public ArrayList<LoginDTO> idCheck(LoginDTO loginDTO);
    public ArrayList<LoginDTO> emailCheck(LoginDTO loginDTO);
    public ArrayList<LoginDTO> findId(LoginDTO loginDTO);
    public ArrayList<LoginDTO> findPw(LoginDTO loginDTO);
    public void sendTempPw(LoginDTO loginDTO);
    public void makeRandomNumber();
	public String joinEmail(String email);
	public void mailSend(String setFrom, String toMail, String title, String content);
    public String getAccessToken(String code);
    public KakaoUserInfo getUserInfo(String accessToken);
    public LoginDTO kakaoLoginProcess(KakaoUserInfo userInfo);
    public LoginDTO findByEmail(String email);
    public void kakaoUnlink(String accessToken);
    public void deleteUser(String memberId);
    public void deleteKakaoUser(String memberId);

    // UserDetailsService의 loadUserByUsername 메서드는 LoginServiceImpl에서 구현
}
