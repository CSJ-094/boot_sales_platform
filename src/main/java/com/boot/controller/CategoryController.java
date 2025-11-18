package com.boot.controller;

import java.util.List;

import com.boot.dto.ProdDTO;
import com.boot.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;


import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/category") // /category로 시작하는 요청 처리
@Slf4j
public class CategoryController {

    @Autowired
    private ProductService productService;
    
 // ================= 상위 카테고리 =================
    private static final int WOMEN_CAT_ID  = 100;
    private static final int MEN_CAT_ID    = 200;
    private static final int UNISEX_CAT_ID = 300;
    private static final int SPORTS_CAT_ID = 400;

    // ================= WOMEN =================
    private static final int WOMEN_TOP    = 101;
    private static final int WOMEN_BOTTOM = 102;
    private static final int WOMEN_OUTER  = 103;
    private static final int WOMEN_SHOES  = 104;
    private static final int WOMEN_ACC    = 105;

    // ================= MEN =================
    private static final int MEN_TOP    = 201;
    private static final int MEN_BOTTOM = 202;
    private static final int MEN_OUTER  = 203;
    private static final int MEN_SHOES  = 204;
    private static final int MEN_ACC    = 205;

    // ================= UNISEX =================
    private static final int UNISEX_TOP    = 301;
    private static final int UNISEX_BOTTOM = 302;
    private static final int UNISEX_OUTER  = 303;
    private static final int UNISEX_SHOES  = 304;

    // ================= SPORTS =================
    private static final int SPORTS_TOP    = 401;
    private static final int SPORTS_BOTTOM = 402;
    private static final int SPORTS_OUTER  = 403;
    
    // 상위 카테고리 전체
    @GetMapping("/{group}")
    public String listByGroup(@PathVariable("group") String group, Model model) {
		
    	Integer catId = resolveGroupCatId(group);
    	
    	if (catId == null) {
            log.warn("잘못된 상위 카테고리 요청: {}", group);
            model.addAttribute("productList", List.of());
            model.addAttribute("group", group);
            model.addAttribute("sub", "all");
            return "category/mans";
        }

        List<ProdDTO> products = productService.getAllProdsByCatId(catId);

        model.addAttribute("group", group);
        model.addAttribute("sub", "all");
        model.addAttribute("productList", products);
        model.addAttribute("totalCount", products.size());

        return "category/category";
    }
    
    private Integer resolveGroupCatId(String group) {
        switch (group.toLowerCase()) {
            case "women":  return WOMEN_CAT_ID;
            case "mans":   return MEN_CAT_ID;
            case "unisex": return UNISEX_CAT_ID;
            case "sports": return SPORTS_CAT_ID;
            default: return null;
        }
    }

    //상위+하위 카테고리
    @GetMapping("/{group}/{sub}")
    public String listByGroupAndSub(@PathVariable("group") String group,
                                    @PathVariable("sub") String sub,
                                    Model model) {

        Integer catId = resolveSubCatId(group, sub);

        if (catId == null) {
            log.warn("잘못된 하위 카테고리 요청: {}/{}", group, sub);
            model.addAttribute("productList", List.of());
            model.addAttribute("group", group);
            model.addAttribute("sub", sub);
            return "category/category";
        }

        List<ProdDTO> products = productService.getAllProdsByCatId(catId);

        model.addAttribute("group", group);
        model.addAttribute("sub", sub);
        model.addAttribute("productList", products);

        return "category/category";
    }

    private Integer resolveSubCatId(String group, String sub) {
        group = group.toLowerCase();
        sub   = sub.toLowerCase();

        switch (group) {

            case "women":
                switch (sub) {
                    case "top":    return WOMEN_TOP;
                    case "bottom": return WOMEN_BOTTOM;
                    case "outer":  return WOMEN_OUTER;
                    case "shoes":  return WOMEN_SHOES;
                    case "acc":    return WOMEN_ACC;
                    default:       return null;
                }

            case "mans":
                switch (sub) {
                    case "top":    return MEN_TOP;
                    case "bottom": return MEN_BOTTOM;
                    case "outer":  return MEN_OUTER;
                    case "shoes":  return MEN_SHOES;
                    case "acc":    return MEN_ACC;
                    default:       return null;
                }

            case "unisex":
                switch (sub) {
                    case "top":    return UNISEX_TOP;
                    case "bottom": return UNISEX_BOTTOM;
                    case "outer":  return UNISEX_OUTER;
                    case "shoes":  return UNISEX_SHOES;
                    default:       return null;
                }

            case "sports":
                switch (sub) {
                    case "top":    return SPORTS_TOP;
                    case "bottom": return SPORTS_BOTTOM;
                    case "outer":  return SPORTS_OUTER;
                    default:       return null;
                }

            default:
                return null;
        }
    }

//    // MANS 카테고리 페이지 처리
//    @GetMapping("/mans")
//    public String mansCategoryPage(Model model) {
//        
//        final int MANS_CAT_ID = 200; // DB에 맞게 수정
//        
//        try {
//            // ⭐️ 전체 상품을 가져오는 메서드 호출
//            List<ProdDTO> mansList = productService.getAllProdsByCatId(MANS_CAT_ID);
//            
//            // JSP가 요구하는 변수명 mansList에 담아서 전달
//            model.addAttribute("mansList", mansList); 
//            log.info("@# MANS 카테고리 전체 상품 {}개 조회 완료.", mansList.size());
//            
//        } catch (Exception e) {
//            log.error("MANS 카테고리 상품 조회 중 오류 발생: {}", e.getMessage());
//            model.addAttribute("mansList", List.of());
//        }
//        
//        // 뷰 이름을 "category/mans"로 가정합니다. (-> /WEB-INF/views/category/mans.jsp)
//        return "category/mans"; 
//    }
}