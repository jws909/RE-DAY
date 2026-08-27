package com.app.controller.test;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.app.dto.test.TestMember;
import com.app.service.test.TestService;

@Controller
public class TestController {
	
	@Autowired
	TestService testService;
	
	@RequestMapping("/test")
	public String test(Model model) {
		
		List<TestMember> testMemberList = testService.findTestMemberList();
		
		model.addAttribute(testMemberList);
		
		return "test/test";
	}
}
