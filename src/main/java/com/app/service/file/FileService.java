package com.app.service.file;

import com.app.dto.file.FileInfo;

public interface FileService {
	public int saveFileInfo(FileInfo fileInfo);
	
	public FileInfo findFileInfoByFileName(String fileName);
}
