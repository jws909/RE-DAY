package com.app.dao.member.impl;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.app.dao.member.MemberDAO;
import com.app.dto.member.MemberDTO;
import com.app.dto.member.MyPageStatsDTO;

import java.util.List;
import com.app.dto.member.WeeklyUserRankingDTO;
import com.app.dto.member.StreakUserDTO;
import java.util.HashMap;
import java.util.Map;


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


	@Override
	public MemberDTO findUserInfoByUserId(String userId) {

		MemberDTO user = sqlSessionTemplate.selectOne("member_mapper.findUserInfoByUserId", userId);
		return user;
	}

    // ========================================
    // 탐색 페이지 - 주간 유저 랭킹 Top 5 조회
    // ========================================
    @Override
    public List<WeeklyUserRankingDTO> findWeeklyUserRanking() {

        return sqlSessionTemplate.selectList(
                "member_mapper.findWeeklyUserRanking"
        );
    }
    
 // 탐색 페이지 - 연속 기록 스트릭 Top 5 조회
 @Override
 public List<StreakUserDTO> findTopStreakUsers() {

     return sqlSessionTemplate.selectList(
             "member_mapper.findTopStreakUsers"
     );
 }
 
//탐색 페이지 - 응원 여부 확인

@Override
public int countCheer(String requestUserId, String responseUserId) {

  Map<String, Object> params = new HashMap<>();

  params.put("requestUserId", requestUserId);
  params.put("responseUserId", responseUserId);

  return sqlSessionTemplate.selectOne(
          "member_mapper.countCheer",
          params
  );
}


//탐색 페이지 - 응원 등록

@Override
public int insertCheer(String requestUserId, String responseUserId) {

  Map<String, Object> params = new HashMap<>();

  params.put("requestUserId", requestUserId);
  params.put("responseUserId", responseUserId);

  return sqlSessionTemplate.insert(
          "member_mapper.insertCheer",
          params
  );
}

//탐색 페이지 - 응원 취소

@Override
public int deleteCheer(String requestUserId, String responseUserId) {

  Map<String, Object> params = new HashMap<>();

  params.put("requestUserId", requestUserId);
  params.put("responseUserId", responseUserId);

  return sqlSessionTemplate.delete(
          "member_mapper.deleteCheer",
          params
  );
}
//탐색 페이지 - 응원 수 증가
@Override
public int increaseCheerCount(String responseUserId) {

    return sqlSessionTemplate.update(
            "member_mapper.increaseCheerCount",
            responseUserId
    );
}
// 탐색 페이지 - 응원 수 감소
@Override
public int decreaseCheerCount(String responseUserId) {

    return sqlSessionTemplate.update(
            "member_mapper.decreaseCheerCount",
            responseUserId
    );
}
}