package com.app.dao.review;

import java.util.List;

import com.app.dto.review.DailyReviewFormDTO;
import com.app.dto.review.DailyReviewImage;

public interface DailyReviewDAO {

    public long saveDailyReview(
            DailyReviewFormDTO formDTO
    );

    public int saveDailyReviewImage(
            DailyReviewImage dailyReviewImage
    );

    public DailyReviewImage findDailyReviewImageByReviewId(
            long reviewId
    );

    public DailyReviewFormDTO findReviewDetailByReviewId(
            long reviewId
    );

    // MY 페이지 - 내가 작성한 데일리 기록 조회
    public List<DailyReviewFormDTO> findDailyReviewsByUserId(
            String userId
    );

}