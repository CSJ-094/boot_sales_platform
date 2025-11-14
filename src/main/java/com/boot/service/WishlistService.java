package com.boot.service;

import com.boot.dto.WishlistDTO;

import java.util.List;

public interface WishlistService { // class를 interface로 변경

    void addProductToWishlist(String memberId, Long prodId);

    void removeProductFromWishlist(String memberId, Long prodId);

    boolean isProductInWishlist(String memberId, Long prodId);

    List<WishlistDTO> getWishlistByMemberId(String memberId);
}
