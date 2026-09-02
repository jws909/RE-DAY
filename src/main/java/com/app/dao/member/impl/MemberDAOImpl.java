package com.app.dao.member.impl;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.app.dao.member.MemberDAO;
import com.app.dto.member.MemberDTO;
import com.app.dto.member.MyPageStatsDTO;


@Repository
public class MemberDAOImpl implements MemberDAO {


    @Autowired
    SqlSessionTemplate sqlSessionTemplate;


    // ========================================
    // 로그인 회원 조회
    // ========================================
    @Override
    public MemberDTO findMemberByEmailAndPassword(
            MemberDTO memberDTO) {

        return sqlSessionTemplate.selectOne(
                "member_mapper.findMemberByEmailAndPassword",
                memberDTO
        );
    }


    // ========================================
    // 이메일 중복 확인
    // ========================================
    @Override
    public MemberDTO findMemberByEmail(
            String email) {

        return sqlSessionTemplate.selectOne(
                "member_mapper.findMemberByEmail",
                email
        );
    }


    // ========================================
    // 회원가입
    // ========================================
    @Override
    public int insertMember(
            MemberDTO memberDTO) {

        return sqlSessionTemplate.insert(
                "member_mapper.insertMember",
                memberDTO
        );
    }


    // ========================================
    // 프로필 이미지 변경
    // ========================================
    @Override
    public int updateProfileImg(
            MemberDTO memberDTO) {

        return sqlSessionTemplate.update(
                "member_mapper.updateProfileImg",
                memberDTO
        );
    }


    // ========================================
    // 프로필 정보 변경
    // ========================================
    @Override
    public int updateProfile(
            MemberDTO memberDTO) {

        return sqlSessionTemplate.update(
                "member_mapper.updateProfile",
                memberDTO
        );
    }


    // ========================================
    // MY 페이지 통계 조회
    // ========================================
    @Override
    public MyPageStatsDTO findMyPageStats(
            String userId) {

        return sqlSessionTemplate.selectOne(
                "member_mapper.findMyPageStats",
                userId
        );
    }

}