package com.boot.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.boot.dto.ChatRequestDTO;
import com.boot.dto.ChatResponseDTO;
import com.boot.service.ChatService;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/chat")
public class ChatController {
	private final ChatService chatService;
	 
    @PostMapping
    public ResponseEntity<ChatResponseDTO> chat(@RequestBody ChatRequestDTO chatRequest) {
        String answer = chatService.getAnswer(chatRequest.getMessage());
 
        return ResponseEntity.ok(ChatResponseDTO.of(answer));
    }
}
