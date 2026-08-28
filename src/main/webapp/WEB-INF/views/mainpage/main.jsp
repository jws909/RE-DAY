	<%@ page language="java" contentType="text/html; charset=UTF-8"
		pageEncoding="UTF-8"%>
	<!DOCTYPE html>
	<html>
	<head>
	<meta charset="UTF-8">
	<title>RE:DAY - 당신의 오늘 하루는 어땠나요?</title>
	<%@ include file="/WEB-INF/views/include/head.jsp"%>
	<link href="/css/mainpage/mainpage.css" rel="stylesheet">
	<script src="/js/mainpage/mainpage.js"></script>
	<link rel="stylesheet"
		href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0" />
	</head>
<body>
	<!-- 상단 네비게이션 바 불러오기 -->
	<%@ include file="/WEB-INF/views/include/navbar.jsp"%>
	<div class="mp_container">
		<!--상단바 -->
		<div class="mp_top_column">
			<div class="mp_top_left_column">
				<div class="mp_t_left_top mb-2">✨RE:DAY 데일리 라이프 리뷰</div>
				<div class="mp_t_left_middle">
					<h1 class="text-2xl sm:text-3xl font-bold">오늘 하루의 평점과 경험을
						기록하세요</h1>
				</div>
				<div class="mp_t_left_bottom">하루 전체의 삶을 별점으로 기록하고, 방문한 맛집/사용한
					전자기기/탑승한 차량 등 세부 서브 리뷰를 함께 남겨보세요.</div>
			</div>
			<div class="mp_top_right_column">
				<button type="button">
					<span class="material-symbols-outlined">add</span>오늘의 하루 리뷰 작성하기
				</button>
			</div>
		</div>
		<div class="mp_bottom_column">
			<div class="mp_bottom_main">
				<!-- 정렬&필터바 -->
				<div class="sort_filter_bar">
					<div class="sort_filter_left">
						<span class="material-symbols-outlined">sort</span>정렬
						<div class="filter_button">
							<button type="button" class="active">최신 날짜순</button>
							<button type="button">하루 평점 높은순</button>
						</div>
					</div>
					<div class="sort_filter_right">총 n개의 하루 리뷰</div>
				</div>
				<!-- 메인 리뷰 카드 -->
				<div class="main_review_container">
					<div class="mp_review_card">
						<div class="mp_review_header">
							<div class="mp_review_author_info">
								<div class="mp_author_avatar font-mono"></div>
								<div class="mp_author_meta">
									<div class="mp_author_name_row">
										<span class="mp_author_name">승북이</span> <span
											class="mp_author_level font-mono">lv.100 집에 얼른 가고 싶은
											군산 출신 막내 팀장</span> <span class="mp_author_badge">5</span>
									</div>
									<div class="mp_review_date_row">
										<span class="material-symbols-outlined">calendar_today</span>
										<span class="font-mono">2026-09-08</span> <span
											class="mp_today_badge font-mono">TODAY</span>
									</div>
								</div>
							</div>

							<div class="mp_review_score_box">
								<span class="mp_score_title">오늘의 하루 평점</span>
								<div class="mp_score_stars">
									<span class="material-symbols-outlined star_fill">star</span> <span
										class="font-mono font-bold">5</span>
								</div>
							</div>
						</div>
						<div class="mp_mood_tags_wrapper">
							<span class="mp_mood_tag">피곤함</span>
						</div>
						<p class="mp_review_summary">집 가고 싶다~!!! 집 가고 싶다~!!!집 가고
							싶다~!!!집 가고 싶다~!!!집 가고 싶다~!!!</p>

						<div class="mp_review_image_placeholder">
							<span class="material-symbols-outlined">image</span>
							<p class="placeholder_title">'[오늘 하루 대표 이미지 영역]' :</p>
							<span class="placeholder_sub">일기 대표 컷 / 장소 뷰 / 하이라이트 사진</span>
						</div>

						<!-- 서브 리뷰 목록 리본 -->
						<div class="mp_sub_reviews_container">
							<div class="mp_sub_reviews_header">
								<div class="mp_sub_reviews_title">
									<span class="material-symbols-outlined">layers</span> <span>이
										날의 서브 리뷰 (n개)</span>
								</div>
								<span class="mp_sub_reviews_caption font-mono">세부 평가 항목</span>
							</div>

							<div class="mp_sub_reviews_grid">
								<div class="mp_sub_review_item">
									<div class="mp_sub_item_left">
										<span class="mp_category_badge">카테고리 뱃지</span> <span
											class="mp_sub_item_name">그냥 사람1</span> <span
											class="material-symbols-outlined icon_verified">check_circle</span>
									</div>
									<div class="mp_sub_item_right">
										<span class="material-symbols-outlined star_fill">star</span>
										<span class="font-mono font-bold">5</span>
									</div>
								</div>
							</div>
						</div>
						<div class="mp_review_footer">
							<div class="mp_interaction_group">
								<button type="button" class="mp_action_btn">
									<span class="material-symbols-outlined icon_heart">favorite</span>
									<span class="font-mono">100</span>
								</button>
								<span class="mp_action_info"> <span
									class="material-symbols-outlined">chat_bubble</span> <span>댓글
										100</span>
								</span>
							</div>
							<div class="mp_detail_link">
								<span>상세 보기</span> <span class="material-symbols-outlined">arrow_forward</span>
							</div>
						</div>
					</div>
				</div>

			</div>
			<div class="mp_bottom_side">
				<!-- 하루 평점 통계표 -->
				<div class="mp_day_rating_static">
					<div class="day_rating_header">
						<div class="day_rating_title">
							<span class="material-symbols-outlined symbol1">license</span>
							<h4 class="text-sm font-bold">내 하루 평점 통계</h4>
							<span class="material-symbols-outlined">chevron_right</span>
						</div>
						<span class="day_rating_sub_text">최근 7일</span>
					</div>
					<div class="average_daily_score_card">
						<div class="score_info_left">
							<span class="score_label">이번 주 평균 하루 점수</span>
							<div class="score_val_wrapper">
								<span class="score_main font-mono">n</span> <span
									class="score_total font-mono">/ n</span>
							</div>
						</div>
						<div class="score_info_right">
							<span class="score_badge">+n점 상승 ↗</span> <span
								class="sub_review_cnt">서브 리뷰 n개 등록</span>
						</div>
					</div>
					<div class="weekly_chart_wrapper">
						<div class="week_days_label">
							<span>월</span><span>화</span><span>수</span><span>목</span><span>금</span><span>토</span><span>일</span>
						</div>
						<div class="chart_bars_container">
							<div class="bar_item" style="height: 60%;" data-score="3.0"></div>
							<div class="bar_item" style="height: 75%;" data-score="3.8"></div>
							<div class="bar_item" style="height: 95%;" data-score="4.8"></div>
							<div class="bar_item" style="height: 70%;" data-score="3.5"></div>
							<div class="bar_item" style="height: 85%;" data-score="4.2"></div>
							<div class="bar_item" style="height: 100%;" data-score="5.0"></div>
							<div class="bar_item" style="height: 80%;" data-score="4.0"></div>
						</div>
					</div>
				</div>
				<!-- 서브 리뷰 카테고리 필터 -->
				<div class="mp_sub_review_category_filter">
					<div class="sub_review_category_filter_header">
						<div class="sub_review_category_filter_title">
							<span class="material-symbols-outlined">trending_up</span>
							<h4 class="text-sm font-bold">서브 리뷰 카테고리 필터</h4>
						</div>
					</div>
					<button type="button"
						class="sub_review_category_filter_card active">
						<div class="sub_review_category_filter_info_left">
							<span class="sub_review_category_filter_label">전체 리뷰 보기</span>
						</div>
						<div class="sub_review_category_filter_info_right">
							<span class="sub_review_category_filter_score font-mono active">n</span>
						</div>
					</button>
					<button type="button" class="sub_review_category_filter_card">
						<div class="sub_review_category_filter_info_left">
							<span class="sub_review_category_filter_label">☕장소·식당·카페</span>
						</div>
						<div class="sub_review_category_filter_info_right">
							<span class="sub_review_category_filter_score font-mono">n</span>
						</div>
					</button>
					<button type="button" class="sub_review_category_filter_card">
						<div class="sub_review_category_filter_info_left">
							<span class="sub_review_category_filter_label">💻아이템·기기</span>
						</div>
						<div class="sub_review_category_filter_info_right">
							<span class="sub_review_category_filter_score font-mono">n</span>
						</div>
					</button>
					<button type="button" class="sub_review_category_filter_card">
						<div class="sub_review_category_filter_info_left">
							<span class="sub_review_category_filter_label">🚗이동수단·모빌리티</span>
						</div>
						<div class="sub_review_category_filter_info_right">
							<span class="sub_review_category_filter_score font-mono">n</span>
						</div>
					</button>
					<button type="button" class="sub_review_category_filter_card">
						<div class="sub_review_category_filter_info_left">
							<span class="sub_review_category_filter_label">🎬콘텐츠·미디어</span>
						</div>
						<div class="sub_review_category_filter_info_right">
							<span class="sub_review_category_filter_score font-mono">n</span>
						</div>
					</button>
				</div>
			</div>
		</div>
	</div>
</body>
</html>