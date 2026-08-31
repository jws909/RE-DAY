package com.app.util;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

import org.springframework.web.multipart.MultipartFile;

import com.app.dto.file.FileInfo;

public class FileManager {
	
	static final String FILE_STORAGE_PATH = "d:/fileStorage/";
	static final String FILE_URL_PATH = "/fileStorage/";

	public static FileInfo storeFile(MultipartFile file, String extraUrl) throws IllegalStateException, IOException {

		// 매개변수로 전달받은 파일 (저장하려는 파일)

		// 파일 가공 과정

		// 파일 저장 -> 저장한 파일에 대한 정보를 담은 객체(FileInfo) -> return

		FileInfo fileInfo = new FileInfo();

		// 파일을 실제 저장 파일명 -> 유니크한값
		// 사용자업로드 파일명 -> originalFileName

		fileInfo.setOriginalFileName(file.getOriginalFilename());
		fileInfo.setFilePath(FILE_STORAGE_PATH + extraUrl);
		fileInfo.setUrlFilePath(FILE_URL_PATH + extraUrl);

		// abc_erd.png -> 변환
		fileInfo.setFileName(createFileName(file)); // 새롭게 만든 파일명

		// 스토리지에 저장
		file.transferTo(new File(fileInfo.getFilePath() + fileInfo.getFileName()));

		return fileInfo;
	}
	
	public static FileInfo storeFile(MultipartFile file) throws IllegalStateException, IOException {
		return storeFile(file, "");
	}

	static String createFileName(String extension) {

		String fileName = UUID.randomUUID().toString();

		fileName = fileName + "." + extension;

		return fileName;
	}

	static String createFileName(MultipartFile file) {
		String extension = extractExtension(file.getOriginalFilename());

		return createFileName(extension);
	}

	static String extractExtension(String fileName) {
		// abc_erd.png
		// png 확장자 (jpg, jpeg, png, csv)

		String extension = fileName.substring((fileName.lastIndexOf(".") + 1));

		return extension;
	}
}
