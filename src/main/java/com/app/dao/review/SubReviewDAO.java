package com.app.dao.review;

import com.app.dto.review.SubReviewDTO;
import java.util.List;

public interface SubReviewDAO {
	public int saveSubReview(SubReviewDTO saveDTO);
	
	// MY 페이지 - 데일리 기록별 서브 리뷰 조회
	public List<SubReviewDTO> findSubReviewsByReviewId(
	        Long reviewId
	);
}
