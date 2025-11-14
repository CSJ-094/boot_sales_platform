package com.boot.dto;

import java.util.List;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class OpenAiRequestDTO {
    private String model;
    
    private List<OpenAiMessageDTO> messages;
 
    public OpenAiRequestDTO(String model, List<OpenAiMessageDTO> messages) {
        this.model = model;
        this.messages = messages;
    }
}
