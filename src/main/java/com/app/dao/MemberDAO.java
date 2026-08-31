package com.app.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.app.dto.MemberDTO;

@Repository
public class MemberDAO {

    @Autowired
    private SqlSession sqlSession;


    // 회원가입
    public int insertMember(MemberDTO member) {

        return sqlSession.insert(
                "member.insertMember",
                member
        );
    }


    // 이메일 중복 검사
    public int checkEmail(String email) {

        return sqlSession.selectOne(
                "member.checkEmail",
                email
        );
    }


    // 닉네임 중복 검사
    public int checkNickname(String nickname) {

        return sqlSession.selectOne(
                "member.checkNickname",
                nickname
        );
    }


    // 관심 키워드 저장
    public int insertInterest(
            int memberNo,
            String interest) {

        Map<String, Object> map =
                new HashMap<>();

        map.put("memberNo", memberNo);
        map.put("interest", interest);

        return sqlSession.insert(
                "member.insertInterest",
                map
        );
    }


    // 회원 정보 조회
    public MemberDTO selectMember(int memberNo) {

        return sqlSession.selectOne(
                "member.selectMember",
                memberNo
        );
    }


    // 회원 관심 키워드 조회
    public List<String> selectInterests(int memberNo) {

        return sqlSession.selectList(
                "member.selectInterests",
                memberNo
        );
    }


    // 프로필 수정
    public int updateProfile(MemberDTO member) {

        return sqlSession.update(
                "member.updateProfile",
                member
        );
    }


    // 기존 관심 키워드 삭제
    public int deleteInterests(int memberNo) {

        return sqlSession.delete(
                "member.deleteInterests",
                memberNo
        );
    }
}