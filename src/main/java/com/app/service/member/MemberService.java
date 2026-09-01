package com.app.service.member;

import org.springframework.web.multipart.MultipartFile;

import com.app.dto.member.MemberDTO;
import com.app.dto.member.MyPageStatsDTO;

public interface MemberService {

    public MemberDTO login(MemberDTO memberDTO);

    // 프로필 이미지 저장
    public String updateProfileImage(
            MemberDTO loginUser,
            MultipartFile profileImageFile
    );

    // MY 페이지 통계 조회
    public MyPageStatsDTO getMyPageStats(String userId);

}