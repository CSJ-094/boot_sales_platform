package com.boot.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.boot.dao.OrdDAO;
import com.boot.dto.OrdDTO;
import com.boot.dto.TrackingResponseDTO;
import com.boot.service.DeliveryService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class DeliveryController {
	@Autowired
    private DeliveryService deliveryService;
    
    @Autowired // DB 연동을 위해 DAO 주입
    private OrdDAO ordDAO; 

    // 1. 주문 상세 페이지 뷰를 띄워주는 메서드 (예시)
    @GetMapping("/order/{ordId}")
    public String orderDetail(@PathVariable("ordId") String ordId, Model model) {
        // DB에서 주문 상세 정보 조회
        OrdDTO order = ordDAO.getOrderById(ordId); 
        model.addAttribute("order", order);
        return "orderDetail"; // orderDetail.jsp로 이동
    }
    

    // 2. Ajax 요청을 받아 운송장 정보를 조회하고 JSON으로 반환하는 메서드
    @GetMapping("/trackDelivery") 
    @ResponseBody 
    public ResponseEntity<?> trackDelivery(
            @RequestParam("t_code") String t_code, // JSP에서 data-code로 넘어옴
            @RequestParam("t_invoice") String t_invoice) { // JSP에서 data-invoice로 넘어옴
        
        log.info("배송 추적 조회 요청 - 택배사코드: {}, 송장번호: {}", t_code, t_invoice);
        
        // 1. Service 호출
        TrackingResponseDTO trackingInfo = deliveryService.getTrackingInfo(t_code, t_invoice);

        if (trackingInfo != null) {
            log.info("배송 추적 조회 성공 - 택배사코드: {}, 송장번호: {}", t_code, t_invoice);
            return ResponseEntity.ok(trackingInfo); 
        } else {
            log.warn("배송 추적 조회 실패 - 택배사코드: {}, 송장번호: {}", t_code, t_invoice);
            // 외부 API 응답이 실패했을 때의 에러 처리
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("배송 정보를 조회할 수 없습니다. 운송장 번호나 택배사 코드를 확인해주세요.");
        }
    }
}
