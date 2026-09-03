package com.app.service.review.impl;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.app.dao.file.FileDAO;
import com.app.dao.review.CommentDAO;
import com.app.dao.review.DailyReviewDAO;
import com.app.dao.review.SubReviewDAO;
import com.app.dto.file.FileInfo;
import com.app.dto.review.CategoryCountDTO;
import com.app.dto.review.DailyReviewFormDTO;
import com.app.dto.review.DailyReviewImage;
import com.app.dto.review.SubReviewDTO;
import com.app.service.review.ReviewService;
import com.app.util.FileManager;
import com.app.util.DateUtil;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import com.app.dao.member.MemberDAO;
import com.app.dao.review.LikeDAO;
import com.app.dto.review.LikeRequestDTO;

@Service
public class ReviewServiceImpl implements ReviewService {

	@Autowired
	DailyReviewDAO dailyReviewDAO;

	@Autowired
	MemberDAO memberDAO;

	@Autowired
	SubReviewDAO subReviewDAO;
	@Autowired
	LikeDAO likeDAO;

	@Autowired
	FileDAO fileDAO;
	
	@Autowired
	CommentDAO commentDAO;

	@Override
	@Transactional(rollbackFor = Exception.class)
	public long createDailyReviewWithSubReviews(DailyReviewFormDTO formDTO) {

		// 동일 작성자 당일 중복 등록 방지 검증
		Map<String, Object> checkParams = new HashMap<>();
		checkParams.put("userId", formDTO.getUserId());
		checkParams.put("reviewDate", formDTO.getReviewDate());
		DailyReviewFormDTO existing = dailyReviewDAO.findReviewByUserIdAndDate(checkParams);
		if (existing != null) {
			throw new IllegalStateException("오늘의 데일리 리뷰는 이미 작성하셨습니다.");
		}

		// 생성된 리뷰아이디
		long generatedReviewId = 0;

		// 파일 저장 후 url 설정
		MultipartFile file = formDTO.getMainImageFile();

		if (file != null) {
			try {
				FileInfo fileInfo = FileManager.storeFile(file, "images/reviews/");

				int result = fileDAO.saveFileInfo(fileInfo);

				if (result > 0) {
					formDTO.setMainImageUrl(fileInfo.getUrlFilePath() + fileInfo.getFileName());

					generatedReviewId = dailyReviewDAO.saveDailyReview(formDTO);

					if (generatedReviewId == 0) {
						throw new RuntimeException("메인 데일리 리뷰 저장에 실패했습니다.");
					}

					DailyReviewImage imageInfo = new DailyReviewImage();
					imageInfo.setFileName(fileInfo.getFileName());
					imageInfo.setReviewId(generatedReviewId);
					int result2 = dailyReviewDAO.saveDailyReviewImage(imageInfo);

					if (result2 == 0) {
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

			if (generatedReviewId == 0) {
				throw new RuntimeException("메인 데일리 리뷰 저장에 실패했습니다.");
			}
		}

		// 서브리뷰 목록이 비어있지 않은 경우에만 순회
		if (formDTO.getSubReviews() != null && !formDTO.getSubReviews().isEmpty()) {
			for (SubReviewDTO subreview : formDTO.getSubReviews()) {
				subreview.setReviewId(generatedReviewId);

				int result = subReviewDAO.saveSubReview(subreview);
				if (result == 0) {
					// ❌ return 0; -> 트랜잭션이 커밋됨
					// ⭕ RuntimeException을 던져야 전체 롤백 발생
					throw new RuntimeException("서브 리뷰 저장 실패로 전체 롤백 처리합니다. 항목: " + subreview.getItemName());
				}
			}
		}

		// 데일리 리뷰 등록 완료 후 연속 출석(스트릭) 갱신
		memberDAO.updateStreakCount(formDTO.getUserId());

		return generatedReviewId;
	}

	@Override
	public int saveDailyReviewImage(DailyReviewImage dailyReviewImage) {

		int result = dailyReviewDAO.saveDailyReviewImage(dailyReviewImage);

		return result;
	}

	@Override
	public DailyReviewImage findDailyReviewImageByReviewId(long reviewId) {

		DailyReviewImage dailyReviewImage = dailyReviewDAO.findDailyReviewImageByReviewId(reviewId);

		return dailyReviewImage;
	}

	@Override
	public DailyReviewFormDTO findReviewDetailByReviewId(long reviewId) {

		DailyReviewFormDTO formDTO = dailyReviewDAO.findReviewDetailByReviewId(reviewId);

		return formDTO;
	}

	@Override
	public List<DailyReviewFormDTO> findDailyReviewsByUserId(String userId) {

		return dailyReviewDAO.findDailyReviewsByUserId(userId);
	}

	// MY 페이지 - 데일리 기록별 서브 리뷰 조회
	@Override
	public List<SubReviewDTO> findSubReviewsByReviewId(Long reviewId) {

		return subReviewDAO.findSubReviewsByReviewId(reviewId);
	}

	// MY 페이지 - 내가 작성한 전체 서브 리뷰 조회
	@Override
	public List<SubReviewDTO> findSubReviewsByUserId(String userId) {

		return subReviewDAO.findSubReviewsByUserId(userId);
	}

	// MY 페이지 - 내가 좋아요한 리뷰 개수
	@Override
	public int countLikesByUserId(String userId) {

		return likeDAO.countLikesByUserId(userId);
	}

	// MY 페이지 - 내가 좋아요한 리뷰 목록
	@Override
	public List<DailyReviewFormDTO> findLikedReviewsByUserId(String userId) {
		return likeDAO.findLikedReviewsByUserId(userId);
	}

	/*
	 * ========================================= 
	 * MY 페이지 - 데일리 리뷰 삭제
	 * 
	 * 삭제 순서 1. 서브 리뷰 2. 댓글 3. 좋아요 4. 리뷰 이미지 정보 5. 데일리 리뷰
	 * =========================================
	 */
	@Override
	@Transactional(rollbackFor = Exception.class)
	public int deleteDailyReviewByReviewId(long reviewId) {

		/* 1. 해당 리뷰의 서브 리뷰 전체 삭제 */
		subReviewDAO.deleteSubReviewsByReviewId(reviewId);

		/* 2. 해당 리뷰의 댓글 전체 삭제 */
		commentDAO.deleteCommentsByReviewId(reviewId);

		/* 3. 해당 리뷰의 좋아요 전체 삭제 */
		likeDAO.deleteLikesByReviewId(reviewId);

		/* 4. 해당 리뷰의 이미지 정보 삭제 */
		dailyReviewDAO.deleteDailyReviewImageByReviewId(reviewId);

		/* 5. 부모 데일리 리뷰 삭제 */
		int result = dailyReviewDAO.deleteDailyReviewByReviewId(reviewId);

		/* 부모 리뷰 삭제 실패 시 전체 롤백 */
		if (result == 0) {

			throw new RuntimeException("데일리 리뷰 삭제에 실패했습니다.");
		}

		return result;
	}

	/*
	 * ========================================= 
	 * 데일리 리뷰 수정 (메인 리뷰, 서브 리뷰 재등록, 이미지 처리)
	 * =========================================
	 */
	@Override
	@Transactional(rollbackFor = Exception.class)
	public int updateDailyReviewWithSubReviews(DailyReviewFormDTO formDTO, String deleteMainImage) {
		long reviewId = formDTO.getReviewId();

		// 1. 기존 리뷰 정보 조회
		DailyReviewFormDTO existingReview = dailyReviewDAO.findReviewDetailByReviewId(reviewId);
		if (existingReview == null) {
			throw new RuntimeException("수정할 데일리 리뷰가 존재하지 않습니다.");
		}

		// 2. 대표 이미지 처리
		MultipartFile file = formDTO.getMainImageFile();

		if (file != null && !file.isEmpty()) {
			// [경우 1] 새 이미지 파일이 업로드된 경우
			try {
				FileInfo fileInfo = FileManager.storeFile(file, "images/reviews/");
				int saveFileResult = fileDAO.saveFileInfo(fileInfo);

				if (saveFileResult > 0) {
					// 기존 리뷰 이미지 매핑 정보 삭제 후 신규 등록
					dailyReviewDAO.deleteDailyReviewImageByReviewId(reviewId);

					DailyReviewImage imageInfo = new DailyReviewImage();
					imageInfo.setReviewId(reviewId);
					imageInfo.setFileName(fileInfo.getFileName());
					int saveImgResult = dailyReviewDAO.saveDailyReviewImage(imageInfo);

					if (saveImgResult == 0) {
						throw new RuntimeException("리뷰 이미지 정보 저장에 실패했습니다.");
					}

					formDTO.setMainImageUrl(fileInfo.getUrlFilePath() + fileInfo.getFileName());
				} else {
					throw new RuntimeException("파일 메타데이터 저장에 실패했습니다.");
				}
			} catch (IllegalStateException | IOException e) {
				e.printStackTrace();
				throw new RuntimeException("사진 저장에 실패했습니다.", e);
			}
		} else if ("Y".equalsIgnoreCase(deleteMainImage)) {
			// [경우 2] 새 이미지는 없으나 기존 이미지 삭제를 요청한 경우
			dailyReviewDAO.deleteDailyReviewImageByReviewId(reviewId);
			formDTO.setMainImageUrl(null);
		} else {
			// [경우 3] 이미지 변경 없음 (기존 이미지 URL 유지)
			formDTO.setMainImageUrl(existingReview.getMainImageUrl());
		}

		// 3. 메인 데일리 리뷰 UPDATE
		int updateCount = dailyReviewDAO.updateDailyReview(formDTO);
		if (updateCount == 0) {
			throw new RuntimeException("메인 데일리 리뷰 수정에 실패했습니다.");
		}

		// 4. 서브 리뷰 Delete & Re-insert (삭제 후 재등록)
		// 4-1. 기존 서브 리뷰 전체 삭제
		subReviewDAO.deleteSubReviewsByReviewId(reviewId);

		// 4-2. 전달받은 새로운 서브 리뷰 목록 재등록
		if (formDTO.getSubReviews() != null && !formDTO.getSubReviews().isEmpty()) {
			for (SubReviewDTO subReview : formDTO.getSubReviews()) {
				if (subReview == null) continue;
				// 항목명이 비어있는 서브리뷰는 등록하지 않음
				if (subReview.getItemName() == null || subReview.getItemName().trim().isEmpty()) {
					continue;
				}
				subReview.setReviewId(reviewId);

				int saveSubResult = subReviewDAO.saveSubReview(subReview);
				if (saveSubResult == 0) {
					throw new RuntimeException("서브 리뷰 저장 실패로 전체 롤백 처리합니다. 항목: " + subReview.getItemName());
				}
			}
		}

		return updateCount;
	}

	/*
	 * ========================================= 
	 * 메인 피드 - 공개 데일리 리뷰 목록 페이징 및 정렬 조회
	 * =========================================
	 */
	@Override
	public Map<String, Object> getPublicReviewFeedPaging(int page, int size, String sort, String loginUserId) {
		if (page < 1) page = 1;
		if (size < 1) size = 5;
		if (sort == null || (!sort.equals("latest") && !sort.equals("rating"))) {
			sort = "latest";
		}

		int offset = (page - 1) * size;

		Map<String, Object> params = new HashMap<>();
		params.put("offset", offset);
		params.put("size", size);
		params.put("sort", sort);

		List<DailyReviewFormDTO> reviews = dailyReviewDAO.findPublicReviewFeed(params);
		int totalCount = dailyReviewDAO.countPublicReviewFeed();

		// 서브 리뷰 목록 및 로그인 유저의 좋아요 상태 바인딩
		if (reviews != null && !reviews.isEmpty()) {
			for (DailyReviewFormDTO review : reviews) {
				// 서브 리뷰 목록 매핑
				review.setSubReviews(subReviewDAO.findSubReviewsByReviewId(review.getReviewId()));

				// 요일 매핑 (예: "수요일", "목요일")
				if (review.getReviewDate() != null) {
					review.setDayOfWeek(DateUtil.DateToDayOfWeek(review.getReviewDate()));
				}

				// 로그인 사용자 좋아요 여부 매핑
				if (loginUserId != null) {
					LikeRequestDTO likeDto = new LikeRequestDTO();
					likeDto.setUserId(loginUserId);
					likeDto.setReviewId(review.getReviewId());
					review.setLikedByMe(likeDAO.checkExists(likeDto) > 0);
				} else {
					review.setLikedByMe(false);
				}
			}
		}

		boolean hasMore = (offset + (reviews != null ? reviews.size() : 0)) < totalCount;

		Map<String, Object> result = new HashMap<>();
		result.put("reviews", reviews);
		result.put("totalCount", totalCount);
		result.put("hasMore", hasMore);
		result.put("page", page);
		result.put("size", size);
		result.put("sort", sort);

		return result;
	}
	
	 // 메인 페이지 - 서브 리뷰 카테고리별 등록 건수 집계
	@Override
	public CategoryCountDTO findCategoryCounts() {
		return subReviewDAO.findCategoryCounts();
	}

	// 작성자 및 일자 기준 데일리 리뷰 단건/중복 조회
	@Override
	public DailyReviewFormDTO findReviewByUserIdAndDate(String userId, String reviewDate) {
		Map<String, Object> params = new HashMap<>();
		params.put("userId", userId);
		params.put("reviewDate", reviewDate);
		return dailyReviewDAO.findReviewByUserIdAndDate(params);
	}
}