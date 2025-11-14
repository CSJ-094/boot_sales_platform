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
	 
	    public OpenAiResponseDTO getChatCompletion(String prompt) {
	        OpenAiRequestDTO openAiRequest = getOpenAiRequest(prompt);
	 
	        ResponseEntity<OpenAiResponseDTO> chatResponse = restTemplate.postForEntity(
	                apiUrl,
	                openAiRequest,
	                OpenAiResponseDTO.class
	        );
	 
	        if (!chatResponse.getStatusCode().is2xxSuccessful() || chatResponse.getBody() == null) {
	            throw new RuntimeException("OpenAI API 호출 실패");
	        }
	 
	        return chatResponse.getBody();
	    }
	 
	    private OpenAiRequestDTO getOpenAiRequest(String prompt) {
	        OpenAiMessageDTO systemMessage = new OpenAiMessageDTO(
	                "system",
	                "모든 질문에는 친절한 AI 비서로서 답변해 단 의류에서 벗어나는 질문은 알 수 없다 하고 도움을 적어달라고 말해." +
	                "상대방이 도움이라고 적으면 "
	        );
	        OpenAiMessageDTO userMessage = new OpenAiMessageDTO("user", prompt);
	        List<OpenAiMessageDTO> messages = List.of(systemMessage, userMessage);
	        return new OpenAiRequestDTO(model, messages);
	    }
	
}
