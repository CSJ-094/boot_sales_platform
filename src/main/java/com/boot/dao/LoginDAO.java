package com.boot.dao;

import com.boot.dto.LoginDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.ArrayList;


@Mapper
public interface LoginDAO {
    public LoginDTO loginYn(@Param("memberId") String memberId);
    public void write(LoginDTO loginDTO);
    public void writeSeller(LoginDTO loginDTO);
    public ArrayList<LoginDTO> idCheck(@Param("memberId") String memberId);
    public ArrayList<LoginDTO> emailCheck(@Param("memberEmail") String memberEmail);
    public ArrayList<LoginDTO> findId(LoginDTO loginDTO);
    public ArrayList<LoginDTO> findPw(LoginDTO loginDTO);
    public void updatePw(LoginDTO loginDTO);
    public void sendTempPw(LoginDTO loginDTO);
    public LoginDTO sellerLoginYn(@Param("selId") String selId);

    Integer getMemberPoint(@Param("memberId") String memberId);
    int updateMemberPoint(@Param("memberId") String memberId, @Param("point") Integer point);

    int deactivateMember(@Param("memberId") String memberId);

    // 재가입 처리를 위한 메서드 추가
    LoginDTO findWithdrawnMember(@Param("memberId") String memberId);
    int rejoinMember(LoginDTO loginDTO);
}
