package com.boot.dao;

import java.util.List;

import com.boot.dto.OrdDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface OrdDAO {
    List<OrdDTO> getOrdersByMemberId(String memberId);
    void save(OrdDTO ord);
    OrdDTO getOrderByOrderId(String orderId);

    void updateStatus(@Param("orderId") String orderId, @Param("status") String status);
}
