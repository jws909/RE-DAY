package com.app.dao.review.impl;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.app.dao.review.DailyReviewDAO;
import com.app.dto.review.DailyReviewFormDTO;
import com.app.dto.review.DailyReviewImage;

@Repository
public class DailyReviewDAOImpl implements DailyReviewDAO {

    @Autowired
    SqlSessionTemplate sqlSessionTemplate;


    /* =========================================
       데일리 리뷰 저장
    ========================================= */
    @Override
    public long saveDailyReview(
            DailyReviewFormDTO formDTO) {

        int result =
                sqlSessionTemplate.insert(
                        "review_mapper.saveDailyReview",
                        formDTO
                );

        long generatedReviewId =
                formDTO.getReviewId();

        if (result > 0) {
            return generatedReviewId;
        }

        return 0;
    }


    /* =========================================
       데일리 리뷰 이미지 저장
    ========================================= */
    @Override
    public int saveDailyReviewImage(
            DailyReviewImage dailyReviewImage) {

        int result =
                sqlSessionTemplate.insert(
                        "review_mapper.saveDailyReviewImage",
                        dailyReviewImage
                );

        return result;
    }


    /* =========================================
       데일리 리뷰 이미지 조회
    ========================================= */
    @Override
    public DailyReviewImage findDailyReviewImageByReviewId(
            long reviewId) {

        DailyReviewImage dailyReviewImage =
                sqlSessionTemplate.selectOne(
                        "review_mapper.findDailyReviewImageByReviewId",
                        reviewId
                );

        return dailyReviewImage;
    }


    /* =========================================
       데일리 리뷰 상세 조회
    ========================================= */
    @Override
    public DailyReviewFormDTO findReviewDetailByReviewId(
            long reviewId) {

        DailyReviewFormDTO formDTO =
                sqlSessionTemplate.selectOne(
                        "review_mapper.findReviewDetailByReviewId",
                        reviewId
                );

        return formDTO;
    }


    /* =========================================
       MY 페이지 - 내가 작성한 데일리 기록 조회
    ========================================= */
    @Override
    public List<DailyReviewFormDTO> findDailyReviewsByUserId(
            String userId) {

        return sqlSessionTemplate.selectList(
                "review_mapper.findDailyReviewsByUserId",
                userId
        );
    }


    /* =========================================
       MY 페이지 - 데일리 리뷰 삭제
    ========================================= */
    @Override
    public int deleteDailyReviewByReviewId(
            long reviewId) {

        return sqlSessionTemplate.delete(
                "review_mapper.deleteDailyReviewByReviewId",
                reviewId
        );
    }

    /* =========================================
    MY 페이지 - 데일리 리뷰 삭제용
    해당 리뷰의 이미지 정보 삭제
 ========================================= */
 @Override
 public int deleteDailyReviewImageByReviewId(
         long reviewId) {

     return sqlSessionTemplate.delete(
             "review_mapper.deleteDailyReviewImageByReviewId",
             reviewId
     );
 }
}