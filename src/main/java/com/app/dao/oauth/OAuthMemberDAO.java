package com.app.dao.oauth;

import com.app.dto.member.MemberDTO;
import com.app.dto.oauth.OAuthUserDTO;

public interface OAuthMemberDAO {

    // Google / Kakao의 고유 ID로 기존 회원 조회
    MemberDTO findMemberByProvider(String provider, String providerId);

    // 같은 이메일로 가입된 회원이 있는지 조회
    MemberDTO findMemberByEmail(String email);

    // 소셜 로그인 신규 회원 등록
    int insertOAuthMember(OAuthUserDTO oauthUser);
}