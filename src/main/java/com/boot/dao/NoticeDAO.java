package com.boot.dao;

import java.util.ArrayList;
import java.util.List;

import com.boot.dto.NoticeDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;



@Mapper
public interface NoticeDAO {
	List<NoticeDTO> list();
	void write(NoticeDTO dto); 
	NoticeDTO contentView(@Param("notNo") int notNo);
	void modify(NoticeDTO dto);
	void delete(@Param("notNo") int notNo);
	List<NoticeDTO> findRecent(@Param("limit") int limit); //최근 공지(메인)
}
