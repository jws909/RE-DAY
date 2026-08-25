<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
	<link href = "/css/mainpage.css" rel="stylesheet">
	<script src= "/js/mainpage.js"></script>
	<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0" />
</head>
<body>
	<h1>mainpage</h1>
	<div class = "mp_container">
		<!--상단바 -->
		<div class = "mp_top_column">
			<div class ="mp_top_left_column">
				<div class = "mp_t_left_top">	
					✨RE:DAY 데일리 라이프 리뷰
				</div>
				<div class = "mp_t_left_middle">
					<h1>오늘 하루의 평점과 경험을 기록하세요</h1>
				</div>
				<div class = "mp_t_left_bottom">
					하루 전체의 삶을 별점으로 기록하고, 방문한 맛집/사용한 전자기기/탑승한 차량 등 세부 서브 리뷰를 함께 남겨보세요.
				</div>
			</div>
			<div class ="mp_top_right_column">
				<button type="button"><span class="material-symbols-outlined">add</span>오늘의 하루 리뷰 작성하기</button>
			</div>
		</div>
		<div class = "mp_bottom_column">
		<!-- 정렬&필터바 -->
			<div class="sort_filter_bar">
				<div class = "sort_filter_left">
					<span class="material-symbols-outlined">sort</span>정렬
					<div class="filter_button">
					<button type="button" class="active">최신 날짜순</button>
					<button type="button">하루 평점 높은순</button>
					</div>
				</div>
				<div class = "sort_filter_right">
					총 n개의 하루 리뷰
				</div>
			</div>
		</div>
	</div>
</body>
</html>