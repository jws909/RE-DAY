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
	        likeDAO.delete(likeRequestDTO);
	        return 0; // 좋아요 취소됨
	    } else {
	        likeDAO.insert(likeRequestDTO);
	        return 1; // 좋아요 등록됨
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

	@Override
	public int countLikesByReviewId(long reviewId) {
		return likeDAO.countLikesByReviewId(reviewId);
	}

	@Override
	public boolean checkExists(LikeRequestDTO likeRequestDTO) {
		if (likeRequestDTO == null || likeRequestDTO.getUserId() == null || likeRequestDTO.getReviewId() == null) {
			return false;
		}
		return likeDAO.checkExists(likeRequestDTO) > 0;
	}

}
