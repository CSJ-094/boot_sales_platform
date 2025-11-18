package com.boot.dao;

import java.util.List;

import com.boot.dto.OrdDTO;
import com.boot.dto.OrderDetailDTO;
import com.boot.dto.SellerOrderSummaryDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface OrdDAO {
    List<OrdDTO> getOrdersByMemberId(String memberId);
    void save(OrdDTO ord);
    OrdDTO getOrderByOrderId(String orderId);


    void updateStatus(@Param("orderId") String orderId, @Param("status") String status);

    void updateAfterPayment(@Param("orderId") String orderId, @Param("status") String status, @Param("paymentKey") String paymentKey);
    
    OrdDTO getOrderById(String ordId);

    List<SellerOrderSummaryDTO> getOrdersBySellerId(String sellerId);

    void updateTrackingNumber(@Param("orderId") String orderId, 
                             @Param("trackingNumber") String trackingNumber,
                             @Param("deliveryCompany") String deliveryCompany);
                             
    void updateTrackingAndStatus(@Param("orderId") String orderId,
                                 @Param("trackingNumber") String trackingNumber,
                                 @Param("deliveryCompany") String deliveryCompany,
                                 @Param("status") String status);
}
