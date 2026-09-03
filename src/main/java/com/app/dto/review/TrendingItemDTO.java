package com.app.dto.review;

import lombok.Data;

/**
 * 탐색(Explore) 페이지 - 이번 주 최다 언급 아이템 & 장소 트렌드 DTO
 */
@Data
public class TrendingItemDTO {

    private String category;       // 카테고리 식별값 ('item', 'place', 'transport', 'content')
    private String categoryLabel;  // 카테고리 표시 라벨 (예: '💻 전자기기/아이템', '☕ 핫플 장소/카페')
    private String itemName;       // 아이템/장소 이름
    private int mentionCount;      // 언급(기록) 횟수
    private Double avgRating;      // 서브리뷰 평균 평점
    private String latestComment;  // 대표/최근 한줄평
}
