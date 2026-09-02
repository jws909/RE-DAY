package com.app.controller.review;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.multipart.MultipartFile;

import com.app.dto.member.MemberDTO;
import com.app.dto.review.DailyReviewFormDTO;
import com.app.service.review.CommentService;
import com.app.service.review.ReviewService;
import com.app.util.DateUtil;

@Controller
public class ReviewController {

    @Autowired
    ReviewService reviewService;

    @Autowired
    CommentService commentService;


    /* =========================================
       리뷰 작성 화면
    ========================================= */
    @GetMapping("/RE:DAY/review/write")
    public String writeReview() {

        return "write/writeReview";
    }


    /* =========================================
       리뷰 작성 처리
    ========================================= */
    @PostMapping("/review/write")
    public String writeReviewAction(
            @ModelAttribute DailyReviewFormDTO formDTO) {

        // 세션에서 로그인 ID 획득
        // 현재는 로그인 기능이 구현 되어있지 않아 임의의 id인 user-01 저장
        formDTO.setUserId("user-01");

        // 대표 이미지 업로드 처리
        MultipartFile imageFile =
                formDTO.getMainImageFile();

        if (
            imageFile != null
            && !imageFile.isEmpty()
        ) {

            // 아직 fileService 구현 전이므로 임의의 링크 저장
            formDTO.setMainImageUrl(
                    "temp_image_URL"
            );
        }

        long generatedReviewId =
                reviewService
                        .createDailyReviewWithSubReviews(
                                formDTO
                        );

        if (generatedReviewId > 0) {

            return "redirect:/RE:DAY/mainpage";

        } else {

            return "redirect:/RE:DAY/review/write";
        }
    }


    /* =========================================
       리뷰 상세 조회
    ========================================= */
    @GetMapping("/RE:DAY/review/detail/{reviewId}")
    public String reviewDetail(
            @PathVariable long reviewId,
            Model model) {

        DailyReviewFormDTO review =
                reviewService
                        .findReviewDetailByReviewId(
                                reviewId
                        );

        model.addAttribute(
                "comments",
                commentService.findCommentList(
                        reviewId
                )
        );

        model.addAttribute(
                "dayOfWeek",
                DateUtil.DateToDayOfWeek(
                        review.getReviewDate()
                )
        );

        model.addAttribute(
                "review",
                review
        );

        model.addAttribute(
                "subReviews",
                review.getSubReviews()
        );

        return "detail/reviewDetail";
    }


    /* =========================================
       MY 페이지 - 데일리 리뷰 삭제
    ========================================= */
    @PostMapping("/RE:DAY/review/delete/{reviewId}")
    public String deleteReview(
            @PathVariable long reviewId,
            HttpSession session) {

        /* 로그인 사용자 확인 */
        MemberDTO loginUser =
                (MemberDTO)
                session.getAttribute("loginUser");

        /* 로그인하지 않은 경우 */
        if (loginUser == null) {

            return "redirect:/member/signin";
        }


        /*
         * 해당 리뷰 정보 조회
         * 본인이 작성한 리뷰인지 확인하기 위해 사용
         */
        DailyReviewFormDTO review =
                reviewService
                        .findReviewDetailByReviewId(
                                reviewId
                        );


        /* 리뷰가 존재하지 않는 경우 */
        if (review == null) {

            return "redirect:/RE:DAY/my";
        }


        /*
         * 로그인한 사용자와
         * 리뷰 작성자가 다른 경우 삭제하지 않음
         */
        if (
            !loginUser.getUserId()
                    .equals(review.getUserId())
        ) {

            return "redirect:/RE:DAY/my";
        }


        /* 본인이 작성한 리뷰만 삭제 */
        reviewService.deleteDailyReviewByReviewId(
                reviewId
        );


        /* 삭제 후 MY 페이지로 이동 */
        return "redirect:/RE:DAY/my";
    }

}