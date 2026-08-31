package com.app.dao.file;

import com.app.dto.file.FileInfo;

public interface FileDAO {
	public int saveFileInfo(FileInfo fileInfo);
	
	public FileInfo findFileInfoByFileName(String fileName);
}
