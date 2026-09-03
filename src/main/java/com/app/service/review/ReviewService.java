package com.app.service.review;

import java.util.List;

import com.app.dto.review.CategoryCountDTO;
import com.app.dto.review.DailyReviewFormDTO;
import com.app.dto.review.DailyReviewImage;
import com.app.dto.review.SubReviewDTO;

public interface ReviewService {

    public long createDailyReviewWithSubReviews(
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

    // MY 페이지 - 내 데일리 기록 조회
    public List<DailyReviewFormDTO> findDailyReviewsByUserId(
            String userId
    );

    // MY 페이지 - 데일리 기록별 서브 리뷰 조회
    public List<SubReviewDTO> findSubReviewsByReviewId(
            Long reviewId
    );

    // MY 페이지 - 내가 작성한 전체 서브 리뷰 조회
    public List<SubReviewDTO> findSubReviewsByUserId(
            String userId
    );

    // MY 페이지 - 내가 좋아요한 리뷰 개수
    public int countLikesByUserId(
            String userId
    );

    // MY 페이지 - 내가 좋아요한 리뷰 목록
    public List<DailyReviewFormDTO> findLikedReviewsByUserId(
            String userId
    );

    // MY 페이지 - 데일리 리뷰 삭제
    public int deleteDailyReviewByReviewId(
            long reviewId
    );
    
    // 메인 페이지 - 서브 리뷰 카테고리별 등록 건수 집계
    public CategoryCountDTO findCategoryCounts();
}