package com.app.service.member;

import org.springframework.web.multipart.MultipartFile;

import com.app.dto.member.MemberDTO;
import com.app.dto.member.MyPageStatsDTO;
import java.util.List;
import com.app.dto.member.WeeklyUserRankingDTO;


public interface MemberService {


    // ========================================
    // 로그인
    // ========================================
    public MemberDTO login(
            MemberDTO memberDTO
    );


    // ========================================
    // 이메일 중복 확인
    // ========================================
    public boolean isEmailDuplicated(
            String email
    );


    // ========================================
    // 회원가입
    // ========================================
    public int signup(
            MemberDTO memberDTO
    );


    // ========================================
    // 프로필 이미지 저장
    // ========================================
    public String updateProfileImage(
            MemberDTO loginUser,
            MultipartFile profileImageFile
    );


    // ========================================
    // 프로필 정보 수정
    // 현재 단계에서는 닉네임 수정
    // ========================================
    public int updateProfile(
            MemberDTO memberDTO
    );


    // ========================================
    // MY 페이지 통계 조회
    // ========================================
    public MyPageStatsDTO getMyPageStats(
            String userId
    );
 
    // 회원 정보 조회
    public MemberDTO findUserInfoByUserId(String userId);
    
    //탐색페이지 -주간유저랭킹 top5 조회
    public List<WeeklyUserRankingDTO> getWeeklyUserRanking();

}