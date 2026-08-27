package com.app.service.test.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.app.dao.test.TestDAO;
import com.app.dto.test.TestMember;
import com.app.service.test.TestService;

@Service
public class TestServiceImpl implements TestService {

	@Autowired
	TestDAO testDAO;
	
	@Override
	public List<TestMember> findTestMemberList() {

		List<TestMember> testMemberList = testDAO.findTestMemberList();
		
		return testMemberList;
	}
	
}
