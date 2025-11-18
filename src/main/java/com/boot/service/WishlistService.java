package com.boot.service;

import com.boot.dao.WishlistDAO;
import com.boot.dto.ProdDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class WishlistService {

    private final WishlistDAO wishlistDAO;

    public List<ProdDTO> getWishlistByMemberId(String memberId) {
        return wishlistDAO.getWishlistByMemberId(memberId);
    }

    // 메서드 이름 복구 및 prodId 타입 Long으로 변경
    public void addProductToWishlist(String memberId, Long prodId) {
        wishlistDAO.addWishlist(memberId, prodId);
    }

    // 메서드 이름 복구 및 prodId 타입 Long으로 변경
    public void removeProductFromWishlist(String memberId, Long prodId) {
        wishlistDAO.delete(memberId, prodId);
    }

    /**
     * 특정 상품이 사용자의 찜 목록에 있는지 확인합니다.
     * @param memberId 회원 ID
     * @param prodId 상품 ID
     * @return 찜 목록에 있으면 true, 없으면 false
     */
    // prodId 타입 Long으로 변경
    public boolean isProductInWishlist(String memberId, Long prodId) {
        return wishlistDAO.countByMemberIdAndProdId(memberId, prodId) > 0;
    }
}
