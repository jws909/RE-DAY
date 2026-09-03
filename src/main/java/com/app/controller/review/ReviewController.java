package com.app.controller.review;

import javax.servlet.http.HttpSession;

import java.util.List;
import java.time.LocalDate;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.app.dto.review.DailyReviewFormDTO;
import com.app.dto.review.SubReviewDTO;
import com.app.service.member.MemberService;
import com.app.service.review.CommentService;
import com.app.service.review.ReviewService;
import com.app.common.ResponseResult;
import org.springframework.web.bind.annotation.ResponseBody;
import com.app.util.DateUtil;
import com.app.dto.member.MemberDTO;
@Controller
public class ReviewController {
	
	@Autowired
	ReviewService reviewService;
	
	@Autowired
	CommentService commentService;
	
	@Autowired
	MemberService memberService;

	@GetMapping("/RE:DAY/review/write")
	public String writeReview(HttpSession session, RedirectAttributes rttr) {

	    MemberDTO loginUser =
	            (MemberDTO) session.getAttribute("loginUser");

	    if (loginUser == null) {
	        return "redirect:/member/signin";
	    }

	    // 당일 이미 작성된 리뷰가 있는지 확인하여 중복 진입 방지
	    DailyReviewFormDTO todayReview = reviewService.findReviewByUserIdAndDate(loginUser.getUserId(), LocalDate.now().toString());
	    if (todayReview != null) {
	        rttr.addFlashAttribute("errorMessage", "오늘의 데일리 리뷰는 이미 작성하셨습니다.");
	        return "redirect:/RE:DAY/review/detail/" + todayReview.getReviewId();
	    }

	    return "write/writeReview";
	}
	
	@PostMapping("/review/write")
	public String writeReviewAction(@ModelAttribute DailyReviewFormDTO formDTO, HttpSession session, RedirectAttributes rttr) {
		
		// 세션에서 로그인 ID 획득
		MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/member/signin";
		}
		formDTO.setUserId(loginUser.getUserId());
		
		// 당일 중복 등록 방지 2차 검증
		DailyReviewFormDTO todayReview = reviewService.findReviewByUserIdAndDate(loginUser.getUserId(), LocalDate.now().toString());
		if (todayReview != null) {
			rttr.addFlashAttribute("errorMessage", "오늘의 데일리 리뷰가 이미 등록되어 있어 중복 등록할 수 없습니다.");
			return "redirect:/RE:DAY/review/detail/" + todayReview.getReviewId();
		}

