package com.app.dto.member;

import lombok.Data;

@Data
public class MyPageStatsDTO {

    // 총 데일리 기록
    private Integer dailyReviewCount;

    // 내 평균 하루 평점
    private Double averageRating;

    // 총 서브 리뷰
    private Integer subReviewCount;

    // 내돈내산 인증률
    private Double certificationRate;


    // =========================
    // 카테고리별 기록 분포
    // =========================

    // 장소
    private Integer placeCount;

    // 아이템
    private Integer itemCount;

    // 이동수단
    private Integer transportCount;

    // 콘텐츠
    private Integer contentCount;

}