package com.app.dao.review;

import java.util.List;

import com.app.dto.review.DailyReviewFormDTO;
import com.app.dto.review.LikeRequestDTO;

public interface LikeDAO {

    public int insert(
            LikeRequestDTO likeRequestDTO
    );

    public int delete(
            LikeRequestDTO likeRequestDTO
    );

    public int checkExists(
            LikeRequestDTO likeRequestDTO
    );

    // MY 페이지 - 내가 좋아요한 리뷰 개수
    public int countLikesByUserId(
            String userId
    );

    // MY 페이지 - 내가 좋아요한 리뷰 목록
    public List<DailyReviewFormDTO> findLikedReviewsByUserId(
            String userId
    );

    /* =========================================
       MY 페이지 - 데일리 리뷰 삭제용
       해당 데일리 리뷰의 좋아요 전체 삭제
    ========================================= */
    public int deleteLikesByReviewId(
            long reviewId
    );
}