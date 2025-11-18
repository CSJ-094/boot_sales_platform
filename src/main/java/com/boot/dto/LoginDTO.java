package com.boot.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date; // Date import 제거

@Data
@AllArgsConstructor
@NoArgsConstructor
public class LoginDTO {
	private String memberId;
	private String memberPw;
	private String memberName;
	private String memberEmail;
	private String memberPhone;
	private String memberZipcode;
	private String memberAddr1;
	private String memberAddr2;
	private String socialLogin = "default";
	// private String rememberMeToken; // 자동 로그인 토큰 제거
	// private Date tokenExpiryDate;   // 토큰 만료일 제거
}
