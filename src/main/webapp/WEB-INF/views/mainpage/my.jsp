<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>RE:DAY - 마이페이지</title>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<link href="${pageContext.request.contextPath}/css/mainpage/my.css"
	rel="stylesheet">
<script src="${pageContext.request.contextPath}/js/mainpage/my.js">
	
</script>
<link rel="stylesheet"
	href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0" />
</head>
<body>
	<!-- 상단 네비게이션 바 -->
	<%@ include file="/WEB-INF/views/include/navbar.jsp"%>

	<div class="my_container">
		<!-- 상단 프로필 & 상태 바 -->
		<div class="my_top_column">
			<div class="my_profile_wrapper">
				<div class="my_challenger_card">
					<div class="my_challenger_info">
						<!-- 아바타 박스 -->
						<!-- 프로필 사진 -->
						<form id="profileImageForm"
							action="${pageContext.request.contextPath}/member/profile/image"
							method="post" enctype="multipart/form-data">

							<div class="my_avatar_wrapper">

								<label for="profileImageInput" class="my_avatar_box"> <c:choose>

										<c:when test="${not empty loginUser.profileImg}">
											<img id="profilePreview"
												src="${pageContext.request.contextPath}${loginUser.profileImg}"
												alt="프로필 이미지">
										</c:when>

										<c:otherwise>

											<div id="profileDefault">👤</div>

											<img id="profilePreview" src="" alt="프로필 이미지"
												style="display: none;">

										</c:otherwise>

									</c:choose> <span class="material-symbols-outlined my_avatar_camera">
										photo_camera </span>

								</label> <input type="file" id="profileImageInput"
									name="profileImageFile" accept="image/*" hidden>

							</div>

						</form>

						<!-- 유저 정보 -->
						<div class="my_meta_content">
							<!-- 로그인 회원 닉네임 -->
							<h1 class="my_user_name">${loginUser.nickname}</h1>

							<!-- 회원 레벨 -->
							<span class="my_badge_blue font-mono">
								${loginUser.userLevel} </span>

							<!-- 연속 기록 -->
							<span class="my_streak_badge font-mono"> <span
								class="material-symbols-outlined icon_flame">
									local_fire_department </span> ${empty loginUser.streakCount ? 0 : loginUser.streakCount}일
								연속 기록
							</span>

						</div>

						<div class="meta_row_bottom">

							<!-- 로그인 회원 이메일 -->
							<span class="my_user_email font-mono"> ${loginUser.email}
							</span>

						</div>
					</div>
				</div>

				<!-- 우측 액션 버튼 그룹 -->
				<button type="button" class="my_review_write">
					<span class="material-symbols-outlined" style="font-size: 16px;">edit_square</span>
					오늘 하루 쓰기
				</button>
			</div>

			<!-- 통계 카드 그리드 -->
			<div class="my_stat_grid">

				<div class="my_stat_card">

					<span class="my_stat_label"> 총 데일리 기록 </span>

					<div class="my_stat_value font-mono">
						${myStats.dailyReviewCount}편</div>

				</div>


				<div class="my_stat_card">

					<span class="my_stat_label"> 평균 하루 평점 </span>

					<div class="my_stat_value rating font-mono">
						${myStats.averageRating}/5.0</div>

				</div>


				<div class="my_stat_card">

					<span class="my_stat_label"> 총 서브 리뷰 </span>

					<div class="my_stat_value sub font-mono">
						${myStats.subReviewCount}개</div>

				</div>


				<div class="my_stat_card">

					<span class="my_stat_label"> 내돈내산 인증률 </span>

					<div class="my_stat_value font-mono">
						${myStats.certificationRate}%</div>

				</div>

			</div>
			<!-- 카테고리별 기록 분포 -->
			<div class="my_category_distribution">

				<div class="my_category_title">
					<span class="material-symbols-outlined"> category </span> 카테고리별 기록
					분포:
				</div>

				<div class="my_category_badges">

					<span class="my_category_badge place"> 장소
						${myStats.placeCount}개 </span> <span class="my_category_badge item">
						아이템 ${myStats.itemCount}개 </span> <span
						class="my_category_badge transport"> 이동수단
						${myStats.transportCount}개 </span> <span
						class="my_category_badge content"> 콘텐츠
						${myStats.contentCount}개 </span>

				</div>

			</div>
		</div>

		<!-- 하단 컨텐츠 영역 -->
		<div class="my_bottom_column">
			<!-- 탭 네비게이션 -->
			<!-- MY 리뷰 탭 -->
			<div class="my_curation_tab_bar">

				<!-- 내 데일리 기록 -->
				<button type="button" class="my_curation_tab active"
					data-tab="daily">

					<span class="material-symbols-outlined"> calendar_today </span> <span>
						내 데일리 기록 </span> <span class="my_tab_count">
						${myStats.dailyReviewCount} </span>

				</button>


				<!-- 내 서브 리뷰 -->
				<button type="button" class="my_curation_tab" data-tab="subreviews">

					<span class="material-symbols-outlined"> deployed_code </span> <span>
						내 서브 리뷰 모아보기 </span> <span class="my_tab_count">
						${myStats.subReviewCount} </span>

				</button>


				<!-- 좋아요한 리뷰 -->
				<button type="button" class="my_curation_tab" data-tab="likes">

					<span class="material-symbols-outlined my_tab_like_icon">
						favorite </span> <span> 좋아요한 리뷰 </span> <span class="my_tab_count">
						    ${likeCount}</span>

				</button>

			</div>

			<!-- 데일리 기록 컨텐츠 -->
			<div id="tabContent-daily" class="my_curation_grid daily_view">

				<c:choose>

					<c:when test="${empty myReviews}">

						<div class="my_card my_empty_card">작성된 데일리 기록이 없습니다.</div>

					</c:when>

					<c:otherwise>

						<c:forEach var="rev" items="${myReviews}">

							<article class="my_daily_card">

								<!-- 작성자 / 날짜 / 평점 -->
								<div class="my_daily_card_header">

									<div class="my_daily_author">

										<div class="my_daily_avatar">

											<c:choose>

												<c:when test="${not empty loginUser.profileImg}">

													<img
														src="${pageContext.request.contextPath}${loginUser.profileImg}"
														alt="프로필 이미지">

												</c:when>

												<c:otherwise>

													<span>👤</span>

												</c:otherwise>

											</c:choose>

										</div>


										<div class="my_daily_author_info">

											<div class="my_daily_author_name_row">

												<span class="my_daily_author_name">
													${loginUser.nickname} </span> <span class="my_daily_my_badge">
													내 글 </span>

											</div>


											<div class="my_daily_date font-mono">${rev.reviewDate}
											</div>

										</div>

									</div>


									<div class="my_daily_header_right">

										<div class="my_daily_rating font-mono">★
											${rev.totalRating}</div>

										<button type="button" class="my_daily_delete_btn" title="삭제">

											<span class="material-symbols-outlined"> delete </span>

										</button>

									</div>

								</div>


								<!-- 하루 총평 -->
								<div class="my_daily_comment">${rev.overallComment}</div>


								<!-- 무드 태그 -->
								<c:if test="${not empty rev.moodTags}">

									<div class="my_daily_mood_tags">

										<c:forEach var="tag" items="${fn:split(rev.moodTags, ',')}">

											<span class="my_daily_mood_tag"> #${tag} </span>

										</c:forEach>

									</div>

								</c:if>


								<!-- 서브 리뷰 -->
								<c:if test="${not empty rev.subReviews}">

									<div class="my_daily_sub_list">

										<c:forEach var="sub" items="${rev.subReviews}">

											<div class="my_daily_sub_item">

												<div class="my_daily_sub_top">

													<span class="my_daily_sub_category"> ${sub.category}
													</span> <span class="my_daily_sub_rating font-mono"> ★
														${sub.subRating} </span>

												</div>


												<div class="my_daily_sub_name">${sub.itemName}</div>


												<c:if test="${not empty sub.locationBrand}">

													<div class="my_daily_sub_location">
														${sub.locationBrand}</div>

												</c:if>


												<div class="my_daily_sub_comment">${sub.subComment}</div>


												<div class="my_daily_sub_bottom">

													<c:if test="${sub.isCertified eq 'Y'}">

														<span class="my_daily_certified"> ✓ 내돈내산 </span>

													</c:if>


													<c:if test="${not empty sub.tags}">

														<span class="my_daily_sub_tags"> ${sub.tags} </span>

													</c:if>

												</div>

											</div>

										</c:forEach>

									</div>

								</c:if>


								<!-- 카드 하단 -->
								<div class="my_daily_card_footer">

									<a
										href="${pageContext.request.contextPath}/RE:DAY/detailReview?reviewId=${rev.reviewId}"
										class="my_daily_detail_link"> 상세보기 → </a>

								</div>

							</article>

						</c:forEach>

					</c:otherwise>

				</c:choose>

			</div>

			<!-- 서브 리뷰 컨텐츠 -->
			<div id="tabContent-subreviews" class="my_curation_grid sub_view"
				style="display: none;">
				<c:choose>
					<c:when test="${empty mySubReviews}">
						<div class="my_card my_empty_card">작성된 서브 리뷰가 없습니다.</div>
					</c:when>
					<c:otherwise>
						<c:forEach var="item" items="${mySubReviews}">
							<div class="my_card">
								<div class="my_card_header">
									<span class="my_card_category">${item.sub.category}</span> <span
										class="my_card_date font-mono">${item.parentDate}</span>
								</div>
								<h4 class="my_card_title">${item.sub.name}
									<span class="my_card_rating font-mono">★
										${item.sub.rating}</span>
								</h4>
								<p class="my_card_comment">"${item.sub.comment}"</p>
							</div>
						</c:forEach>
					</c:otherwise>
				</c:choose>
			</div>
		</div>
	</div>
	<script>
		document.addEventListener("DOMContentLoaded", function() {

			const profileImageInput = document
					.getElementById("profileImageInput");

			const profileImageForm = document
					.getElementById("profileImageForm");

			profileImageInput.addEventListener("change", function() {

				const file = this.files[0];

				// 파일 선택 취소
				if (!file) {
					return;
				}

				// 이미지 파일 확인
				if (!file.type.startsWith("image/")) {

					alert("이미지 파일만 선택할 수 있습니다.");

					this.value = "";

					return;
				}

				// 10MB 제한
				if (file.size > 10 * 1024 * 1024) {

					alert("프로필 이미지는 10MB 이하만 가능합니다.");

					this.value = "";

					return;
				}

				const reader = new FileReader();

				// 먼저 화면에 미리보기
				reader.onload = function(e) {

					const preview = document.getElementById("profilePreview");

					const defaultAvatar = document
							.getElementById("profileDefault");

					preview.src = e.target.result;

					preview.style.display = "block";

					if (defaultAvatar) {

						defaultAvatar.style.display = "none";

					}

					// 미리보기가 된 후 자동 저장
					profileImageForm.submit();

				};

				reader.readAsDataURL(file);

			});

		});
	</script>
</body>
</html>