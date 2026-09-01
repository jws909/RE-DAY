package com.app.controller.review;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.app.common.ResponseResult;
import com.app.dto.review.CommentDTO;
import com.app.service.review.CommentService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/RE:DAY/reviews/{reviewId}/comments")
public class CommentController {
	
	@Autowired
	CommentService commentService;
	
	@GetMapping
	public ResponseResult<?> findCommentList(@PathVariable int reviewId, CommentDTO commentDTO) {
		List<CommentDTO> commentList = commentService.findCommentList(reviewId);
		return ResponseResult.success(commentList);
	}
	
	@GetMapping("/{commentId}")
	public ResponseResult<?> findCommentByCommentId(@PathVariable int reviewId,  @PathVariable long commentId) {
		CommentDTO comment = commentService.findCommentByCommentId(commentId);
		return ResponseResult.success(comment);
	}
	
	@PostMapping(consumes = "application/json") 
	public ResponseResult<?> saveComment(@PathVariable int reviewId, @RequestBody CommentDTO commentDTO) {
		commentDTO.setReviewId(reviewId);
		commentService.saveComment(commentDTO);
		CommentDTO savedComment = commentService.findCommentByCommentId(commentDTO.getCommentId());
		return ResponseResult.success(savedComment);
	}
	
	@PatchMapping("/{commentId}")
	public ResponseResult<?> modifyComment(@PathVariable int reviewId, @PathVariable long commentId, @RequestBody CommentDTO commentDTO) {
		commentDTO.setReviewId(reviewId);
		commentDTO.setCommentId(commentId);
		commentService.modifyComment(commentDTO);
		CommentDTO updatedComment = commentService.findCommentByCommentId(commentDTO.getCommentId());
		return ResponseResult.success(updatedComment);
	}
	
	@DeleteMapping("/{commentId}")
	public ResponseResult<?> removeComment(@PathVariable int reviewId,  @PathVariable long commentId) {
		commentService.removeComment(commentId);
		return ResponseResult.success(commentId);
	}
}
