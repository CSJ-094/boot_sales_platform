package com.boot.dao;


import com.boot.dto.ImageDTO;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ImageDAO {
    int insertImage(ImageDTO dto);
    List<ImageDTO> selectByProdId(Long prodId);
	void deleteByProdId(Long prodId);
}