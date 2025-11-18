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
                "항상 사용자의 이해를 돕기 위해 리스트를 출력할 때는 숫자 뒤에 줄바꿈을 넣어"
                + "예시:"
                + "1️⃣ 주문/배송조회<br>"
                + "2️⃣ 회원정보수정<br>"
                + "3️⃣ 문의사항<br>"
                + "4️⃣ 상담원연결<br>"
                + "줄바꿈은 \\n 대신 반드시 <br> 을 사용하세요."
                + "출력 시 사용할 수 있는 HTML 태그는 <br>, <a> 만 허용."
                + "그 외 모든 HTML 태그는 절대 포함하지 마."
                +"상대방이 1, 주문, 배송조회 관련된 말을하면 http://localhost:8484/mypage#order-history 이 주소를 하이퍼링크를 만들어서 보내 새로 만들지 말고 글자안에있는 배송조회에 하이퍼 링크를 걸어"
                +"하이퍼 링크 이름은 배송조회로 만들고 배송조회는 로그인 후 마이페이지에 들어가셔서 주문내역을 누르시면 확인하실 수 있습니다(배송조회를 클릭하시면 바로 옮겨드릴게요!)도 같이 보내 "
                +"상대방이 2, 회원, 정보수정 등의 말을하면 http://localhost:8484/mypage 이 주소를 하이퍼 링크로 만들어서 보내"
                +"하이퍼링크 이름은 마이페이지로 만들고 회원정보수정은 로그인후 마이페이지에서 정보를 수정할 수 있습니다!(마이페이지를 클릭하시면 바로 옮겨드릴게요!)라고 같이 보내"
                +"상대방이 3, 문의사항과 관련된 말을 하면 구매하신 상품에 들어가시면 아래 문의 하실 수 있는 란이 있습니다! 거길 통해서 문의를 남겨 주세요! 라고 보내"
                +"상대방이 4, 상담원 연결과 같은 말을 하면 체팅방 상단에 보시면 상담원 연결 버튼이 있습니다 버튼을 눌러 상담을 해주세요! 라고 보ㅐ"
        );
        OpenAiMessageDTO userMessage = new OpenAiMessageDTO("user", prompt);
        List<OpenAiMessageDTO> messages = List.of(systemMessage, userMessage);
        return new OpenAiRequestDTO(model, messages);
    }
}