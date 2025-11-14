package com.boot.dao;

import com.boot.dto.WishlistDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface WishlistDAO {
    void insertWishlist(WishlistDTO wishlistDTO);
    void deleteWishlist(@Param("memberId") String memberId, @Param("prodId") Long prodId);
    int countWishlist(@Param("memberId") String memberId, @Param("prodId") Long prodId);
    List<WishlistDTO> getWishlistByMemberId(String memberId);
    
    // 회원 탈퇴 시 찜 목록 전체 삭제
    void clearWishlistByMemberId(@Param("memberId") String memberId);
}
