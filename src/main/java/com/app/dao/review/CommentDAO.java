package com.app.dao.review;

import java.util.List;

import com.app.dto.review.CommentDTO;

public interface CommentDAO {

    List<CommentDTO> findCommentList(
            long reviewId
    );

    int saveComment(
            CommentDTO comment
    );

    CommentDTO findCommentByCommentId(
            long commentId
    );

    int removeComment(
            long commentId
    );

    int modifyComment(
            CommentDTO comment
    );

    /* =========================================
       MY 페이지 - 데일리 리뷰 삭제용
       해당 데일리 리뷰의 댓글 전체 삭제
    ========================================= */
    int deleteCommentsByReviewId(
            long reviewId
    );
}
