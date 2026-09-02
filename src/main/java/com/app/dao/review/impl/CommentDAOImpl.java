package com.app.dao.review.impl;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.app.dao.review.CommentDAO;
import com.app.dto.review.CommentDTO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Repository
public class CommentDAOImpl implements CommentDAO {

    @Autowired
    SqlSessionTemplate sqlSessionTemplate;

	@Override
	public List<CommentDTO> findCommentListForDetail(long reviewId) {
		List<CommentDTO> commentList = sqlSessionTemplate.selectList("comment_mapper.findCommentListForDetail", reviewId);
		return commentList;
	}


    /* =========================================
       댓글 목록 조회
    ========================================= */
    @Override
    public List<CommentDTO> findCommentList(
            long reviewId) {

        List<CommentDTO> commentList =
                sqlSessionTemplate.selectList(
                        "comment_mapper.findCommentList",
                        reviewId
                );

        return commentList;
    }


    /* =========================================
       댓글 저장
    ========================================= */
    @Override
    public int saveComment(
            CommentDTO comment) {

        int result = 0;

        try {

            result =
                    sqlSessionTemplate.insert(
                            "comment_mapper.saveComment",
                            comment
                    );

        } catch (Exception e) {

            log.warn(e.getMessage());
            log.error(e.getMessage());

        }

        return result;
    }


    /* =========================================
       댓글 단건 조회
    ========================================= */
    @Override
    public CommentDTO findCommentByCommentId(
            long commentId) {

        CommentDTO comment = null;

        try {

            comment =
                    sqlSessionTemplate.selectOne(
                            "comment_mapper.findCommentByCommentId",
                            commentId
                    );

        } catch (Exception e) {

            log.error(e.getMessage());

        }

        return comment;
    }


    /* =========================================
       댓글 단건 삭제
    ========================================= */
    @Override
    public int removeComment(
            long commentId) {

        int result =
                sqlSessionTemplate.delete(
                        "comment_mapper.removeComment",
                        commentId
                );

        return result;
    }


    /* =========================================
       댓글 수정
    ========================================= */
    @Override
    public int modifyComment(
            CommentDTO comment) {

        int result =
                sqlSessionTemplate.update(
                        "comment_mapper.modifyComment",
                        comment
                );

        return result;
    }


    /* =========================================
       MY 페이지 - 데일리 리뷰 삭제용
       해당 리뷰의 댓글 전체 삭제
    ========================================= */
    @Override
    public int deleteCommentsByReviewId(
            long reviewId) {

        return sqlSessionTemplate.delete(
                "comment_mapper.deleteCommentsByReviewId",
                reviewId
        );
    }

}