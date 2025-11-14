package com.boot.dto;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class OpenAiMessageDTO {
    private String role;
 
    private String content;
 
    public OpenAiMessageDTO(String role, String content) {
        this.role = role;
        this.content = content;
    }

}
