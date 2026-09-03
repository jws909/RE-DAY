package com.app.dto.review;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class DailyReviewFormDTO {
    private Long reviewId;                  // review_id (PK)
    private String userId;                  // user_id (작성자)

    private String authorNickname;           // 작성자 닉네임
    private String authorProfileImg;         // 작성자 프로필 이미지
    private String authorLevel;              // 작성자 레벨/칭호
    private Integer authorStreakCount;       // 작성자 스트릭 수

    private String reviewDate;              // review_date ("YYYY-MM-DD")
    private String dayOfWeek;               // 요일 ("월요일", "화요일"...)
    private Double totalRating;             // total_rating (0.5 ~ 5.0)
    private String moodTags;                // mood_tags ("생산적인하루,힐링성공")
    private String overallComment;          // overall_comment (오늘 하루 총평)
    private String mainImageUrl;            // main_image_url (DB 저장용 URL/경로)
    private MultipartFile mainImageFile;    // mainImageFile (업로드된 실제 파일)
    private String isPublic;                // is_public ('Y' / 'N')
    private int likeCount;                  // 좋아요 수
    private int commentCount;               // 댓글 수
    private boolean likedByMe;              // 현재 로그인 사용자의 좋아요 여부

    // 1:N 서브 리뷰 목록 바인딩
    private List<SubReviewDTO> subReviews;  // subReviews[0], subReviews[1]...
    private String subReviewsJson;          // subReviewsJson (JSON 보조 필드)
    
}
