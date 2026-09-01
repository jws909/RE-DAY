package com.app.service.review;

import com.app.dto.review.DailyReviewFormDTO;
import com.app.dto.review.DailyReviewImage;
import java.util.List;
import java.util.List;
import com.app.dto.review.SubReviewDTO;

public interface ReviewService {
	public long createDailyReviewWithSubReviews(DailyReviewFormDTO formDTO);
	
	public int saveDailyReviewImage(DailyReviewImage dailyReviewImage);
	public DailyReviewImage findDailyReviewImageByReviewId(long reviewId);
	
	public DailyReviewFormDTO findReviewDetailByReviewId(long reviewId); 
	
	// MY 페이지 - 내 데일리 기록 조회
    public List<DailyReviewFormDTO> findDailyReviewsByUserId(
            String userId
    );
    
    public List<SubReviewDTO> findSubReviewsByReviewId(
            Long reviewId
    );
	
 // MY 페이지 - 내가 좋아요한 리뷰 개수
    public int countLikesByUserId(String userId);
}
