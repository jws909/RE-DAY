package com.app.service.review;

import com.app.dto.review.DailyReviewFormDTO;

public interface ReviewService {
	public long createDailyReviewWithSubReviews(DailyReviewFormDTO formDTO);
}
