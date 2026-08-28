package com.app.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/RE:DAY")
public class MainPageController {
	@GetMapping("/mainpage")
	public String mainpage() {
		return "mainpage/main";
	}
	
	@GetMapping("/explore")
	public String explore() {
		return "mainpage/explore";
	}
	
	@GetMapping("/my")
	public String my() {
		return "mainpage/my";
	}
	
	@GetMapping("/detailReview")
	public String detailReview() {
		return "mainpage/detailReview";
	}
}
