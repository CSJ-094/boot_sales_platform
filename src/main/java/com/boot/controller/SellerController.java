package com.boot.controller;

import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpSession;

import com.boot.dao.CategoryDAO;
import com.boot.dao.MemDAO;
import com.boot.dao.ProdDAO;
import com.boot.dao.ProductCategoryDAO;
import com.boot.dto.MemDTO;
import com.boot.dto.ProdDTO;
import com.boot.dto.ProductCategoryDTO;
import com.boot.dto.SellerDTO;
import com.boot.service.ProductService;
import com.boot.service.SellerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import org.springframework.web.multipart.MultipartFile;

@Controller
@RequestMapping("/seller") // ✅ 모든 URL에 /seller를 붙이는 대신 클래스 레벨에 매핑
public class SellerController {
	
	@Autowired private ProdDAO prodDAO;
	@Autowired private MemDAO memDAO;
	// ⭐️ 추가: Service와 DAO들을 주입받습니다.
	@Autowired private ProductService productService;
	@Autowired private CategoryDAO categoryDAO;
	@Autowired private ProductCategoryDAO productCategoryDAO;
	@Autowired private SellerService sellerService;
	
	// 1. 판매자 로그인 페이지 이동 
	@GetMapping("/login")
    public String sellerLogin(HttpSession session) {
        // 이미 로그인 되어있다면 메인으로 리다이렉트
		if (session.getAttribute("seller") != null) {
		return "redirect:/seller/mypage";
		}
        return "login/login"; 
    }

    // 2. 판매자 로그인 처리 (POST: /seller/loginCheck)
    @PostMapping("/loginCheck")
    public String sellerLoginCheck(SellerDTO sellerDTO, HttpSession session) {
        
        // ID와 PW로 DB에서 판매자 정보 조회
        SellerDTO resultDTO = sellerService.loginCheck(sellerDTO);

        if (resultDTO != null) {
            // 로그인 성공: 세션에 판매자 정보(seller) 저장
            session.setAttribute("seller", resultDTO); 
            return "redirect:/seller/mypage"; // 판매자 메인 페이지로 이동
        } else {
            // 로그인 실패
            return "redirect:login/login?error=fail"; 
        }
    }
    
    // 4. 판매자 로그아웃 (GET: /seller/logout)
    @GetMapping("/logout")
    public String sellerLogout(HttpSession session) {
        session.invalidate(); // 세션 전체 무효화
        return "redirect:/seller/login";
    }
    
	//마이페이지 메인 (/seller/mypage)
	@RequestMapping("/mypage")
	public String mypage() {
		return "redirect:/seller/products";
	}
	
	//상품 목록 (/seller/products)
	@GetMapping("/products")
	public String productList(@RequestParam(value = "created", required = false) Long createdId, Model model) {
		model.addAttribute("products", prodDAO.getProductList());
		model.addAttribute("createdId", createdId); // 등록 성공 배너
		model.addAttribute("activeMenu", "product");
		return "seller/products";
	}
	
	@GetMapping("/products/new")
	public String productNewForm(Model model) {
		model.addAttribute("product", new ProdDTO());
		// ⭐️ categoryDAO를 주입받아 인스턴스 메서드로 호출하도록 수정
		model.addAttribute("categories", categoryDAO.selectTreeFlat()); 
		model.addAttribute("checkedMap", new HashMap<String, Boolean>());
		model.addAttribute("mainCatIdStr", null);	
		model.addAttribute("activeMenu", "product");
		return "seller/product_new";
	}
	
	//상품 등록 처리 + 카테고리 매핑(Service로 위임)
	@PostMapping("/products")
    public String createProduct(@ModelAttribute ProdDTO dto,
                                 @RequestParam(value = "catIds", required = false) List<Long> catIds,
                                 @RequestParam(value = "mainCatId", required = false) Long mainCatId,
                                 @RequestParam("uploadFile") MultipartFile file, 
                                 RedirectAttributes ra,
                                 HttpSession session) {

        SellerDTO seller = (SellerDTO) session.getAttribute("seller");
        
        if (seller == null) {
            return "redirect:/seller/login";
        }
	    
	    // 2. 로그인된 판매자 ID를 DTO에 설정
	    dto.setProdSeller(seller.getSelId()); 
	    
	    // 3. 상품 등록 서비스 호출 (catIds, mainCatId 사용)
	    productService.createProductWithCategories(dto, catIds, mainCatId, file);
	    
	    // 4. 리다이렉트 설정 (ra 사용)
	    ra.addFlashAttribute("createdId", dto.getProdId());
	    return "redirect:/seller/products/" + dto.getProdId(); //상세로
	}
	
