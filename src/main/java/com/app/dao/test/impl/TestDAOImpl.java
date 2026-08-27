package com.app.dao.test.impl;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.app.dao.test.TestDAO;
import com.app.dto.test.TestMember;

@Repository
public class TestDAOImpl implements TestDAO {
	
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;

	@Override
	public List<TestMember> findTestMemberList() {

		List<TestMember> testMemberList = sqlSessionTemplate.selectList("test_mapper.findTestMemberList");
		
		return testMemberList;
	}

}
