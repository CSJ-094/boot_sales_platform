package com.boot.controller;

import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpSession;

import com.boot.dao.CategoryDAO;
import com.boot.dao.QnaDAO;
import com.boot.dao.ProdDAO;
import com.boot.dao.ProductCategoryDAO;
import com.boot.dto.OrdDTO;
import com.boot.dto.MemDTO;
import com.boot.dto.ProdDTO;
import com.boot.dto.ProductCategoryDTO;
import com.boot.dto.ReviewDTO;
import com.boot.dto.SellerDTO;
import com.boot.dto.SellerOrderSummaryDTO;
import com.boot.dto.QnaDTO;
import com.boot.service.ProductService;
import com.boot.service.ReviewService;
import com.boot.service.OrderService;
import com.boot.service.SellerService;
import com.boot.service.UserService;
import com.boot.service.QnaService;

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

import lombok.extern.slf4j.Slf4j; // Slf4j import 주석 해제
// import org.slf4j.Logger; // Logger import 제거
// import org.slf4j.LoggerFactory; // LoggerFactory import 제거

@Slf4j
@Controller
@RequestMapping("/seller")
public class SellerController {

	// private static final Logger log = LoggerFactory.getLogger(SellerController.class); // log 변수 수동 선언 제거
	
	@Autowired private ProdDAO prodDAO;
	@Autowired private ProductService productService;
	@Autowired private CategoryDAO categoryDAO;
	@Autowired private ProductCategoryDAO productCategoryDAO;
	@Autowired private SellerService sellerService;
	@Autowired private QnaService qnaService;
	@Autowired private ReviewService reviewService;
	@Autowired private UserService userService;
	@Autowired private OrderService orderService;
	
	@GetMapping("/login")
    public String sellerLogin(HttpSession session) {
		if (session.getAttribute("seller") != null) {
		return "redirect:/seller/mypage";
		}
        return "login/login"; 
    }

    @PostMapping("/loginCheck")
    public String sellerLoginCheck(SellerDTO sellerDTO, HttpSession session) {
        
        SellerDTO resultDTO = sellerService.loginCheck(sellerDTO);

        if (resultDTO != null) {
			session.setAttribute("memberId", resultDTO.getSelId());
			session.setAttribute("userType", "seller");
			session.setAttribute("memberName", resultDTO.getSelName());
			session.setAttribute("seller", resultDTO);
            return "redirect:/seller/mypage";
        } else {
            return "redirect:login/login?error=fail"; 
        }
    }
    
    @GetMapping("/logout")
    public String sellerLogout(HttpSession session) {
        session.invalidate();
        return "redirect:/seller/login";
    }
    
	@RequestMapping("/mypage")
	public String mypage() {
		return "redirect:/seller/dashboard";
	}
	
	@GetMapping("/products")
	public String productList(@RequestParam(value = "created", required = false) Long createdId, Model model) {
		model.addAttribute("products", prodDAO.getProductList());
		model.addAttribute("createdId", createdId);
		model.addAttribute("activeMenu", "product");
		return "seller/products";
	}
	
	@GetMapping("/products/new")
	public String productNewForm(Model model) {
		model.addAttribute("product", new ProdDTO());
		model.addAttribute("categories", categoryDAO.selectTreeFlat()); 
		model.addAttribute("checkedMap", new HashMap<String, Boolean>());
		model.addAttribute("mainCatIdStr", null);	
		model.addAttribute("activeMenu", "product");
		return "seller/product_new";
	}
	
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
	    
	    dto.setProdSeller(seller.getSelId()); 
	    
	    productService.createProductWithCategories(dto, catIds, mainCatId, file);
	    
