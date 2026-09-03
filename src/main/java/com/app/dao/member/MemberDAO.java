package com.app.dao.member;

import java.util.List;

import com.app.dto.member.MemberDTO;
import com.app.dto.member.MyPageStatsDTO;
import com.app.dto.member.WeeklyUserRankingDTO;
import com.app.dto.member.StreakUserDTO;

public interface MemberDAO {

	// ========================================
	// 로그인
	// ========================================
	public MemberDTO findMemberByEmailAndPassword(MemberDTO memberDTO);

	// ========================================
	// 이메일 중복 확인
	// ========================================
	public MemberDTO findMemberByEmail(String email);

	// ========================================
	// 회원가입
	// ========================================
	public int insertMember(MemberDTO memberDTO);

	// ========================================
	// 프로필 이미지 변경
	// ========================================
	public int updateProfileImg(MemberDTO memberDTO);

	// ========================================
	// 프로필 정보 변경
	// ========================================
	public int updateProfile(MemberDTO memberDTO);

	// ========================================
	// MY 페이지 통계 조회
	// ========================================
	public MyPageStatsDTO findMyPageStats(String userId);

	// ========================================
	// 회원 정보 조회
	// ========================================
	public MemberDTO findUserInfoByUserId(String userId);

	// ========================================
	// 탐색 페이지 - 주간 유저 랭킹 Top 5 조회
	// ========================================
	public List<WeeklyUserRankingDTO> findWeeklyUserRanking();

	// 탐색페이지-연속기록 스트릭5 조회
	public List<StreakUserDTO> findTopStreakUsers();

	// 탐색 페이지 - 응원 여부 확인
	public int countCheer(String requestUserId, String responseUserId);

	// 탐색 페이지 - 응원 등록
	public int insertCheer(String requestUserId, String responseUserId);

	// 탐색 페이지 - 응원 취소
	public int deleteCheer(String requestUserId, String responseUserId);

	// 탐색 페이지 - 응원 수 증가
	public int increaseCheerCount(String responseUserId);
	
	// 탐색 페이지 - 응원 수 감소
	public int decreaseCheerCount(String responseUserId);
}