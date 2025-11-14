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

    public void addWishlist(String memberId, Integer prodId) {
        // DTO를 생성할 필요 없이 파라미터를 직접 전달합니다.
        wishlistDAO.addWishlist(memberId, prodId);
    }

    public void removeWishlist(String memberId, Integer prodId) {
        // DAO의 delete 메서드를 호출하도록 수정합니다.
        wishlistDAO.delete(memberId, prodId);
    }

    /**
     * 특정 상품이 사용자의 찜 목록에 있는지 확인합니다.
     * @param memberId 회원 ID
     * @param prodId 상품 ID
     * @return 찜 목록에 있으면 true, 없으면 false
     */
    public boolean isProductInWishlist(String memberId, Integer prodId) {
        // DAO의 count 메서드를 호출하여 0보다 크면 true를 반환합니다.
        return wishlistDAO.countByMemberIdAndProdId(memberId, prodId) > 0;
    }
}
