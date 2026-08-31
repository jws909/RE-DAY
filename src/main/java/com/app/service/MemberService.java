package com.app.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.app.dao.MemberDAO;
import com.app.dto.MemberDTO;

@Service
public class MemberService {

    @Autowired
    private MemberDAO memberDAO;


    // ==========================================
    // 회원가입
    // ==========================================

    public int signup(MemberDTO member) {

        int result =
                memberDAO.insertMember(member);


        // 회원가입 성공 후 관심 키워드 저장
        if (result > 0) {

            String[] interests =
                    member.getInterests();


            if (interests != null) {

                for (String interest : interests) {

                    memberDAO.insertInterest(
                            member.getMemberNo(),
                            interest
                    );
                }
            }
        }


        return result;
    }


    // ==========================================
    // 이메일 중복 검사
    // ==========================================

    public int checkEmail(String email) {

        return memberDAO.checkEmail(email);
    }


    // ==========================================
    // 닉네임 중복 검사
    // ==========================================

    public int checkNickname(String nickname) {

        return memberDAO.checkNickname(nickname);
    }


    // ==========================================
    // 회원 정보 조회
    // ==========================================

    public MemberDTO selectMember(int memberNo) {

        MemberDTO member =
                memberDAO.selectMember(memberNo);


        if (member != null) {

            List<String> interestList =
                    memberDAO.selectInterests(memberNo);


            member.setInterests(
                    interestList.toArray(
                            new String[0]
                    )
            );
        }


        return member;
    }


    // ==========================================
    // 프로필 수정
    // ==========================================

    public int updateProfile(MemberDTO member) {

        int result =
                memberDAO.updateProfile(member);


        if (result > 0) {

            // 기존 관심 키워드 삭제
            memberDAO.deleteInterests(
                    member.getMemberNo()
            );


            // 새 관심 키워드 저장
            String[] interests =
                    member.getInterests();


            if (interests != null) {

                for (String interest : interests) {

                    memberDAO.insertInterest(
                            member.getMemberNo(),
                            interest
                    );
                }
            }
        }


        return result;
    }
}