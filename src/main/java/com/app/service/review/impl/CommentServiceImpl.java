package com.app.service.review.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.app.dao.review.CommentDAO;
import com.app.dto.review.CommentDTO;
import com.app.service.review.CommentService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class CommentServiceImpl implements CommentService {

	@Autowired
	CommentDAO commentDAO;
	
	@Override
	public List<CommentDTO> findCommentList(long reviewId) {
		
		List<CommentDTO> commentList = commentDAO.findCommentList(reviewId);
		
		return commentList;
	}

	@Override
	public int saveComment(CommentDTO comment) {
		
		int result = commentDAO.saveComment(comment);
		
		return result;
	}

	@Override
	public CommentDTO findCommentByCommentId(long commentId) {

		CommentDTO comment = commentDAO.findCommentByCommentId(commentId);
		
		return comment;
	}

	@Override
	public int removeComment(long commentId) {
		
		int result = commentDAO.removeComment(commentId);
		
		return result;
	}

	@Override
	public int modifyComment(CommentDTO comment) {
		
		int result = commentDAO.modifyComment(comment);
		
		return result;
	}

	@Override
	public List<CommentDTO> findCommentListForDetail(long reviewId) {
		List<CommentDTO> commentList = commentDAO.findCommentListForDetail(reviewId);
		return commentList;
	}
	
}
