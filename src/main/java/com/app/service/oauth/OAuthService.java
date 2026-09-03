package com.app.service.oauth;

import com.app.dto.member.MemberDTO;

public interface OAuthService {

    // Google 로그인 페이지 URL 생성
    String getGoogleLoginUrl(String state);

    // Google 로그인 처리
    MemberDTO loginWithGoogle(String code);

    // Kakao 로그인 페이지 URL 생성
    String getKakaoLoginUrl(String state);

    // Kakao 로그인 처리
    MemberDTO loginWithKakao(String code);
}