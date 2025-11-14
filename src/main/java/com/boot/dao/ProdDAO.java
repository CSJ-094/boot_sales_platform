package com.boot.dao;

import java.util.ArrayList;
import java.util.List;

import com.boot.dto.ProdDTO;
import com.boot.dto.ProductSearchCondition;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;


@Mapper
public interface ProdDAO {
	List<ProdDTO> getProductList();
    ProdDTO getProduct(Long prodId); // getProductById(int prodId) 제거
    int insertProduct(ProdDTO product);
    int updateProduct(ProdDTO product);
    int deleteProduct(@Param("prodId") long prodId);
	public ArrayList<ProdDTO> selectProductsByCategory(int catId);
	public ArrayList<ProdDTO> getAllProdsByCatId(int catId);
	List<ProdDTO> searchProducts(ProductSearchCondition condition);
}
