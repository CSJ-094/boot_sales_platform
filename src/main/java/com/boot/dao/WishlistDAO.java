package com.boot.dao;

import com.boot.dto.ProdDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * Wishlist 관련 데이터베이스 작업을 위한 MyBatis Mapper 인터페이스입니다.
 * @Mapper 어노테이션을 통해 Spring이 이 인터페이스를 스캔하여 Mapper 구현체를 생성하도록 합니다.
 */
@Mapper
public interface WishlistDAO {
    /**
     * 회원 ID를 기반으로 찜목록에 담긴 상품 목록을 조회합니다.
     * 찜목록 정보와 상품 정보를 조인하여 ProdDTO 형태로 반환합니다.
     * @param memberId 찜목록을 조회할 회원의 ID
     * @return 해당 회원의 찜목록 상품 목록
     */
    List<ProdDTO> getWishlistByMemberId(String memberId);

    /**
     * 찜목록에 상품을 추가합니다.
     * @param memberId 회원 ID
     * @param prodId 상품 ID
     */
    void addWishlist(@Param("memberId") String memberId, @Param("prodId") Long prodId); // Integer -> Long 변경

    /**
     * 찜목록에서 특정 상품을 삭제합니다.
     * @param memberId 회원 ID
     * @param prodId 상품 ID
     */
    void delete(@Param("memberId") String memberId, @Param("prodId") Long prodId); // Integer -> Long 변경

    /**
     * 특정 상품이 찜 목록에 있는지 확인합니다.
     */
    int countByMemberIdAndProdId(@Param("memberId") String memberId, @Param("prodId") Long prodId); // Integer -> Long 변경
}
