package com.boot.service;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

import com.boot.dao.ImageDAO;
import com.boot.dao.ProdDAO;
import com.boot.dao.ProductCategoryDAO;
import com.boot.dto.ImageDTO;
import com.boot.dto.ProdDTO;
import com.boot.dto.ProductCategoryDTO;
import com.boot.dto.ProductSearchCondition;
import com.boot.dao.CategoryDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;


import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class ProductServiceImpl implements ProductService {

    private static final String UPLOAD_DIR = "C:/temp/product_upload/images"; 
    @Autowired
    private final ProdDAO prodDAO;
    private final ProductCategoryDAO productCategoryDAO;
    private final ImageDAO imageDAO;
    private final CategoryDAO categoryDAO;

    @Override
    public List<ProdDTO> selectProductsByCategory(int catId) {
        log.info("@# selectProdsByCategory(catId: {}) - 메인 상품 조회", catId);
        
        return prodDAO.selectProductsByCategory(catId); 
    }
    
    @Override
    public List<ProdDTO> getAllProdsByCatId(int catId) {
        log.info("@# getAllProdsByCatId(catId: {}) - 카테고리 전체 상품 조회", catId);
        return prodDAO.getAllProdsByCatId(catId); 
    }
    
    // 1. [Read 기능] 상품 상세 조회
    @Override
    public ProdDTO getProductById(Long prodId) { // Integer -> Long 변경
        log.info("Fetching product detail for prodId: {}", prodId);
        return prodDAO.getProduct(prodId);
    }

    // 2. [Admin 기능] 상품 등록
    @Override
    @Transactional
    public void createProductWithCategories(ProdDTO product, List<Long> catIds, Long mainCatId, MultipartFile file) {
        
        prodDAO.insertProduct(product);
        Long prodId = product.getProdId();

        if (file != null && !file.isEmpty()) {
            try {
                String originalFileName = file.getOriginalFilename();
                String fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
                String savedFileName = UUID.randomUUID().toString() + fileExtension; 
                String savedFilePath = "/upload/images/" + savedFileName; 
                
                File uploadDirectory = new File(UPLOAD_DIR);
                if (!uploadDirectory.exists()) {
                    uploadDirectory.mkdirs();
                }
                
                File targetFile = new File(UPLOAD_DIR, savedFileName);
                file.transferTo(targetFile); 
                
                ImageDTO imageDTO = new ImageDTO();
                imageDTO.setImgProdId(prodId);
                imageDTO.setImgPath(savedFilePath);
                imageDTO.setIsMain("Y");
                imageDTO.setImgOrder(0); 

                imageDAO.insertImage(imageDTO);
                
            } catch (IOException e) {
                log.error("파일 저장 중 오류 발생: {}", e.getMessage());
                throw new RuntimeException("파일 업로드 중 오류가 발생했습니다.", e);
            }
        } else {
            log.warn("상품 등록 시 이미지 파일이 누락되었습니다. 상품 ID: {}", prodId);
        }
        
        if (catIds == null || catIds.isEmpty()) {
            throw new IllegalArgumentException("카테고리를 최소 1개 선택해 주세요.");
        }
        if (mainCatId == null || !catIds.contains(mainCatId)) {
            mainCatId = catIds.get(0);
        }
        
        HashSet<Long> fullCatIds = new HashSet<>(catIds);
        if (!catIds.isEmpty()) {
            fullCatIds.addAll(categoryDAO.selectAllParentIds(catIds));
        }
        
        List<ProductCategoryDTO> list = new ArrayList<ProductCategoryDTO>();
        for (Long cid : fullCatIds) {
            ProductCategoryDTO m = new ProductCategoryDTO();
            m.setProdId(prodId);
            m.setCatId(cid);
            m.setIsMain(cid.equals(mainCatId) ? "Y" : "N");
            list.add(m);
        }
        productCategoryDAO.bulkInsert(list);
    }

    @Override
    @Transactional
    public void updateProductWithCategories(ProdDTO form, List<Long> catIds, Long mainCatId, MultipartFile file, boolean deleteImage) {
        prodDAO.updateProduct(form);
        Long prodId = form.getProdId();
        
        boolean hasNewFile = (file != null && !file.isEmpty());

        if (deleteImage || hasNewFile) {
            imageDAO.deleteByProdId(prodId);
        }

        if (hasNewFile) {
            try {
                String originalFileName = file.getOriginalFilename();
                String fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
                String savedFileName = UUID.randomUUID().toString() + fileExtension;
                String savedFilePath = "/upload/images/" + savedFileName;

                File uploadDirectory = new File(UPLOAD_DIR);
                if (!uploadDirectory.exists()) {
                    uploadDirectory.mkdirs();
                }

                File targetFile = new File(UPLOAD_DIR, savedFileName);
                file.transferTo(targetFile);

                ImageDTO imageDTO = new ImageDTO();
                imageDTO.setImgProdId(prodId);
                imageDTO.setImgPath(savedFilePath);
                imageDTO.setIsMain("Y");
                imageDTO.setImgOrder(0);

                imageDAO.insertImage(imageDTO);

            } catch (IOException e) {
                log.error("파일 업데이트 중 오류 발생: {}", e.getMessage());
                throw new RuntimeException("파일 업로드 중 오류가 발생했습니다.", e);
            }
        }

        productCategoryDAO.deleteAllByProdId(prodId);

        if (catIds == null || catIds.isEmpty()) {
            throw new IllegalArgumentException("카테고리를 최소 1개 선택해 주세요.");
        }
        if (mainCatId == null || !catIds.contains(mainCatId)) {
            mainCatId = catIds.get(0);
        }

        HashSet<Long> fullCatIds = new HashSet<>(catIds);
        if (!catIds.isEmpty()) {
            fullCatIds.addAll(categoryDAO.selectAllParentIds(catIds));
        }

        List<ProductCategoryDTO> list = new ArrayList<>();
        for (Long cid : fullCatIds) {
            ProductCategoryDTO m = new ProductCategoryDTO();
            m.setProdId(prodId);
            m.setCatId(cid);
            m.setIsMain(cid.equals(mainCatId) ? "Y" : "N");
            list.add(m);
        }
        productCategoryDAO.bulkInsert(list);
    }

    @Override
    public List<ProdDTO> searchProducts(ProductSearchCondition condition) {
        log.info("Searching products with condition: {}", condition);
        return prodDAO.searchProducts(condition);
    }
}
