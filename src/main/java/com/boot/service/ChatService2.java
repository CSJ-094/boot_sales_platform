package com.boot.service;

import com.boot.domain.ChatRepository;
import com.boot.dto.ChatDTO2;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

import java.time.LocalDateTime;

@RequiredArgsConstructor
@Service
public class ChatService2 {

    private final ChatRepository chatRepository;

    public Mono<ChatDTO2> save(ChatDTO2 dto) {
        dto.setCreatedAt(LocalDateTime.now());
        return chatRepository.save(dto);
    }
}
