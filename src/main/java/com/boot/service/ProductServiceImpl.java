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
import com.boot.dao.CategoryDAO; // CategoryDAO import 추가
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

    // ⭐️ 파일 저장 경로: 실제 서버 경로로 변경해야 합니다.
    private static final String UPLOAD_DIR = "C:/temp/product_upload/images"; 
    @Autowired
    private final ProdDAO prodDAO;
    private final ProductCategoryDAO productCategoryDAO;
    private final ImageDAO imageDAO; // @RequiredArgsConstructor를 통해 주입됨
    private final CategoryDAO categoryDAO; // 상위 카테고리 조회를 위해 추가

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
    public ProdDTO getProductById(Integer prodId) {
        log.info("Fetching product detail for prodId: {}", prodId);
        // ⭐️ DAO 호출 메서드명을 getProduct으로 통일
        return prodDAO.getProduct(prodId.longValue());
    }

    // 2. [Admin 기능] 상품 등록
    @Override
    @Transactional
    // ⭐️ MultipartFile file 매개변수 추가
    public void createProductWithCategories(ProdDTO product, List<Long> catIds, Long mainCatId, MultipartFile file) {
        
        // 1. 상품 등록: MyBatis <selectKey>를 통해 product.getProdId()에 ID가 채워집니다.
        prodDAO.insertProduct(product);
        Long prodId = product.getProdId();

        // 2. 이미지 파일 처리 및 DB 삽입
        if (file != null && !file.isEmpty()) {
            try {
                // 2-1. 파일 정보 설정 및 저장
                String originalFileName = file.getOriginalFilename();
                String fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
                
                // 파일명 중복 방지 (UUID 사용)
                String savedFileName = UUID.randomUUID().toString() + fileExtension; 
                
                // DB에 저장할 웹 접근 경로 (Spring Resource Handler 설정과 일치해야 함)
                String savedFilePath = "/upload/images/" + savedFileName; 
                
                File uploadDirectory = new File(UPLOAD_DIR);
                if (!uploadDirectory.exists()) {
                    uploadDirectory.mkdirs(); // 저장 디렉터리가 없으면 생성
                }
                
                File targetFile = new File(UPLOAD_DIR, savedFileName);
                
                // 파일 저장 실행
                file.transferTo(targetFile); 
                
                // 2-2. 이미지 DTO 생성 및 IMAGE_DB에 삽입
                ImageDTO imageDTO = new ImageDTO();
                imageDTO.setImgProdId(prodId);
                imageDTO.setImgPath(savedFilePath);
                imageDTO.setIsMain("Y"); // 첫 번째 파일은 대표 이미지
                imageDTO.setImgOrder(0); 

                imageDAO.insertImage(imageDTO);
                
            } catch (IOException e) {
                log.error("파일 저장 중 오류 발생: {}", e.getMessage());
                // 파일 저장 오류 발생 시 트랜잭션 롤백 유도
                throw new RuntimeException("파일 업로드 중 오류가 발생했습니다.", e);
            }
        } else {
            log.warn("상품 등록 시 이미지 파일이 누락되었습니다. 상품 ID: {}", prodId);
        }
        
        // 3. 카테고리 매핑 로직
        if (catIds == null || catIds.isEmpty()) {
            throw new IllegalArgumentException("카테고리를 최소 1개 선택해 주세요.");
        }
        if (mainCatId == null || !catIds.contains(mainCatId)) {
            mainCatId = catIds.get(0);
        }
        
        // ⭐️ 상위 카테고리 ID를 포함한 전체 카테고리 ID 목록 생성
        // 1. Set을 사용해 중복을 방지하며 catIds를 추가
        HashSet<Long> fullCatIds = new HashSet<>(catIds);
        // 2. catIds에 해당하는 모든 상위 카테고리 ID를 조회하여 추가 (CategoryDAO에 구현 필요)
        if (!catIds.isEmpty()) {
            fullCatIds.addAll(categoryDAO.selectAllParentIds(catIds));
        }
        
        List<ProductCategoryDTO> list = new ArrayList<ProductCategoryDTO>();
        for (Long cid : fullCatIds) { // ⭐️ 수정: catIds 대신 fullCatIds 사용
            ProductCategoryDTO m = new ProductCategoryDTO();
            m.setProdId(prodId); // 새로 생성된 prodId 사용
            m.setCatId(cid);
            m.setIsMain(cid.equals(mainCatId) ? "Y" : "N"); // 대표 카테고리 설정은 유지
            list.add(m);
        }
        productCategoryDAO.bulkInsert(list);
    }

    @Override
    @Transactional
    public void updateProductWithCategories(ProdDTO form, List<Long> catIds, Long mainCatId, MultipartFile file, boolean deleteImage) {
        // 상품 정보 업데이트
        prodDAO.updateProduct(form);
        Long prodId = form.getProdId();
        
        // 2) 이미지 처리
        boolean hasNewFile = (file != null && !file.isEmpty());

        // 삭제 체크 되거나, 새 파일이 올라오면 기존 대표 이미지 삭제
        if (deleteImage || hasNewFile) {
            imageDAO.deleteByProdId(prodId);
        }

        
     // 새 파일 있으면 업로드 후 대표 이미지로 등록
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

        // 3) 카테고리 매핑 초기화 후 다시 삽입
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
}