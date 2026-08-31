package com.app.dto.review;

import lombok.Data;

@Data
public class DailyReviewImage {
	
	private Long reviewId; //데일리 리뷰 id
	String fileName;       //FILE_INFO 파일이름
	
}
