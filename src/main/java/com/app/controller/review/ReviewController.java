package com.app.controller.review;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.multipart.MultipartFile;

import com.app.dto.review.DailyReviewFormDTO;
import com.app.service.review.ReviewService;

@Controller
public class ReviewController {
	
	@Autowired
	ReviewService reviewService;

	@GetMapping("/RE:DAY/review/write")
	public String writeReview() {
		
		return "write/writeReview";
	}
	
	@PostMapping("/review/write")
	public String writeReviewAction(@ModelAttribute DailyReviewFormDTO formDTO) {
		
		// 세션에서 로그인 ID 획득
		//**현재는 로그인 기능이 구현 되어있지 않아 임의의 id인 user-01 저장**
		formDTO.setUserId("user-01");
		
		//대표 이미지 업로드 처리
		MultipartFile imageFile = formDTO.getMainImageFile();
		if(imageFile != null && !imageFile.isEmpty()) {
//			String savedPath = fileService.upload(imageFile);
//			formDTO.setMainImageUrl(savedPath);
			
			//**아직 fileService 구현 전이므로 임의의 링크 저장**
			formDTO.setMainImageUrl("temp_image_URL");
		}
		
		long generatedReviewId = reviewService.createDailyReviewWithSubReviews(formDTO);
		
		if(generatedReviewId > 0) {
			return "redirect:/RE:DAY/mainpage";
		} else {
			return "redirect:/RE:DAY/review/write";
		}
		
	}
	
	@GetMapping("/RE:DAY/review/detail")
	public String reviewDetail() {
		return "detail/reviewDetail";
	}
	
}
