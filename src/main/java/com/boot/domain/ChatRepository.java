package com.boot.domain;

import org.springframework.data.mongodb.repository.Query;
import org.springframework.data.mongodb.repository.ReactiveMongoRepository;
import org.springframework.data.mongodb.repository.Tailable;

import com.boot.dto.ChatDTO2;

import reactor.core.publisher.Flux;

public interface ChatRepository extends ReactiveMongoRepository<ChatDTO2, String> {

    @Tailable
    @Query("{}")
    Flux<ChatDTO2> streamAllChats();
}


