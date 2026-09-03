<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>오늘의 하루 리뷰 작성 - RE:DAY</title>

<!-- 공통 Head 태그 (Tailwind & Font Awesome 포함) -->
<%@ include file="/WEB-INF/views/include/head.jsp"%>

<!-- 리뷰 작성 전용 스타일시트 분리 -->
<link href="<%=request.getContextPath()%>/css/write/writeReview.css"
	rel="stylesheet">
</head>
<body
	class="bg-slate-100 text-slate-900 min-h-screen pb-12 font-sans antialiased">

	<!-- 상단 네비게이션 바 불러오기 (상단 여백 없이 top-0에 밀착) -->
	<%@ include file="/WEB-INF/views/include/navbar.jsp"%>

	<div class="max-w-4xl mx-auto px-4 sm:px-6 space-y-8">

		<!-- ========================================================================= -->
		<!-- Header: 돌아가기 & 타이틀 영역 (요일 뱃지 포함) -->
		<!-- ========================================================================= -->
		<header
			class="flex items-center justify-between pb-4 border-b-2 border-dashed border-slate-300">
			<div>
				<a href="javascript:history.back()"
					class="inline-flex items-center gap-1.5 text-xs text-slate-500 hover:text-slate-900 mb-1 font-mono transition-colors">
					<i class="fa-solid fa-arrow-left text-xs"></i> <span>돌아가기</span>
				</a>
				<h1
					class="text-xl sm:text-2xl font-bold text-slate-900 flex items-center gap-2">
					<span>오늘의 하루 리뷰 작성</span> <span
						class="text-xs bg-slate-200 text-slate-700 px-2 py-0.5 rounded font-mono font-normal">
						1:N 서브 리뷰 시스템 </span>
				</h1>
			</div>

			<div class="text-right">
				<span
					class="inline-flex items-center gap-1.5 text-xs text-slate-600 font-mono bg-white px-2.5 py-1 rounded-md border border-dashed border-slate-300 shadow-xs">
					<i class="fa-regular fa-calendar text-slate-400"></i> <span
					id="headerDayOfWeek"></span>
				</span>
			</div>
		</header>

		<!-- ========================================================================= -->
		<!-- Spring MVC 메인 폼 전송 영역 (멀티파트 지원) -->
		<!-- ========================================================================= -->
		<form id="reviewForm"
			action="<%=request.getContextPath()%>/review/write" method="post"
			enctype="multipart/form-data" class="space-y-8">

			<!-- Spring MVC Controller 바인딩용 Hidden 필드 (기본값 제거) -->
			<input type="hidden" id="totalRatingInput" name="totalRating"
				value="0.0" /> <input type="hidden" id="moodTagsInput"
				name="moodTags" value="" /> <input type="hidden" id="isPublicInput"
				name="isPublic" value="Y" /> <input type="hidden"
				id="subReviewsJsonInput" name="subReviewsJson" value="" />

			<!-- 서브 리뷰 1:N List DTO 자동 바인딩 컨테이너 -->
			<div id="subReviewsHiddenContainer"></div>

			<!-- ========================================================================= -->
			<!-- SECTION 1: Main Daily Review (메인 데일리 리뷰) -->
			<!-- ========================================================================= -->
			<section
				class="border-2 border-dashed border-slate-300 rounded-2xl bg-white p-6 space-y-6 shadow-xs">
				<div
					class="flex items-center justify-between pb-3 border-b border-slate-200">
					<div class="flex items-center gap-2">
						<span
							class="w-6 h-6 rounded-full bg-slate-900 text-white font-mono text-xs flex items-center justify-center font-bold">
							1 </span>
						<h2 class="font-bold text-base text-slate-900">메인 데일리 리뷰 (오늘
							하루 종합)</h2>
					</div>
					<span
						class="text-xs font-mono text-blue-600 bg-blue-50 px-2 py-0.5 rounded border border-blue-200">
						필수 입력 </span>
				</div>

				<!-- Date & Total Score -->
				<div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
					<div>
						<label
							class="block text-xs font-bold text-slate-700 mb-1.5 flex items-center gap-1.5">
							<i class="fa-regular fa-calendar-days text-slate-400"></i> <span>리뷰
								일자</span>
						</label> <input type="date" id="reviewDate" name="reviewDate" required
							class="w-full px-3 py-2 border-2 border-dashed border-slate-300 rounded-lg text-sm font-mono focus:outline-none focus:border-slate-800 bg-slate-50" />
					</div>

					<div>
						<label
							class="block text-xs font-bold text-slate-700 mb-1.5 flex items-center gap-1.5">
							<i class="fa-solid fa-wand-magic-sparkles text-amber-500"></i> <span>오늘
								하루 종합 평점 (별점 클릭)</span>
						</label>
						<div
							class="flex items-center justify-between p-2 bg-amber-50/60 border border-dashed border-amber-300 rounded-lg">
							<div id="mainStarContainer"
								class="inline-flex items-center gap-1 select-none">
								<!-- JS 별점 렌더링 -->
							</div>
							<span id="mainScoreText"
								class="text-slate-700 text-sm font-semibold font-mono">
								0.0 <span class="text-slate-400 font-normal">/ 5.0</span>
							</span>
						</div>
					</div>
				</div>

				<!-- Mood / Tag Selector -->
				<div class="space-y-2">
					<label
						class="block text-xs font-bold text-slate-700 flex items-center gap-1.5">
						<i class="fa-solid fa-tag text-slate-400"></i> <span>오늘의 기분
							/ 상황 태그</span>
					</label>
					<div id="popularTagsList" class="flex flex-wrap gap-1.5">
						<!-- JS 태그 렌더링 -->
					</div>

					<!-- Custom Tag Input -->
					<div class="flex gap-2 pt-1 max-w-sm">
						<input type="text" id="customTagInput"
							placeholder="직접 태그 입력 (예: 개발몰입)"
							class="flex-1 px-3 py-1.5 text-xs border border-dashed border-slate-300 rounded-md bg-slate-50 focus:outline-none focus:border-slate-800"
							onkeydown="if(event.key==='Enter'){ event.preventDefault(); addCustomTag(); }" />
						<button type="button" onclick="addCustomTag()"
							class="px-3 py-1.5 bg-slate-800 text-white rounded-md text-xs font-semibold hover:bg-slate-900 transition-colors cursor-pointer">
							+ 추가</button>
					</div>
				</div>

				<!-- Daily Overall Comment Textarea -->
				<div class="space-y-1.5">
					<div class="flex items-center justify-between">
						<label class="block text-xs font-bold text-slate-700"> 오늘
							하루 총평 <span class="text-rose-500">*</span>
						</label> <span id="overallCommentCharCount"
							class="text-[11px] font-mono text-slate-400">0 / 1,000자</span>
					</div>
					<textarea rows="4" id="overallCommentInput" name="overallComment"
						required maxlength="1000"
						oninput="document.getElementById('overallCommentCharCount').textContent = this.value.length + ' / 1,000자'"
						placeholder="오늘 하루 있었던 주요 일과와 총평을 일기처럼 자유롭게 적어주세요. (예: 오전엔 카페에서 생산적인 코딩, 오후엔 새로운 헤드폰 테스트와 저녁 드라이브...)"
						class="w-full p-3 border-2 border-dashed border-slate-300 rounded-lg text-sm focus:outline-none focus:border-slate-800 bg-slate-50/50 leading-relaxed font-sans"></textarea>
				</div>

				<!-- Representative Photo Upload with Real Live Thumbnail Preview -->
				<div class="space-y-1.5">
					<label
						class="block text-xs font-bold text-slate-700 flex items-center justify-between">
						<span>오늘 하루 대표 사진</span> <span
						class="text-[10px] text-slate-400 font-mono">JPG, PNG, GIF
							지원</span>
					</label>

					<!-- Hidden Real File Input -->
					<input type="file" id="mainImageFileInput" name="mainImageFile"
						accept="image/*" onchange="handleImageFileChange(this)"
						class="hidden" />

					<div
						class="p-3 border-2 border-dashed border-slate-300 rounded-lg bg-slate-50 space-y-2">
						<!-- Empty State Box (클릭 시 파일 선택) -->
						<div id="imageUploadEmptyBox"
							onclick="document.getElementById('mainImageFileInput').click()"
							class="h-28 border-2 border-dashed border-slate-300 hover:border-slate-400 rounded-lg bg-slate-100 flex flex-col items-center justify-center text-center p-3 cursor-pointer transition-colors group">
							<i
								class="fa-regular fa-image text-2xl text-slate-400 group-hover:text-blue-600 mb-1 transition-colors"></i>
							<span
								class="text-xs font-mono font-bold text-slate-600 group-hover:text-blue-600 transition-colors">
								[오늘 하루 대표 사진 등록하기] </span> <span
								class="text-[10px] text-slate-400 mt-0.5"> 클릭하여 사진 파일을
								첨부하세요 </span>
						</div>

						<!-- Selected Photo Preview Box -->
						<div id="imagePreviewBox"
							class="hidden flex items-center gap-3 bg-white p-2.5 rounded-lg border border-slate-200">
							<div
								class="w-20 h-20 rounded-md overflow-hidden bg-slate-200 shrink-0 border border-slate-300">
								<img id="previewImgElement" src="" alt="대표 사진 미리보기"
									class="w-full h-full object-cover" />
							</div>
							<div class="min-w-0 flex-1 space-y-1">
								<p id="previewFileName"
									class="text-xs font-mono font-bold text-slate-800 truncate"></p>
								<p id="previewFileSize"
									class="text-[10px] font-mono text-slate-400"></p>
								<div class="pt-1 flex items-center gap-2">
									<button type="button"
										onclick="document.getElementById('mainImageFileInput').click()"
										class="px-2 py-0.5 bg-slate-100 hover:bg-slate-200 border border-slate-300 text-slate-700 rounded text-xs font-mono transition-colors">
										사진 교체</button>
									<button type="button" onclick="removeSelectedImage()"
										class="px-2 py-0.5 bg-rose-50 hover:bg-rose-100 border border-rose-200 text-rose-600 rounded text-xs font-mono transition-colors">
										삭제</button>
								</div>
							</div>
						</div>
					</div>
				</div>
			</section>

			<!-- ========================================================================= -->
			<!-- SECTION 2: Sub-Reviews System (1 : N 세부 리뷰 카드) -->
			<!-- ========================================================================= -->
			<section
				class="border-2 border-dashed border-blue-300 rounded-2xl bg-blue-50/30 p-6 space-y-6 shadow-xs">
				<div
					class="flex flex-wrap items-center justify-between gap-3 pb-3 border-b border-blue-200">
					<div>
						<div class="flex items-center gap-2">
							<span
								class="w-6 h-6 rounded-full bg-blue-600 text-white font-mono text-xs flex items-center justify-center font-bold">
								2 </span>
							<h2 class="font-bold text-base text-slate-900">서브 리뷰 시스템 (1
								: N 세부 리뷰)</h2>
						</div>
						<p class="text-xs text-slate-500 mt-0.5">오늘 하루 동안 경험한 장소, 사용한
							제품, 이동수단 등을 개별 카드로 추가하세요.</p>
					</div>

					<button type="button" onclick="openSubReviewForm()"
						class="inline-flex items-center gap-1.5 px-3.5 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg text-xs font-bold shadow-xs transition-colors cursor-pointer">
						<i class="fa-solid fa-plus text-xs"></i> <span>+ 서브 리뷰 추가</span>
					</button>
				</div>

				<!-- Current Sub-reviews List -->
				<div id="subReviewsList" class="space-y-4">
					<!-- JS 동적 렌더링 영역 -->
				</div>

				<!-- ===================================================================== -->
				<!-- Sub Review Builder Form (새 서브 리뷰 작성 모달/폼 박스) -->
				<!-- ===================================================================== -->
				<div id="subReviewFormBox"
					class="hidden border-2 border-dashed border-blue-400 rounded-xl bg-white p-5 space-y-4 shadow-md">
					<div
						class="flex items-center justify-between pb-2 border-b border-slate-200">
						<span
							class="font-bold text-sm text-slate-900 flex items-center gap-1.5">
							<i class="fa-solid fa-layer-group text-blue-600"></i> 새 서브 리뷰 작성
						</span>
						<button type="button" onclick="closeSubReviewForm()"
							class="text-slate-400 hover:text-slate-600 text-xs font-mono cursor-pointer">
							닫기 ✕</button>
					</div>

					<!-- Category Selector Tabs -->
					<div class="space-y-1.5">
						<label class="block text-xs font-bold text-slate-700">
							카테고리 선택 </label>
						<div class="grid grid-cols-2 sm:grid-cols-4 gap-2"
							id="categoryTabGroup">
							<button type="button" onclick="selectCategory('place')"
								data-cat="place"
								class="cat-btn flex items-center justify-center gap-1.5 py-2 px-3 rounded-lg text-xs font-bold border transition-all bg-blue-600 text-white border-blue-600 shadow-xs cursor-pointer">
								<i class="fa-solid fa-mug-saucer text-xs"></i> <span>장소/식당</span>
							</button>
							<button type="button" onclick="selectCategory('item')"
								data-cat="item"
								class="cat-btn flex items-center justify-center gap-1.5 py-2 px-3 rounded-lg text-xs font-medium border transition-all bg-slate-50 text-slate-700 border-slate-300 hover:bg-slate-100 cursor-pointer">
								<i class="fa-solid fa-laptop text-xs"></i> <span>아이템/기기</span>
							</button>
							<button type="button" onclick="selectCategory('transport')"
								data-cat="transport"
								class="cat-btn flex items-center justify-center gap-1.5 py-2 px-3 rounded-lg text-xs font-medium border transition-all bg-slate-50 text-slate-700 border-slate-300 hover:bg-slate-100 cursor-pointer">
								<i class="fa-solid fa-car text-xs"></i> <span>이동수단</span>
							</button>
							<button type="button" onclick="selectCategory('content')"
								data-cat="content"
								class="cat-btn flex items-center justify-center gap-1.5 py-2 px-3 rounded-lg text-xs font-medium border transition-all bg-slate-50 text-slate-700 border-slate-300 hover:bg-slate-100 cursor-pointer">
								<i class="fa-solid fa-clapperboard text-xs"></i> <span>미디어/콘텐츠</span>
							</button>
						</div>
					</div>

					<!-- Item Name -->
					<div class="space-y-1.5">
						<label class="block text-xs font-bold text-slate-700"> 항목
							이름 / 모델명 <span class="text-rose-500">*</span>
						</label> <input type="text" id="itemNameInput"
							placeholder="예: 성수 어니언 카페, 소니 WH-1000XM5, 쏘카 아이오닉 5, 로지텍 마우스"
							class="w-full px-3 py-2 border-2 border-dashed border-slate-300 rounded-lg text-sm focus:outline-none focus:border-blue-600 bg-slate-50" />
					</div>

					<!-- Location or Brand & Sub Rating -->
					<div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
						<div>
							<label class="block text-xs font-bold text-slate-700 mb-1">
								위치 / 브랜드 / 구매처 </label> <input type="text" id="locationBrandInput"
								placeholder="예: 서울 성동구 성수동, 공식 스토어, 넷플릭스"
								class="w-full px-3 py-1.5 border border-slate-300 rounded-md text-xs bg-slate-50 focus:outline-none" />
						</div>

						<div>
							<label class="block text-xs font-bold text-slate-700 mb-1">
								세부 별점 </label>
							<div
								class="p-1.5 bg-slate-50 border border-slate-300 rounded-md flex items-center justify-between">
								<div id="subStarContainer"
									class="inline-flex items-center gap-1 select-none">
									<!-- JS 동적 별점 -->
								</div>
								<span id="subScoreText"
									class="text-xs font-mono font-bold text-slate-700">0.0 /
									5.0</span>
							</div>
						</div>
					</div>

					<!-- Sub Comment -->
					<div class="space-y-1">
						<label class="block text-xs font-bold text-slate-700"> 세부
							리뷰 한줄평 / 후기 </label>
						<textarea rows="2" id="subCommentInput"
							placeholder="이 장소나 아이템에 대한 솔직한 평을 적어주세요."
							class="w-full p-2.5 border border-slate-300 rounded-md text-xs bg-slate-50 focus:outline-none"></textarea>
					</div>

					<!-- Sub Tags -->
					<div class="space-y-1">
						<label class="block text-xs font-bold text-slate-700"> 서브
							리뷰 태그 </label>
						<div class="flex gap-2">
							<input type="text" id="subTagInput"
								placeholder="태그 입력 (예: 노이즈캔슬링, 작업하기좋은)"
								class="flex-1 px-3 py-1.5 border border-slate-300 rounded-md text-xs bg-slate-50 focus:outline-none"
								onkeydown="if(event.key==='Enter'){ event.preventDefault(); addSubTag(); }" />
							<button type="button" onclick="addSubTag()"
								class="px-3 py-1.5 bg-slate-800 text-white rounded-md text-xs font-semibold hover:bg-slate-900 transition-colors cursor-pointer">
								+ 태그 추가</button>
						</div>
						<div id="currentSubTagsList" class="flex flex-wrap gap-1 pt-1"></div>
					</div>

					<!-- Verified Checkbox -->
					<div class="flex items-center gap-2 pt-1">
						<label
							class="flex items-center gap-2 cursor-pointer select-none text-xs font-semibold text-slate-800">
							<input type="checkbox" id="isCertifiedInput" checked
							class="w-4 h-4 text-blue-600 rounded border-slate-300 focus:ring-0 cursor-pointer" />
							<span class="flex items-center gap-1.5"> <i
								class="fa-solid fa-circle-check text-emerald-600"></i> 내돈내산 /
								영수증 인증 뱃지 표시
						</span>
						</label>
					</div>

					<!-- Action buttons -->
					<div
						class="flex items-center justify-end gap-2 pt-2 border-t border-slate-200">
						<button type="button" onclick="closeSubReviewForm()"
							class="px-3 py-1.5 text-xs text-slate-600 hover:text-slate-800 font-medium cursor-pointer">
							취소</button>
						<button type="button" onclick="saveSubReview()"
							class="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg text-xs font-bold shadow-xs cursor-pointer">
							서브 리뷰 카드 등록</button>
					</div>
				</div>
			</section>

			<!-- ========================================================================= -->
			<!-- Submit Bar: 발행 완료 버튼 -->
			<!-- ========================================================================= -->
			<div
				class="pt-4 flex flex-col sm:flex-row items-center justify-between gap-4 border-t-2 border-dashed border-slate-300">
				<p id="submitInfoText" class="text-xs text-slate-500 font-mono">
					* 등록 시 메인 데일리 리뷰 1건과 서브 리뷰 0건이 발행됩니다.</p>

				<label
					class="inline-flex items-center gap-2 cursor-pointer select-none bg-white px-3.5 py-2.5 rounded-xl border border-dashed border-slate-300 hover:border-slate-400 transition-colors shadow-xs">
					<span class="text-xs font-bold text-slate-700">공개 여부</span> <input
					type="checkbox" id="singlePublicCheckbox" checked
					onchange="handleSinglePublicToggle(this)"
					class="w-4 h-4 text-blue-600 bg-slate-100 border-slate-300 rounded focus:ring-blue-500 cursor-pointer" />
				</span>
				</label>



				<button type="submit"
					class="w-full sm:w-auto px-8 py-3.5 bg-slate-900 hover:bg-slate-800 text-white font-bold rounded-xl text-sm shadow-md transition-all flex items-center justify-center gap-2 cursor-pointer">
					<i class="fa-solid fa-check text-sm"></i> <span>하루 리뷰 발행 완료</span>
				</button>
			</div>
		</form>
	</div>

	<!-- 리뷰 작성 전용 스크립트 분리 -->
	<script src="<%=request.getContextPath()%>/js/write/writeReview.js"></script>
</body>
</html>
