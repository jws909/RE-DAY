package com.app.controller.member;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.app.common.ResponseResult;
import com.app.dto.member.MemberDTO;
import com.app.dto.member.MyProfileStatsDTO;
import com.app.service.member.StatService;


@RestController
@RequestMapping("/RE:DAY/member/my")
public class StatController {

	@Autowired
	StatService statService;
		
	@GetMapping
	public ResponseResult<?> stats(HttpSession session){
		
		MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
		
		if (loginUser == null) {
			
			return ResponseResult.fail("로그인이 필요합니다");
		}else {
			String userId = loginUser.getUserId();
			MyProfileStatsDTO myProfileStatsDTO = statService.getProfileStats(userId);
			
			return ResponseResult.success(myProfileStatsDTO);
		}
	}
}
