package com.app.util;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

import org.springframework.web.multipart.MultipartFile;

import com.app.dto.file.FileInfo;

public class FileManager {

    static final String FILE_STORAGE_PATH =
            "d:/fileStorage/";

    static final String FILE_URL_PATH =
            "/fileStorage/";


    public static FileInfo storeFile(
            MultipartFile file,
            String extraUrl)
            throws IllegalStateException, IOException {


        FileInfo fileInfo = new FileInfo();


        // 원래 파일명
        fileInfo.setOriginalFileName(
                file.getOriginalFilename()
        );


        // 실제 저장 경로
        fileInfo.setFilePath(
                FILE_STORAGE_PATH + extraUrl
        );


        // 브라우저 접근 URL
        fileInfo.setUrlFilePath(
                FILE_URL_PATH + extraUrl
        );


        // UUID 파일명 생성
        fileInfo.setFileName(
                createFileName(file)
        );


        /*
         * 저장할 폴더가 없으면 자동 생성
         *
         * D:/fileStorage/images/profiles/
         */
        File directory =
                new File(fileInfo.getFilePath());


        if (!directory.exists()) {

            directory.mkdirs();

        }


        // 실제 저장할 파일
        File saveFile =
                new File(
                        directory,
                        fileInfo.getFileName()
                );


        // 실제 파일 저장
        file.transferTo(saveFile);


        return fileInfo;
    }


    public static FileInfo storeFile(
            MultipartFile file)
            throws IllegalStateException, IOException {

        return storeFile(file, "");
    }


    static String createFileName(
            String extension) {

        String fileName =
                UUID.randomUUID().toString();

        fileName =
                fileName + "." + extension;

        return fileName;
    }


    static String createFileName(
            MultipartFile file) {

        String extension =
                extractExtension(
                        file.getOriginalFilename()
                );

        return createFileName(extension);
    }


    static String extractExtension(
            String fileName) {

        String extension =
                fileName.substring(
                        fileName.lastIndexOf(".") + 1
                );

        return extension;
    }

}