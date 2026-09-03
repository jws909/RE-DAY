package com.app.dao.review;

import java.util.List;
import java.util.Map;

import com.app.dto.review.CategoryCountDTO;
import com.app.dto.review.SubReviewDTO;
import com.app.dto.review.TrendingItemDTO;

public interface SubReviewDAO {

    // 서브 리뷰 저장
    public int saveSubReview(
            SubReviewDTO saveDTO
    );

    // MY 페이지 - 데일리 기록별 서브 리뷰 조회
    public List<SubReviewDTO> findSubReviewsByReviewId(
            Long reviewId
    );

    // MY 페이지 - 내가 작성한 전체 서브 리뷰 조회
    public List<SubReviewDTO> findSubReviewsByUserId(
            String userId
    );

    /* =========================================
       MY 페이지 - 데일리 리뷰 삭제용
       해당 데일리 리뷰의 서브 리뷰 전체 삭제
    ========================================= */
    public int deleteSubReviewsByReviewId(
            long reviewId
    );
    
    /*===========================================
     	메인 페이지 - 서브 리뷰 카테고리별 등록 건수 집계
   ============================================*/
    public CategoryCountDTO findCategoryCounts();

    /*===========================================
     	탐색 페이지 - 이번 주 최다 언급 아이템 & 장소 Top N 조회
    ============================================*/
    public List<TrendingItemDTO> findWeeklyTrendingItems(Map<String, Object> params);
    
}