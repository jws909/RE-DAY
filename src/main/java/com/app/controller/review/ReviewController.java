package com.app.controller.review;

import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.multipart.MultipartFile;

import com.app.dto.review.DailyReviewFormDTO;
import com.app.service.member.MemberService;
import com.app.service.review.CommentService;
import com.app.service.review.ReviewService;
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
	public String writeReview(HttpSession session) {

	    MemberDTO loginUser =
	            (MemberDTO) session.getAttribute("loginUser");

	    if (loginUser == null) {
	        return "redirect:/member/signin";
	    }

	    return "write/writeReview";
	}
	
	@PostMapping("/review/write")
	public String writeReviewAction(@ModelAttribute DailyReviewFormDTO formDTO, HttpSession session) {
		
		// 세션에서 로그인 ID 획득
		MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");
		formDTO.setUserId(loginUser.getUserId());
		
		long generatedReviewId = reviewService.createDailyReviewWithSubReviews(formDTO);
		
		if(generatedReviewId > 0) {
			return "redirect:/RE:DAY/mainpage";
		} else {
			return "redirect:/RE:DAY/review/write";
		}
		
	}
	
	@GetMapping("/RE:DAY/review/detail/{reviewId}")
	public String reviewDetail(@PathVariable long reviewId, Model model) {
		
		DailyReviewFormDTO review = reviewService.findReviewDetailByReviewId(reviewId);
		
		if(review != null) {
			model.addAttribute("comments", commentService.findCommentListForDetail(reviewId));
			model.addAttribute("dayOfWeek", DateUtil.DateToDayOfWeek(review.getReviewDate()));
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
}
