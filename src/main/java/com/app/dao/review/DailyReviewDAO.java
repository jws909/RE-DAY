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

    // MY 페이지 - 데일리 리뷰 삭제
    public int deleteDailyReviewByReviewId(
            long reviewId
    );
    /* =========================================
    MY 페이지 - 데일리 리뷰 삭제용
    해당 리뷰의 이미지 정보 삭제
 ========================================= */
    public int deleteDailyReviewImageByReviewId(
         long reviewId
    );
}