package com.app.dto.review;

import lombok.Data;

@Data
public class SubReviewDTO {

    private Long subReviewId;
    private Long reviewId;

    /* MY 페이지 - 부모 데일리 리뷰 작성 날짜 */
    private String reviewDate;

    private String category;
    private String itemName;
    private Double subRating;
    private String subComment;
    private String locationBrand;
    private String isCertified;
    private String tags;
}