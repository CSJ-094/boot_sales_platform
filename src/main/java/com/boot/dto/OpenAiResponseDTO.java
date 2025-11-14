package com.boot.dto;

import java.util.List;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class OpenAiResponseDTO {
    private List<Choice> choices;
 
    @Getter
    public static class Choice {
        private OpenAiMessageDTO message;
    }
}
