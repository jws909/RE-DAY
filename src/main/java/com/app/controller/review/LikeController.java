package com.app.controller.review;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
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
	
	// 게시글 좋아요 활성화 및 토글
	@PostMapping(consumes = "application/json")
	public ResponseResult<?> insert(@RequestBody LikeRequestDTO likeRequestDTO, HttpSession session) throws Exception {
		MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");
		if (loginUser == null) {
			return ResponseResult.fail("로그인이 필요한 서비스입니다.");
		}
		likeRequestDTO.setUserId(loginUser.getUserId());
		int status = likeService.insert(likeRequestDTO);
		boolean isLiked = (status == 1);
		int likeCount = likeService.countLikesByReviewId(likeRequestDTO.getReviewId());

		Map<String, Object> data = new HashMap<>();
		data.put("liked", isLiked);
		data.put("likeCount", likeCount);
		return ResponseResult.success(data);
	}
	
	// 게시글 좋아요 비활성화
	@DeleteMapping(consumes = "application/json")
	public ResponseResult<?> delete(@RequestBody LikeRequestDTO likeRequestDTO, HttpSession session) throws Exception {
		MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");
		if (loginUser == null) {
			return ResponseResult.fail("로그인이 필요한 서비스입니다.");
		}
		likeRequestDTO.setUserId(loginUser.getUserId());
		likeService.delete(likeRequestDTO);
		int likeCount = likeService.countLikesByReviewId(likeRequestDTO.getReviewId());

		Map<String, Object> data = new HashMap<>();
		data.put("liked", false);
		data.put("likeCount", likeCount);
		return ResponseResult.success(data);
	}

	// 게시글 좋아요 상태 및 개수 조회
	@GetMapping("/status")
	public ResponseResult<?> getStatus(@RequestParam("reviewId") Long reviewId, HttpSession session) {
		MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");
		boolean isLiked = false;
		if (loginUser != null) {
			LikeRequestDTO likeRequestDTO = new LikeRequestDTO();
			likeRequestDTO.setUserId(loginUser.getUserId());
			likeRequestDTO.setReviewId(reviewId);
			isLiked = likeService.checkExists(likeRequestDTO);
		}
		int likeCount = likeService.countLikesByReviewId(reviewId);

		Map<String, Object> data = new HashMap<>();
		data.put("liked", isLiked);
		data.put("likeCount", likeCount);
		return ResponseResult.success(data);
	}
}