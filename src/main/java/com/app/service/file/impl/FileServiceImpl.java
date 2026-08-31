package com.app.service.file.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.app.dao.file.FileDAO;
import com.app.dto.file.FileInfo;
import com.app.service.file.FileService;

@Service
public class FileServiceImpl implements FileService {
	
	@Autowired
	FileDAO fileDAO;

	@Override
	public int saveFileInfo(FileInfo fileInfo) {

		int result = fileDAO.saveFileInfo(fileInfo);
		
		return result;
	}

	@Override
	public FileInfo findFileInfoByFileName(String fileName) {

		FileInfo fileInfo = fileDAO.findFileInfoByFileName(fileName);
		
		return fileInfo;
	}
	
}
