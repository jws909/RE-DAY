package com.app.dao.test;

import java.util.List;

import com.app.dto.test.TestMember;

public interface TestDAO {
	public List<TestMember> findTestMemberList();
}
