package com.app.dao.member.impl;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.app.dao.member.WeekRateDAO;
import com.app.dto.member.WeekRateDTO;

@Repository	
public class WeekRateDAOImpl implements WeekRateDAO {
	
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;

	@Override
	public List<WeekRateDTO> WeekRate(String userId) {
		List<WeekRateDTO> rateList = sqlSessionTemplate.selectList("week_rate_mapper.weekRate", userId);
		return rateList;
	}
	
	
}
