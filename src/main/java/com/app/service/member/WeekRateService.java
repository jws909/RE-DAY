package com.app.service.member;

import java.util.List;

import com.app.dto.member.WeekRateDTO;

public interface WeekRateService {
	
	public List<WeekRateDTO> WeekRate(String userId);
}
