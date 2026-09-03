package com.app.service.member.impl;

import java.io.IOException;

import java.util.List;

import com.app.dto.member.WeeklyUserRankingDTO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.transaction.annotation.Transactional;

import com.app.dao.file.FileDAO;
import com.app.dao.member.MemberDAO;
import com.app.dto.file.FileInfo;
import com.app.dto.member.MemberDTO;
import com.app.dto.member.MyPageStatsDTO;
import com.app.service.member.MemberService;
import com.app.util.FileManager;
import com.app.dto.member.StreakUserDTO;

@Service
public class MemberServiceImpl implements MemberService {

	@Autowired
	MemberDAO memberDAO;

	@Autowired
	FileDAO fileDAO;

	// ========================================
	// 로그인
	// ========================================
	@Override
	public MemberDTO login(MemberDTO memberDTO) {

		return memberDAO.findMemberByEmailAndPassword(memberDTO);
	}

	// ========================================
	// 이메일 중복 확인
	// ========================================
	@Override
	public boolean isEmailDuplicated(String email) {

		MemberDTO member = memberDAO.findMemberByEmail(email);

		return member != null;
	}

	// ========================================
	// 회원가입
	// ========================================
	@Override
	public int signup(MemberDTO memberDTO) {

		return memberDAO.insertMember(memberDTO);
	}

	// ========================================
	// 프로필 이미지 저장
	// ========================================
	@Override
	public String updateProfileImage(MemberDTO loginUser, MultipartFile profileImageFile) {

		try {

			// ========================================
			// 1. 실제 이미지 파일 저장
			// ========================================
			FileInfo fileInfo = FileManager.storeFile(profileImageFile, "images/profiles/");

			// ========================================
			// 2. FILE_INFO DB 저장
			// ========================================
			int fileResult = fileDAO.saveFileInfo(fileInfo);

			if (fileResult == 0) {

				throw new RuntimeException("프로필 이미지 파일 정보 저장 실패");
			}

			// ========================================
			// 3. 브라우저용 이미지 URL 생성
			// ========================================
			String profileImg = fileInfo.getUrlFilePath() + fileInfo.getFileName();

			// ========================================
			// 4. 로그인 사용자 DTO에
			// 새 프로필 이미지 URL 저장
			// ========================================
			loginUser.setProfileImg(profileImg);

			// ========================================
			// 5. USERS 테이블 PROFILE_IMG 변경
			// ========================================
			int memberResult = memberDAO.updateProfileImg(loginUser);

			if (memberResult == 0) {

				throw new RuntimeException("프로필 이미지 DB 변경 실패");
			}

			// ========================================
			// 변경된 프로필 이미지 URL 반환
			// ========================================
			return profileImg;

		} catch (IllegalStateException | IOException e) {

			e.printStackTrace();

			throw new RuntimeException("프로필 이미지 저장 중 오류가 발생했습니다.");
		}
	}

	// ========================================
	// 프로필 정보 수정
	// 현재 단계에서는 닉네임 수정
	// ========================================
	@Override
	public int updateProfile(MemberDTO memberDTO) {

		return memberDAO.updateProfile(memberDTO);
	}

	// ========================================
	// MY 페이지 통계 조회
	// ========================================
	@Override
	public MyPageStatsDTO getMyPageStats(String userId) {

		return memberDAO.findMyPageStats(userId);
	}

	@Override
	public MemberDTO findUserInfoByUserId(String userId) {

		MemberDTO user = memberDAO.findUserInfoByUserId(userId);
		return user;
	}

	// 탐색 페이지 - 주간 유저 랭킹 Top 5 조회
	@Override
	public List<WeeklyUserRankingDTO> getWeeklyUserRanking() {

		return memberDAO.findWeeklyUserRanking();
	}

	// 탐색 페이지 - 연속 기록 스트릭 Top 5 조회
	@Override
	public List<StreakUserDTO> getTopStreakUsers() {

		return memberDAO.findTopStreakUsers();
	}

	// ========================================
	// 탐색 페이지 - 내가 해당 유저를 응원했는지 확인
	// ========================================
	@Override
	public boolean isCheeredByUser(
	        String requestUserId,
	        String responseUserId) {

	    int cheerCount =
	            memberDAO.countCheer(
	                    requestUserId,
	                    responseUserId
	            );

	    return cheerCount > 0;
	}


	// ========================================
	// 탐색 페이지 - 응원 등록 / 취소 통합 처리
	// - CHEER 테이블과 USERS.CHEER_COUNT를
	//   하나의 트랜잭션으로 처리
	// ========================================
	@Override
	@Transactional
	public void toggleCheer(
	        String requestUserId,
	        String responseUserId) {

	    // ========================================
	    // 기존 응원 여부 확인
	    // ========================================
	    int cheerCount =
	            memberDAO.countCheer(
	                    requestUserId,
	                    responseUserId
	            );


	    // ========================================
	    // 이미 응원한 경우
	    // - 응원 삭제
	    // - 응원 수 감소
	    // ========================================
	    if (cheerCount > 0) {

	        int deleteResult =
	                memberDAO.deleteCheer(
	                        requestUserId,
	                        responseUserId
	                );

	        if (deleteResult > 0) {

	            memberDAO.decreaseCheerCount(
	                    responseUserId
	            );
	        }


	    // ========================================
	    // 아직 응원하지 않은 경우
	    // - 응원 등록
	    // - 응원 수 증가
	    // ========================================
	    } else {

	        int insertResult =
	                memberDAO.insertCheer(
	                        requestUserId,
	                        responseUserId
	                );

	        if (insertResult > 0) {

	            memberDAO.increaseCheerCount(
	                    responseUserId
	            );
	        }
	    }
	}
}