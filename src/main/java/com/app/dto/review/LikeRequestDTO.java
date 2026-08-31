package com.app.dto.review;

import lombok.Data;

@Data
public class LikeRequestDTO {
	
	private String userId;
	private Long reviewId;
	private Long likeId;
}
