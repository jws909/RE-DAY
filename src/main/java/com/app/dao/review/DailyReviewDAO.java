package com.app.dao.review;

import com.app.dto.review.DailyReviewFormDTO;

public interface DailyReviewDAO {
	public long saveDailyReview(DailyReviewFormDTO formDTO);
}
