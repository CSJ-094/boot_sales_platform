


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

### 유저 전용 UI

<details>
  <summary>**메인화면**</summary>
<img width="1601" height="942" alt="chrome_DHcEmL3QNu" src="https://github.com/user-attachments/assets/5a117255-4963-4379-8f08-13b3d7f35b97" />

- 구조: ItemController → ItemService → ItemRepository(QueryDSL)

- 핵심 로직:

     동적 쿼리: QueryDSL을 사용하여 상품명, 상품 상태, 등록자별 검색 기능을 구현했습니다.

     페이징(Pagination): Pageable 인터페이스를 활용해 대량의 상품 데이터를 효율적으로 끊어서 로드합니다.
 
     이미지 최적화: ItemImgRepository에서 repImgYn="Y"인 대표 이미지만 추출하여 메인 리스트에 노출합니다.
  
</details>

<details>
  <summary>**상품 상세페이지**</summary>
<img width="1606" height="846" alt="chrome_V28P15tZbg" src="https://github.com/user-attachments/assets/1e493341-16e7-4395-8528-1f41d7a90608" />

- 구조: Item 엔티티와 ItemImg 엔티티의 1:N 매핑 구조

- 핵심 로직:

    상품 ID(itemId)를 경로 변수로 받아 상품 기본 정보와 등록된 모든 이미지 리스트를 함께 조회합니다.

    조회수/재고 확인: 실시간 재고 수량을 파악하여 '품절' 상태일 경우 '주문하기' 버튼을 비활성화 처리합니다.

</details>

<details>
  <summary>**상품 구매(결제)페이지**</summary>
<img width="1567" height="852" alt="chrome_umQpbhperS" src="https://github.com/user-attachments/assets/6b090870-bda5-41aa-9c30-d589c9e729b5" />

- 구조: OrderController → OrderService → Toss Payments API

- 핵심 로직:

    트랜잭션 관리: 주문 생성 시 Item 엔티티의 removeStock 메서드를 호출하여 재고를 차감합니다. (재고 부족 시 OutOfStockException 발생)

    결제 검증: 프론트엔드에서 전달받은 결제 금액과 서버 DB의 실제 상품 금액을 대조하여 위변조를 방지하는 검증 로직을 거친 후 Toss API 최종 승인을 호출합니다.
  
</details>

<details>
  <summary>**마이페이지**</summary>
<img width="1614" height="836" alt="chrome_AEjdsVdzH4" src="https://github.com/user-attachments/assets/4edc4510-136e-4220-bbf2-21f80a1f049f" />

<img width="1613" height="856" alt="chrome_4gIlYRpAho" src="https://github.com/user-attachments/assets/44623260-2999-4945-be59-71b76066aa10" />

- 구조: OrderRepository에서 현재 로그인한 사용자의 email로 필터링 조회

- 핵심 로직:

    주문 이력: 본인이 주문한 내역을 최신순으로 페이징 조회합니다.

    배송 상태: OrderStatus 상수를 정의하여 ORDER, CANCEL, SHIPPING, DELIVERED 단계를 추적합니다.

    주문 취소: 배송 시작 전(ORDER 상태)에만 취소가 가능하도록 검증 로직이 포함되어 있습니다.
</details>

### 관리자 전용 UI

<details>
  <summary>**대시보드**</summary>
<img width="1587" height="840" alt="chrome_otZmBEAbIW" src="https://github.com/user-attachments/assets/6a9c7503-473a-4868-af66-0b8e2ae9d429" />
</details>

<details>
  <summary>**주문관리**</summary>
<img width="1600" height="840" alt="chrome_mOk8ryT3lL" src="https://github.com/user-attachments/assets/e498aa08-7a33-4de7-84b8-cde1ee6a43a2" />
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
