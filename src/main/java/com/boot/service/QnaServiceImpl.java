package com.boot.service;

import com.boot.dao.QnaDAO;
import com.boot.dto.QnaDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class QnaServiceImpl implements QnaService {

    private final QnaDAO qnaDAO;

    @Override
    public void addQuestion(QnaDTO qnaDTO) {
        qnaDAO.insertQuestion(qnaDTO);
    }

    @Override
    public void addReply(QnaDTO qnaDTO) {
        qnaDAO.insertReply(qnaDTO);
        if (qnaDTO.getQnaParentId() != null) {
            qnaDAO.updateStatus(qnaDTO.getQnaParentId(), "답변완료");
        }
    }

    @Override
    public List<QnaDTO> getQnaByProductId(Long productId) {
        List<QnaDTO> flatList = qnaDAO.findByProdId(productId);
        Map<Long, QnaDTO> qnaMap = new HashMap<>();
        List<QnaDTO> topLevelQna = new ArrayList<>();

        flatList.forEach(qna -> {
            qna.setReplies(new ArrayList<>());
            qnaMap.put(qna.getQnaId(), qna);
            if (qna.getQnaParentId() == null) {
                topLevelQna.add(qna);
            } else {
                qnaMap.get(qna.getQnaParentId()).getReplies().add(qna);
            }
        });
        return topLevelQna;
    }

    @Override
    public List<QnaDTO> getQnaBySellerId(String sellerId) {
        return qnaDAO.findBySellerId(sellerId);
    }

    @Override
    public QnaDTO getQnaById(Long qnaId) {
        return qnaDAO.findById(qnaId);
    }

    @Override
    public List<QnaDTO> getRepliesByParentId(Long parentId) {
        return qnaDAO.findByParentId(parentId);
    }
}