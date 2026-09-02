package com.app.service.member.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.app.dao.member.StatDAO;
import com.app.dto.member.MyProfileStatsDTO;
import com.app.service.member.StatService;

@Service
public class StatServiceImpl implements StatService {

	@Autowired
	StatDAO statDAO;
	
	@Override
	public MyProfileStatsDTO getProfileStats(String userId) {
		
		long dailyCount = statDAO.dailyCount(userId);
		Double avgRating = statDAO.avgTotalRating(userId);
		long subCount =statDAO.subCount(userId);
		Double certifiedRate = statDAO.certifiedRate(userId);
		
		MyProfileStatsDTO stat = new MyProfileStatsDTO();
		
		stat.setDailyCount(dailyCount);
		stat.setAvgTotalRating(avgRating);
		stat.setSubCount(subCount);
		stat.setCertifiedRate(certifiedRate);
		
		return stat;
	}
	
	
}
