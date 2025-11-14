package com.boot.service;

import com.boot.dao.WishlistDAO;
import com.boot.dto.WishlistDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class WishlistServiceImpl implements WishlistService {

    private final WishlistDAO wishlistDAO;

    @Override
    @Transactional
    public void addProductToWishlist(String memberId, Long prodId) {
        // 이미 찜목록에 있는지 확인
        if (wishlistDAO.countWishlist(memberId, prodId) > 0) { // isProductInWishlist -> countWishlist로 변경
            throw new IllegalArgumentException("이미 찜목록에 있는 상품입니다.");
        }
        WishlistDTO wishlistDTO = new WishlistDTO();
        wishlistDTO.setMemberId(memberId);
        wishlistDTO.setProdId(prodId);
        wishlistDAO.insertWishlist(wishlistDTO); // addWishlist -> insertWishlist로 변경
    }

    @Override
    @Transactional
    public void removeProductFromWishlist(String memberId, Long prodId) {
        // WishlistDTO를 생성하여 넘기는 대신 memberId와 prodId를 직접 넘기도록 변경
        wishlistDAO.deleteWishlist(memberId, prodId); // removeWishlist -> deleteWishlist로 변경
    }

    @Override
    public boolean isProductInWishlist(String memberId, Long prodId) {
        return wishlistDAO.countWishlist(memberId, prodId) > 0; // isProductInWishlist -> countWishlist로 변경
    }

    @Override
    public List<WishlistDTO> getWishlistByMemberId(String memberId) { // ProdDTO -> WishlistDTO로 반환 타입 변경
        return wishlistDAO.getWishlistByMemberId(memberId);
    }
}
