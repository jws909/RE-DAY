package com.app.dao.member;

import com.app.dto.member.MemberDTO;
import com.app.dto.member.MyPageStatsDTO;

public interface MemberDAO {

    public MemberDTO findMemberByEmailAndPassword(
            MemberDTO memberDTO
    );


    // ========================================
    // 프로필 이미지 변경
    // ========================================
    public int updateProfileImg(
            MemberDTO memberDTO
    );


    // ========================================
    // 프로필 정보 변경
    // ========================================
    public int updateProfile(
            MemberDTO memberDTO
    );


    // ========================================
    // MY 페이지 통계 조회
    // ========================================
    public MyPageStatsDTO findMyPageStats(
            String userId
    );

}