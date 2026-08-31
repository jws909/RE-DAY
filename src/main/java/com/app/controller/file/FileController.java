package com.app.controller.file;

import java.net.MalformedURLException;
import java.nio.charset.StandardCharsets;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.util.UriUtils;

import com.app.dto.file.FileInfo;
import com.app.service.file.FileService;

@Controller
public class FileController {
	
	@Autowired
	FileService fileService;
	
	@GetMapping("/attach/{fileName}")
	public ResponseEntity<Resource> downloadAttach(@PathVariable String fileName) throws MalformedURLException {
		// Item item = itemRepository.findById(itemId);
		FileInfo fileInfo = fileService.findFileInfoByFileName(fileName);

		String storeFileName = fileInfo.getFileName();
		String uploadFileName = fileInfo.getOriginalFileName();

		UrlResource resource = new UrlResource("file:" + fileInfo.getFilePath() + storeFileName);

		String encodedUploadFileName = UriUtils.encode(uploadFileName, StandardCharsets.UTF_8);
		String contentDisposition = "attachment; filename=\"" + encodedUploadFileName + "\"";

		return ResponseEntity.ok().header(HttpHeaders.CONTENT_DISPOSITION, contentDisposition).body(resource);
	}
}