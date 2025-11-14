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
        List<OrdDTO> orders = ordDAO.getOrdersByMemberId(memberId);
        for (OrdDTO order : orders) {
            List<OrderDetailDTO> details = orderDetailDAO.findByOrderId(order.getOrdId());
            order.setOrderDetails(details); // OrdDTO에 setOrderDetails 메서드 필요
        }
        return orders;
    }

    /**
     * 주문 ID로 주문 정보를 조회합니다. (TossController에서 사용)
     * @param orderId 조회할 주문의 ID
     * @return 조회된 주문 정보 DTO
     */
    public OrdDTO getOrderByOrderId(String orderId) {
        return ordDAO.getOrderByOrderId(orderId);
    }

    /**
     * 결제 전 '결제 대기' 상태의 주문을 미리 생성합니다.
     * @param memberId 주문하는 회원의 ID
     * @param cartItems 장바구니에 담긴 상품 목록
     * @return 생성된 주문 정보 DTO
     */
    @Transactional
    public OrdDTO prepareOrder(String memberId, List<CartDTO> cartItems) {
        log.info("Preparing order for member: {}", memberId);

        // 1. 주문 ID 생성
        String orderId = "ORD-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();

        // 2. 주문 총액 계산
        int totalProductPrice = cartItems.stream()
                .mapToInt(item -> item.getProdPrice() * item.getCartQty())
                .sum();

        final int SHIPPING_FEE = 3000; // 배송비는 3000원으로 가정

        // 3. 주문(Orders) 정보 생성 및 DB 저장
        OrdDTO pendingOrder = new OrdDTO();
        pendingOrder.setOrdId(orderId);
        pendingOrder.setOrdMemId(memberId);
        pendingOrder.setOrdAmount(totalProductPrice); // 상품 금액만 저장
        pendingOrder.setOrdDfee(SHIPPING_FEE);
        pendingOrder.setOrdDiscount(0);
        pendingOrder.setOrdStatus("결제대기"); // ⭐️ 주문 상태를 '결제대기'로 설정
        ordDAO.save(pendingOrder);
        log.info("Pending order saved: {}", orderId);

        // 4. 주문 상세(Order_details) 정보 생성 및 DB 저장
        saveOrderDetails(orderId, cartItems);

        // ⭐️ 아직 결제가 완료되지 않았으므로 장바구니는 비우지 않습니다.

        return pendingOrder;
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
        int ordAmount = totalProductPrice; // 상품 금액만 저장
        
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
        saveOrderDetails(orderId, cartItems);

        // 6. 주문 완료 후 장바구니 비우기
        cartDAO.clearCartByMemberId(memberId);
        log.info("Cart cleared for member: {}", memberId);

        return newOrder;
    }

    /**
     * 주문 상세 항목들을 저장하는 공통 메서드
     */
    private void saveOrderDetails(String orderId, List<CartDTO> cartItems) {
        for (CartDTO cartItem : cartItems) {
            OrderDetailDTO orderDetail = new OrderDetailDTO();
            orderDetail.setOrderId(orderId);
            orderDetail.setProductId(cartItem.getProdId());
            orderDetail.setQuantity(cartItem.getCartQty());
            orderDetail.setPrice(cartItem.getProdPrice()); // 주문 시점의 가격
            orderDetailDAO.save(orderDetail);
        }
        log.info("Saved {} order detail items for order: {}", cartItems.size(), orderId);
    }

    /**
     * 결제 승인 후 주문 상태를 업데이트하고 장바구니를 비웁니다.
     * @param orderId 주문 ID
     * @param paymentKey 토스페이먼츠 결제 키
     * @param amount 최종 결제 금액
     */
    @Transactional
    public void confirmPayment(String orderId, String paymentKey, Long amount) {
        OrdDTO order = ordDAO.getOrderByOrderId(orderId);
        if (order == null) {
            throw new IllegalArgumentException("존재하지 않는 주문입니다: " + orderId);
        }

        // 1. 주문 상태와 결제 키 업데이트
        ordDAO.updateAfterPayment(orderId, "결제완료", paymentKey);
        log.info("Order status updated to '결제완료' for orderId: {}", orderId);

        // 2. 결제가 성공적으로 완료되었으므로 장바구니를 비웁니다.
        cartDAO.clearCartByMemberId(order.getOrdMemId());
        log.info("Cart cleared for member: {}", order.getOrdMemId());
    }

    /**
     * 결제 성공 후, 세션의 장바구니 정보로 주문을 생성합니다.
     * @param memberId 회원 ID
     * @param cartItems 세션에 저장된 장바구니 상품 목록
     * @param orderId 토스페이먼츠에서 사용된 주문 ID
     * @param paymentKey 토스페이먼츠 결제 키
     * @param amount 최종 결제 금액
     * @return 생성된 주문 정보 DTO
     */
    @Transactional
    public OrdDTO createOrderFromCart(String memberId, List<CartDTO> cartItems, String orderId, String paymentKey, Long amount) {
        log.info("Creating order from cart for member: {}, orderId: {}", memberId, orderId);

        if (cartItems == null || cartItems.isEmpty()) {
            throw new IllegalStateException("주문할 상품 정보가 없습니다.");
        }

        // 1. 주문 총 상품 금액 및 배송비 계산
        int totalProductPrice = cartItems.stream()
                .mapToInt(item -> item.getProdPrice() * item.getCartQty())
                .sum();
        final int SHIPPING_FEE = 3000;

        // 2. 주문(Orders) 정보 생성 및 DB 저장
        OrdDTO newOrder = new OrdDTO();
        newOrder.setOrdId(orderId); // 토스에서 받은 주문 ID 사용
        newOrder.setOrdMemId(memberId);
        newOrder.setOrdAmount(totalProductPrice);
        newOrder.setOrdDfee(SHIPPING_FEE);
        newOrder.setOrdDiscount(0);
        newOrder.setOrdStatus("결제완료");
        newOrder.setOrdPaymentKey(paymentKey); // 결제 키 저장
        ordDAO.save(newOrder);
        log.info("Order saved: {}", orderId);

        // 3. 주문 상세(Order_details) 정보 생성 및 DB 저장
        saveOrderDetails(orderId, cartItems);

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
