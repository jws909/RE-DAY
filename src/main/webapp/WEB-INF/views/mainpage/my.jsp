<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>RE:DAY - 당신의 오늘 하루는 어땠나요?</title>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<link href="/css/mainpage/my.css" rel="stylesheet">
<script src="/js/mainpage/my.js"></script>
<link rel="stylesheet"
	href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0" />
</head>
<body>
	<!-- 상단 네비게이션 바 -->
	<%@ include file="/WEB-INF/views/include/navbar.jsp"%>

	<div class="my_container">
		<!-- 상단 프로필 & 상태 바 -->
		<div class="my_top_column">
			<div class="my_challenger_card"">
				<div class="my_challenger_info"">
					<!-- 아바타 박스 -->
					<div class="my_streak_box">👤</div>
					<!-- 유저 정보 -->
					<div class="my_challenger_meta">
						<div class="meta_row_top">
							<h1 class="text-2xl font-bold">유저</h1>
							<span class="my_badge_blue font-mono">Lv.100 피곤에 쪄든 기록러</span> <span
								class="streak_badge"> <span
								class="material-symbols-outlined icon_flame">local_fire_department</span>
								1000일 연속 기록
							</span>
						</div>
						<div class="meta_row_bottom">
							<span class="font-mono text-slate-500">USER@EMAIL.COM</span>
						</div>
					</div>
				</div>

				<!-- 우측 액션 버튼 그룹 -->
				<div>
					<a href="${pageContext.request.contextPath}/write"
						class="my_theme_btn active"> <span
						class="material-symbols-outlined" style="font-size: 16px;">edit_square</span>
						오늘 하루 쓰기
					</a>
				</div>
			</div>
		</div>

		<div class="my_bottom_column">
			<!-- 통계 카드 바 -->
			<div class="my_theme_filter_section">
				<div class="my_theme_header">
					<div class="my_theme_title">
						<span class="material-symbols-outlined icon_compass">analytics</span>
						<span class="title_text">내 활동 지표 요약</span>
					</div>
					<span class="my_theme_sub font-mono">실시간 누적 데이터</span>
				</div>

				<div class="my_theme_list">
					<div class="my_curation_card">
						<span class="category_label">총 데일리 기록</span>
						<div class="font-mono font-bold">
							1000<span>편</span>
						</div>
					</div>
					<div class="my_curation_card">
						<span class="category_label">평균 하루 평점</span>
						<div class="font-mono font-bold"">
							5.0 <span>/ 5.0</span>
						</div>
					</div>
					<div class="my_curation_card">
						<span class="category_label">총 서브 리뷰</span>
						<div class="font-mono font-bold">
							700<span>개</span>
						</div>
					</div>
					<div class="my_curation_card">
						<span class="category_label">내돈내산 인증률</span>
						<div class="font-mono font-bold">1%</div>
					</div>
				</div>
			</div>

			<!-- 하단 컨텐츠 영역 -->
			<div class="my_bottom_right">
				<!-- 탭 네비게이션 -->
				<div class="my_curation_tab_bar">
					<button type="button" onclick="switchTab('daily')"
						id="tabBtn-daily" class="my_curation_tab active">
						<span class="material-symbols-outlined">calendar_today</span> 내
						데일리 기록
					</button>
					<button type="button" onclick="switchTab('subreviews')"
						id="tabBtn-subreviews" class="my_curation_tab">
						<span class="material-symbols-outlined">category</span> 내 서브 리뷰
					</button>
				</div>
			</div>
		</div>
	</div>
	</div>
</body>
</html>