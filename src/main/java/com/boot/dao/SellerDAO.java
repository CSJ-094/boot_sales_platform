package com.boot.dao;


import com.boot.dto.SellerDTO;
import org.apache.ibatis.annotations.Mapper; // @Mapper를 사용하지 않으면 생략 가능

@Mapper
public interface SellerDAO {
    // 로그인 정보를 받아 일치하는 SellerDTO를 반환하는 메서드
    public SellerDTO loginCheck(SellerDTO dto);
}