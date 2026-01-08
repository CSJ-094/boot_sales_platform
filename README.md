


# 🛒 Boot Sales Platform (Spring Boot E-Commerce)

> **GPT-4o-mini AI 상담과 MongoDB 실시간 채팅이 통합된 스마트 커머스 플랫폼**

이 프로젝트는 Spring Boot 기반의 이커머스 서비스에 현대적인 AI 기술과 실시간 통신 기술을 접목했습니다. RDBMS(MySQL)와 NoSQL(MongoDB)을 혼합하여 서비스 특성에 맞는 최적의 데이터 저장 구조를 설계했습니다.


<img width="891" height="1260" alt="image" src="https://github.com/user-attachments/assets/f8eca2d3-54a5-4444-a7a1-6adcf7e2d276" />

---

## 🛠 Tech Stack

### Backend
![Java](https://img.shields.io/badge/Java-17-007396?style=flat&logo=java&logoColor=white)
![SpringBoot](https://img.shields.io/badge/SpringBoot-3.2.x-6DB33F?style=flat&logo=springboot&logoColor=white)
![SpringSecurity](https://img.shields.io/badge/SpringSecurity-6.x-6DB33F?style=flat&logo=springsecurity&logoColor=white)
![JPA](https://img.shields.io/badge/JPA-Hibernate-59666C?style=flat)

### Database & AI
![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1?style=flat&logo=mysql&logoColor=white)
![MongoDB](https://img.shields.io/badge/MongoDB-6.0-47A248?style=flat&logo=mongodb&logoColor=white)
![OpenAI](https://img.shields.io/badge/GPT--4o--mini-API-412991?style=flat&logo=openai&logoColor=white)

---

## ✨ Key Features

**👤 회원 관리 (Member)**

회원가입/로그인: 
Spring Security를 활용한 폼 기반 로그인 및 보안 설정.

권한 제어: 일반 사용자(USER)와 관리자(ADMIN) 권한 분리.

GPT-4o-mini AI 상담: 사용자의 상품 문의를 실시간으로 분석하여 적절한 답변을 제공하는 지능형 챗봇을 구현했습니다.

실시간 WebSocket 채팅: 상담사와 1:1 실시간 채팅이 가능하며, 대화 내용은 MongoDB에 비동기로 저장되어 대용량 메시지 데이터를 효율적으로 관리합니다.

**🛍 상품 관리 (Item)**

상품 등록/수정: 관리자 권한을 가진 사용자만 상품 이미지와 상세 정보를 등록 및 수정 가능.

상품 조회: 페이징 처리 및 검색 기능을 통한 효율적인 상품 목록 제공.

**🛒 주문 시스템 (Cart & Order)**

장바구니: 구매를 원하는 상품을 장바구니에 담고 수량 조절 가능.

주문/결제: 장바구니 아이템 주문 및 Toss Payment API를 이용한 실제 결제 프로세스 구현.

주문 내역: 사용자의 과거 주문 기록 확인 및 취소 기능.

**👑 관리자 기능 (Admin Side)**

관리자 권한(ROLE_ADMIN)을 가진 계정만 접근 가능한 백오피스 기능입니다.

상품 등록 (Item Management): * 상품명, 가격, 상세 설명 및 재고 수량 설정.

다중 상품 이미지 업로드 및 대표 이미지 설정.

상품 수정 및 상태 관리: * 기존 상품 정보 수정.

상품 상태 변경 (판매 중 / 품절)을 통한 노출 제어.

재고 관리: 주문 및 취소 발생 시 실시간 재고 증감 로직 반영.

주문 현황 모니터링: 모든 사용자의 주문 내역을 대시보드 방식으로 표시하고 관리.

통합 상담 센터: 사용자의 상담 요청 목록 확인 및 실시간 1:1 대화 응대

보안: 역할 기반 접근 제어(RBAC)를 통해 관리자 전용 메뉴 접근을 보호합니다.


## ERD

<img width="1731" height="1448" alt="image" src="https://github.com/user-attachments/assets/326f24f6-409d-4f37-ac39-ba31cc7e6faf" />


## UI/UX Screenshot

### 👤 유저 전용 UI

<details>
  <summary><b>🏠 메인화면</b></summary>
  <br>
  <img width="1601" height="942" alt="Main Page" src="https://github.com/user-attachments/assets/5a117255-4963-4379-8f08-13b3d7f35b97" />
  <br><br>
  
  - **동적 쿼리 최적화:** QueryDSL을 활용하여 상품명, 판매 상태, 등록자 등 복합적인 검색 조건을 안정적으로 처리합니다.
  - **서버 사이드 페이징:** `Pageable` 인터페이스를 통해 대량의 상품 데이터를 효율적으로 분할 로드하여 초기 로딩 속도를 개선했습니다.
  - **이미지 서빙 최적화:** 모든 이미지 중 대표 이미지(`repImgYn="Y"`)만을 선별적으로 조회하여 불필요한 데이터 전송을 최소화합니다.
</details>

<details>
  <summary><b>🔍 상품 상세페이지</b></summary>
  <br>
  <img width="1606" height="846" alt="Item Detail" src="https://github.com/user-attachments/assets/1e493341-16e7-4395-8528-1f41d7a90608" />
  <br><br>
  
  - **엔티티 매핑 설계:** `Item`과 `ItemImg` 간의 1:N 연관관계를 활용하여 상품 정보와 상세 이미지를 유기적으로 바인딩합니다.
  - **실시간 상태 검증:** 요청 시점의 재고 수량을 파악하여, 품절 시 클라이언트 단의 '주문' 액션을 즉각 차단하는 비즈니스 로직을 적용했습니다.
  - **RESTful 조회:** 경로 변수(`itemId`)를 통한 표준화된 API 구조로 상세 정보를 신속하게 로드합니다.
</details>

<details>
  <summary><b>💳 상품 구매(결제)페이지</b></summary>
  <br>
  <img width="1567" height="852" alt="Payment Page" src="https://github.com/user-attachments/assets/6b090870-bda5-41aa-9c30-d589c9e729b5" />
  <br><br>
  
  - **원자적 재고 관리:** 주문 생성 시 엔티티 내부의 `removeStock` 메서드를 호출하여 재고 차감과 주문 생성을 하나의 트랜잭션으로 보장합니다.
  - **결제 무결성 검증:** Toss API 최종 승인 전 서버 DB의 실제 단가와 요청 금액을 대조하여 금액 위변조를 원천 차단합니다.
  - **예외 처리 설계:** 재고 부족 시 `OutOfStockException` 등 커스텀 예외를 발생시켜 사용자에게 명확한 안내 메시지를 전달합니다.
</details>

<details>
  <summary><b>👤 마이페이지 및 배송 추적</b></summary>
  <br>
  <img width="1614" height="836" alt="MyPage 1" src="https://github.com/user-attachments/assets/4edc4510-136e-4220-bbf2-21f80a1f049f" />
  <img width="1613" height="856" alt="MyPage 2" src="https://github.com/user-attachments/assets/44623260-2999-4945-be59-71b76066aa10" />
  <br><br>
  
  - **개인화 데이터 필터링:** Spring Security 세션의 사용자 식별값(`Email`)을 기반으로 본인의 데이터만 안전하게 필터링하여 제공합니다.
  - **라이프사이클 추적:** `OrderStatus` 상수를 통해 주문 완료부터 배송, 취소에 이르는 전체 구매 프로세스를 실시간으로 추적합니다.
  - **조건부 액션 제어:** 배송 시작 전(`ORDER` 상태)에 한해서만 취소 로직을 허용하는 상태 기반 검증 프로세스를 구현했습니다.
</details>

---

### 👑 관리자 전용 UI

<details>
  <summary><b>📊 관리자 대시보드</b></summary>
  <br>
  <img width="1587" height="840" alt="Admin Dashboard" src="https://github.com/user-attachments/assets/6a9c7503-473a-4868-af66-0b8e2ae9d429" />
  <br><br>
  
  - **구조적 집계:** QueryDSL을 활용해 전체 주문/상품/회원 데이터를 상태별로 집계하여 운영 지표를 시각화합니다.
  - **실시간 관제:** MongoDB 기반의 실시간 상담 로그와 연동되어 AI 챗봇 응대 현황을 모니터링하고 즉각적인 관리자 개입이 가능합니다.
  - **보안 설계:** Spring Security의 RBAC(Role-Based Access Control)를 적용하여 관리자 전용 API 접근 권한을 엄격히 분리했습니다.
  - **일괄 트랜잭션:** 다량의 상품 재고 수정 및 주문 상태 일괄 변경 등 관리 업무 효율을 위한 비즈니스 로직을 제공합니다.
</details>

<details>
  <summary><b>📦 주문관리</b></summary>
  <br>
  <img width="1600" height="840" alt="Order Management" src="https://github.com/user-attachments/assets/e498aa08-7a33-4de7-84b8-cde1ee6a43a2" />
  <br><br>
  
  - **전체 주문 관제:** 시스템 전체 주문 데이터를 최신순으로 페이징 조회하여 관리 편의성을 극대화했습니다.
  - **상태 강제 제어:** 관리자가 직접 입금 확인 및 배송 상태를 변경하며, 이는 사용자의 마이페이지와 실시간으로 연동됩니다.
  - **데이터 정합성 보장:** 관리자에 의한 주문 취소 시 차감되었던 상품 재고를 자동으로 원복하는 로직을 수행합니다.
</details>

## 🗺️ 시스템 구조도 (Architecture Diagram)

```mermaid
graph TD
    User((사용자)) --> Security[Spring Security]
    Admin((관리자)) --> Security
    
    subgraph App_Server [Spring Boot Application]
        Security --> Controller[Controller Layer]
        Controller --> Service[Business Service]
        Service --> AIService[AI & Chat Service]
        Service --> PayService[Payment Service]
    end
    
    Service --> MySQL[(MySQL: Order/Item)]
    AIService <--> MongoDB[(MongoDB: Chat Log)]
    AIService <--> OpenAI[[GPT-4o-mini API]]
    PayService <--> Toss[[Toss Payments API]]
