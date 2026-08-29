package com.app.service.review.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.app.dao.review.DailyReviewDAO;
import com.app.dao.review.SubReviewDAO;
import com.app.dto.review.DailyReviewFormDTO;
import com.app.dto.review.SubReviewDTO;
import com.app.service.review.ReviewService;

@Service
public class ReviewServiceImpl implements ReviewService {

	@Autowired
	DailyReviewDAO dailyReviewDAO;
	
	@Autowired
	SubReviewDAO subReviewDAO;
	
	@Override
	@Transactional(rollbackFor = Exception.class)
	public long createDailyReviewWithSubReviews(DailyReviewFormDTO formDTO) {

		long generatedReviewId = dailyReviewDAO.saveDailyReview(formDTO);
		
	    if(generatedReviewId == 0) {
	        throw new RuntimeException("메인 데일리 리뷰 저장에 실패했습니다.");
	    }
	    
	    // 서브리뷰 목록이 비어있지 않은 경우에만 순회
	    if (formDTO.getSubReviews() != null && !formDTO.getSubReviews().isEmpty()) {
	        for(SubReviewDTO subreview : formDTO.getSubReviews()) {
	            subreview.setReviewId(generatedReviewId);
	            
	            int result = subReviewDAO.saveSubReview(subreview);
	            if(result == 0) {
	                // ❌ return 0; -> 트랜잭션이 커밋됨
	                // ⭕ RuntimeException을 던져야 전체 롤백 발생
	                throw new RuntimeException("서브 리뷰 저장 실패로 전체 롤백 처리합니다. 항목: " + subreview.getItemName());
	            }
	        }
	    }
	    
	    return generatedReviewId;
	}
	
}
