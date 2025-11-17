package com.boot.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;
import java.util.List;

@Data
public class TrackingResponseDTO {

    // API 응답의 'status' 필드 (boolean)
    @JsonProperty("status")
    private boolean status;

    // API 응답의 'msg' 필드 (String)
    @JsonProperty("msg")
    private String message;

    // API 응답의 'invoiceNo' 필드
    @JsonProperty("invoiceNo")
    private String invoiceNo;

    // API 응답의 'itemName' 필드
    @JsonProperty("itemName")
    private String itemName;

    // API 응답의 'complete' 필드 (boolean)
    @JsonProperty("complete")
    private boolean complete;

    // API 응답의 'completeYN' 필드 (String "Y" or "N")
    // isComplete() 메소드에서 이 값을 사용하도록 합니다.
    @JsonProperty("completeYN")
    private String completeYN;

    // API 응답의 'trackingDetails' 필드
    @JsonProperty("trackingDetails")
    private List<TrackingDetailDTO> trackingDetails;

    /**
     * API 응답의 'complete' 필드(boolean) 또는 'completeYN' 필드(String)를 기반으로
     * 배송 완료 여부를 반환합니다.
     * @return 배송이 완료되었으면 true
     */
    public boolean isComplete() {
        // 1. 'complete' 필드가 true이면 true 반환
        if (this.complete) {
            return true;
        }
        // 2. 'completeYN' 필드가 "Y"이면 true 반환
        return "Y".equalsIgnoreCase(this.completeYN);
    }

    // TrackingDetailDTO 내부 클래스 (또는 별도 파일)
    @Data
    public static class TrackingDetailDTO {
        @JsonProperty("kind")
        private String kind;

        @JsonProperty("where")
        private String where;

        @JsonProperty("timeString")
        private String timeString;

        @JsonProperty("telno")
        private String telno;
    }
}

