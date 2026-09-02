package com.app.controller.review;

import javax.servlet.http.HttpSession;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.app.common.ResponseResult;
import com.app.dto.member.MemberDTO;
import com.app.dto.review.LikeRequestDTO;
import com.app.service.review.LikeService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/RE:DAY/like")
public class LikeController {
	
	private final LikeService likeService;
	
	// 게시글 좋아요 활성화
	@PostMapping(consumes = "application/json")
	public ResponseResult<?> insert(@RequestBody LikeRequestDTO likeRequestDTO, HttpSession session) throws Exception {
		MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");
		likeRequestDTO.setUserId(loginUser.getUserId());
		likeService.insert(likeRequestDTO);
		return ResponseResult.success(null);
	}
	
	// 게시글 좋아요 비활성화
	@DeleteMapping(consumes = "application/json")
	public ResponseResult<?> delete(@RequestBody LikeRequestDTO likeRequestDTO, HttpSession session) throws Exception {
		MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");
		likeRequestDTO.setUserId(loginUser.getUserId());
		likeService.delete(likeRequestDTO);
		return ResponseResult.success(null);
	}
}