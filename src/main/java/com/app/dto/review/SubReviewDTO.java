package com.app.dto.review;

import lombok.Data;

@Data
public class SubReviewDTO {
	private Long subReviewId;       // sub_review_id (PK)
    private Long reviewId;          // review_id (FK)
    private String category;        // category ("place", "item", "transport", "content")
    private String itemName;        // item_name (항목명/모델명)
    private Double subRating;       // sub_rating (0.5 ~ 5.0)
    private String subComment;      // sub_comment (세부 한줄평)
    private String locationBrand;   // location_brand (위치/브랜드)
    private String isCertified;     // is_certified ('Y' / 'N')
    private String tags;            // 세부 태그 ("#카페,#성수")
}
