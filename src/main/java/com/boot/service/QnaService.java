package com.boot.service;

import com.boot.dto.QnaDTO;
import java.util.List;

public interface QnaService {
    void addQuestion(QnaDTO qnaDTO);
    void addReply(QnaDTO qnaDTO);
    List<QnaDTO> getQnaByProductId(Long productId);
    List<QnaDTO> getQnaBySellerId(String sellerId);
    QnaDTO getQnaById(Long qnaId);
    List<QnaDTO> getRepliesByParentId(Long parentId);
}