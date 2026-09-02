package com.app.dto.member;

// =========================================
// 탐색 페이지 - 연속 기록 스트릭 DTO
// - 유저 기본 정보
// - 연속 기록 일수
// - 전체 리뷰 수
// - 전체 서브 리뷰 수
// - 이번 주 리뷰 작성 수
// - 응원 수
// =========================================
public class StreakUserDTO {

    // =========================================
    // 유저 기본 정보
    // =========================================
    private String userId;
    private String nickname;
    private String profileImg;
    private String userLevel;

    // =========================================
    // 스트릭 / 리뷰 / 응원 정보
    // =========================================
    private int streakCount;
    private int totalReviewCount;
    private int subReviewCount;
    private int weeklyReviewCount;
    private int cheerCount;
    private String recentTags;
    
  //현재 로그인 유저의 응원 여부 true  : 이미 응원함- false : 응원하지 않음
    private boolean cheeredByMe; 

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

    public String getUserLevel() {
        return userLevel;
    }

    public void setUserLevel(String userLevel) {
        this.userLevel = userLevel;
    }

    public int getStreakCount() {
        return streakCount;
    }

    public void setStreakCount(int streakCount) {
        this.streakCount = streakCount;
    }

    public int getTotalReviewCount() {
        return totalReviewCount;
    }

    public void setTotalReviewCount(int totalReviewCount) {
        this.totalReviewCount = totalReviewCount;
    }

    public int getSubReviewCount() {
        return subReviewCount;
    }

    public void setSubReviewCount(int subReviewCount) {
        this.subReviewCount = subReviewCount;
    }

    public int getWeeklyReviewCount() {
        return weeklyReviewCount;
    }

    public void setWeeklyReviewCount(int weeklyReviewCount) {
        this.weeklyReviewCount = weeklyReviewCount;
    }

    public int getCheerCount() {
        return cheerCount;
    }

    public void setCheerCount(int cheerCount) {
        this.cheerCount = cheerCount;
    }
    
    public String getRecentTags() {
        return recentTags;
    }

    public void setRecentTags(String recentTags) {
        this.recentTags = recentTags;
    }
    
 // 현재 로그인 유저의 응원 여부 Getter / Setter
    public boolean isCheeredByMe() {
        return cheeredByMe;
    }

    public void setCheeredByMe(boolean cheeredByMe) {
        this.cheeredByMe = cheeredByMe;
    }
}