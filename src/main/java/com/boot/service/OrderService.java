package com.boot.service;

import java.util.List;
import java.util.UUID;

import com.boot.dao.CartDAO;
import com.boot.dao.OrdDAO;
import com.boot.dao.OrderDetailDAO;
import com.boot.dto.CartDTO;
import com.boot.dto.OrdDTO;
import com.boot.dto.OrderDetailDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;


import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class OrderService {

    @Autowired
    private OrdDAO ordDAO;

    @Autowired
    private OrderDetailDAO orderDetailDAO;

    @Autowired
    private CartDAO cartDAO;

    /**
     * 회원 ID로 주문 내역 목록을 조회합니다.
     */
    public List<OrdDTO> getOrdersByMemberId(String memberId) {
        return ordDAO.getOrdersByMemberId(memberId);
    }

    /**
     * 주문을 생성하고 데이터베이스에 저장합니다.
     * 이 메소드는 하나의 트랜잭션으로 실행됩니다.
     * @param memberId 주문하는 회원의 ID
     * @return 생성된 주문 정보 DTO
     * @throws IllegalStateException 장바구니가 비어있는 경우
     */
    @Transactional
    public OrdDTO createOrder(String memberId) throws IllegalStateException {
        log.info("Creating order for member: {}", memberId);

        // 1. 장바구니에서 주문할 상품 목록 가져오기
        List<CartDTO> cartItems = cartDAO.getCartListByMemberId(memberId);

        if (cartItems == null || cartItems.isEmpty()) {
            throw new IllegalStateException("장바구니에 주문할 상품이 없습니다.");
        }

        // 2. 주문 ID 생성 (고유한 문자열 ID 사용)
        String orderId = "ORD-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        
        // 3. 주문 총액 계산
        int totalProductPrice = cartItems.stream()
                                 .mapToInt(item -> item.getProdPrice() * item.getCartQty())
                                 .sum();

        final int SHIPPING_FEE = 3000; // 배송비는 3000원으로 가정
        int ordAmount = totalProductPrice + SHIPPING_FEE;
        
        // 4. 주문(Orders) 정보 생성 및 DB 저장
        OrdDTO newOrder = new OrdDTO();
        newOrder.setOrdId(orderId);
        newOrder.setOrdMemId(memberId);
        newOrder.setOrdAmount(ordAmount);
        newOrder.setOrdDfee(SHIPPING_FEE); 
        newOrder.setOrdDiscount(0); // 할인은 0으로 가정
        newOrder.setOrdStatus("결제완료"); 
        ordDAO.save(newOrder);
        log.info("Order saved: {}", orderId);

        // 5. 주문 상세(Order_details) 정보 생성 및 DB 저장
        for (CartDTO cartItem : cartItems) {
            OrderDetailDTO orderDetail = new OrderDetailDTO();
            orderDetail.setOrderId(orderId);
            orderDetail.setProductId(cartItem.getProdId());
            orderDetail.setQuantity(cartItem.getCartQty());
            orderDetail.setPrice(cartItem.getProdPrice()); // 주문 시점의 가격
            orderDetailDAO.save(orderDetail);
        }
        log.info("Saved {} order detail items for order: {}", cartItems.size(), orderId);

        // 6. 주문 완료 후 장바구니 비우기
        cartDAO.clearCartByMemberId(memberId);
        log.info("Cart cleared for member: {}", memberId);

        return newOrder;
    }
}
