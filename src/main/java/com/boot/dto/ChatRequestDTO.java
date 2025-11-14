package com.boot.dto;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class ChatRequestDTO {
	private String message;

	public ChatRequestDTO(String message) {
		this.message = message;
	}
}
