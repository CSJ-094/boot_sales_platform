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
        // step 1. OpenAiClient를 통해 질문을 OpenAI에 전달
        OpenAiResponseDTO openAiResponse = openAiClient.getChatCompletion(question);
        
        // step 2. 응답 중 첫 번째 메세지의 content 추출
        return openAiResponse.getChoices().get(0).getMessage().getContent();
    }
}
