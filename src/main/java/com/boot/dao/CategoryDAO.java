package com.boot.dao;

import com.boot.dto.CategoryDTO;
import org.apache.ibatis.annotations.Mapper;

import java.util.Collection;
import java.util.List;


@Mapper
public interface CategoryDAO {
	List<CategoryDTO> selectTreeFlat();
	Collection<? extends Long> selectAllParentIds(List<Long> catIds);
}