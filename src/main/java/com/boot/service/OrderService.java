package com.boot.service;

import java.util.List;
import java.util.UUID;

import com.boot.dao.CartDAO;
import com.boot.dao.OrdDAO;
import com.boot.dao.OrderDetailDAO;
import com.boot.dao.ReviewDAO;
import com.boot.dto.CartDTO;
import com.boot.dto.OrdDTO;
import com.boot.dto.OrderDetailDTO;
import com.boot.dto.SellerOrderSummaryDTO;
import com.boot.dto.TrackingResponseDTO;
import com.boot.dto.UserCouponDTO; // UserCouponDTO import 추가
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
    private ReviewDAO reviewDAO;

    @Autowired
    private CartDAO cartDAO;

    @Autowired
    private DeliveryService deliveryService;

    @Autowired
    private UserCouponService userCouponService; // UserCouponService 주입
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
        List<OrdDTO> orders = ordDAO.getOrdersByMemberId(memberId);
        for (OrdDTO order : orders) {
            List<OrderDetailDTO> details = orderDetailDAO.findByOrderId(order.getOrdId());
            for (OrderDetailDTO detail : details) {
                boolean hasReview = reviewDAO.existsReview(memberId, detail.getProductId()) > 0;
                detail.setHasReview(hasReview);
            }
            order.setOrderDetails(details);
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

        String orderId = "ORD-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();

        int totalProductPrice = cartItems.stream()
                .mapToInt(item -> item.getProdPrice() * item.getCartQty())
                .sum();

        final int SHIPPING_FEE = 3000;

        OrdDTO pendingOrder = new OrdDTO();
        pendingOrder.setOrdId(orderId);
        pendingOrder.setOrdMemId(memberId);
        pendingOrder.setOrdAmount(totalProductPrice);
        pendingOrder.setOrdDfee(SHIPPING_FEE);
        pendingOrder.setOrdDiscount(0);
        pendingOrder.setOrdStatus("결제대기");
        ordDAO.save(pendingOrder);
        log.info("Pending order saved: {}", orderId);

        saveOrderDetails(orderId, cartItems);

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

        List<CartDTO> cartItems = cartDAO.getCartListByMemberId(memberId);

        if (cartItems == null || cartItems.isEmpty()) {
            throw new IllegalStateException("장바구니에 주문할 상품이 없습니다.");
        }

        String orderId = "ORD-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        
        int totalProductPrice = cartItems.stream()
                                 .mapToInt(item -> item.getProdPrice() * item.getCartQty())
                                 .sum();
        
        final int SHIPPING_FEE = 3000;
        int ordAmount = totalProductPrice;
        
        OrdDTO newOrder = new OrdDTO();
        newOrder.setOrdId(orderId);
        newOrder.setOrdMemId(memberId);
        newOrder.setOrdAmount(ordAmount);
        newOrder.setOrdDfee(SHIPPING_FEE);
        newOrder.setOrdDiscount(0);
        newOrder.setOrdStatus("결제완료"); 
        ordDAO.save(newOrder);
        log.info("Order saved: {}", orderId);

        saveOrderDetails(orderId, cartItems);

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
            orderDetail.setPrice(cartItem.getProdPrice());
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

        ordDAO.updateAfterPayment(orderId, "결제완료", paymentKey);
        log.info("Order status updated to '결제완료' for orderId: {}", orderId);

        cartDAO.clearCartByMemberId(order.getOrdMemId());
        log.info("Cart cleared for member: {}", order.getOrdMemId());
    }

    /**
     * 결제 성공 후, 세션의 장바구니 정보로 주문을 생성합니다.
     * @param memberId 회원 ID
     * @param cartItems 세션에 저장된 장바구니 상품 목록
     * @param orderId 토스페이먼츠에서 사용된 주문 ID
     * @param paymentKey 토스페이먼츠 결제 키
     * @param finalPaymentAmount 최종 결제 금액 (할인 적용 후)
     * @param selectedUserCouponId 사용된 쿠폰의 userCouponId (없으면 null)
     * @param usedPoint 사용된 포인트 (없으면 0)
     * @return 생성된 주문 정보 DTO
     */
    @Transactional
    public OrdDTO createOrderFromCart(String memberId, List<CartDTO> cartItems, String orderId, String paymentKey, Long finalPaymentAmount, Long selectedUserCouponId, int usedPoint) {
        log.info("Creating order from cart for member: {}, orderId: {}", memberId, orderId);

        if (cartItems == null || cartItems.isEmpty()) {
            throw new IllegalStateException("주문할 상품 정보가 없습니다.");
        }

        // 1. 총 상품 금액 및 배송비 계산 (할인 적용 전)
        int totalProductPrice = cartItems.stream()
                .mapToInt(item -> item.getProdPrice() * item.getCartQty())
                .sum();
        final int SHIPPING_FEE = 3000;

        int totalDiscountAmount = 0; // 총 할인 금액

        // 2. 쿠폰 할인 계산 및 적용
        if (selectedUserCouponId != null) {
            UserCouponDTO userCoupon = userCouponService.getUserCouponById(selectedUserCouponId);
            if (userCoupon != null && "N".equals(userCoupon.getIsUsed()) && (userCoupon.getExpirationDate() == null || userCoupon.getExpirationDate().after(new java.util.Date()))) {
                int couponDiscount = 0;
                if (userCoupon.getCouponType().equals("PERCENT")) {
                    couponDiscount = (int) (totalProductPrice * (userCoupon.getDiscountValue() / 100.0));
                    if (userCoupon.getMaxDiscountAmount() != null && couponDiscount > userCoupon.getMaxDiscountAmount()) {
                        couponDiscount = userCoupon.getMaxDiscountAmount();
                    }
                } else if (userCoupon.getCouponType().equals("AMOUNT")) {
                    couponDiscount = userCoupon.getDiscountValue();
                }

                if (totalProductPrice >= userCoupon.getMinOrderAmount()) {
                    totalDiscountAmount += couponDiscount;
                    userCouponService.useUserCoupon(selectedUserCouponId, memberId); // 쿠폰 사용 처리
                    log.info("Coupon {} applied for order {}. Discount: {}", userCoupon.getCouponName(), orderId, couponDiscount);
                } else {
                    log.warn("Coupon {} not applied: Minimum order amount not met.", userCoupon.getCouponName());
                }
            } else {
                log.warn("Invalid or already used coupon: {}", selectedUserCouponId);
            }
        }

        // 3. 포인트 사용 적용
        if (usedPoint > 0) {
            try {
                pointService.usePoint(memberId, usedPoint, "주문 결제 포인트 사용 (주문번호: " + orderId + ")");
                totalDiscountAmount += usedPoint;
                log.info("Point {} used for order {}. Usage: {}", memberId, orderId, usedPoint);
            } catch (IllegalArgumentException e) {
                log.error("Point usage failed for order {}: {}", orderId, e.getMessage());
                throw e; // 예외를 다시 던져 트랜잭션을 롤백시킵니다.
            }
        }

        // 4. 최종 결제 금액 계산 (클라이언트에서 넘어온 finalPaymentAmount와 서버에서 계산한 금액 비교)
        long calculatedFinalAmount = totalProductPrice + SHIPPING_FEE - totalDiscountAmount;
        if (calculatedFinalAmount < 0) calculatedFinalAmount = 0;

        if (calculatedFinalAmount != finalPaymentAmount) {
            log.error("Final payment amount mismatch! Calculated: {}, Received: {}", calculatedFinalAmount, finalPaymentAmount);
            throw new IllegalStateException("결제 금액이 일치하지 않습니다. 결제를 다시 시도해주세요.");
        }

        // 5. 주문(Orders) 정보 생성 및 DB 저장
        OrdDTO newOrder = new OrdDTO();
        newOrder.setOrdId(orderId);
        newOrder.setOrdMemId(memberId);
        newOrder.setOrdAmount(totalProductPrice); // 총 상품 금액 (할인 전)
        newOrder.setOrdDfee(SHIPPING_FEE);
        newOrder.setOrdDiscount(totalDiscountAmount); // 총 할인 금액 저장
        newOrder.setOrdStatus("결제완료");
        newOrder.setOrdPaymentKey(paymentKey);
        ordDAO.save(newOrder);
        log.info("Order saved: {}", orderId);

        // 6. 주문 상세(Order_details) 정보 생성 및 DB 저장
        saveOrderDetails(orderId, cartItems);

        // 7. 장바구니 비우기
        cartDAO.clearCartByMemberId(memberId);
        log.info("Cart cleared for member: {}", memberId);

        return newOrder;
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

    /**
     * 주문 상태를 '배송완료'로 수동 변경합니다.
     * @param orderId 주문 ID
     */
    @Transactional
    public void manuallyCompleteOrder(String orderId) {
        ordDAO.updateStatus(orderId, "배송완료");
        log.info("Order status manually updated to '배송완료' for orderId: {}", orderId);
    }

    /**
     * 판매자 ID로 해당 판매자 상품의 주문 요약을 조회합니다.
     */
    public List<SellerOrderSummaryDTO> getSellerOrderSummaries(String sellerId) {
        return ordDAO.getOrdersBySellerId(sellerId);
    }

    /**
     * 송장번호와 택배사 코드를 입력하고 주문 상태를 배송중으로 변경합니다.
     * 배송 추적 API로 유효성 검증을 수행하고, 배송 완료 여부에 따라 상태를 자동 업데이트합니다.
     * @param orderId 주문 ID
     * @param trackingNumber 송장번호
     * @param deliveryCompany 택배사 코드
     * @return 검증 결과 메시지 (성공 시 null, 실패 시 오류 메시지)
     */
    @Transactional
    public String updateTrackingNumber(String orderId, String trackingNumber, String deliveryCompany) {
        String status = "배송중";
        String validationMessage = null;

        TrackingResponseDTO trackingInfo = null;
        try {
            trackingInfo = deliveryService.getTrackingInfo(deliveryCompany, trackingNumber);
            if (trackingInfo != null) {
                status = determineOrderStatus(trackingInfo);
            } else {
                validationMessage = "송장번호가 저장되었습니다. 배송 추적 API 검증에 실패하여 자동 상태 업데이트는 되지 않았습니다. 송장번호를 확인해주세요.";
            }
        } catch (Exception e) {
            log.warn("API 검증 중 예외 발생 (송장번호는 저장됨): orderId={}, error={}", orderId, e.getMessage());
            validationMessage = "송장번호가 저장되었으나, 배송 추적 API 연동 중 오류가 발생했습니다.";
        }
        
        ordDAO.updateTrackingAndStatus(orderId, trackingNumber, deliveryCompany, status);
        log.info("송장 정보 업데이트 완료: orderId={}, trackingNumber={}, status={}", orderId, trackingNumber, status);

        return validationMessage;
    }

    /**
     * 배송 추적 정보를 기반으로 주문 상태를 결정합니다.
     * @param trackingInfo 배송 추적 정보
     * @return 주문 상태 ("배송중", "배송완료" 등)
     */
    private String determineOrderStatus(TrackingResponseDTO trackingInfo) {
        if (trackingInfo == null) {
            return "배송중";
        }

        if (trackingInfo.isComplete()) {
            return "배송완료";
        }

        if (trackingInfo.getTrackingDetails() != null && !trackingInfo.getTrackingDetails().isEmpty()) {
            int lastIndex = trackingInfo.getTrackingDetails().size() - 1;
            String latestStatus = trackingInfo.getTrackingDetails().get(lastIndex).getKind();
            if (latestStatus != null && (latestStatus.contains("배송완료") || latestStatus.contains("배달완료") || latestStatus.contains("수령완료"))) {
                return "배송완료";
            }
        }

        return "배송중";
    }

    /**
     * 특정 사용자가 특정 상품을 구매했는지 확인합니다.
     * @param memberId 회원 ID
     * @param productId 상품 ID
     * @return 구매 이력이 있으면 true, 없으면 false
     */
    public boolean hasUserPurchasedProduct(String memberId, Long productId) {
        return orderDetailDAO.countConfirmedPurchase(memberId, productId) > 0;
    }
}
