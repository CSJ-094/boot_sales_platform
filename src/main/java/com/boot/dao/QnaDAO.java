package com.boot.dao;

import com.boot.dto.QnaDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface QnaDAO {
    void insertQuestion(QnaDTO qna);
    void insertReply(QnaDTO qna);
    List<QnaDTO> findByProdId(Long prodId);
    List<QnaDTO> findBySellerId(String sellerId);
    QnaDTO findById(Long qnaId);
    List<QnaDTO> findByParentId(Long parentId);
    void updateStatus(@Param("qnaId") Long qnaId, @Param("status") String status);
}