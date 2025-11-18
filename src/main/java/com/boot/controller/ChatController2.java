package com.boot.controller;

import com.boot.domain.ChatRepository;
import com.boot.dto.ChatDTO;
import com.boot.dto.ChatDTO2;
import com.boot.service.ChatService2;

import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api")
public class ChatController2 {

	 private final ChatRepository chatRepository;
	    private final ChatService2 chatService;

	    // 메시지 저장
	    @PostMapping("/support")
	    public Mono<ChatDTO2> send(@RequestBody ChatDTO2 dto) {
	        return chatService.save(dto);
	    }

	    // 실시간 스트림 (SSE)
	    @GetMapping(value = "/support/stream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
	    public Flux<ChatDTO2> stream() {
	        return chatRepository.streamAllChats();
	    }
}
