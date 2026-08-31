package com.app.dto;

public class MemberDTO {

    private int memberNo;

    private String nickname;
    private String email;
    private String memberPw;

    // 프로필 설정에서 사용
    private String profileImage;
    private String introduction;

    // 관심 키워드
    private String[] interests;

    // 회원가입 약관 동의
    // DB에는 저장하지 않고 검증용으로 사용
    private boolean termsAgreed;


    public int getMemberNo() {
        return memberNo;
    }

    public void setMemberNo(int memberNo) {
        this.memberNo = memberNo;
    }


    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }


    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }


    public String getMemberPw() {
        return memberPw;
    }

    public void setMemberPw(String memberPw) {
        this.memberPw = memberPw;
    }


    public String getProfileImage() {
        return profileImage;
    }

    public void setProfileImage(String profileImage) {
        this.profileImage = profileImage;
    }


    public String getIntroduction() {
        return introduction;
    }

    public void setIntroduction(String introduction) {
        this.introduction = introduction;
    }


    public String[] getInterests() {
        return interests;
    }

    public void setInterests(String[] interests) {
        this.interests = interests;
    }


    public boolean isTermsAgreed() {
        return termsAgreed;
    }

    public void setTermsAgreed(boolean termsAgreed) {
        this.termsAgreed = termsAgreed;
    }
}