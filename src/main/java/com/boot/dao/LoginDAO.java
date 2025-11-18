package com.boot.dao;

import com.boot.dto.KakaoUserInfo;
import com.boot.dto.LoginDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.ArrayList;
import java.util.Date; // Date import 제거


@Mapper
public interface LoginDAO {
    public LoginDTO loginYn(LoginDTO loginDTO);
    public void write(LoginDTO loginDTO);
    public ArrayList<LoginDTO> idCheck(LoginDTO loginDTO);
    public ArrayList<LoginDTO> emailCheck(LoginDTO loginDTO);
    public ArrayList<LoginDTO> findId(LoginDTO loginDTO);
    public ArrayList<LoginDTO> findPw(LoginDTO loginDTO);
    public LoginDTO findByEmail(String email);
    public void updatePw(LoginDTO loginDTO);
    public void sendTempPw(LoginDTO loginDTO);
    public String getAccessToken(String code);
    public String getUserInfo(String accessToken);
    public LoginDTO kakaoLoginProcess(KakaoUserInfo userInfo);
    public void kakaoUnlink(String accessToken);
    public void deleteUser(String memberId);
    public void deleteKakaoUser(String memberId);
    public LoginDTO findDeletedByEmail(String email);
    public void reactivateUser(String email);

    // 포인트 기능 추가
    Integer getMemberPoint(@Param("memberId") String memberId);
    void updateMemberPoint(@Param("memberId") String memberId, @Param("point") Integer point);

    // 자동 로그인 기능 관련 메서드 제거
    // void insertRememberMeToken(@Param("memberId") String memberId, @Param("token") String token, @Param("expiryDate") Date expiryDate);
    // LoginDTO findMemberByRememberMeToken(@Param("token") String token);
    // void deleteRememberMeToken(@Param("memberId") String memberId);
}
