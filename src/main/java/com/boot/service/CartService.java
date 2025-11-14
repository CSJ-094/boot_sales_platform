package com.boot.service;



import com.boot.dao.CartDAO;
import com.boot.dao.WishlistDAO;
import com.boot.dto.CartDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class CartService {

    @Autowired
    private CartDAO cartDAO;

    @Autowired
    private WishlistDAO wishlistDAO;

    /**
     * 회원 ID로 장바구니 목록을 조회합니다.
     */
    public List<CartDTO> getCartListByMemberId(String memberId) {
        return cartDAO.getCartListByMemberId(memberId);
    }

    /**
     * 특정 cartId 목록에 해당하는 장바구니 상품들을 조회합니다.
     */
    public List<CartDTO> getCartItemsByCartIds(String memberId, List<Long> cartIds) {
        return cartDAO.getCartItemsByCartIds(memberId, cartIds);
    }

    /**
     * 장바구니에 상품을 추가합니다. 이미 있으면 수량만 증가시킵니다.
     */
    public void addCart(String memberId, Long prodId, int cartQty) { // prodId 타입을 Long으로 변경
        CartDTO existingCartItem = cartDAO.getCartItemByMemberIdAndProdId(memberId, prodId);
        if (existingCartItem != null) {
            // 이미 장바구니에 있는 상품이면 수량만 업데이트
            existingCartItem.setCartQty(existingCartItem.getCartQty() + cartQty);
            cartDAO.updateCartQuantity(existingCartItem);
        } else {
            // 장바구니에 없는 상품이면 새로 추가
            CartDTO newCartItem = new CartDTO();
            newCartItem.setMemberId(memberId);
            newCartItem.setProdId(prodId);
            newCartItem.setCartQty(cartQty);
            cartDAO.insertCart(newCartItem);
        }
    }

    /**
     * 장바구니 상품의 수량을 업데이트합니다.
     */
    public void updateCartQuantity(int cartId, String memberId, int cartQty) {
        CartDTO cartDTO = new CartDTO();
        cartDTO.setCartId(cartId);
        cartDTO.setMemberId(memberId); // 보안을 위해 memberId도 함께 전달
        cartDTO.setCartQty(cartQty);
        cartDAO.updateCartQuantity(cartDTO);
    }

    /**
     * 장바구니에서 특정 상품을 삭제합니다.
     */
    public void deleteCart(int cartId, String memberId) {
        cartDAO.deleteCart(cartId, memberId);
    }

    /**
     * 찜목록 상품을 장바구니로 이동합니다. (트랜잭션 처리)
     * 장바구니에 상품을 추가하고, 찜목록에서 해당 상품을 삭제합니다.
     */
    @Transactional // 두 개 이상의 DB 작업이 하나의 논리적인 단위로 처리되도록 트랜잭션 적용
    public void moveWishlistItemToCart(String memberId, Long prodId, int cartQty) { // prodId 타입을 Long으로 변경
        // 1. 장바구니에 상품 추가 (기존 addCart 로직 재사용)
        addCart(memberId, prodId, cartQty);

        // 2. 찜목록에서 해당 상품 삭제
        wishlistDAO.deleteWishlist(memberId, prodId); // WishlistDAO의 deleteWishlist 메서드 호출
    }
}
