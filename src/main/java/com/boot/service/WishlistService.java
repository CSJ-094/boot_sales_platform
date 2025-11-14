package com.boot.service;

import com.boot.dao.WishlistDAO;
import com.boot.dto.ProdDTO;
import com.boot.dto.WishlistDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


import java.util.List;

@Service
public class WishlistService {

    @Autowired
    private WishlistDAO wishlistMapper;

    public List<ProdDTO> getWishlistByMemberId(String memberId) {
        return wishlistMapper.getWishlistByMemberId(memberId);
    }

    public void addWishlist(String memberId, Integer prodId) {
        WishlistDTO wishlistDTO = new WishlistDTO();
        wishlistDTO.setMemberId(memberId);
        wishlistDTO.setProdId(prodId);
        wishlistMapper.addWishlist(wishlistDTO);
    }

    public void removeWishlist(String memberId, Integer prodId) {
        WishlistDTO wishlistDTO = new WishlistDTO();
        wishlistDTO.setMemberId(memberId);
        wishlistDTO.setProdId(prodId);
        wishlistMapper.removeWishlist(wishlistDTO);
    }
}
