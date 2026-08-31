package com.app.dao.review;

import com.app.dto.review.LikeRequestDTO;

public interface LikeDAO {
	
	public int insert(LikeRequestDTO likeRequestDTO);
	
	public int delete	(LikeRequestDTO likeRequestDTO);

	public int checkExists(LikeRequestDTO likeRequestDTO);
}
