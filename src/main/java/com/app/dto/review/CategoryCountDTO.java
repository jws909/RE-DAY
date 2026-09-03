package com.app.dto.review;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CategoryCountDTO {
	
	//전체 서브 리뷰 수
	int totalCount;
	
	//장소·식당·카페
	int placeCount;
	
	// 아이템·기기
	int itemCount;
	
	// 이동수단·모빌리티
	int transportCount;
	
	 // 콘텐츠·미디어
	int contentCount;
}
