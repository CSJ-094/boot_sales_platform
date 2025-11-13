package com.boot.service;

import java.util.List;

import com.boot.dto.ProdDTO;
import org.springframework.web.multipart.MultipartFile;



public interface ProductService {
    ProdDTO getProductById(Integer prodId);
    void createProductWithCategories(ProdDTO product, List<Long> catIds, Long mainCatId, MultipartFile file);
    void updateProductWithCategories(ProdDTO form, List<Long> catIds, Long mainCatId, MultipartFile file);
    List<ProdDTO> selectProductsByCategory(int catId);
    List<ProdDTO> getAllProdsByCatId(int catId);
}