		try {
			long generatedReviewId = reviewService.createDailyReviewWithSubReviews(formDTO);
			
			if(generatedReviewId > 0) {
				// 리뷰 등록 성공 후 세션의 loginUser(MemberDTO) 정보 갱신 (증가된 STREAK_COUNT 반영)
				MemberDTO updatedUser = memberService.findUserInfoByUserId(loginUser.getUserId());
				if (updatedUser != null) {
					session.setAttribute("loginUser", updatedUser);
				}
				return "redirect:/RE:DAY/mainpage";
			} else {
				return "redirect:/RE:DAY/review/write";
			}
		} catch (IllegalStateException e) {
			rttr.addFlashAttribute("errorMessage", e.getMessage());
			return "redirect:/RE:DAY/mainpage";
		}
	}
	
	@GetMapping("/RE:DAY/review/detail/{reviewId}")
	public String reviewDetail(@PathVariable long reviewId, Model model) {
		
		DailyReviewFormDTO review = reviewService.findReviewDetailByReviewId(reviewId);
		
		if(review != null) {
			MemberDTO user = memberService.findUserInfoByUserId(review.getUserId());
			
			model.addAttribute("user", user);
			model.addAttribute("comments", commentService.findCommentListForDetail(reviewId));
			model.addAttribute("dayOfWeek", DateUtil.DateToDayOfWeek(review.getReviewDate()));
			model.addAttribute("todayDate", LocalDate.now().toString());
			model.addAttribute("review", review);
			model.addAttribute("subReviews", review.getSubReviews());
		}
		
		return "detail/reviewDetail";
	}
	
	// ========================================
    // MY 페이지 - 데일리 리뷰 삭제
    // ========================================
    @PostMapping("/RE:DAY/review/delete/{reviewId}")
    public String deleteReview(
            @PathVariable long reviewId,
            HttpSession session) {


        // ========================================
        // 로그인 사용자 확인
        // ========================================
        MemberDTO loginUser =
                (MemberDTO)
                session.getAttribute(
                        "loginUser"
                );


        // ========================================
        // 로그인하지 않은 경우
        // ========================================
        if (loginUser == null) {

            return "redirect:/member/signin";
        }


        /*
         * 해당 리뷰 정보 조회
         *
         * 로그인한 사용자가 작성한 리뷰인지
         * 확인하기 위해 사용한다.
         */
        DailyReviewFormDTO review =
                reviewService
                        .findReviewDetailByReviewId(
                                reviewId
                        );


        // ========================================
        // 리뷰가 존재하지 않는 경우
        // ========================================
        if (review == null) {

            return "redirect:/RE:DAY/my";
        }


        /*
         * 로그인한 사용자와
         * 리뷰 작성자가 다른 경우
         * 삭제하지 않는다.
         */
        if (!loginUser
                .getUserId()
                .equals(
                        review.getUserId()
                )) {

            return "redirect:/RE:DAY/my";
        }


        // ========================================
        // 본인이 작성한 데일리 리뷰 삭제
        // ========================================
        reviewService
                .deleteDailyReviewByReviewId(
                        reviewId
                );


        // ========================================
        // 삭제 완료 후 MY 페이지 이동
        // ========================================
        return "redirect:/RE:DAY/my";
    }
    
    @GetMapping("/RE:DAY/review/edit/{reviewId}")                                                                            
    public String viewEditReview(@PathVariable Long reviewId, Model model, HttpSession session) {                         
    	MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");                           
        if (loginUser == null) {                                                                       
            return "redirect:/member/signin"; // 비로그인 시 로그인 화면으로 이동                      
        }                                                                                              
                                                                                                       
         //Service에서 기존 리뷰 정보 조회 후 작성자 본인 확인                                         
        DailyReviewFormDTO existingReview = reviewService.findReviewDetailByReviewId(reviewId);               
         if (!existingReview.getUserId().equals(loginUser.getUserId())) {                            
             return "redirect:/review/detail/" + reviewId; // 타인 글 수정 시도시 차단            
         }          
    	
    	// DB에서 리뷰 상세 정보 및 서브 리뷰 목록 조회                                                    
        DailyReviewFormDTO review = reviewService.findReviewDetailByReviewId(reviewId);                             
        List<SubReviewDTO> subReviews = review.getSubReviews();
                                                                                                           
        model.addAttribute("review", review);                                                              
        model.addAttribute("subReviews", subReviews);                                               
                                                                                                           
        return "edit/editReview"; // editReview.jsp 로 이동                                                     
    }

    @PostMapping({"/review/edit", "/RE:DAY/review/edit"})                                                                           
    public String updateReview(@ModelAttribute DailyReviewFormDTO formDto,                                 
                               @RequestParam(value = "deleteMainImage", defaultValue = "N") String deleteMainImage, 
                               HttpSession session) {
        // 1) 로그인 확인
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/member/signin";
        }

        // 2) 기존 리뷰 확인 및 작성자 본인 검증
        DailyReviewFormDTO existingReview = reviewService.findReviewDetailByReviewId(formDto.getReviewId());
        if (existingReview == null) {
            return "redirect:/RE:DAY/mainpage";
        }

        if (!loginUser.getUserId().equals(existingReview.getUserId())) {
            return "redirect:/RE:DAY/review/detail/" + formDto.getReviewId();
        }

        formDto.setUserId(loginUser.getUserId());

        // 3) 리뷰 수정 서비스 호출 (메인 리뷰 UPDATE, 서브리뷰 delete & re-insert, 대표 이미지 처리)
        reviewService.updateDailyReviewWithSubReviews(formDto, deleteMainImage);
  
        return "redirect:/RE:DAY/review/detail/" + formDto.getReviewId();
    }

    // ========================================
    // MY 페이지 - 특정 데일리 리뷰 1건 공개/비공개 토글 (AJAX)
    // ========================================
    @PostMapping({"/review/public/daily", "/RE:DAY/review/public/daily"})
    @ResponseBody
    public ResponseResult<?> toggleDailyReviewPublic(
            @RequestParam("reviewId") long reviewId,
            @RequestParam("isPublic") String isPublic,
            HttpSession session) {

        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
        if (loginUser == null) {
            return ResponseResult.fail("로그인이 필요한 서비스입니다.");
        }

        boolean success = reviewService.updateDailyReviewPublic(reviewId, loginUser.getUserId(), isPublic);
        if (success) {
            return ResponseResult.success(isPublic);
        } else {
            return ResponseResult.fail("데일리 리뷰 공개 설정 변경에 실패했습니다.");
        }
    }

    // ========================================
    // MY 페이지 - 선택된 특정 데일리 리뷰들 일괄 공개/비공개 변경 (AJAX)
    // ========================================
    @PostMapping({"/review/public/selected", "/RE:DAY/review/public/selected"})
    @ResponseBody
    public ResponseResult<?> toggleSelectedReviewsPublic(
            @RequestParam("reviewIds") List<Long> reviewIds,
            @RequestParam("isPublic") String isPublic,
            HttpSession session) {

        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
        if (loginUser == null) {
            return ResponseResult.fail("로그인이 필요한 서비스입니다.");
        }

        if (reviewIds == null || reviewIds.isEmpty()) {
            return ResponseResult.fail("선택된 데일리 리뷰가 없습니다.");
        }

        boolean success = reviewService.updateSelectedReviewsPublic(reviewIds, loginUser.getUserId(), isPublic);
        if (success) {
            return ResponseResult.success(isPublic);
        } else {
            return ResponseResult.fail("선택한 데일리 리뷰 공개 설정 변경에 실패했습니다.");
        }
    }

    // ========================================
    // MY 페이지 - 전체 데일리 리뷰 일괄 공개/비공개 변경 (AJAX)
    // ========================================
    @PostMapping({"/review/public/all", "/RE:DAY/review/public/all"})
    @ResponseBody
    public ResponseResult<?> toggleAllReviewsPublic(
            @RequestParam("isPublic") String isPublic,
            HttpSession session) {

        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
        if (loginUser == null) {
            return ResponseResult.fail("로그인이 필요한 서비스입니다.");
        }

        boolean success = reviewService.updateAllDailyReviewsPublic(loginUser.getUserId(), isPublic);
        if (success) {
            return ResponseResult.success(isPublic);
        } else {
            return ResponseResult.fail("전체 데일리 리뷰 공개 설정 변경에 실패했습니다.");
        }
    }
}
