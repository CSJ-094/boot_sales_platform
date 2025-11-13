package com.boot.dto;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class OpenAiMessageDTO {
	  // 메세지 역할 (user, assistant, system)
    private String role;
 
    // 메세지 내용
    private String content;
 
    public OpenAiMessageDTO(String role, String content) {
        this.role = role;
        this.content = content;
    }

}
