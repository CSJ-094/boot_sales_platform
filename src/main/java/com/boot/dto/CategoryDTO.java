package com.boot.dto;

import java.util.Date;

import lombok.Data;

@Data
public class CategoryDTO {
	private Long catId;			//카테고리 ID
	private Long catParent;		//상위 카테고리 ID
	private String catCode;		// 카테고리 코드
	private String catName;		//카테고리명
	private Integer catSort;	//카테고리 정렬 순서
	private String catUseyn;	//사용 여부
	private Date catReg;		//등록일
	private Date catUpd;		//수정일
	private Integer depth;  	// LEVEL
}