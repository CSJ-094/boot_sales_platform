package com.boot.dao;

import com.boot.dto.OrderDetailDTO;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;



/**
 * OrderDetail 관련 데이터베이스 작업을 위한 MyBatis Mapper 인터페이스입니다.
 */
@Mapper
public interface OrderDetailDAO {
    /**
     * 주문 상세 정보를 저장합니다.
     * @param orderDetail 저장할 주문 상세 정보 DTO
     */
    void save(OrderDetailDTO orderDetail);

    List<OrderDetailDTO> findByOrderId(String orderId);
    List<OrderDetailDTO> selectOrderDetailByOrderId(String orderId);
    /**
     * 특정 사용자가 특정 상품을 구매했는지 확인합니다. (리뷰 작성 자격)
     * @param memberId 회원 ID
     * @param productId 상품 ID
     * @return 구매한 상품의 개수 (0 이상)
     */
    int countConfirmedPurchase(@Param("memberId") String memberId, @Param("productId") Long productId);
}
