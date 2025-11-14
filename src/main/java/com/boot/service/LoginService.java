package com.boot.service;

import com.boot.dto.LoginDTO;

import java.util.ArrayList;

public interface LoginService {
    public LoginDTO loginYn(LoginDTO loginDTO);
    public LoginDTO loginSellerYn(LoginDTO loginDTO); // 판매자 로그인 메소드 추가
    public void write(LoginDTO loginDTO);
    public void writeSeller(LoginDTO loginDTO); // 판매자 회원가입 메소드 추가
    public ArrayList<LoginDTO> idCheck(String memberId);
    public ArrayList<LoginDTO> emailCheck(String memberEmail);
    public ArrayList<LoginDTO> findId(LoginDTO loginDTO);
    public ArrayList<LoginDTO> findPw(LoginDTO loginDTO);
    public void sendTempPw(LoginDTO loginDTO);
    public void makeRandomNumber();
    public String joinEmail(String email);
    public void mailSend(String setFrom, String toMail, String title, String content);
    
    // 회원 탈퇴
    boolean withdrawMember(String memberId, String memberPw);
}
