package com.app.service.member.impl;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.app.dao.file.FileDAO;
import com.app.dao.member.MemberDAO;
import com.app.dto.file.FileInfo;
import com.app.dto.member.MemberDTO;
import com.app.dto.member.MyPageStatsDTO;
import com.app.service.member.MemberService;
import com.app.util.FileManager;


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
    public MemberDTO login(
            MemberDTO memberDTO) {

        return memberDAO
                .findMemberByEmailAndPassword(
                        memberDTO
                );
    }


    // ========================================
    // 이메일 중복 확인
    // ========================================
    @Override
    public boolean isEmailDuplicated(
            String email) {

        MemberDTO member =
                memberDAO.findMemberByEmail(
                        email
                );

        return member != null;
    }


    // ========================================
    // 회원가입
    // ========================================
    @Override
    public int signup(
            MemberDTO memberDTO) {

        return memberDAO.insertMember(
                memberDTO
        );
    }


    // ========================================
    // 프로필 이미지 저장
    // ========================================
    @Override
    public String updateProfileImage(
            MemberDTO loginUser,
            MultipartFile profileImageFile) {

        try {

            // ========================================
            // 1. 실제 이미지 파일 저장
            // ========================================
            FileInfo fileInfo =
                    FileManager.storeFile(
                            profileImageFile,
                            "images/profiles/"
                    );


            // ========================================
            // 2. FILE_INFO DB 저장
            // ========================================
            int fileResult =
                    fileDAO.saveFileInfo(
                            fileInfo
                    );


            if (fileResult == 0) {

                throw new RuntimeException(
                        "프로필 이미지 파일 정보 저장 실패"
                );
            }


            // ========================================
            // 3. 브라우저용 이미지 URL 생성
            // ========================================
            String profileImg =
                    fileInfo.getUrlFilePath()
                    + fileInfo.getFileName();


            // ========================================
            // 4. 로그인 사용자 DTO에
            //    새 프로필 이미지 URL 저장
            // ========================================
            loginUser.setProfileImg(
                    profileImg
            );


            // ========================================
            // 5. USERS 테이블 PROFILE_IMG 변경
            // ========================================
            int memberResult =
                    memberDAO.updateProfileImg(
                            loginUser
                    );


            if (memberResult == 0) {

                throw new RuntimeException(
                        "프로필 이미지 DB 변경 실패"
                );
            }


            // ========================================
            // 변경된 프로필 이미지 URL 반환
            // ========================================
            return profileImg;


        } catch (
                IllegalStateException
                | IOException e) {

            e.printStackTrace();

            throw new RuntimeException(
                    "프로필 이미지 저장 중 오류가 발생했습니다."
            );
        }
    }


    // ========================================
    // 프로필 정보 수정
    // 현재 단계에서는 닉네임 수정
    // ========================================
    @Override
    public int updateProfile(
            MemberDTO memberDTO) {

        return memberDAO.updateProfile(
                memberDTO
        );
    }


    // ========================================
    // MY 페이지 통계 조회
    // ========================================
    @Override
    public MyPageStatsDTO getMyPageStats(
            String userId) {

        return memberDAO
                .findMyPageStats(
                        userId
                );
    }


	@Override
	public MemberDTO findUserInfoByUserId(String userId) {

		MemberDTO user = memberDAO.findUserInfoByUserId(userId);
		return user;
	}

}