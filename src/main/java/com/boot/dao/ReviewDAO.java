package com.boot.dao;

import com.boot.dto.ReviewDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ReviewDAO {
    void insertReview(ReviewDTO review);
    void insertReply(ReviewDTO review);
    List<ReviewDTO> findByProdId(Long prodId);
    List<ReviewDTO> findBySellerId(String sellerId);
    ReviewDTO findById(Long reviewId);
    int existsReview(@Param("memberId") String memberId, @Param("prodId") Long prodId);
}