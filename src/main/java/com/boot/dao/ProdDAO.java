package com.boot.dao;

import java.util.ArrayList;
import java.util.List;

import com.boot.dto.ProdDTO;
import com.boot.dto.ProductSearchCondition;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;


@Mapper
public interface ProdDAO {
	List<ProdDTO> getProductList();         // 전체 목록
    ProdDTO getProduct(Long prodId);        // 상세 (Integer -> Long 변경)
    int insertProduct(ProdDTO product);     // 등록
    int updateProduct(ProdDTO product);     // 수정
    int deleteProduct(@Param("prodId") Long prodId); // 삭제 (int -> Long 변경)
	ProdDTO getProductById(Long prodId); // Integer -> Long 변경
	public ArrayList<ProdDTO> selectProductsByCategory(int catId);
	public ArrayList<ProdDTO> getAllProdsByCatId(int catId);

    // 상품 검색 기능 추가
    List<ProdDTO> searchProducts(ProductSearchCondition condition);
}