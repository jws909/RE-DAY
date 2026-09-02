package com.app.dao.member;

public interface StatDAO {
	
	public long dailyCount(String userId);
	
	public Double avgTotalRating(String userId);
	
	public long subCount(String userId);
	
	public Double certifiedRate(String userId);
}
