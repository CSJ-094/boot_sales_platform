


# 🛒 Boot Sales Platform (Spring Boot E-Commerce)

> **GPT-4o-mini AI 상담과 MongoDB 실시간 채팅이 통합된 스마트 커머스 플랫폼**

이 프로젝트는 Spring Boot 기반의 이커머스 서비스에 현대적인 AI 기술과 실시간 통신 기술을 접목했습니다. RDBMS(MySQL)와 NoSQL(MongoDB)을 혼합하여 서비스 특성에 맞는 최적의 데이터 저장 구조를 설계했습니다.

[마이그레이션 전 프로젝트 링크](https://github.com/CSJ-094/boot_car_recall_final.git)


<img width="891" height="1260" alt="image" src="https://github.com/user-attachments/assets/f8eca2d3-54a5-4444-a7a1-6adcf7e2d276" />

---

## 🛠 Tech Stack

### 🌐 프론트엔드
| 기술 | 설명 |
|:--:|:--|
| ![JSP](https://img.shields.io/badge/JSP-007396?style=flat&logo=java&logoColor=white) | 서버 사이드 렌더링 기반 동적 페이지 구성 |
| ![HTML5](https://img.shields.io/badge/HTML5-E34F26?style=flat&logo=html5&logoColor=white) <br> ![CSS3](https://img.shields.io/badge/CSS3-1572B6?style=flat&logo=css3&logoColor=white) | UI 마크업 및 스타일링 |
| ![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?style=flat&logo=javascript&logoColor=black) <br> ![jQuery](https://img.shields.io/badge/jQuery-0769AD?style=flat&logo=jquery&logoColor=white) | 사용자 인터랙션 및 Ajax 통신 처리 |
| ![Bootstrap](https://img.shields.io/badge/Bootstrap-7952B3?style=flat&logo=bootstrap&logoColor=white) | 반응형 UI 컴포넌트 기반 화면 구성 |

---

### 🧩 백엔드
| 기술 | 설명 |
|:--:|:--|
| ![Java](https://img.shields.io/badge/Java-17-007396?style=flat&logo=java&logoColor=white) | 백엔드 핵심 언어 및 서버 로직 구현 |
| ![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.2.x-6DB33F?style=flat&logo=springboot&logoColor=white) | MVC 기반 웹 애플리케이션 / REST API 구성 |
| ![Spring Security](https://img.shields.io/badge/Spring%20Security-6.x-6DB33F?style=flat&logo=springsecurity&logoColor=white) | 인증·인가 및 권한 기반 접근 제어 |
| ![MyBatis](https://img.shields.io/badge/MyBatis-000000?style=flat) | SQL 중심 데이터 처리 및 동적 쿼리 매핑 |
| ![Apache Tomcat](https://img.shields.io/badge/Apache%20Tomcat-F8DC75?style=flat&logo=apachetomcat&logoColor=black) | 웹 애플리케이션 구동 환경 |

---

### 🗄️ 데이터베이스 & 외부 연동
| 기술 | 설명 |
|:--:|:--|
| ![Oracle](https://img.shields.io/badge/Oracle-F80000?style=flat&logo=oracle&logoColor=white) | 상품·주문 등 핵심 데이터 관리 |
| ![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1?style=flat&logo=mysql&logoColor=white) | 관계형 데이터 저장 및 조회 |
| ![MongoDB](https://img.shields.io/badge/MongoDB-6.0-47A248?style=flat&logo=mongodb&logoColor=white) | 채팅 로그 등 메시지성 데이터 저장 |
| ![OpenAI](https://img.shields.io/badge/OpenAI-GPT--4o--mini-412991?style=flat&logo=openai&logoColor=white) | AI 상담(상품 문의 응답) |
| ![Toss](https://img.shields.io/badge/Toss%20Payments-0064FF?style=flat) | 결제 승인 및 위변조 검증 |

---

### 🤝 협업 & 도구
| 기술 | 설명 |
|:--:|:--|
| ![GitHub](https://img.shields.io/badge/GitHub-181717?style=flat&logo=github&logoColor=white) | 형상 관리 및 협업 |
| ![Notion](https://img.shields.io/badge/Notion-000000?style=flat&logo=notion&logoColor=white) | 문서화 및 일정 관리 |
| ![Jira](https://img.shields.io/badge/Jira-0052CC?style=flat&logo=jira&logoColor=white) | 이슈 및 작업 관리 |
| ![Slack](https://img.shields.io/badge/Slack-4A154B?style=flat&logo=slack&logoColor=white) | 팀 커뮤니케이션 |
| ![KakaoTalk](https://img.shields.io/badge/KakaoTalk-FFCD00?style=flat&logo=kakaotalk&logoColor=black) | 실시간 소통 |

---
## 📁 Project Structure (프로젝트 폴더 구조)

본 프로젝트는 **Spring Boot 기반 웹 애플리케이션**으로, 서버 사이드 렌더링(JSP)과 정적 리소스 분리를 고려한 구조를 따르고 있습니다.
- MVC 패턴에 맞춘 **역할별 패키지 분리**
- JSP 템플릿과 정적 리소스(css/js/img) 분리로 유지보수 용이
- MyBatis Mapper와 비즈니스 로직 명확히 분리
- 관리자/사용자/상품/주문 도메인 구조가 한눈에 파악 가능

```bash
Product-sales-platform-boot/
├─ src/
│  ├─ main/
│  │  ├─ java/
│  │  │  └─ com.boot
│  │  │     ├─ config/            # Spring Security, Web 설정
│  │  │     ├─ controller/        # MVC Controller
│  │  │     ├─ dao/               # MyBatis DAO
│  │  │     ├─ domain/            # Entity / Domain 객체
│  │  │     ├─ dto/               # DTO
│  │  │     ├─ OpenAiClient/      # OpenAI API 연동 로직
│  │  │     └─ service/           # 비즈니스 로직
│  │  │
│  │  ├─ resources/
│  │  │  ├─ mybatis/
│  │  │  │  ├─ mapper/            # MyBatis Mapper XML
│  │  │  │  └─ mappers/
│  │  │  ├─ templates/            # JSP 템플릿
│  │  │  │  ├─ cart/
│  │  │  │  ├─ category/
│  │  │  │  ├─ find/
│  │  │  │  ├─ fragments/         # header, footer 공통 레이아웃
│  │  │  │  ├─ login/
│  │  │  │  ├─ order/
│  │  │  │  ├─ product/
│  │  │  │  ├─ seller/
│  │  │  │  └─ user/
│  │  │  ├─ static/
│  │  │  │  ├─ css/               # 페이지별 CSS
│  │  │  │  ├─ img/               # 이미지 리소스
│  │  │  │  └─ js/                # JS (차트, 채팅, 대시보드)
│  │  │  ├─ application.properties
│  │  │  ├─ mybatis-config.xml
│  │  │  └─ keystore.p12          # HTTPS 인증서
│  │
│  └─ test/                       # 테스트 코드
│
├─ build.gradle                   # Gradle 빌드 설정
├─ settings.gradle
├─ gradlew / gradlew.bat
└─ README.md
```
<br/>

---
## ✨ Key Features

### 👤 회원 관리 (Member)
- **회원가입 / 로그인**  
  Spring Security 기반 폼 로그인 및 보안 설정 적용
- **권한 제어**  
  일반 사용자(USER) / 관리자(ADMIN) 권한 분리
- **AI 상담 챗봇**  
  GPT-4o-mini를 활용한 상품 문의 자동 응답
- **실시간 상담 채팅**  
  WebSocket 기반 1:1 실시간 채팅 지원  
  채팅 로그는 MongoDB에 비동기 저장

---

### 🛍 상품 관리 (Item)
- **상품 등록 / 수정**  
  관리자 권한 사용자만 상품 이미지 및 상세 정보 관리 가능
- **상품 조회**  
  페이징 처리 및 검색 기능을 통한 상품 목록 제공

---

### 🛒 주문 시스템 (Cart & Order)
- **장바구니**  
  상품 담기 및 수량 변경 기능 제공
- **주문 / 결제**  
  Toss Payments API 연동을 통한 실제 결제 프로세스 구현
- **주문 내역 관리**  
  주문 기록 조회 및 주문 취소 기능 제공

---

### 👑 관리자 기능 (Admin Side)
- **관리자 전용 백오피스**  
  ROLE_ADMIN 권한 계정만 접근 가능
- **상품 관리**
  - 상품명, 가격, 상세 설명, 재고 수량 설정  
  - 다중 상품 이미지 업로드 및 대표 이미지 지정  
  - 상품 상태 관리 (판매 중 / 품절)
- **재고 관리**  
  주문 및 취소 시 실시간 재고 증감 처리
- **주문 현황 관리**  
  전체 주문 내역을 대시보드 형태로 조회 및 관리
- **통합 상담 센터**  
  상담 요청 목록 확인 및 실시간 1:1 채팅 응대
- **보안**  
  RBAC(Role Based Access Control) 기반 관리자 기능 접근 제어


## ERD

<img width="1731" height="1448" alt="image" src="https://github.com/user-attachments/assets/326f24f6-409d-4f37-ac39-ba31cc7e6faf" />

<details>
  <summary><b>📋 테이블 세부 명세서 보기</b></summary>
  <br>
<img width="1835" height="7033" alt="3차프로젝트_테이블명세서_최종" src="https://github.com/user-attachments/assets/676470ce-0894-4761-9a49-3e8becd2ef84" />

</details>


## 🗺️ 시스템 구조도 (Architecture Diagram)

```mermaid
graph TD
    User((사용자)) --> Security[Spring Security]
    Admin((관리자)) --> Security
    
    subgraph App_Server[Spring Boot Application]
        Security --> Controller[Controller Layer]
        Controller --> Service[Business Service]
        Service --> AIService[AI & Chat Service]
        Service --> PayService[Payment Service]
    end
    
    Service --> MySQL[(MySQL: Order/Item)]
    AIService <--> MongoDB[(MongoDB: Chat Log)]
    AIService <--> OpenAI[[GPT-4o-mini API]]
    PayService <--> Toss[[Toss Payments API]]
```

## 📂 Project Documents (기타 문서)

프로젝트 진행 시 작성된 설계 문서입니다. 클릭 시 상세 내용을 확인할 수 있습니다.

| 문서 종류 | 파일명 | 형식 | 바로가기 |
| :--- | :--- | :---: | :---: |
| **화면 설계서** | 화면설계서.pdf | ![PDF](https://img.shields.io/badge/PDF-F40F02?style=flat-square&logo=adobe-acrobat-reader&logoColor=white) | [📄 문서 보기](https://github.com/user-attachments/files/24488584/default.pdf) |
| **서비스구조** | 서비스 구조도.pdf | ![PDF](https://img.shields.io/badge/PDF-F40F02?style=flat-square&logo=adobe-acrobat-reader&logoColor=white)  | [📄 문서 보기](https://github.com/user-attachments/files/24488707/-3.pdf) |

<br/>

---

## 🚀 결과

### 유저 전용 UI

<details>
  <summary><b>메인페이지</b></summary>
  ![main](https://github.com/user-attachments/assets/f5a14f1b-00ea-4073-9a60-f14e419751d1)

- 구조: ItemController → ItemService → ItemRepository(QueryDSL)

- 핵심 로직:

     동적 쿼리: QueryDSL을 사용하여 상품명, 상품 상태, 등록자별 검색 기능을 구현했습니다.

     페이징(Pagination): Pageable 인터페이스를 활용해 대량의 상품 데이터를 효율적으로 끊어서 로드합니다.
 
     이미지 최적화: ItemImgRepository에서 repImgYn="Y"인 대표 이미지만 추출하여 메인 리스트에 노출합니다.
  
</details>

<details>
  <summary>상품 상세페이지</summary>
<img width="1606" height="846" alt="chrome_V28P15tZbg" src="https://github.com/user-attachments/assets/1e493341-16e7-4395-8528-1f41d7a90608" />

- 구조: Item 엔티티와 ItemImg 엔티티의 1:N 매핑 구조

- 핵심 로직:

    상품 ID(itemId)를 경로 변수로 받아 상품 기본 정보와 등록된 모든 이미지 리스트를 함께 조회합니다.

    조회수/재고 확인: 실시간 재고 수량을 파악하여 '품절' 상태일 경우 '주문하기' 버튼을 비활성화 처리합니다.

</details>

<details>
  <summary>상품 구매(결제)페이지</summary>
<img width="1567" height="852" alt="chrome_umQpbhperS" src="https://github.com/user-attachments/assets/6b090870-bda5-41aa-9c30-d589c9e729b5" />

- 구조: OrderController → OrderService → Toss Payments API

- 핵심 로직:

    트랜잭션 관리: 주문 생성 시 Item 엔티티의 removeStock 메서드를 호출하여 재고를 차감합니다. (재고 부족 시 OutOfStockException 발생)

    결제 검증: 프론트엔드에서 전달받은 결제 금액과 서버 DB의 실제 상품 금액을 대조하여 위변조를 방지하는 검증 로직을 거친 후 Toss API 최종 승인을 호출합니다.
  
</details>

<details>
  <summary>마이페이지</summary>
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
  <summary>대시보드</summary>
<img width="1587" height="840" alt="chrome_otZmBEAbIW" src="https://github.com/user-attachments/assets/6a9c7503-473a-4868-af66-0b8e2ae9d429" />
</details>

<details>
  <summary>주문관리</summary>
<img width="1600" height="840" alt="chrome_mOk8ryT3lL" src="https://github.com/user-attachments/assets/e498aa08-7a33-4de7-84b8-cde1ee6a43a2" />
</details>

---

## 👥 Team & Roles (팀 구성 및 역할)

| 이름 | 역할 | 담당 기능 |
|:--:|:--:|:--|
| **조상진** | 팀장 / Full-Stack | - 프로젝트 전반 관리 및 초기 설계·역할 분담<br>- DB 세팅 및 수정<br>- 메인페이지 구현<br>- 토스 결제 API 연동<br>- 상품 페이지 기능 구현<br>- 고객 마이페이지(구매내역) 구현<br>- 프로젝트 병합 및 오류 수정<br>- 전반 문서/보고서 작성 |
| **최예성** | Full-Stack | - 관리자 공지사항 등록/수정/삭제 기능 구현<br>- 관리자 페이지 프론트 구현<br>- 파일 업로드 및 주요 오류 대응 참여<br>- 택배 배송 조회 API 연동<br>- 주문 페이지 택배 기능 구현<br>- 문서 작업 |
| **김가영** | Full-Stack | - 전반 UI/프론트 디자인 가이드 적용<br>- 판매자 정보 조회 기능 구현<br>- 판매자 상품 등록/수정/삭제 기능 구현<br>- 카테고리 기능 구현 및 연동<br>- 판매자 마이페이지 프론트 구현<br>- 판매자 마이페이지 최근 리스트 구현<br>- 판매자 대시보드 구현<br>- PPT 제작 |
| **주석우** | Full-Stack | - 로그인 / 회원가입 기능 구현<br>- 이메일 인증 기능 구현<br>- 카테고리별 상품 조회 페이지 구현<br>- 메인 페이지 상품 리스트 프론트 구현<br>- ChatGPT 연동 챗봇 구현<br>- 챗봇 내 1:1 상담사 채팅 기능 구현 |
| **한경훈** | Full-Stack | - 프론트 디자인 통일 및 UI 구현<br>- 상품 구매 및 결제 기능 개발<br>- 고객 마이페이지 프론트 구현<br>- 파일 업로드 기능 개발<br>- 상품 검색 기능 구현<br>- 챗봇 API 연동<br>- 출석체크 API 구현<br>- 쿠폰/포인트 기능 구현 |
| **최민규** | Full-Stack | - 메인페이지 상품 리스트 기능 구현<br>- 회원가입 / 로그인 기능 구현<br>- 메인페이지 프론트 구현<br>- 목록 페이지 프론트 구현<br>- 카카오 API 연동<br>- 로그인/회원정보 암호화 적용<br>- 비밀번호 찾기 기능 구현<br>- 회원 탈퇴 기능 구현<br>- 마이그레이션 작업 |
