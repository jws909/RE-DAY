package com.app.controller;

import java.time.LocalDate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import javax.servlet.http.HttpSession;
import org.springframework.ui.Model;
import com.app.dto.member.MemberDTO;
import org.springframework.beans.factory.annotation.Autowired;

import com.app.dto.member.MyPageStatsDTO;
import com.app.service.member.MemberService;

import java.util.List;

import com.app.dto.review.DailyReviewFormDTO;
import com.app.service.review.ReviewService;
import com.app.dto.review.SubReviewDTO;

@Controller
@RequestMapping("/RE:DAY")
public class MainPageController {
	@Autowired
	MemberService memberService;
	@Autowired
	ReviewService reviewService;
	
	@GetMapping("/mainpage")
	public String mainpage() {
		return "mainpage/main";
	}
	
	@GetMapping("/explore")
	public String explore() {
		return "mainpage/explore";
	}
	
	@GetMapping("/my")
	public String my(
	        HttpSession session,
	        Model model) {

	    MemberDTO loginUser =
	            (MemberDTO)
	            session.getAttribute("loginUser");

	    // 로그인 안 되어 있으면 로그인 페이지로 이동
	    if (loginUser == null) {

	        return "redirect:/member/signin";

	    }

	    // MY 페이지 통계
	    MyPageStatsDTO myStats =
	            memberService.getMyPageStats(
	                    loginUser.getUserId()
	            );

	    // 내가 작성한 데일리 리뷰 목록
	    List<DailyReviewFormDTO> myReviews =
	            reviewService.findDailyReviewsByUserId(
	                    loginUser.getUserId()
	            );

	    // 각 데일리 리뷰의 서브 리뷰 목록
	    for (DailyReviewFormDTO review : myReviews) {

	        review.setSubReviews(
	                reviewService.findSubReviewsByReviewId(
	                        review.getReviewId()
	                )
	        );

	    }
	    
	 // MY 페이지 - 내가 작성한 전체 서브 리뷰 목록
	    List<SubReviewDTO> mySubReviews =
	            reviewService.findSubReviewsByUserId(
	                    loginUser.getUserId()
	            );

	    // 내가 좋아요한 리뷰 개수
	    int likeCount =
	            reviewService.countLikesByUserId(
	                    loginUser.getUserId()
	            );
	 // 내가 좋아요한 리뷰 목록
	    List<DailyReviewFormDTO> likedReviews =
	            reviewService.findLikedReviewsByUserId(
	                    loginUser.getUserId()
	            );
	 // MY 페이지 - 좋아요한 리뷰의 서브 리뷰 목록 연결
	    for (DailyReviewFormDTO review : likedReviews) {

	        // 현재 좋아요 리뷰의 reviewId 확인
	        System.out.println(
	                "[좋아요 리뷰] reviewId = "
	                + review.getReviewId()
	        );

	        List<com.app.dto.review.SubReviewDTO> subReviews =
	                reviewService.findSubReviewsByReviewId(
	                        review.getReviewId()
	                );

	        // 해당 리뷰에서 조회된 서브 리뷰 개수 확인
	        System.out.println(
	                "[좋아요 리뷰] subReviews size = "
	                + subReviews.size()
	        );

	        review.setSubReviews(subReviews);

	    }

	 // JSP로 데이터 전달
	    model.addAttribute("loginUser", loginUser);
	    model.addAttribute("myStats", myStats);
	    model.addAttribute("myReviews", myReviews);
	    model.addAttribute("mySubReviews", mySubReviews);
	    model.addAttribute("likeCount", likeCount);
	    model.addAttribute("likedReviews", likedReviews);
	    
	 //  MY 페이지 - TODAY 배지용 오늘 날짜
	    model.addAttribute("today", LocalDate.now().toString());

	    return "mainpage/my";

	}
}