package com.app.service.member;

import com.app.dto.member.MyProfileStatsDTO;

public interface StatService {

	public MyProfileStatsDTO getProfileStats(String userId);
	
}
