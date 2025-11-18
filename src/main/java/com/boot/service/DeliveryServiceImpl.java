package com.boot.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.util.concurrent.ConcurrentHashMap;
import java.util.Map;
import java.util.Collections;
import com.boot.dto.TrackingResponseDTO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class DeliveryServiceImpl implements DeliveryService{
	@Value("${delivery.api.key}") 
    private String API_KEY; 

    @Value("${delivery.api.base-url}") 
    private String API_URL;

    private final RestTemplate restTemplate = new RestTemplate(); 
    
    // 💡 추가: 간단한 인메모리 캐시 구현
    private final Map<String, TrackingResponseDTO> trackingCache = new ConcurrentHashMap<>();

    @Override
    public TrackingResponseDTO getTrackingInfo(String t_code, String t_invoice) {
        String cacheKey = t_code + ":" + t_invoice;
        // 1. 캐시에서 먼저 조회
        if (trackingCache.containsKey(cacheKey)) {
            log.info("캐시에서 배송 정보 반환: {}", cacheKey);
            return trackingCache.get(cacheKey);
        }

        // API 키 확인
        if (API_KEY == null || API_KEY.isEmpty()) {
            log.error("API 키가 설정되지 않았습니다. application.properties에서 delivery.api.key를 확인하세요.");
            return null;
        }
        
        log.info("API 키 확인: {} (길이: {})", API_KEY.substring(0, Math.min(10, API_KEY.length())) + "...", API_KEY.length());
        log.info("API 키 전체: {}", API_KEY); // 디버깅용 - 실제 운영에서는 제거 권장
        
        // 💡 수정: UriComponentsBuilder를 사용하여 안전하게 URL과 파라미터를 인코딩합니다.
        String requestUrl = UriComponentsBuilder.fromHttpUrl(API_URL)
                .queryParam("t_key", API_KEY)
                .queryParam("t_code", t_code)
                .queryParam("t_invoice", t_invoice)
                .build()
                .toUriString();
        
        log.info("배송 추적 API 호출 시작 - URL: {}, 택배사코드: {}, 송장번호: {}", 
                 API_URL, t_code, t_invoice);
        log.info("전체 요청 URL: {}", requestUrl);

        try {
            // 💡 수정: HTTP 헤더 설정 (JSON 응답 요청)
            HttpHeaders headers = new HttpHeaders();
            headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));
            HttpEntity<String> entity = new HttpEntity<>(headers);

            // 💡 수정: getForEntity 대신 exchange를 사용하여 헤더와 함께 요청
            ResponseEntity<TrackingResponseDTO> response = restTemplate.exchange(
                requestUrl, 
                HttpMethod.GET, 
                entity, 
                TrackingResponseDTO.class
            );
            
            if (response.getStatusCode().is2xxSuccessful() && response.getBody() != null) {
                TrackingResponseDTO body = response.getBody();
                // 💡 추가: API가 실제로 어떤 내용을 보내주는지 확인하기 위해 응답 본문 전체를 로그로 남깁니다.
                log.info("Sweet Tracker API 실제 응답 본문: {}", body.toString());

                log.info("API 호출 성공 - 배송완료여부: {}, 상품명: {}, 송장번호: {}", 
                         body.isComplete(), body.getItemName(), body.getInvoiceNo());
                if (body.getTrackingDetails() != null) {
                    log.info("배송 내역 개수: {}", body.getTrackingDetails().size());
                }
                // 2. 성공 시 캐시에 저장
                trackingCache.put(cacheKey, body);

                return body;
            } else {
                log.error("API 호출 실패 - HTTP Status: {}, 택배사코드: {}, 송장번호: {}", 
                         response.getStatusCode(), t_code, t_invoice);
                return null;
            }

        } catch (org.springframework.web.client.HttpClientErrorException e) {
            String responseBody = e.getResponseBodyAsString();
            log.error("HTTP 클라이언트 오류 - Status: {}, Message: {}, 택배사코드: {}, 송장번호: {}", 
                     e.getStatusCode(), e.getMessage(), t_code, t_invoice);
            log.error("응답 본문: {}", responseBody);
            
            // API Key 없음 오류인 경우
            if (responseBody != null && responseBody.contains("API Key")) {
                log.error("API 키 오류 감지! API 키가 제대로 전달되지 않았습니다.");
                log.error("설정된 API 키: {}", API_KEY != null ? "설정됨 (길이: " + API_KEY.length() + ")" : "NULL");
            }
            return null;
        } catch (org.springframework.web.client.ResourceAccessException e) {
            log.error("네트워크 연결 오류 - Message: {}, 택배사코드: {}, 송장번호: {}", 
                     e.getMessage(), t_code, t_invoice);
            return null;
        } catch (Exception e) {
            log.error("API 호출 중 예외 발생 - Message: {}, 택배사코드: {}, 송장번호: {}", 
                     e.getMessage(), t_code, t_invoice, e);
            return null;
        }
    }
}
