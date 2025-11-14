package com.boot.service;

import com.boot.dto.ReviewDTO;

import java.util.List;

public interface ReviewService {
    void addReview(ReviewDTO reviewDTO);
    void addReply(ReviewDTO reviewDTO);
    List<ReviewDTO> getReviewsByProductId(Long productId);
    List<ReviewDTO> getReviewsBySellerId(String sellerId);
    ReviewDTO getReviewById(Long reviewId);
}