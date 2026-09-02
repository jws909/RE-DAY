package com.app.dao.member.impl;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.app.dao.member.StatDAO;

@Repository
public class StatDAOImpl implements StatDAO{

	@Autowired
	SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public long dailyCount(String userId) {
		
		long result = sqlSessionTemplate.selectOne("stat_mapper.dailyCount", userId);
		
		return result;
	}

	@Override
	public Double avgTotalRating(String userId) {
		Double result = sqlSessionTemplate.selectOne("stat_mapper.avgTotalRating", userId);
		
		return result;
	}

	@Override
	public long subCount(String userId) {
		long result = sqlSessionTemplate.selectOne("stat_mapper.subCount", userId);
		
		return result;
	}

	@Override
	public Double certifiedRate(String userId) {
		Double result = sqlSessionTemplate.selectOne("stat_mapper.certifiedRate", userId);
		
		return result;
	}

}
