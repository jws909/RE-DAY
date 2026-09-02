package com.app.dao.review.impl;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.app.dao.review.LikeDAO;
import com.app.dto.review.DailyReviewFormDTO;
import com.app.dto.review.LikeRequestDTO;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class LikeDAOImpl implements LikeDAO {

    private final SqlSessionTemplate sqlSessionTemplate;


    /* =========================================
       좋아요 등록
    ========================================= */
    @Override
    public int insert(
            LikeRequestDTO likeRequestDTO) {

        int result =
                sqlSessionTemplate.insert(
                        "like_mapper.insert",
                        likeRequestDTO
                );

        return result;
    }


    /* =========================================
       좋아요 취소
    ========================================= */
    @Override
    public int delete(
            LikeRequestDTO likeRequestDTO) {

        int result =
                sqlSessionTemplate.delete(
                        "like_mapper.delete",
                        likeRequestDTO
                );

        return result;
    }


    /* =========================================
       좋아요 존재 여부 확인
    ========================================= */
    @Override
    public int checkExists(
            LikeRequestDTO likeRequestDTO) {

        int result =
                sqlSessionTemplate.selectOne(
                        "like_mapper.checkExists",
                        likeRequestDTO
                );

        return result;
    }


    /* =========================================
       MY 페이지 - 내가 좋아요한 리뷰 개수
    ========================================= */
    @Override
    public int countLikesByUserId(
            String userId) {

        return sqlSessionTemplate.selectOne(
                "like_mapper.countLikesByUserId",
                userId
        );
    }


    /* =========================================
       MY 페이지 - 내가 좋아요한 리뷰 목록
    ========================================= */
    @Override
    public List<DailyReviewFormDTO> findLikedReviewsByUserId(
            String userId) {

        return sqlSessionTemplate.selectList(
                "like_mapper.findLikedReviewsByUserId",
                userId
        );
    }


    /* =========================================
       MY 페이지 - 데일리 리뷰 삭제용
       해당 리뷰의 좋아요 전체 삭제
    ========================================= */
    @Override
    public int deleteLikesByReviewId(
            long reviewId) {

        return sqlSessionTemplate.delete(
                "like_mapper.deleteLikesByReviewId",
                reviewId
        );
    }

}