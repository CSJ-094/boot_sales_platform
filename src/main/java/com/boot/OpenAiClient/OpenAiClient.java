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
import lombok.extern.slf4j.Slf4j;

@Component
@RequiredArgsConstructor
@Slf4j
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
                "너는 친절한 AI 비서로써 질문에 답변해 상대가 도움이라는 단어를 치면 1.주문/배송조회 2.회원정보수정 3.문의사항 4.상담원연결 필요하신 서비스를 적어주세요!라고 답해" +
                "도움 리스트 보낼때 숫자에는 이모지 넣어"
                +"한번쓴 이모지는 계속 사용해"
                +"사용자가 1, 주문, 배송, 주문조회, 배송조회 라는 단어를 검색하면 아직 안만들었다고 말해"
                +"사용자가 2,회원정보, 정보수정 과 관련된 말을 하면 로그인 후 마이페이지 클릭해 변경할 수 있다고 말해 "
        );
        OpenAiMessageDTO userMessage = new OpenAiMessageDTO("user", prompt);
        List<OpenAiMessageDTO> messages = List.of(systemMessage, userMessage);
        return new OpenAiRequestDTO(model, messages);
    }
}