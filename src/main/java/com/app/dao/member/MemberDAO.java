package com.app.dao.member;

import com.app.dto.member.MemberDTO;

public interface MemberDAO {

    public MemberDTO findMemberByEmailAndPassword(MemberDTO memberDTO);

}