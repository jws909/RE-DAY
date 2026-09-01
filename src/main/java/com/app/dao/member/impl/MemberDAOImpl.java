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

    @Override
    public MemberDTO findMemberByEmailAndPassword(MemberDTO memberDTO) {

        return sqlSessionTemplate.selectOne(
                "member_mapper.findMemberByEmailAndPassword",
                memberDTO
        );
    }

    @Override
    public int updateProfileImg(MemberDTO memberDTO) {

        return sqlSessionTemplate.update(
                "member_mapper.updateProfileImg",
                memberDTO
        );
    }

    @Override
    public MyPageStatsDTO findMyPageStats(String userId) {

        return sqlSessionTemplate.selectOne(
                "member_mapper.findMyPageStats",
                userId
        );
    }

}