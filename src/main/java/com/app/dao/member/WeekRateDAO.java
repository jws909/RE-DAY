package com.app.dao.member;

import java.util.List;

import com.app.dto.member.WeekRateDTO;

public interface WeekRateDAO {
	
	public List<WeekRateDTO> WeekRate(String userId);
	
}
