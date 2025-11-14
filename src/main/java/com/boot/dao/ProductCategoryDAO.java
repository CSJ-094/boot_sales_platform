package com.boot.dao;

import java.util.List;
import java.util.Map;

import com.boot.dto.ProductCategoryDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;


@Mapper
public interface ProductCategoryDAO {
	List<ProductCategoryDTO> selectByProdId(@Param("prodId") Long prodId);
	 int deleteAllByProdId(@Param("prodId") Long prodId);
	 int bulkInsert(@Param("list") List<ProductCategoryDTO> list);
}
