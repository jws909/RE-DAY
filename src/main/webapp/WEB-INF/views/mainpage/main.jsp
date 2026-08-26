<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<<<<<<< HEAD
<<<<<<< Updated upstream
=======
	<%@ include file="/WEB-INF/views/include/head.jsp"%>
>>>>>>> develop
	<link href = "/css/mainpage.css" rel="stylesheet">
	<script src= "/js/mainpage.js"></script>
	<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0" />
</head>
<body>
	<!-- 상단 네비게이션 바 불러오기 -->
	<%@ include file="/WEB-INF/views/include/navbar.jsp"%>
	<div class = mp_container>
		<!--상단바 -->
		<div class = "mp_top_column">
			<div class ="mp_top_left_column">
				<div class = "mp_t_left_top mb-2">	
					✨RE:DAY 데일리 라이프 리뷰
				</div>
				<div class = "mp_t_left_middle">
					<h1 class="text-2xl sm:text-3xl font-bold">오늘 하루의 평점과 경험을 기록하세요</h1>
				</div>
				<div class = "mp_t_left_bottom">
					하루 전체의 삶을 별점으로 기록하고, 방문한 맛집/사용한 전자기기/탑승한 차량 등 세부 서브 리뷰를 함께 남겨보세요.
=======
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<link href="/css/mainpage.css" rel="stylesheet">
<script src="/js/mainpage.js"></script>
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
>>>>>>> Stashed changes
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
								<span class="score_main font-mono">4.6</span> <span
									class="score_total font-mono">/ 5.0</span>
							</div>
						</div>
						<div class="score_info_right">
							<span class="score_badge">+0.3점 상승 ↗</span> <span
								class="sub_review_cnt">서브 리뷰 14개 등록</span>
						</div>
					</div>
					<div class="weekly_chart_wrapper">
						<div class="week_days_label">
							<span>월</span><span>화</span><span>수</span><span>목</span><span>금</span><span>토</span><span>일</span>
						</div>
						<div class="chart_bars_container">
							<!-- 높이(height)는 백엔드 값에 따라 퍼센트로 조절 가능 -->
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
			</div>
		</div>
	</div>
</body>
</html>