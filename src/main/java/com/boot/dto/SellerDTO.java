package com.boot.dto;

import lombok.Data;

@Data
public class SellerDTO {
    // SELLER_DB 컬럼명에 매칭
    private String selId;     // SEL_ID
    private String selPw;     // SEL_PW
    private String selName;   // SEL_NAME
    private String selCName;  // SEL_CNAME (회사명)
    private String selEmail;  // SEL_EMAIL
    private String selPhone;  // SEL_PHONE
    private String selZipcode;// SEL_ZIPCODE
    private String selAddr1;  // SEL_ADDR1
    private String selAddr2;  // SEL_ADDR2
}