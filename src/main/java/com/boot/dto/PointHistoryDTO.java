package com.boot.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class PointHistoryDTO {
    private Long pointId;
    private String memberId;
    private String pointType; // EARN, USE, CANCEL
    private Integer amount;
    private String description;
    private Date changeDate;
}