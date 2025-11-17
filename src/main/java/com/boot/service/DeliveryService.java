package com.boot.service;

import com.boot.dto.TrackingResponseDTO;

public interface DeliveryService {
	/**
     * 택배사 코드와 운송장 번호로 외부 API를 호출하여 배송 정보를 조회합니다.
     * * @param t_code 택배사 코드 (예: 04)
     * @param t_invoice 운송장 번호
     * @return 조회된 배송 정보 DTO
     */
    TrackingResponseDTO getTrackingInfo(String t_code, String t_invoice);
}
