package com.app.service.review;

import java.util.List;

import com.app.dto.review.CommentDTO;

public interface CommentService {

	List<CommentDTO> findCommentList(long reviewId);

	int saveComment(CommentDTO comment);

	CommentDTO findCommentByCommentId(long commentId);

	int removeComment(long commentId);

	int modifyComment(CommentDTO comment);
}
