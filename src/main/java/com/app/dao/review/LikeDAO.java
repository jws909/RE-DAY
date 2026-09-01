package com.app.dao.review;

import com.app.dto.review.LikeRequestDTO;
import java.util.List;
import com.app.dto.review.DailyReviewFormDTO;

public interface LikeDAO {

    public int insert(LikeRequestDTO likeRequestDTO);

    public int delete(LikeRequestDTO likeRequestDTO);

    public int checkExists(LikeRequestDTO likeRequestDTO);

    // MY 페이지 - 내가 좋아요한 리뷰 개수
    public int countLikesByUserId(String userId);

 // MY 페이지 - 내가 좋아요한 리뷰 목록
    public List<DailyReviewFormDTO> findLikedReviewsByUserId(String userId);
}