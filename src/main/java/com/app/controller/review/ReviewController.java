package com.app.controller.review;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class ReviewController {

	@GetMapping("/RE:DAY/review/write")
	public String write() {
		
		return "write/writeReview";
	}
	
//	@PostMapping("/review/write")
	
}
