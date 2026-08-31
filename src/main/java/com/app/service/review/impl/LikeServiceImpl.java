package com.app.service.review.impl;

import org.springframework.stereotype.Service;

import com.app.dao.review.LikeDAO;
import com.app.dto.review.LikeRequestDTO;
import com.app.service.review.LikeService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class LikeServiceImpl implements LikeService {

	private final LikeDAO likeDAO;

	@Override
	public int insert(LikeRequestDTO likeRequestDTO) throws Exception {
		log.info("Received LikeRequestDTO - userId: {}, reviewId: {}", likeRequestDTO.getUserId(), likeRequestDTO.getReviewId());

		if (likeRequestDTO.getUserId() == null || likeRequestDTO.getReviewId() == null) {

			throw new Exception();
		}

		int count = likeDAO.checkExists(likeRequestDTO);
	    
	    if (count > 0) {
	        return likeDAO.delete(likeRequestDTO);
	    } else {
	        return likeDAO.insert(likeRequestDTO);
	    }
	}

	@Override
	public int delete(LikeRequestDTO likeRequestDTO) throws Exception {
		if (likeRequestDTO.getUserId() == null || likeRequestDTO.getReviewId() == null) {

			throw new Exception();
		}

		int result = likeDAO.delete(likeRequestDTO);

		return result;

	}


}
