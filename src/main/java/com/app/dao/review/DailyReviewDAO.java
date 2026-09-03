package com.app.dao.review;

import java.util.List;
import java.util.Map;

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

    // 데일리 리뷰 수정
    public int updateDailyReview(
            DailyReviewFormDTO formDTO
    );

    // 메인 피드 - 공개 데일리 리뷰 목록 페이징 조회
    public List<DailyReviewFormDTO> findPublicReviewFeed(
            Map<String, Object> params
    );

    // 메인 피드 - 공개 데일리 리뷰 전체 개수 조회
    public int countPublicReviewFeed();

    public int countPublicReviewFeed(Map<String, Object> params);

    // 특정 데일리 리뷰 1건 공개/비공개 수정
    public int updateDailyReviewPublic(
            long reviewId,
            String userId,
            String isPublic
    );

    // 선택된 특정 데일리 리뷰들 일괄 공개/비공개 수정
    public int updateSelectedDailyReviewsPublic(
            List<Long> reviewIds,
            String userId,
            String isPublic
    );

    // 사용자의 전체 데일리 리뷰 일괄 공개/비공개 수정
    public int updateAllDailyReviewsPublic(
            String userId,
            String isPublic
    );

    // 작성자 및 일자 기준 데일리 리뷰 중복/단건 조회
    public DailyReviewFormDTO findReviewByUserIdAndDate(
            Map<String, Object> params
    );
}