package com.app.dto.review;

import lombok.Data;

@Data
public class CommentDTO {
	
	long commentId;
	long reviewId;
	String userId;
	String content;
	String createdAt;
	String updatedAt;
}
