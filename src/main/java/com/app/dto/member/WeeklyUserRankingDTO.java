package com.app.dto.member;

// =========================================
// 주간 유저 랭킹 DTO
// - 이번 주 데일리 리뷰 작성률
// - 이번 주 평균 평점
// - Top 5 유저 정보를 담는 객체
// =========================================
public class WeeklyUserRankingDTO {

    // =========================================
    // 유저 기본 정보
    // =========================================
    private String userId;
    private String nickname;
    private String profileImg;

    // =========================================
    // 이번 주 작성 정보
    // =========================================
    private int weeklyReviewCount;
    private double writingRate;
    private double averageRating;

    // =========================================
    // 랭킹 순위
    // =========================================
    private int ranking;


    // =========================================
    // Getter / Setter
    // =========================================

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public String getProfileImg() {
        return profileImg;
    }

    public void setProfileImg(String profileImg) {
        this.profileImg = profileImg;
    }

    public int getWeeklyReviewCount() {
        return weeklyReviewCount;
    }

    public void setWeeklyReviewCount(int weeklyReviewCount) {
        this.weeklyReviewCount = weeklyReviewCount;
    }

    public double getWritingRate() {
        return writingRate;
    }

    public void setWritingRate(double writingRate) {
        this.writingRate = writingRate;
    }

    public double getAverageRating() {
        return averageRating;
    }

    public void setAverageRating(double averageRating) {
        this.averageRating = averageRating;
    }

    public int getRanking() {
        return ranking;
    }

    public void setRanking(int ranking) {
        this.ranking = ranking;
    }
}