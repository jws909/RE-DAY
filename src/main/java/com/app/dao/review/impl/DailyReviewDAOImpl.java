package com.app.dao.review.impl;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.app.dao.review.DailyReviewDAO;
import com.app.dto.review.DailyReviewFormDTO;

@Repository
public class DailyReviewDAOImpl implements DailyReviewDAO {

	@Autowired
	SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public long saveDailyReview(DailyReviewFormDTO formDTO) {

		int result = sqlSessionTemplate.insert("review_mapper.saveDailyReview", formDTO);
		
		long generatedReviewId = formDTO.getReviewId();
		
		if(result > 0) {
			return generatedReviewId;
		}
		
		return 0;
	}
	
}
