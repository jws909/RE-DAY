<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<link href="/css/mainpage/explore.css" rel="stylesheet">
<script src="/js/mainpage/explore.js"></script>
</head>
<body>
	<!-- 상단 네비게이션 바 불러오기 -->
	<%@ include file="/WEB-INF/views/include/navbar.jsp"%>
	<div class = "ex_cotainer">
		<!--상단바 -->
		<div class="ex_top_column">
				<div class="ex_t_top mb-2">✨라이프스타일 탐색 & 트렌드</div>
				<div class="ex_t_middle">
					<h1 class="text-2xl sm:text-3xl font-bold">다른 사람들의 하루와 실제 라이프 트렌드를 탐색하세요</h1>
				</div>
				<div class="ex_t_bottom">주관적인 평점 순위 대신, 꾸준히 기록을 이어가는 유저들의 일기에 가장 많이 등장한 실사용 장소·아이템 트렌드를 확인해보세요.</div>
		</div>
	</div>
</body>
</html>