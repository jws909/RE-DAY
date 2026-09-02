package com.app.dto.member;

import lombok.Data;

@Data
public class MyProfileStatsDTO {
	
	long dailyCount;
	double avgTotalRating;
	long subCount;
	double certifiedRate;
}
