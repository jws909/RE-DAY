package com.app.dao.review.impl;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.app.dao.review.DailyReviewDAO;
import com.app.dto.review.DailyReviewFormDTO;
import com.app.dto.review.DailyReviewImage;

import java.util.List;

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
	public DailyReviewImage findDailyReviewImageByReviewId(long reviewId) {

		DailyReviewImage dailyReviewImage = sqlSessionTemplate.selectOne("review_mapper.findDailyReviewImageByReviewId", reviewId);
		
		return dailyReviewImage;
	}

	@Override
	public DailyReviewFormDTO findReviewDetailByReviewId(long reviewId) {

		DailyReviewFormDTO formDTO = sqlSessionTemplate.selectOne("review_mapper.findReviewDetailByReviewId", reviewId);
		
		return formDTO;
	}
	
	
	@Override
	public List<DailyReviewFormDTO> findDailyReviewsByUserId(
	        String userId) {

	    return sqlSessionTemplate.selectList(
	            "review_mapper.findDailyReviewsByUserId",
	            userId
	    );
	}
}
