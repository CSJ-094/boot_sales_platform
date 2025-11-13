package com.boot.dao;

import java.util.List;

import com.boot.dto.OrdDTO;
import org.apache.ibatis.annotations.Mapper;



/**
 * Order 관련 데이터베이스 작업을 위한 MyBatis Mapper 인터페이스입니다.
 */
@Mapper
public interface OrdDAO {
    /**
     * 회원 ID를 기반으로 주문 내역 목록을 조회합니다.
     * @param memberId 주문 내역을 조회할 회원의 ID
     * @return 해당 회원의 주문 내역 목록
     */
    List<OrdDTO> getOrdersByMemberId(String memberId);

    /**
     * 새로운 주문 정보를 저장합니다.
     * @param ord 저장할 주문 정보 DTO
     */
    void save(OrdDTO ord);
}
