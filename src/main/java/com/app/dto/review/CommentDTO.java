package com.app.dto.review;

import lombok.Data;

@Data
public class CommentDTO {
	
	private long commentId;
	private long reviewId;
	private String userId;
	private String content;
	private String createdAt;
	private String updatedAt;

	// 작성자 회원 정보 (LEFT JOIN 조회용 평탄화 필드)
	private String nickname;
	private String profileImg;
	private String userLevel;
	private Integer streakCount;
}
