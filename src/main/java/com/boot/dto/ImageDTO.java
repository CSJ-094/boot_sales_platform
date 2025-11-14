package com.boot.dto;

import java.util.Date;

import lombok.Data;

@Data
public class ImageDTO {
	private Long imgId;
	private Long imgProdId;
	private String imgPath;
	private String isMain;
	private int imgOrder;
	private Date imgRegDate;
}
