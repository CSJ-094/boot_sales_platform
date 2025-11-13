package com.boot.service;

import com.boot.dao.ReviewDAO;
import com.boot.dto.ReviewDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class ReviewServiceImpl implements ReviewService {

    private final ReviewDAO reviewDAO;

    @Override
    public void addReview(ReviewDTO reviewDTO) {
        reviewDAO.insertReview(reviewDTO);
    }

    @Override
    public void addReply(ReviewDTO reviewDTO) {
        reviewDAO.insertReply(reviewDTO);
    }

    @Override
    public List<ReviewDTO> getReviewsByProductId(Long productId) {
        List<ReviewDTO> flatList = reviewDAO.findByProdId(productId);
        Map<Long, ReviewDTO> reviewMap = new HashMap<>();
        List<ReviewDTO> topLevelReviews = new ArrayList<>();

        // 모든 리뷰를 맵에 추가
        for (ReviewDTO review : flatList) {
            review.setReplies(new ArrayList<>()); // 답변 리스트 초기화
            reviewMap.put(review.getReviewId(), review);
        }

        // 계층 구조 생성
        for (ReviewDTO review : flatList) {
            if (review.getReviewParentId() != null) {
                ReviewDTO parent = reviewMap.get(review.getReviewParentId());
                if (parent != null) {
                    parent.getReplies().add(review);
                }
            } else {
                topLevelReviews.add(review);
            }
        }
        return topLevelReviews;
    }

    @Override
    public List<ReviewDTO> getReviewsBySellerId(String sellerId) {
        return reviewDAO.findBySellerId(sellerId);
    }

    @Override
    public ReviewDTO getReviewById(Long reviewId) {
        return reviewDAO.findById(reviewId);
    }
}