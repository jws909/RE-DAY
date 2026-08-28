<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<link href="/css/mainpage/explore.css" rel="stylesheet">
<link rel="stylesheet"
	href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0" />
<script src="/js/mainpage/explore.js"></script>
</head>
<body>
	<!-- 상단 네비게이션 바 불러오기 -->
	<%@ include file="/WEB-INF/views/include/navbar.jsp"%>
	<div class="ex_container">
		<!--상단바 -->
		<div class="ex_top_column">
			<div class="ex_t_top mb-2">✨라이프스타일 탐색 & 트렌드</div>
			<div class="ex_t_middle">
				<h1 class="text-2xl sm:text-3xl font-bold">다른 사람들의 하루와 실제 라이프
					트렌드를 탐색하세요</h1>
			</div>
			<div class="ex_t_bottom">주관적인 평점 순위 대신, 꾸준히 기록을 이어가는 유저들의 일기에
				가장 많이 등장한 실사용 장소·아이템 트렌드를 확인해보세요.</div>
		</div>
		<div class="ex_bottom_column">
			<!-- 라이프스타일 테마 필터 바 -->
			<div class="ex_theme_filter_section">
				<div class="ex_theme_header">
					<div class="ex_theme_title">
						<span class="material-symbols-outlined icon_compass">explore</span>
						<span class="title_text">라이프스타일 테마별 하루 엿보기</span>
					</div>
					<span class="ex_theme_sub font-mono">관심 있는 키워드로 둘러보기</span>
				</div>

				<div class="ex_theme_list">
					<button type="button" class="ex_theme_btn active">
						<span class="theme_label">전체 둘러보기</span> <span
							class="theme_count font-mono">1.2k+</span>
					</button>
					<button type="button" class="ex_theme_btn">
						<span class="theme_label">💻 재택 & 생산성 데이</span> <span
							class="theme_count font-mono">342</span>
					</button>
					<button type="button" class="ex_theme_btn">
						<span class="theme_label">☕ 주말 카페 & 핫플</span> <span
							class="theme_count font-mono">489</span>
					</button>
					<button type="button" class="ex_theme_btn">
						<span class="theme_label">🏃 오운완 & 미라클모닝</span> <span
							class="theme_count font-mono">215</span>
					</button>
					<button type="button" class="ex_theme_btn">
						<span class="theme_label">🚗 야간 드라이브 & 여행</span> <span
							class="theme_count font-mono">178</span>
					</button>
					<button type="button" class="ex_theme_btn">
						<span class="theme_label">🎬 집콕 넷플릭스 & 휴식</span> <span
							class="theme_count font-mono">164</span>
					</button>
				</div>
			</div>

			<!-- 하단 2열 컨텐츠 영역 -->
			<div class="ex_b_bottom_column">
				<!-- 좌측: 연속 기록 스트릭 챌린저 -->
				<div class="ex_bottom_left">
					<div class="ex_section_header">
						<div class="ex_section_title">
							<span class="material-symbols-outlined icon_flame">local_fire_department</span>
							<h2 class="text-lg font-bold">연속 기록 스트릭(Streak)</h2>
						</div>
						<span class="ex_badge_orange font-mono">꾸준한 기록러</span>
					</div>
					<p class="ex_section_desc">
						평점이 아닌 <strong>매일 하루를 빼놓지 않고 기록</strong>하며 삶을 성실히 채워가는 유저들입니다.
					</p>

					<!-- 스트릭 챌린저 목록 -->
					<div class="ex_challenger_list">
						<div class="ex_challenger_card">
							<div class="ex_challenger_info">
								<!-- 좌측 스트릭 박스 -->
								<div class="ex_streak_box">
									<span class="material-symbols-outlined icon_flame">local_fire_department</span>
									<span class="streak_day font-mono">28일</span>
								</div>
								<!-- 중앙 유저 메타 정보 -->
								<div class="ex_challenger_meta">
									<div class="meta_row_top">
										<h3 class="ex_challenger_name">승북이</h3>
										<span class="streak_badge">👑 28일 연속 기록</span>
									</div>
									<div class="meta_row_bottom">
										<span class="user_level font-mono">Lv.10 2006년생 막내 팀장</span> <span
											class="dot">•</span> <span class="review_stats">기록 28편
											(서브 84개)</span>
									</div>
								</div>
							</div>
							<!-- 우측 응원 버튼 -->
							<button type="button" class="ex_cheer_btn">
								<span class="material-symbols-outlined icon_heart">favorite</span>
								<span>응원 128</span>
							</button>
						</div>
					</div>

					<!-- 스트릭 유도 배너 -->
					<div class="ex_streak_banner">
						<div class="banner_title">
							<span class="material-symbols-outlined">event_available</span> <span>나도
								스트릭 챌린지 시작하기</span>
						</div>
						<p class="banner_desc">오늘의 하루를 리뷰하면 1일차 불꽃 뱃지가 활성화됩니다. 7일 연속
							작성 시 '주간 루틴 마스터' 뱃지가 부여됩니다.</p>
					</div>
				</div>

				<!-- 우측: 이번 주 최다 언급 아이템 & 장소 -->
				<div class="ex_bottom_right">
					<div class="ex_section_header">
						<div class="ex_section_title">
							<span class="material-symbols-outlined icon_blue">trending_up</span>
							<h2 class="text-lg font-bold">이번 주 최다 언급 아이템 & 장소</h2>
						</div>
						<span class="ex_badge_blue font-mono">실사용 데이터 기반</span>
					</div>
					<p class="ex_section_desc">
						단순 주관적 별점이 아닌, <strong>실제 유저들의 일기 속에 가장 많이 기록되고 내돈내산 인증된</strong>
						핫 아이템/장소입니다.
					</p>

					<!-- 카테고리 탭 버튼 -->
					<div class="ex_curation_tab_bar">
						<button type="button" onclick="filterCuration('all')" id="tab-all"
							class="ex_curation_tab active">전체 트렌드</button>
						<button type="button" onclick="filterCuration('item')"
							id="tab-item" class="ex_curation_tab">💻 전자기기/아이템</button>
						<button type="button" onclick="filterCuration('place')"
							id="tab-place" class="ex_curation_tab">☕ 핫플 장소/카페</button>
						<button type="button" onclick="filterCuration('transport')"
							id="tab-transport" class="ex_curation_tab">🚗 모빌리티/차량</button>
					</div>

					<!-- 큐레이션 카드 그리드 -->
					<div class="ex_curation_grid" id="curation-list">
						<div class="ex_curation_card" data-category="item">
							<div class="card_header">
								<span class="category_label">💻 전자기기/아이템</span> <span
									class="mention_cnt font-mono">언급 248회</span>
							</div>
							<h4 class="curation_title">로지텍 MX Master 3S</h4>
							<p class="curation_desc">재택/생산성 데이 일기에 가장 많이 등장한 무소음 마우스</p>
						</div>
						<div class="ex_curation_card" data-category="place">
							<div class="card_header">
								<span class="category_label">☕ 핫플 장소/카페</span> <span
									class="mention_cnt font-mono">언급 182회</span>
							</div>
							<h4 class="curation_title">블루보틀 삼청 한옥</h4>
							<p class="curation_desc">주말 카페 탐방 기록 1위, 고즈넉한 뷰와 드립 커피</p>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>