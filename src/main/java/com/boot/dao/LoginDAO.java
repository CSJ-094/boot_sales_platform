package com.boot.dao;

import com.boot.dto.KakaoUserInfo;
import com.boot.dto.LoginDTO;
import org.apache.ibatis.annotations.Mapper;

import java.util.ArrayList;


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
}
