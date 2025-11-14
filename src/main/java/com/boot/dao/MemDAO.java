package com.boot.dao;

import com.boot.dto.MemDTO;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;


@Mapper
public interface MemDAO {
	public MemDTO getMemberInfo(String memberId);
	void modify(MemDTO member);
	MemDTO getUserById(String memberId);
	List<MemDTO> getUserList();       // 전체 회원 조회
    MemDTO getUser(String memberId);
}
