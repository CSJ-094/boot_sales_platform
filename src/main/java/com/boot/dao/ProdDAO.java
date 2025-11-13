package com.boot.dao;

import java.util.ArrayList;
import java.util.List;

import com.boot.dto.ProdDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;


@Mapper
public interface ProdDAO {
	List<ProdDTO> getProductList();         // 전체 목록
    ProdDTO getProduct(Long prodId);        // 상세
    int insertProduct(ProdDTO product);     // 등록
    int updateProduct(ProdDTO product);     // 수정
    int deleteProduct(@Param("prodId") long prodId); // 삭제
	ProdDTO getProductById(int prodId);
	public ArrayList<ProdDTO> selectProductsByCategory(int catId);
	public ArrayList<ProdDTO> getAllProdsByCatId(int catId);
}
