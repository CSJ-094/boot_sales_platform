package com.boot.dao;


import com.boot.dto.CartDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

/**
 * Cart 관련 데이터베이스 작업을 위한 MyBatis Mapper 인터페이스입니다.
 */
@Mapper
public interface CartDAO {
    /**
     * 회원 ID를 기반으로 장바구니 목록을 조회합니다. (상품 정보 포함)
     * @param memberId 장바구니를 조회할 회원의 ID
     * @return 해당 회원의 장바구니 상품 목록
     */
    List<CartDTO> getCartListByMemberId(String memberId);

    /**
     * 장바구니에 상품을 추가합니다.
     * @param cartDTO 추가할 장바구니 정보 (회원 ID, 상품 ID, 수량)
     */
    void insertCart(CartDTO cartDTO);

    /**
     * 장바구니 상품의 수량을 업데이트합니다.
     * @param cartDTO 업데이트할 장바구니 정보 (장바구니 ID, 변경할 수량)
     */
    void updateCartQuantity(CartDTO cartDTO);

    /**
     * 장바구니에서 특정 상품을 삭제합니다.
     * @param cartId 삭제할 장바구니 항목의 ID
     * @param memberId 삭제 요청을 한 회원의 ID (보안 체크)
     */
    void deleteCart(@Param("cartId") int cartId, @Param("memberId") String memberId);

    /**
     * 특정 상품이 장바구니에 이미 있는지 확인하고, 있으면 해당 항목 정보를 반환합니다.
     * @param memberId 회원 ID
     * @param prodId 상품 ID
     * @return 장바구니 항목 DTO (없으면 null)
     */
    CartDTO getCartItemByMemberIdAndProdId(@Param("memberId") String memberId, @Param("prodId") Integer prodId);

    /**
     * 회원의 장바구니를 모두 비웁니다. (주문 완료 후 사용)
     * @param memberId 장바구니를 비울 회원의 ID
     */
    void clearCartByMemberId(String memberId);
}
