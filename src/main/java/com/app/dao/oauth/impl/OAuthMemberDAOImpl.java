package com.app.dao.oauth.impl;

import java.util.HashMap;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.app.dao.oauth.OAuthMemberDAO;
import com.app.dto.member.MemberDTO;
import com.app.dto.oauth.OAuthUserDTO;

@Repository
public class OAuthMemberDAOImpl implements OAuthMemberDAO {

    @Autowired
    private SqlSessionTemplate sqlSession;

    @Override
    public MemberDTO findMemberByProvider(String provider, String providerId) {

        Map<String, Object> parameter = new HashMap<>();

        parameter.put("provider", provider);
        parameter.put("providerId", providerId);

        return sqlSession.selectOne(
                "member_mapper.findOAuthMemberByProvider",
                parameter
        );
    }

    @Override
    public MemberDTO findMemberByEmail(String email) {

        return sqlSession.selectOne(
                "member_mapper.findOAuthMemberByEmail",
                email
        );
    }

    @Override
    public int insertOAuthMember(OAuthUserDTO oauthUser) {

        return sqlSession.insert(
                "member_mapper.insertOAuthMember",
                oauthUser
        );
    }
}