	    ra.addFlashAttribute("createdId", dto.getProdId());
	    return "redirect:/seller/products/" + dto.getProdId();
	}
	
	@GetMapping("/products/{prodId}")
		public String productDetail(@PathVariable("prodId") Long prodId, Model model) { // Integer -> Long 변경
			ProdDTO product = productService.getProductById(prodId);
			model.addAttribute("product", product);
			model.addAttribute("activeMenu", "product");
			return "seller/productDetail";
		}
	
	@GetMapping("/products/{id}/edit")
	public String editForm(@PathVariable("id") Long id, Model model) {
		ProdDTO p = prodDAO.getProduct(id); // .intValue() 제거
		if (p == null) {
			return "redirect:/seller/products?error=notfound";
		}
		model.addAttribute("product", p);
		model.addAttribute("categories", categoryDAO.selectTreeFlat());
		
		List<ProductCategoryDTO> mappings = productCategoryDAO.selectByProdId(id);

		 String mainCatIdStr = null;
		 Map<Long, Boolean> checkedMap = new HashMap<>();
		 Set<Long> checkedCatIds = new HashSet<>();
		Long mainCatId = null;
		for (ProductCategoryDTO m : mappings) {
			checkedCatIds.add(m.getCatId());
			if ("Y".equals(m.getIsMain())) mainCatId = m.getCatId();
		}
		model.addAttribute("checkedMap", checkedMap); 
		model.addAttribute("mainCatIdStr", mainCatIdStr);
		model.addAttribute("activeMenu", "product");
		return "seller/product_edit";
	}
	
	@PostMapping("/products/{id}/edit")
	public String update(@PathVariable("id") Long id,
					@ModelAttribute ProdDTO form,
					@RequestParam(value = "catIds", required = false) List<Long> catIds,
					@RequestParam(value = "mainCatId", required = false) Long mainCatId,
					@RequestParam(value = "uploadFile", required = false) MultipartFile file,
					@RequestParam(value = "deleteImage", defaultValue = "false") boolean deleteImage,
					RedirectAttributes ra) {

		form.setProdId(id);
		productService.updateProductWithCategories(form, catIds, mainCatId, file, deleteImage); 
		ra.addFlashAttribute("msg", "수정되었습니다.");
		return "redirect:/seller/products/" + id;
	}
	
	@PostMapping("/products/{id}/delete")
	public String delete(@PathVariable("id") Long id, RedirectAttributes ra) { // int -> Long 변경
		int deleted = prodDAO.deleteProduct(id);
		if (deleted == 0) {
			ra.addFlashAttribute("error", "삭제할 수 없습니다.");
		} else {
			ra.addFlashAttribute("msg", "삭제되었습니다.");
		}
		return "redirect:/seller/products";
	}
	
	@GetMapping("/members")
	public String memberList(Model model) {
		List<MemDTO> users = userService.getUserList();
		model.addAttribute("users", users);
		model.addAttribute("activeMenu", "member");
		return "seller/members";
	}
	//주문 내역(/seller/orders)
		@GetMapping("/orders")
		public String orderList(HttpSession session, Model model) {
			SellerDTO seller = (SellerDTO) session.getAttribute("seller");
			if (seller == null) {
				return "redirect:/seller/login";
			}
			List<SellerOrderSummaryDTO> orders = orderService.getSellerOrderSummaries(seller.getSelId());
			model.addAttribute("orders", orders);
			model.addAttribute("activeMenu", "orders");
			return "seller/orders";
		}

		//송장번호 입력 및 배송중 상태 변경(/seller/orders/{orderId}/tracking)
		@PostMapping("/orders/{orderId}/tracking")
		public String updateTrackingNumber(@PathVariable("orderId") String orderId,
		                                   @RequestParam("trackingNumber") String trackingNumber,
		                                   @RequestParam("deliveryCompany") String deliveryCompany,
		                                   RedirectAttributes redirectAttributes) {
			
			if (trackingNumber == null || trackingNumber.trim().isEmpty()) {
				redirectAttributes.addFlashAttribute("error", "송장번호를 입력해주세요.");
				return "redirect:/seller/orders";
			}

			if (deliveryCompany == null || deliveryCompany.trim().isEmpty()) {
				redirectAttributes.addFlashAttribute("error", "택배사를 선택해주세요.");
				return "redirect:/seller/orders";
			}

			try {
				String message = orderService.updateTrackingNumber(orderId, trackingNumber.trim(), deliveryCompany.trim());
				// message가 있으면 경고/오류, 없으면 성공
				redirectAttributes.addFlashAttribute(message != null ? "error" : "msg", 
				                                     message != null ? message : "송장번호가 성공적으로 등록되었습니다.");
			} catch (Exception e) {
				log.error("Error updating tracking number", e);
				redirectAttributes.addFlashAttribute("error", "송장번호 등록 중 오류가 발생했습니다: " + e.getMessage());
			}

			return "redirect:/seller/orders";
		}

		/**
		 * 주문 상태를 '배송완료'로 수동 변경합니다.
		 */
		@PostMapping("/orders/complete")
		public String completeOrder(@RequestParam("orderId") String orderId, RedirectAttributes redirectAttributes) {
			try {
				orderService.manuallyCompleteOrder(orderId);
				redirectAttributes.addFlashAttribute("msg", "주문 상태를 '배송완료'로 성공적으로 변경했습니다.");
			} catch (Exception e) {
				log.error("Error manually completing order: {}", orderId, e);
				redirectAttributes.addFlashAttribute("error", "상태 변경 중 오류가 발생했습니다.");
			}
			// 판매자 주문 목록 페이지로 리다이렉트
			return "redirect:/seller/orders";
		}

	@GetMapping("/members/{memberId}")
	public String memberDetail(@PathVariable("memberId") String memberId ,Model model) {
		MemDTO member = userService.getUserById(memberId);
		if (member == null) {
			return "redirect:/seller/members";
		}
		List<OrdDTO> orders = orderService.getOrdersWithDetailsByMemberId(memberId);

		model.addAttribute("member", member);
		model.addAttribute("orders", orders);
		model.addAttribute("activeMenu", "member");
		return "seller/memberDetail";
	}

	@GetMapping("/qna")
	public String qnaList(HttpSession session, Model model) {
		SellerDTO seller = (SellerDTO) session.getAttribute("seller");
		if (seller == null) {
			return "redirect:/seller/login";
		}

		List<QnaDTO> qnaList = qnaService.getQnaBySellerId(seller.getSelId());
		model.addAttribute("qnaList", qnaList);
		model.addAttribute("activeMenu", "qna");
		return "seller/qna_list";
	}

	@GetMapping("/qna/{qnaId}/reply")
	public String qnaReplyForm(@PathVariable("qnaId") Long qnaId, HttpSession session, Model model) {
		SellerDTO seller = (SellerDTO) session.getAttribute("seller");
		if (seller == null) {
			return "redirect:/seller/login";
		}

		QnaDTO question = qnaService.getQnaById(qnaId);
		model.addAttribute("question", question);

		List<QnaDTO> replies = qnaService.getRepliesByParentId(qnaId);
		model.addAttribute("replies", replies);

		model.addAttribute("activeMenu", "qna");
		return "seller/qna_reply";
	}

	@PostMapping("/qna/reply")
	public String addReply(QnaDTO reply, HttpSession session, RedirectAttributes ra) {
		SellerDTO seller = (SellerDTO) session.getAttribute("seller");
		if (seller == null) {
			return "redirect:/seller/login";
		}

		QnaDTO question = qnaService.getQnaById(reply.getQnaParentId());
		if (question == null) {
			ra.addFlashAttribute("error", "원본 문의글을 찾을 수 없습니다.");
			return "redirect:/seller/qna";
		}
		reply.setMemberId(question.getMemberId());
		reply.setQnaTitle("Re: " + reply.getQnaTitle());

		qnaService.addReply(reply);
		ra.addFlashAttribute("msg", "답변이 등록되었습니다.");
		return "redirect:/seller/qna";
	}

	@GetMapping("/reviews")
	public String reviewList(HttpSession session, Model model) {
		SellerDTO seller = (SellerDTO) session.getAttribute("seller");
		if (seller == null) {
			return "redirect:/seller/login";
		}

		List<ReviewDTO> reviewList = reviewService.getReviewsBySellerId(seller.getSelId());
		model.addAttribute("reviewList", reviewList);
		model.addAttribute("activeMenu", "review");
		return "seller/review_list";
	}

	@GetMapping("/reviews/{reviewId}/reply")
	public String reviewReplyForm(@PathVariable("reviewId") Long reviewId, HttpSession session, Model model) {
		SellerDTO seller = (SellerDTO) session.getAttribute("seller");
		if (seller == null) {
			return "redirect:/seller/login";
		}

		ReviewDTO review = reviewService.getReviewById(reviewId);
		model.addAttribute("review", review);
		model.addAttribute("activeMenu", "review");
		return "seller/review_reply";
	}

	@PostMapping("/reviews/reply")
	public String addReviewReply(ReviewDTO reply, HttpSession session, RedirectAttributes ra) {
		SellerDTO seller = (SellerDTO) session.getAttribute("seller");
		if (seller == null) {
			return "redirect:/seller/login";
		}

		ReviewDTO originalReview = reviewService.getReviewById(reply.getReviewParentId());
		if (originalReview == null) {
			ra.addFlashAttribute("error", "원본 리뷰를 찾을 수 없습니다.");
			return "redirect:/seller/reviews";
		}

		reply.setMemberId(originalReview.getMemberId());
		reply.setProdId(originalReview.getProdId());

		reviewService.addReply(reply);
		ra.addFlashAttribute("msg", "리뷰 답변이 등록되었습니다.");
		return "redirect:/seller/reviews";
	}
}
