package com.app.dao.file.impl;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.app.dao.file.FileDAO;
import com.app.dto.file.FileInfo;

@Repository
public class FileDAOImpl implements FileDAO {
	
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;

	@Override
	public int saveFileInfo(FileInfo fileInfo) {

		int result = sqlSessionTemplate.insert("file_mapper.saveFileInfo", fileInfo);
		
		return result;
	}

	@Override
	public FileInfo findFileInfoByFileName(String fileName) {

		FileInfo fileInfo = sqlSessionTemplate.selectOne("file_mapper.findFileInfoByFileName", fileName);
		
		return fileInfo;
	}

}
