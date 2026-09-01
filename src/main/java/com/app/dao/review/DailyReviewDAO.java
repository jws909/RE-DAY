package com.app.dao.review;

import com.app.dto.review.DailyReviewFormDTO;
import com.app.dto.review.DailyReviewImage;

public interface DailyReviewDAO {
	public long saveDailyReview(DailyReviewFormDTO formDTO);
	
	public int saveDailyReviewImage(DailyReviewImage dailyReviewImage);
	public DailyReviewImage findDailyReviewImageByReviewId(long reviewId);
	
	public DailyReviewFormDTO findReviewDetailByReviewId(long reviewId);
}
