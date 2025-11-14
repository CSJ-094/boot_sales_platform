package com.boot.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class LoginDTO {
	// 구매자 필드
	private String memberId;
	private String memberPw;
	private String memberName;
	private String memberEmail;
	private String memberPhone;
	private String memberZipcode;
	private String memberAddr1;
	private String memberAddr2;
	private Integer memberPoint;
	private String memberStatus; // 회원 상태 필드 추가 (e.g., 'ACTIVE', 'WITHDRAWN')

	// 🚩 판매자 필드 추가
	private String selId;
	private String selPw;
	private String selName;
	private String selCName; // 상호명
	private String selEmail;
	private String selPhone;
	private String selZipcode;
	private String selAddr1;
	private String selAddr2;
}
