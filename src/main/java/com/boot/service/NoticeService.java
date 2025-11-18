package com.boot.service;

import java.util.List;

import com.boot.dao.NoticeDAO;
import com.boot.dto.NoticeDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


@Service
public class NoticeService {

    @Autowired
    private NoticeDAO noticeMapper;

    // 1. 공지사항 목록 조회
    public List<NoticeDTO> list() {
        // 별도의 비즈니스 로직 없이 DAO를 통해 DB에서 데이터를 가져옵니다.
        return noticeMapper.list();
    }

    // 2. 공지사항 등록
    public void write(NoticeDTO noticeDTO) {
        // 등록 시 작성자 정보(NOT_NAME)나 유효성 검사 등 비즈니스 로직을 추가할 수 있습니다.
        // 예: if (noticeDTO.getNOT_TITLE().isEmpty()) throw new IllegalArgumentException("제목은 필수입니다.");
        
        noticeMapper.write(noticeDTO);
    }

    // 3. 공지사항 상세 내용 조회
    public NoticeDTO contentView(int notNo) {
        // 조회수 증가 로직(upHit)을 여기에 추가할 수 있습니다.
        // noticeMapper.upHit(notNo); 
        
        return noticeMapper.contentView(notNo);
    }

    // 4. 공지사항 수정
    public void modify(NoticeDTO noticeDTO) {
        // 수정 권한 확인 등의 비즈니스 로직을 여기에 추가할 수 있습니다.
        noticeMapper.modify(noticeDTO);
    }
    
    // 메인에서 쓸 최근 공지 조회
    public List<NoticeDTO> getRecentNotices(int limit) {
        return noticeMapper.findRecent(limit);
    }

    // 5. 공지사항 삭제
    public void delete(int notNo) {
        // 삭제 권한 확인 등의 비즈니스 로직을 여기에 추가할 수 있습니다.
        noticeMapper.delete(notNo);
    }

}