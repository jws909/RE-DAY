package com.app.dao.review.impl;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.app.dao.review.SubReviewDAO;
import com.app.dto.review.CategoryCountDTO;
import com.app.dto.review.SubReviewDTO;
import com.app.dto.review.TrendingItemDTO;

@Repository
public class SubReviewDAOImpl implements SubReviewDAO {

    @Autowired
    SqlSessionTemplate sqlSessionTemplate;


    /* =========================================
       서브 리뷰 저장
    ========================================= */
    @Override
    public int saveSubReview(
            SubReviewDTO saveDTO) {

        int result =
                sqlSessionTemplate.insert(
                        "review_mapper.saveSubReview",
                        saveDTO
                );

        return result;
    }


    /* =========================================
       MY 페이지 - 데일리 기록별 서브 리뷰 조회
    ========================================= */
    @Override
    public List<SubReviewDTO> findSubReviewsByReviewId(
            Long reviewId) {

        return sqlSessionTemplate.selectList(
                "review_mapper.findSubReviewsByReviewId",
                reviewId
        );
    }


    /* =========================================
       MY 페이지 - 내가 작성한 전체 서브 리뷰 조회
    ========================================= */
    @Override
    public List<SubReviewDTO> findSubReviewsByUserId(
            String userId) {

        return sqlSessionTemplate.selectList(
                "review_mapper.findSubReviewsByUserId",
                userId
        );
    }


    /* =========================================
       MY 페이지 - 데일리 리뷰 삭제용
       해당 리뷰의 서브 리뷰 전체 삭제
    ========================================= */
    @Override
    public int deleteSubReviewsByReviewId(
            long reviewId) {

        return sqlSessionTemplate.delete(
                "review_mapper.deleteSubReviewsByReviewId",
                reviewId
        );
    }


    /*===========================================
 	메인 페이지 - 서브 리뷰 카테고리별 등록 건수 집계
	============================================*/
    
	@Override
	public CategoryCountDTO findCategoryCounts() {
		
		return sqlSessionTemplate.selectOne("review_mapper.findCategoryCounts");
		
	}

    /*===========================================
     	탐색 페이지 - 이번 주 최다 언급 아이템 & 장소 Top N 조회
    ============================================*/
    @Override
    public List<TrendingItemDTO> findWeeklyTrendingItems(Map<String, Object> params) {
        return sqlSessionTemplate.selectList("review_mapper.findWeeklyTrendingItems", params);
    }

}