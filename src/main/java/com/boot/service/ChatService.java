package com.boot.service;

import org.springframework.stereotype.Service;

import com.boot.OpenAiClient.OpenAiClient;
import com.boot.dto.OpenAiResponseDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ChatService {
	private final OpenAiClient openAiClient;
	 
    /**
     * 클라이언트 질문을 받아 OpenAI 응답 텍스트 반환
     */
    public String getAnswer(String question) {
        OpenAiResponseDTO openAiResponse = openAiClient.getChatCompletion(question);
        
        return openAiResponse.getChoices().get(0).getMessage().getContent();
    }
}
