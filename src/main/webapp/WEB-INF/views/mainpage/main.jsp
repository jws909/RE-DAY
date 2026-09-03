<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>RE:DAY - 당신의 오늘 하루는 어땠나요?</title>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<link href="${pageContext.request.contextPath}/css/mainpage/mainpage.css?v=<%=System.currentTimeMillis()%>" rel="stylesheet">
<script>var contextPath = "${pageContext.request.contextPath}";</script>
<script src="${pageContext.request.contextPath}/js/mainpage/mainpage.js?v=<%=System.currentTimeMillis()%>"></script>
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

				<c:choose>

					<%-- 로그인하지 않은 상태 --%>
					<c:when test="${empty sessionScope.loginUser}">

						<button type="button" id="mp_review_write"
							onclick="location.href='${pageContext.request.contextPath}/member/signin'">

							<span class="material-symbols-outlined"> add </span> 오늘의 하루 리뷰
							작성하기

						</button>

					</c:when>


					<%-- 로그인한 상태 --%>
					<c:otherwise>

						<button type="button" id="mp_review_write"
							onclick="location.href='${pageContext.request.contextPath}/review/write'">

							<span class="material-symbols-outlined"> add </span> 오늘의 하루 리뷰
							작성하기

						</button>

					</c:otherwise>

				</c:choose>

			</div>
		</div>
		<div class="mp_bottom_column">
			<div class="mp_bottom_main">
				<!-- 정렬&필터바 -->
				<div class="sort_filter_bar">
					<div class="sort_filter_left">
						<span class="material-symbols-outlined">sort</span>정렬
						<div class="filter_button">
							<button type="button" class="${currentSort eq 'latest' ? 'active' : ''}" data-sort="latest"
									onclick="location.href='${pageContext.request.contextPath}/RE:DAY/mainpage?sort=latest'">최신 날짜순</button>
							<button type="button" class="${currentSort eq 'rating' ? 'active' : ''}" data-sort="rating"
									onclick="location.href='${pageContext.request.contextPath}/RE:DAY/mainpage?sort=rating'">하루 평점 높은순</button>
						</div>
					</div>
					<div class="sort_filter_right">총 <span id="feedTotalCount">${totalCount}</span>개의 하루 리뷰</div>
				</div>

				<!-- 메인 리뷰 카드 컨테이너 -->
				<div class="main_review_container" id="mainReviewContainer" data-sort="${currentSort}" data-page="1" data-has-more="${hasMore}">
					<c:choose>
						<c:when test="${empty feedList}">
							<div class="empty_feed_box" style="text-align: center; padding: 60px 20px; background: #ffffff; border: 2px dashed #CBD5E1; border-radius: 16px; margin-top: 20px;">
								<span class="material-symbols-outlined" style="font-size: 48px; color: #94A3B8;">sentiment_dissatisfied</span>
								<p style="margin-top: 12px; font-size: 15px; font-weight: bold; color: #475569;">등록된 데일리 리뷰가 없습니다.</p>
								<p style="font-size: 13px; color: #94A3B8; margin-top: 4px;">첫 번째 하루 리뷰를 기록해보세요!</p>
							</div>
						</c:when>
						<c:otherwise>
							<c:forEach items="${feedList}" var="review">
								<div class="mp_review_card" data-review-id="${review.reviewId}">
									<div class="mp_review_header">
										<div class="mp_review_author_info">
											<div class="mp_author_avatar font-mono">
												<c:choose>
													<c:when test="${not empty review.authorProfileImg}">
														<img src="${pageContext.request.contextPath}${review.authorProfileImg}" alt="프로필" style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%;" onerror="this.style.display='none';">
													</c:when>
													<c:otherwise>
														<span class="material-symbols-outlined" style="font-size: 20px; color: #64748B;">person</span>
													</c:otherwise>
												</c:choose>
											</div>
											<div class="mp_author_meta">
												<div class="mp_author_name_row">
													<span class="mp_author_name"><c:out value="${empty review.authorNickname ? '익명' : review.authorNickname}" /></span>
													<span class="mp_author_level font-mono"><c:out value="${empty review.authorLevel ? 'lv.1 초보 기록러' : review.authorLevel}" /></span>
													<c:if test="${not empty review.authorStreakCount && review.authorStreakCount > 0}">
														<span class="mp_author_badge font-mono">${review.authorStreakCount}</span>
													</c:if>
												</div>
												<div class="mp_review_date_row">
													<span class="material-symbols-outlined">calendar_today</span>
													<span class="font-mono">${review.reviewDate}</span>
													<c:if test="${review.reviewDate eq todayDate}">
														<span class="mp_today_badge font-mono">TODAY</span>
													</c:if>
												</div>
											</div>
										</div>

										<div class="mp_review_score_box">
											<span class="mp_score_title">오늘의 하루 평점</span>
											<div class="mp_score_stars">
												<span class="material-symbols-outlined star_fill">star</span>
												<span class="font-mono font-bold">${review.totalRating}</span>
											</div>
										</div>
									</div>

									<c:if test="${not empty review.moodTags}">
										<div class="mp_mood_tags_wrapper">
											<c:forEach items="${fn:split(review.moodTags, ',')}" var="tag">
												<c:if test="${not empty fn:trim(tag)}">
													<span class="mp_mood_tag">#${fn:trim(tag)}</span>
												</c:if>
											</c:forEach>
										</div>
									</c:if>

									<p class="mp_review_summary"><c:out value="${review.overallComment}" /></p>

									<%-- 대표 사진 --%>
									<c:if test="${not empty review.mainImageUrl}">
										<div class="mp_review_main_image" style="margin: 12px 0; border-radius: 12px; overflow: hidden; max-height: 360px; background: #f1f5f9;">
											<img src="${pageContext.request.contextPath}${review.mainImageUrl}" alt="대표 이미지" style="width: 100%; height: 100%; object-fit: cover; display: block;" onerror="this.parentElement.style.display='none';">
										</div>
									</c:if>

									<%-- 서브 리뷰 목록 리본 --%>
									<c:if test="${not empty review.subReviews}">
										<div class="mp_sub_reviews_container">
											<div class="mp_sub_reviews_header">
												<div class="mp_sub_reviews_title">
													<span class="material-symbols-outlined">layers</span>
													<span>이 날의 서브 리뷰 (${fn:length(review.subReviews)}개)</span>
												</div>
												<span class="mp_sub_reviews_caption font-mono">세부 평가 항목</span>
											</div>

											<div class="mp_sub_reviews_grid">
												<c:forEach items="${review.subReviews}" var="sub">
													<div class="mp_sub_review_item">
														<div class="mp_sub_item_left">
															<span class="mp_category_badge"><c:out value="${sub.category}" /></span>
															<span class="mp_sub_item_name"><c:out value="${sub.itemName}" /></span>
															<c:if test="${sub.isCertified eq 'Y'}">
																<span class="material-symbols-outlined icon_verified">check_circle</span>
															</c:if>
														</div>
														<div class="mp_sub_item_right">
															<span class="material-symbols-outlined star_fill">star</span>
															<span class="font-mono font-bold">${sub.subRating}</span>
														</div>
													</div>
												</c:forEach>
											</div>
										</div>
									</c:if>

									<div class="mp_review_footer">
										<div class="mp_interaction_group">
											<button type="button" class="mp_action_btn like_btn ${review.likedByMe ? 'active' : ''}"
												data-review-id="${review.reviewId}" data-liked="${review.likedByMe}">
												<span class="material-symbols-outlined icon_heart">favorite</span>
												<span class="font-mono like_count">${review.likeCount}</span>
											</button>
											<span class="mp_action_info">
												<span class="material-symbols-outlined">chat_bubble</span>
												<span>댓글 ${review.commentCount}</span>
											</span>
										</div>
										<div class="mp_detail_link" onclick="location.href='${pageContext.request.contextPath}/RE:DAY/review/detail/${review.reviewId}'" style="cursor: pointer;">
											<span>상세 보기</span>
											<span class="material-symbols-outlined">arrow_forward</span>
										</div>
									</div>
								</div>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</div>

				<!-- 피드 더보기 버튼 영역 -->
				<div id="feedMoreContainer" style="margin-top: 24px; text-align: center; ${hasMore ? '' : 'display: none;'}">
					<button type="button" id="btnLoadMore" 
							onclick="if(window.loadMoreReviews) window.loadMoreReviews();"
							style="display: inline-flex; align-items: center; justify-content: center; gap: 6px; width: 100%; max-width: 320px; padding: 12px 20px; background-color: #ffffff; border: 2px dashed #CBD5E1; border-radius: 12px; font-weight: bold; font-size: 14px; color: #475569; cursor: pointer; transition: all 0.2s ease;">
						<span class="material-symbols-outlined" style="font-size: 18px;">expand_more</span>
						<span>리뷰 더보기 (+5개)</span>
					</button>
				</div>

			</div>
			<div class="mp_bottom_side">
				<!-- 하루 평점 통계표 -->
				<div class="mp_day_rating_static">
					<a class="day_rating_header"
						href="${pageContext.request.contextPath}/RE:DAY/my">
						<div class="day_rating_title">
							<span class="material-symbols-outlined symbol1">license</span>
							<h4 class="text-sm font-bold">내 하루 평점 통계</h4>
							<span class="material-symbols-outlined">chevron_right</span>
						</div> <span class="day_rating_sub_text">최근 7일</span>
					</a>
					<div class="average_daily_score_card">
						<div class="score_info_left">
							<span class="score_label">이번 주 평균 하루 점수</span>
							<div class="score_val_wrapper">
								<!-- 평균 점수와 만점(5.0)을 동적으로 넣을 수 있게 클래스 추가 -->
								<span class="score_main font-mono">0.0</span> <span
									class="score_total font-mono">/ 5.0</span>
							</div>
						</div>
						<div class="score_info_right">
							<!-- 상승 점수와 서브 리뷰 개수 영역에 클래스 지정 -->
							<span class="score_badge stat_diff">+0점 상승 ↗</span> <span
								class="sub_review_cnt">서브 리뷰 <span
								class="sub_review_count_val">0</span>개 등록
							</span>
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