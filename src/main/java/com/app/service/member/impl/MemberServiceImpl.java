package com.app.service.member.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.app.dao.member.MemberDAO;
import com.app.dto.member.MemberDTO;
import com.app.service.member.MemberService;

@Service
public class MemberServiceImpl implements MemberService {

    @Autowired
    MemberDAO memberDAO;

    @Override
    public MemberDTO login(MemberDTO memberDTO) {

        return memberDAO.findMemberByEmailAndPassword(memberDTO);
    }

}