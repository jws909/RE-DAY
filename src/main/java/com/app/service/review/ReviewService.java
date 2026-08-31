package com.app.service.review;

import com.app.dto.review.DailyReviewFormDTO;
import com.app.dto.review.DailyReviewImage;

public interface ReviewService {
	public long createDailyReviewWithSubReviews(DailyReviewFormDTO formDTO);
	
	public int saveDailyReviewImage(DailyReviewImage dailyReviewImage);
	public DailyReviewImage findDailyReviewImageByReviewId(String reviewId);
	
}
