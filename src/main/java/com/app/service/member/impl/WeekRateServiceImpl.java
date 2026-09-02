package com.app.service.member.impl;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.app.dao.member.WeekRateDAO;
import com.app.dto.member.WeekRateDTO;
import com.app.service.member.WeekRateService;

@Service
public class WeekRateServiceImpl implements WeekRateService {
	
	@Autowired
	WeekRateDAO weekRateDAO;

	@Override
	public List<WeekRateDTO> WeekRate(String userId) {
		List<WeekRateDTO> dbRateList = weekRateDAO.WeekRate(userId);
		List<WeekRateDTO> resultList = new ArrayList<>();
		
		for(int i = 6; i >= 0; i--) {
			LocalDate targetDate = LocalDate.now().minusDays(i);
			
			WeekRateDTO matchedDTO = null;
			for(WeekRateDTO dto : dbRateList) {
				if(dto.getReviewDate() != null && dto.getReviewDate().equals(targetDate.toString())) {
				    matchedDTO = dto;
				    break;
				}
			}
			
			if(matchedDTO != null) {
				resultList.add(matchedDTO);
			} else {
				WeekRateDTO emptyDTO = new WeekRateDTO();
				emptyDTO.setReviewDate(targetDate.toString());
				emptyDTO.setTotalRating(0.0);
				resultList.add(emptyDTO);
			}
		}
		
		return resultList;
	}
}