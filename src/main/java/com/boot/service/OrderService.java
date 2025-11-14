package com.boot.service;

import java.util.List;
import java.util.Objects;
import java.util.UUID;

import com.boot.dao.CartDAO;
import com.boot.dao.OrdDAO;
import com.boot.dao.OrderDetailDAO;
import com.boot.dto.CartDTO;
import com.boot.dto.OrdDTO;
import com.boot.dto.OrderDetailDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.amqp.RabbitProperties;
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

    @Autowired
    private PointService pointService; // PointService 주입

    /**
     * 회원 ID로 주문 내역 목록을 조회합니다.
     */
    public List<OrdDTO> getOrdersByMemberId(String memberId) {
        return ordDAO.getOrdersByMemberId(memberId);
    }

    /**
     * 회원 ID로 주문 내역과 각 주문의 상세 항목 목록을 함께 조회합니다.
     */
    public List<OrdDTO> getOrdersWithDetailsByMemberId(String memberId) {
        log.info("Fetching orders with details for member: {}", memberId);
        List<OrdDTO> orders = ordDAO.getOrdersByMemberId(memberId);
        if (orders == null || orders.isEmpty()) {
            log.info("No orders found for member: {}", memberId);
            return orders;
        }
        for (OrdDTO order : orders) {
            log.info("Fetching order details for orderId: {}", order.getOrdId());
            List<OrderDetailDTO> details = orderDetailDAO.findByOrderId(order.getOrdId());
            if (details == null || details.isEmpty()) {
                log.warn("No order details found for orderId: {}", order.getOrdId());
            } else {
                log.info("Found {} order details for orderId: {}", details.size(), order.getOrdId());
            }
            order.setOrderDetails(details);
        }
        return orders;
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

        // ⭐️ 7. 상품 구매 시 포인트 적립 (총 결제 금액의 1% 적립)
        int earnedPoint = (int) (ordAmount * 0.01); // 1% 적립
        if (earnedPoint > 0) {
            pointService.earnPoint(memberId, earnedPoint, "상품 구매 적립 (주문번호: " + orderId + ")");
            log.info("상품 구매 포인트 지급: memberId={}, orderId={}, amount={}", memberId, orderId, earnedPoint);
        }

        return newOrder;
    }

    /**
     * 특정 사용자가 특정 상품을 구매했는지 확인합니다.
     * @param memberId 회원 ID
     * @param productId 상품 ID
     * @return 구매 이력이 있으면 true, 없으면 false
     */
    public boolean hasUserPurchasedProduct(String memberId, Long productId) {
        // 특정 사용자가 특정 상품을 포함하는 '구매확정' 상태의 주문을 했는지 확인
        int count = orderDetailDAO.countConfirmedPurchase(memberId, productId);
        return count > 0;
    }

    /**
     * 주문 상태를 '구매확정'으로 변경합니다.
     * @param orderId 주문 ID
     * @param memberId 회원 ID (본인 확인용)
     */
    @Transactional
    public void confirmOrder(String orderId, String memberId) {
        ordDAO.updateStatus(orderId, "구매확정");
    }
}