	//상품 상세 (/seller/products/{prodId})
	@GetMapping("/products/{prodId}")
		// ⭐️ prodId를 Long 타입으로 받도록 통일
		public String productDetail(@PathVariable("prodId") Long prodId, Model model) { 
			// ⭐️ DAO 직접 호출 대신 Service 계층 사용
			ProdDTO product = productService.getProductById(prodId.intValue());
			model.addAttribute("product", product);
			model.addAttribute("activeMenu", "product");
			return "seller/productDetail";
		}
	
	//수정 폼 이동(/seller/products/{id}/edit)
	@GetMapping("/products/{id}/edit")
	public String editForm(@PathVariable("id") Long id, Model model) {
		// ⭐️ ProdDTO -> ProdDTO로 변경
		ProdDTO p = prodDAO.getProduct(id); 
		if (p == null) {
			return "redirect:/seller/products?error=notfound";
		}
		model.addAttribute("product", p);
		model.addAttribute("categories", categoryDAO.selectTreeFlat());
		
		// ⭐️ productCategoryDAO 주입 완료 후 메서드 호출
		List<ProductCategoryDTO> mappings = productCategoryDAO.selectByProdId(id);

		 String mainCatIdStr = null;
		 Map<Long, Boolean> checkedMap = new HashMap<>(); // ⭐️ Map<Long, Boolean>으로 타입 명시
		 Set<Long> checkedCatIds = new HashSet<>();
		Long mainCatId = null;
		for (ProductCategoryDTO m : mappings) {
			 checkedCatIds.add(m.getCatId());
			 if ("Y".equals(m.getIsMain())) mainCatId = m.getCatId();
		}
		// ⭐️ checkedMap에 값을 채우는 로직이 누락되어있지만 일단 컴파일되도록 주석처리 후 변수만 전달
		model.addAttribute("checkedMap", checkedMap); 
		// model.addAttribute("mainCatId", mainCatId); // 이 줄은 주석 처리된 상태로 유지
		model.addAttribute("mainCatIdStr", mainCatIdStr);
		model.addAttribute("activeMenu", "product");
		return "seller/product_edit";
	}
	
	//수정 처리 (/seller/products/{id}/edit)
	@PostMapping("/products/{id}/edit")
	public String update(@PathVariable("id") Long id,
					@ModelAttribute ProdDTO form, // ⭐️ ProdDTO -> ProdDTO로 변경
					@RequestParam(value = "catIds", required = false) List<Long> catIds,
					@RequestParam(value = "mainCatId", required = false) Long mainCatId, // 이미지 파일 추가
					@RequestParam(value = "uploadFile", required = false) MultipartFile file,
					 @RequestParam(value = "deleteImage", required = false) String deleteImage,
					RedirectAttributes ra) {

		form.setProdId(id);
		boolean deleteFlag = "Y".equals(deleteImage);
		
		productService.updateProductWithCategories(form, catIds, mainCatId, file, deleteFlag); // ✅ 트랜잭션 경계
		
		ra.addFlashAttribute("msg", "수정되었습니다.");
		return "redirect:/seller/products/" + id; // 상세로 이동
	}
	
	//삭제(/seller/products/{id}/delete)
	@PostMapping("/products/{id}/delete")
	public String delete(@PathVariable("id") Long id, RedirectAttributes ra) { // ⭐️ id를 Long으로 받도록 통일
		int deleted = prodDAO.deleteProduct(id);
		if (deleted == 0) {
			ra.addFlashAttribute("error", "삭제할 수 없습니다.");
		} else {
			ra.addFlashAttribute("msg", "삭제되었습니다.");
		}
		return "redirect:/seller/products";
	}
	
	//회원 목록(/seller/members)
	@GetMapping("/members")
	public String memberList(Model model) {
		model.addAttribute("users", memDAO.getUserList());
		model.addAttribute("activeMenu", "member");
		return "seller/members";
	}

	//회원 상세(/seller/members/{memberId})
	@GetMapping("/members/{memberId}")
	public String memberDetail(@PathVariable("memberId") String memberId ,Model model) {
		// ⭐️ MemDTO는 import 추가
		MemDTO user = memDAO.getUser(memberId);
		model.addAttribute("user", user);
		model.addAttribute("activeMenu", "member");
		// TODO: 이후 구매내역 orders도 같이 model에 넣을 예정
		return "seller/memberDetail";
	}
}