package com.boot.dto;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class WishlistDTO {
    
    private int wishId;      // WISHLIST_DB.WISH_ID
    private String memberId; // WISHLIST_DB.MEMBER_ID
    private long prodId;      // WISHLIST_DB.PROD_ID
    private Timestamp wishDate; // WISHLIST_DB.WISH_DATE (Timestamp로 변경)
}