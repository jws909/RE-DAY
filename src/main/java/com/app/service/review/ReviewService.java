package com.app.service.review;

import java.util.List;
import java.util.Map;

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

    // 데일리 리뷰 수정 (메인 리뷰 및 서브 리뷰 동기화, 이미지 처리)
    public int updateDailyReviewWithSubReviews(
            DailyReviewFormDTO formDTO,
            String deleteMainImage
    );

    // 메인 피드 - 공개 데일리 리뷰 목록 페이징 및 정렬 조회
    public Map<String, Object> getPublicReviewFeedPaging(
            int page,
            int size,
            String sort,
            String loginUserId
    );

    // 메인 피드 - 공개 데일리 리뷰 목록 페이징 및 정렬 조회 (카테고리 필터 포함)
    public Map<String, Object> getPublicReviewFeedPaging(
            int page,
            int size,
            String sort,
            String loginUserId,
            String category
    );
    
    // 메인 페이지 - 서브 리뷰 카테고리별 등록 건수 집계
    public CategoryCountDTO findCategoryCounts();

    // 특정 데일리 리뷰 1건 공개/비공개 토글
    public boolean updateDailyReviewPublic(long reviewId, String userId, String isPublic);

    // 선택된 특정 데일리 리뷰들 일괄 공개/비공개 변경
    public boolean updateSelectedReviewsPublic(List<Long> reviewIds, String userId, String isPublic);

    // 사용자의 전체 데일리 리뷰 일괄 공개/비공개 변경
    public boolean updateAllDailyReviewsPublic(String userId, String isPublic);
}