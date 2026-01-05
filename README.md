
# 의류 판매 플랫폼

의류 판매 플랫폼(가칭)은 실제 의류 판매 사이트와 동일한 기능을 재현한 프로젝트입니다.




## 기능 스택

**Backend**

Framework: Spring Boot 3.x

Language: Java 17

Security: Spring Security

Data: Spring Data JPA, QueryDSL

Database: MySQL (운영), H2 (테스트)

Build Tool: Gradle

**Frontend**

Engine: Thymeleaf

Styling: Bootstrap 5, CSS

Interaction: JavaScript, jQuery

**External API**

Payment : Toss Payment API
## Features

**👤 회원 관리 (Member)**

회원가입/로그인: 
Spring Security를 활용한 폼 기반 로그인 및 보안 설정.

권한 제어: 일반 사용자(USER)와 관리자(ADMIN) 권한 분리.

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
## ERD


## UI/UX Screenshot
