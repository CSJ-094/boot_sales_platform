package com.boot.service;

import java.util.List;

import com.boot.dto.ProdDTO;
import com.boot.dto.ProductSearchCondition;
import org.springframework.web.multipart.MultipartFile;

public interface ProductService {
    ProdDTO getProductById(Long prodId); // Integer에서 Long으로 변경
    void createProductWithCategories(ProdDTO product, List<Long> catIds, Long mainCatId, MultipartFile file);
    void updateProductWithCategories(ProdDTO form, List<Long> catIds, Long mainCatId, MultipartFile file, boolean deleteImage);
    List<ProdDTO> selectProductsByCategory(int catId);
    List<ProdDTO> getAllProdsByCatId(int catId);
    List<ProdDTO> searchProducts(ProductSearchCondition condition);
}
