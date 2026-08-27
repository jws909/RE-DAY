package com.app.controller.review;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/RE:DAY/review")
public class ReviewController {

	@GetMapping("/write")
	public String write() {
		
		return "write/writeReview";
	}
}
