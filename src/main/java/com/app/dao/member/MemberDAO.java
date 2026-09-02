package com.app.dao.member;

import java.util.List;

import com.app.dto.member.MemberDTO;
import com.app.dto.member.MyPageStatsDTO;
import com.app.dto.member.WeeklyUserRankingDTO;

public interface MemberDAO {


    // ========================================
    // 로그인
    // ========================================
    public MemberDTO findMemberByEmailAndPassword(
            MemberDTO memberDTO
    );


    // ========================================
    // 이메일 중복 확인
    // ========================================
    public MemberDTO findMemberByEmail(
            String email
    );


    // ========================================
    // 회원가입
    // ========================================
    public int insertMember(
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
    

    // ========================================
    // 회원 정보 조회
    // ========================================
    public MemberDTO findUserInfoByUserId(
            String userId
    );


    // ========================================
    // 탐색 페이지 - 주간 유저 랭킹 Top 5 조회
    // ========================================
    public List<WeeklyUserRankingDTO> findWeeklyUserRanking();
}