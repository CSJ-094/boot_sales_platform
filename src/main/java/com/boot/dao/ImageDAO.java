package com.boot.dao;


import com.boot.dto.ImageDTO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ImageDAO {
    int insertImage(ImageDTO dto);
}