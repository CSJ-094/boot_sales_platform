package com.boot.dto;

import lombok.Data;

@Data
public class SalesStatDTO {
	private String label; //날짜/주/월
	private long salesAmount;
	private int orderCount;
}
