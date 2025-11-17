package com.boot.dto;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class NoticeDTO {
	private int NOT_NO;
	private String NOT_TITLE;
	private String NOT_CONTENT;
	private String NOT_NAME;
	private Timestamp NOT_TIME;
}
