package com.app.service.review;

import com.app.dto.review.LikeRequestDTO;

public interface LikeService {
	public int insert(LikeRequestDTO likeRequestDTO) throws Exception;
	
	public int delete(LikeRequestDTO likeRequestDTO) throws Exception;
	
}
