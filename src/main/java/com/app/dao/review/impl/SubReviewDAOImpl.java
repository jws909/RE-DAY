package com.app.dao.review.impl;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.app.dao.review.SubReviewDAO;
import com.app.dto.review.SubReviewDTO;

@Repository
public class SubReviewDAOImpl implements SubReviewDAO {
	
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;

	@Override
	public int saveSubReview(SubReviewDTO saveDTO) {

		int result = sqlSessionTemplate.insert("review_mapper.saveSubReview", saveDTO);
		
		return result;
	}

}
