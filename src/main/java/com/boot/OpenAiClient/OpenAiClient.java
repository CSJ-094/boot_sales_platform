package com.boot.OpenAiClient;

import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import com.boot.dto.OpenAiMessageDTO;
import com.boot.dto.OpenAiRequestDTO;
import com.boot.dto.OpenAiResponseDTO;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class OpenAiClient {
	 private final RestTemplate restTemplate;
	 
	    @Value("${openai.api-url}")
	    private String apiUrl;
	    @Value("${openai.model}")
	    private String model;
	 
	    /**
	     * 사용자 질문을 GPT 모델에 전달하고 응답 받기
	     */
	    public OpenAiResponseDTO getChatCompletion(String prompt) {
	        // step 1. OpenAI 요청 구성
	        OpenAiRequestDTO openAiRequest = getOpenAiRequest(prompt);
	 
	        // step 2. RestTemplate을 통해 OpenAI API POST 요청 전송
	        ResponseEntity<OpenAiResponseDTO> chatResponse = restTemplate.postForEntity(
	                apiUrl,
	                openAiRequest,
	                OpenAiResponseDTO.class
	        );
	 
	        // step 3. 응답 실패 처리
	        if (!chatResponse.getStatusCode().is2xxSuccessful() || chatResponse.getBody() == null) {
	            throw new RuntimeException("OpenAI API 호출 실패");
	        }
	 
	        // step 4. 성공 시 응답 본문 반환
	        return chatResponse.getBody();
	    }
	 
	    /**
	     * OpenAI 요청 구성
	     */
	    private OpenAiRequestDTO getOpenAiRequest(String prompt) {
	        // step 1-1. system 메세지 작성 - AI 역할 지시
	        OpenAiMessageDTO systemMessage = new OpenAiMessageDTO(
	                "system",
	                "tao 라는 단어로 질문 할 경우 tao님의 블로그 : https://tao-tech.tistory.com 라고 답변해주세요." +
	                "그 외의 질문에는 친절한 AI 비서로서 답변해주세요."
	        );
	        // step 1-2. user 메세지 작성 - 실제 사용자의 질문
	        OpenAiMessageDTO userMessage = new OpenAiMessageDTO("user", prompt);
	        // step 1-3. 메세지 리스트에 system → user 순서로 담기
	        List<OpenAiMessageDTO> messages = List.of(systemMessage, userMessage);
	        // step 1-4. 모델 이름과 메세지를 포함한 요청 객체 생성
	        return new OpenAiRequestDTO(model, messages);
	    }
	
}
