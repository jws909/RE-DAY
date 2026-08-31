package com.app.dao.review.impl;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.app.dao.review.DailyReviewDAO;
import com.app.dto.review.DailyReviewFormDTO;
import com.app.dto.review.DailyReviewImage;

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

	@Override
	public int saveDailyReviewImage(DailyReviewImage dailyReviewImage) {

		int result = sqlSessionTemplate.insert("review_mapper.saveDailyReviewImage", dailyReviewImage);
		
		return result;
	}

	@Override
	public DailyReviewImage findDailyReviewImageByReviewId(String reviewId) {

		DailyReviewImage dailyReviewImage = sqlSessionTemplate.selectOne("review_mapper.findDailyReviewImageByReviewId", reviewId);
		
		return dailyReviewImage;
	}
	
}
