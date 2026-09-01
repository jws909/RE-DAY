package com.app.dao.review;

import java.util.List;

import com.app.dto.review.SubReviewDTO;

public interface SubReviewDAO {

    // 서브 리뷰 저장
    public int saveSubReview(SubReviewDTO saveDTO);

    // MY 페이지 - 데일리 기록별 서브 리뷰 조회
    public List<SubReviewDTO> findSubReviewsByReviewId(
            Long reviewId
    );

    // MY 페이지 - 내가 작성한 전체 서브 리뷰 조회
    public List<SubReviewDTO> findSubReviewsByUserId(
            String userId
    );
}