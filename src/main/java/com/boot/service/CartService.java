package com.boot.service;

import com.boot.dao.CartDAO;
import com.boot.dao.WishlistDAO;
import com.boot.dto.CartDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.HashMap;

@Service
public class CartService {

    @Autowired
    private CartDAO cartDAO;

    @Autowired
    private WishlistDAO wishlistDAO;

    public List<CartDTO> getCartListByMemberId(String memberId) {
        return cartDAO.getCartListByMemberId(memberId);
    }

    /**
     * 선택된 여러 cartId에 해당하는 장바구니 상품 목록을 조회합니다.
     */
    public List<CartDTO> getCartListByCartIds(String memberId, List<Integer> cartIds) {
        Map<String, Object> params = new HashMap<>();
        params.put("memberId", memberId); // 보안: 다른 사람의 장바구니를 조회하지 못하도록
        params.put("cartIds", cartIds);
        return cartDAO.getCartListByCartIds(params);
    }

    public void addCart(String memberId, Integer prodId, int cartQty) {
        CartDTO existingCartItem = cartDAO.getCartItemByMemberIdAndProdId(memberId, prodId);
        if (existingCartItem != null) {
            existingCartItem.setCartQty(existingCartItem.getCartQty() + cartQty);
            cartDAO.updateCartQuantity(existingCartItem);
        } else {
            CartDTO newCartItem = new CartDTO();
            newCartItem.setMemberId(memberId);
            newCartItem.setProdId(prodId);
            newCartItem.setCartQty(cartQty);
            cartDAO.insertCart(newCartItem);
        }
    }

    public void updateCartQuantity(int cartId, String memberId, int cartQty) {
        CartDTO cartDTO = new CartDTO();
        cartDTO.setCartId(cartId);
        cartDTO.setMemberId(memberId);
        cartDTO.setCartQty(cartQty);
        cartDAO.updateCartQuantity(cartDTO);
    }

    public void deleteCart(int cartId, String memberId) {
        cartDAO.deleteCart(cartId, memberId);
    }

    @Transactional
    public void moveWishlistItemToCart(String memberId, Integer prodId, int cartQty) {
        addCart(memberId, prodId, cartQty);
        // wishlistDAO.deleteWishlistItem(memberId, prodId);
    }
}
