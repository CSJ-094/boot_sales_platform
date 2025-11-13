package com.boot.dao;

import com.boot.dto.ReviewDTO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface ReviewDAO {
    void insertReview(ReviewDTO review);
    List<ReviewDTO> findByProdId(Long prodId);
}