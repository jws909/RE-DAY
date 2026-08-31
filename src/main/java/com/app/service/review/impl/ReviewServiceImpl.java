package com.app.service.review.impl;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.app.dao.file.FileDAO;
import com.app.dao.review.DailyReviewDAO;
import com.app.dao.review.SubReviewDAO;
import com.app.dto.file.FileInfo;
import com.app.dto.review.DailyReviewFormDTO;
import com.app.dto.review.DailyReviewImage;
import com.app.dto.review.SubReviewDTO;
import com.app.service.review.ReviewService;
import com.app.util.FileManager;

@Service
public class ReviewServiceImpl implements ReviewService {

	@Autowired
	DailyReviewDAO dailyReviewDAO;
	
	@Autowired
	SubReviewDAO subReviewDAO;
	
	@Autowired
	FileDAO fileDAO;
	
	@Override
	@Transactional(rollbackFor = Exception.class)
	public long createDailyReviewWithSubReviews(DailyReviewFormDTO formDTO) {
	    
		// 생성된 리뷰아이디
		long generatedReviewId = 0;
		
	    //파일 저장 후 url 설정
	    MultipartFile file = formDTO.getMainImageFile();
	    
	    if(file != null) {
	    	try {
				FileInfo fileInfo = FileManager.storeFile(file, "images/reviews/");
				
				int result = fileDAO.saveFileInfo(fileInfo);
			    
				if(result > 0) {
					formDTO.setMainImageUrl(fileInfo.getUrlFilePath() + fileInfo.getFileName());
					
					generatedReviewId = dailyReviewDAO.saveDailyReview(formDTO);
					
				    if(generatedReviewId == 0) {
				        throw new RuntimeException("메인 데일리 리뷰 저장에 실패했습니다.");
				    }
				    
					DailyReviewImage imageInfo = new DailyReviewImage();
					imageInfo.setFileName(fileInfo.getFileName());
					imageInfo.setReviewId(generatedReviewId);
					int result2 = dailyReviewDAO.saveDailyReviewImage(imageInfo);
					
					if(result2 == 0) {
						throw new RuntimeException("사진 정보 저장에 실패했습니다.");
					}
				} else {
					throw new RuntimeException("사진 정보 저장에 실패했습니다.");
				}
				
			} catch (IllegalStateException | IOException e) {
				e.printStackTrace();
				throw new RuntimeException("사진 저장에 실패했습니다.");
			}
	    } else {
	    	generatedReviewId = dailyReviewDAO.saveDailyReview(formDTO);
			
		    if(generatedReviewId == 0) {
		        throw new RuntimeException("메인 데일리 리뷰 저장에 실패했습니다.");
		    }
	    }
	    
	    // 서브리뷰 목록이 비어있지 않은 경우에만 순회
	    if (formDTO.getSubReviews() != null && !formDTO.getSubReviews().isEmpty()) {
	        for(SubReviewDTO subreview : formDTO.getSubReviews()) {
	            subreview.setReviewId(generatedReviewId);
	            
	            int result = subReviewDAO.saveSubReview(subreview);
	            if(result == 0) {
	                // ❌ return 0; -> 트랜잭션이 커밋됨
	                // ⭕ RuntimeException을 던져야 전체 롤백 발생
	                throw new RuntimeException("서브 리뷰 저장 실패로 전체 롤백 처리합니다. 항목: " + subreview.getItemName());
	            }
	        }
	    }
	    
	    return generatedReviewId;
	}

	@Override
	public int saveDailyReviewImage(DailyReviewImage dailyReviewImage) {

		int result = dailyReviewDAO.saveDailyReviewImage(dailyReviewImage);
		
		return result;
	}

	@Override
	public DailyReviewImage findDailyReviewImageByReviewId(String reviewId) {

		DailyReviewImage dailyReviewImage = dailyReviewDAO.findDailyReviewImageByReviewId(reviewId);
		
		return dailyReviewImage;
	}
	
}
