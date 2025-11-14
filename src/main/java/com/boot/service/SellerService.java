package com.boot.service;


import com.boot.dao.SellerDAO;
import com.boot.dto.SellerDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class SellerService {
    
    @Autowired
    private SellerDAO sellerDAO; // SellerDAO 주입

    // 로그인 체크
    public SellerDTO loginCheck(SellerDTO dto) {
        // 암호화된 비밀번호를 사용한다면 여기서 복호화 로직을 처리해야 합니다.
        return sellerDAO.loginCheck(dto);
    }
}