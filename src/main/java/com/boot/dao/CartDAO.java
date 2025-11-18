package com.boot.dao;

import com.boot.dto.CartDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;
import java.util.Map;

@Mapper
public interface CartDAO {

    List<CartDTO> getCartListByMemberId(String memberId);

    /**
     * 선택된 여러 cartId에 해당하는 장바구니 상품 목록을 조회합니다.
     * @param params Map에 memberId와 cartIds(List<Integer>)를 담아 전달
     * @return 선택된 장바구니 상품 목록
     */
    List<CartDTO> getCartListByCartIds(Map<String, Object> params);

    void insertCart(CartDTO cartDTO);

    void updateCartQuantity(CartDTO cartDTO);

    void deleteCart(@Param("cartId") int cartId, @Param("memberId") String memberId);

    CartDTO getCartItemByMemberIdAndProdId(@Param("memberId") String memberId, @Param("prodId") Integer prodId);

    void clearCartByMemberId(String memberId);
}
