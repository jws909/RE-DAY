<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html lang="ko">

<head>

<meta charset="UTF-8">

<title>RE:DAY - 마이페이지</title>

<%-- 공통 HEAD --%>
<%@ include file="/WEB-INF/views/include/head.jsp"%>

<%-- MY 페이지 CSS --%>
<link href="${pageContext.request.contextPath}/css/mainpage/my.css"
	rel="stylesheet">

<%-- MY 페이지 JavaScript --%>
<script src="${pageContext.request.contextPath}/js/mainpage/my.js">
	
</script>

<%-- =========================================
         Material Symbols 아이콘 폰트
    ========================================= --%>
<link rel="stylesheet"
	href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined">

</head>


<body>

	<%-- =========================================
         상단 네비게이션 바
    ========================================= --%>
	<%@ include file="/WEB-INF/views/include/navbar.jsp"%>


	<div class="my_container">


		<%-- =========================================
             상단 프로필 & 상태 영역
        ========================================= --%>
		<div class="my_top_column">


			<%-- =========================================
                 프로필 / 액션 버튼 영역
            ========================================= --%>
			<div class="my_profile_wrapper">


				<%-- =========================================
                     프로필 정보
                ========================================= --%>
				<div class="my_challenger_card">

					<div class="my_challenger_info">


						<%-- =========================================
                             프로필 이미지 변경
                        ========================================= --%>
						<form id="profileImageForm"
							action="${pageContext.request.contextPath}/member/profile/image"
							method="post" enctype="multipart/form-data">

							<div class="my_avatar_wrapper">

								<label for="profileImageInput" class="my_avatar_box"> <c:choose>

										<%-- 프로필 이미지 경로가 있는 경우 --%>
										<c:when test="${not empty loginUser.profileImg}">

											<%-- 실제 프로필 이미지 --%>
											<img id="profilePreview"
												src="${pageContext.request.contextPath}${loginUser.profileImg}"
												alt="프로필 이미지"
												onerror="
                                                    this.style.display='none';
                                                    document.getElementById('profileDefault').style.display='flex';
                                                ">

											<%-- 이미지 파일을 불러오지 못한 경우 --%>
											<div id="profileDefault" style="display: none;">👤</div>

										</c:when>


										<%-- 프로필 이미지 경로가 없는 경우 --%>
										<c:otherwise>

											<%-- 기본 프로필 --%>
											<div id="profileDefault">👤</div>

											<%-- 이미지 선택 후 미리보기용 --%>
											<img id="profilePreview" src="" alt="프로필 이미지"
												style="display: none;">

										</c:otherwise>

									</c:choose> <%-- 프로필 이미지 변경 카메라 아이콘 --%> <span
									class="material-symbols-outlined my_avatar_camera">
										photo_camera </span>

								</label>


								<%-- 실제 파일 선택 input --%>
								<input type="file" id="profileImageInput"
									name="profileImageFile" accept="image/*" hidden>

							</div>

						</form>


						<%-- =========================================
                             로그인 회원 정보
                        ========================================= --%>
						<div class="my_meta_content">

							<%-- 회원 닉네임 --%>
							<h1 class="my_user_name">${loginUser.nickname}</h1>


							<%-- 회원 레벨 / 연속 기록 --%>
							<div class="my_meta_row_top">

								<%-- 회원 레벨 --%>
								<span class="my_badge_blue font-mono">
									${loginUser.userLevel} </span>


								<%-- 연속 기록 --%>
								<span class="my_streak_badge font-mono"> <span
									class="material-symbols-outlined icon_flame">
										local_fire_department </span> ${empty loginUser.streakCount
                                        ? 0
                                        : loginUser.streakCount}일
									연속 기록

								</span>

							</div>


							<%-- 회원 이메일 --%>
							<div class="my_meta_row_bottom">

								<span class="my_user_email font-mono"> ${loginUser.email}
								</span>

							</div>
							<%-- 회원 상태 메시지 --%>
							<div class="my_profile_status">오늘도 나의 하루를 기록하는 중 ✍</div>

						</div>

					</div>

				</div>


				<%-- =========================================
                     우측 액션 버튼 그룹
                ========================================= --%>
				<div class="my_action_group">

					<%-- 오늘 하루 쓰기 --%>
					<button type="button" class="my_review_write">

						<span class="material-symbols-outlined"> edit_square </span> 오늘 하루
						쓰기

					</button>


					<%-- 프로필 수정 --%>
					<button type="button" class="my_profile_edit">

						<span class="material-symbols-outlined"> person_edit </span> 프로필
						수정

					</button>


					<%-- 로그아웃 --%>
					<a href="${pageContext.request.contextPath}/member/logout"
						class="my_logout_btn"> <span class="material-symbols-outlined">
							logout </span> 로그아웃

					</a>

				</div>

			</div>



			<%-- 통계 카드 그리드 --%>

			<div class="my_stat_grid">

				<%-- 총 데일리 기록 --%>
				<div class="my_stat_card">

					<span class="my_stat_label"> 총 데일리 기록 </span>

					<div class="my_stat_value font-mono">
						${myStats.dailyReviewCount}편</div>

					<%-- 통계 카드 보조 설명 --%>
					<div class="my_stat_desc">
						<span class="material-symbols-outlined"> calendar_today </span>
						지금까지 작성한 하루 기록
					</div>

				</div>


				<%-- 평균 하루 평점 --%>
				<div class="my_stat_card">

					<span class="my_stat_label"> 평균 하루 평점 </span>

					<div class="my_stat_value rating font-mono">
						${myStats.averageRating}/5.0</div>

					<%-- 통계 카드 보조 설명 --%>
					<div class="my_stat_desc">
						<span class="material-symbols-outlined"> star </span> 전체 데일리 기록 평균
					</div>

				</div>


				<%-- 총 서브 리뷰 --%>
				<div class="my_stat_card">

					<span class="my_stat_label"> 총 서브 리뷰 </span>

					<div class="my_stat_value sub font-mono">
						${myStats.subReviewCount}개</div>

					<%-- 통계 카드 보조 설명 --%>
					<div class="my_stat_desc">
						<span class="material-symbols-outlined"> deployed_code </span> 기록에
						포함된 세부 리뷰
					</div>

				</div>


				<%-- 내돈내산 인증률 --%>
				<div class="my_stat_card">

					<span class="my_stat_label"> 내돈내산 인증률 </span>

					<div class="my_stat_value verify font-mono">
						${myStats.certificationRate}%</div>

					<%-- 통계 카드 보조 설명 --%>
					<div class="my_stat_desc">
						<span class="material-symbols-outlined"> verified </span> 인증된 서브
						리뷰 비율
					</div>

				</div>

			</div>

			<%-- =========================================
                 카테고리별 기록 분포
            ========================================= --%>
			<div class="my_category_distribution">

				<div class="my_category_title">

					<span class="material-symbols-outlined"> category </span> 카테고리별 기록
					분포:

				</div>


				<div class="my_category_badges">

					<%-- 장소 --%>
					<span class="my_category_badge place"> 장소
						${myStats.placeCount}개 </span>

					<%-- 아이템 --%>
					<span class="my_category_badge item"> 아이템
						${myStats.itemCount}개 </span>

					<%-- 이동수단 --%>
					<span class="my_category_badge transport"> 이동수단
						${myStats.transportCount}개 </span>

					<%-- 콘텐츠 --%>
					<span class="my_category_badge content"> 콘텐츠
						${myStats.contentCount}개 </span>

				</div>

			</div>

		</div>



		<%-- =========================================
             하단 컨텐츠 영역
        ========================================= --%>
		<div class="my_bottom_column">


			<%-- =========================================
                 MY 리뷰 탭
            ========================================= --%>
			<div class="my_curation_tab_bar">


				<%-- 내 데일리 기록 --%>
				<button type="button" class="my_curation_tab active"
					data-tab="daily">

					<span class="material-symbols-outlined"> calendar_today </span> <span>
						내 데일리 기록 </span> <span class="my_tab_count">
						${myStats.dailyReviewCount} </span>

				</button>


				<%-- 내 서브 리뷰 --%>
				<button type="button" class="my_curation_tab" data-tab="subreviews">

					<span class="material-symbols-outlined"> deployed_code </span> <span>
						내 서브 리뷰 모아보기 </span> <span class="my_tab_count">
						${myStats.subReviewCount} </span>

				</button>


				<%-- 좋아요한 리뷰 --%>
				<button type="button" class="my_curation_tab" data-tab="likes">

					<span class="material-symbols-outlined my_tab_like_icon">
						favorite </span> <span> 좋아요한 리뷰 </span> <span class="my_tab_count">
						${likeCount} </span>

				</button>

			</div>

			<%-- =========================================
     MY 기록 검색 / 정렬 영역
========================================= --%>

			<div class="my_filter_bar">

				<%-- 기록 검색 --%>
				<div class="my_search_box">

					<span class="material-symbols-outlined"> search </span> <input
						type="text" id="mySearchInput" class="my_search_input"
						placeholder="기록 검색">

				</div>


				<%-- 기록 정렬 --%>
				<div class="my_sort_box">

					<span class="material-symbols-outlined"> swap_vert </span> <select
						id="mySortSelect" class="my_sort_select">

						<option value="latest">최신순</option>

						<option value="oldest">오래된순</option>

						<option value="ratingHigh">평점 높은순</option>

						<option value="ratingLow">평점 낮은순</option>

					</select>

				</div>

			</div>



			<%-- 1. 내 데일리 기록 --%>
			<div id="tabContent-daily" class="my_curation_grid daily_view">

				<c:choose>
					<%-- 작성한 데일리 기록이 없는 경우 --%>
					<c:when test="${empty myReviews}">

						<div class="my_card my_empty_card">작성된 데일리 기록이 없습니다.</div>

					</c:when>

					<%-- 작성한 데일리 기록이 있는 경우 --%>
					<c:otherwise>

						<c:forEach var="rev" items="${myReviews}">

							<%-- 데일리 리뷰 카드 --%>

							<article class="my_daily_card">

								<%--작성자 / 날짜 / 평점--%>

								<div class="my_daily_card_header">

									<%-- 작성자 영역 --%>
									<div class="my_daily_author">

										<%-- 작성자 프로필 이미지 --%>
										<div class="my_daily_avatar">

											<c:choose>

												<%-- 프로필 이미지가 있는 경우 --%>
												<c:when test="${not empty loginUser.profileImg}">

													<img
														src="${pageContext.request.contextPath}${loginUser.profileImg}"
														alt="프로필 이미지"
														onerror="
                                        this.style.display='none';
                                        this.nextElementSibling.style.display='flex';
                                    ">

													<%-- 이미지 로드 실패 시 기본 프로필 --%>
													<span style="display: none;"> 👤 </span>

												</c:when>

												<%-- 프로필 이미지가 없는 경우 --%>
												<c:otherwise>

													<span> 👤 </span>

												</c:otherwise>

											</c:choose>

										</div>


										<%-- 작성자 정보 --%>
										<div class="my_daily_author_info">

											<div class="my_daily_author_name_row">

												<span class="my_daily_author_name">
													${loginUser.nickname} </span> <span class="my_daily_my_badge">
													내 글 </span>

											</div>


											<%-- 리뷰 작성 날짜 - YYYY-MM-DD --%>
											<div class="my_daily_date font-mono">
												${fn:substring(rev.reviewDate, 0, 10)}</div>

										</div>

									</div>


									<%-- 평점 / 삭제 --%>
									<div class="my_daily_header_right">

										<%-- 리뷰 평점 --%>
										<div class="my_daily_rating font-mono">★
											${rev.totalRating}</div>

										<%-- 리뷰 삭제 버튼 --%>
										<button type="button" class="my_daily_delete_btn" title="삭제">

											<span class="material-symbols-outlined"> delete </span>

										</button>

									</div>

								</div>


								<%-- =========================================
                 TODAY 배지
            ========================================= --%>

								<c:if test="${fn:substring(rev.reviewDate, 0, 10) eq today}">

									<div class="my_daily_today_badge">TODAY</div>

								</c:if>


								<%-- =========================================
                 하루 총평
            ========================================= --%>

								<div class="my_daily_comment">${rev.overallComment}</div>


								<%-- =========================================
                 무드 태그
            ========================================= --%>

								<c:if test="${not empty rev.moodTags}">

									<div class="my_daily_mood_tags">

										<c:forEach var="tag" items="${fn:split(rev.moodTags, ',')}">

											<span class="my_daily_mood_tag"> #${tag} </span>

										</c:forEach>

									</div>

								</c:if>


								<%-- =========================================
                 메인 이미지
            ========================================= --%>

								<c:if test="${not empty rev.mainImageUrl}">

									<div class="my_daily_main_image">

										<img
											src="${pageContext.request.contextPath}${rev.mainImageUrl}"
											alt="데일리 리뷰 메인 이미지"
											onerror="
                            this.parentElement.style.display='none';
                        ">

									</div>

								</c:if>


								<%-- =========================================
                 서브 리뷰 목록
            ========================================= --%>

								<c:if test="${not empty rev.subReviews}">

									<div class="my_daily_sub_list">

										<c:forEach var="sub" items="${rev.subReviews}">

											<%-- 서브 리뷰 1개 --%>
											<div class="my_daily_sub_item">

												<%-- 카테고리 / 별점 --%>
												<div class="my_daily_sub_top">

													<%-- 서브 리뷰 카테고리 한글 표시 --%>
													<span class="my_daily_sub_category"> <c:choose>

															<%-- 장소 --%>
															<c:when test="${sub.category eq 'place'}">
                                            장소
                                        </c:when>

															<%-- 아이템 --%>
															<c:when test="${sub.category eq 'item'}">
                                            아이템
                                        </c:when>

															<%-- 이동수단 --%>
															<c:when test="${sub.category eq 'transport'}">
                                            이동수단
                                        </c:when>

															<%-- 콘텐츠 --%>
															<c:when test="${sub.category eq 'content'}">
                                            콘텐츠
                                        </c:when>

															<%-- 그 외 값 --%>
															<c:otherwise>
                                            ${sub.category}
                                        </c:otherwise>

														</c:choose>

													</span> <span class="my_daily_sub_rating font-mono"> ★
														${sub.subRating} </span>

												</div>


												<%-- 서브 리뷰 항목명 --%>
												<div class="my_daily_sub_name">${sub.itemName}</div>


												<%-- 위치 / 브랜드 --%>
												<c:if test="${not empty sub.locationBrand}">

													<div class="my_daily_sub_location">
														${sub.locationBrand}</div>

												</c:if>


												<%-- 서브 리뷰 한줄평 --%>
												<c:if test="${not empty sub.subComment}">

													<div class="my_daily_sub_comment">${sub.subComment}</div>

												</c:if>


												<%-- 인증 / 태그 --%>
												<div class="my_daily_sub_bottom">

													<%-- 내돈내산 인증 --%>
													<c:if test="${sub.isCertified eq 'Y'}">

														<span class="my_daily_certified"> ✓ 내돈내산 </span>

													</c:if>


													<%-- 서브 리뷰 태그 --%>
													<c:if test="${not empty sub.tags}">

														<span class="my_daily_sub_tags"> ${sub.tags} </span>

													</c:if>

												</div>

											</div>

										</c:forEach>

									</div>

								</c:if>


								<%-- =========================================
                 카드 하단
            ========================================= --%>

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



			<%-- =================================================
     2. 내 서브 리뷰 모아보기
================================================= --%>

			<div id="tabContent-subreviews" class="my_curation_grid sub_view"
				style="display: none;">

				<c:choose>

					<%-- =========================================
             작성된 서브 리뷰가 없는 경우
        ========================================= --%>

					<c:when test="${empty mySubReviews}">

						<div class="my_card my_empty_card">작성된 서브 리뷰가 없습니다.</div>

					</c:when>


					<%-- =========================================
             작성된 서브 리뷰가 있는 경우
        ========================================= --%>

					<c:otherwise>

						<c:forEach var="item" items="${mySubReviews}">

							<%-- =========================================
                     서브 리뷰 카드
                ========================================= --%>

							<div class="my_card">

								<%-- =========================================
                         카테고리 / 평점
                    ========================================= --%>

								<div class="my_card_header">

									<%-- 서브 리뷰 카테고리 한글 표시 --%>
									<span class="my_card_category"> <c:choose>

											<%-- 장소 --%>
											<c:when test="${item.category eq 'place'}">
                                    장소
                                </c:when>

											<%-- 아이템 --%>
											<c:when test="${item.category eq 'item'}">
                                    아이템
                                </c:when>

											<%-- 이동수단 --%>
											<c:when test="${item.category eq 'transport'}">
                                    이동수단
                                </c:when>

											<%-- 콘텐츠 --%>
											<c:when test="${item.category eq 'content'}">
                                    콘텐츠
                                </c:when>

											<%-- 그 외 카테고리 --%>
											<c:otherwise>
                                    ${item.category}
                                </c:otherwise>

										</c:choose>

									</span>


									<%-- 서브 리뷰 평점 --%>
									<span class="my_card_rating font-mono"> ★
										${item.subRating} </span>

								</div>


								<%-- =========================================
                         서브 리뷰 항목명
                    ========================================= --%>

								<h4 class="my_card_title">${item.itemName}</h4>


								<%-- =========================================
                         위치 / 브랜드
                    ========================================= --%>

								<c:if test="${not empty item.locationBrand}">

									<div class="my_daily_sub_location">${item.locationBrand}
									</div>

								</c:if>


								<%-- =========================================
                         서브 리뷰 한줄평
                    ========================================= --%>

								<c:if test="${not empty item.subComment}">

									<p class="my_card_comment">${item.subComment}</p>

								</c:if>


								<%-- =========================================
                         인증 / 태그
                    ========================================= --%>

								<div class="my_daily_sub_bottom">

									<%-- 내돈내산 인증 --%>
									<c:if test="${item.isCertified eq 'Y'}">

										<span class="my_daily_certified"> ✓ 내돈내산 </span>

									</c:if>


									<%-- 서브 리뷰 태그 --%>
									<c:if test="${not empty item.tags}">

										<span class="my_daily_sub_tags"> ${item.tags} </span>

									</c:if>

								</div>

							</div>

						</c:forEach>

					</c:otherwise>

				</c:choose>

			</div>
			<%-- =================================================
                 3. 좋아요한 리뷰
            ================================================= --%>
			<div id="tabContent-likes" class="my_curation_grid daily_view"
				style="display: none;">

				<c:choose>


					<%-- 좋아요한 리뷰가 없는 경우 --%>
					<c:when test="${empty likedReviews}">

						<div class="my_card my_empty_card">좋아요한 리뷰가 없습니다.</div>

					</c:when>


					<%-- 좋아요한 리뷰가 있는 경우 --%>
					<c:otherwise>


						<c:forEach var="rev" items="${likedReviews}">


							<%-- =========================================
                                 좋아요한 리뷰 카드
                            ========================================= --%>
							<article class="my_daily_card">


								<%-- =========================================
                                     작성자 / 날짜 / 평점
                                ========================================= --%>
								<div class="my_daily_card_header">


									<%-- 작성자 영역 --%>
									<div class="my_daily_author">


										<%-- 작성자 프로필 이미지 --%>
										<div class="my_daily_avatar">

											<c:choose>


												<%-- 작성자 프로필 이미지가 있는 경우 --%>
												<c:when test="${not empty rev.authorProfileImg}">

													<img
														src="${pageContext.request.contextPath}${rev.authorProfileImg}"
														alt="프로필 이미지"
														onerror="
                                                            this.style.display='none';
                                                            this.nextElementSibling.style.display='flex';
                                                        ">

													<%-- 이미지 로드 실패 시 기본 프로필 --%>
													<span style="display: none;"> 👤 </span>

												</c:when>


												<%-- 작성자 프로필 이미지가 없는 경우 --%>
												<c:otherwise>

													<span> 👤 </span>

												</c:otherwise>

											</c:choose>

										</div>


										<%-- 작성자 정보 --%>
										<div class="my_daily_author_info">

											<div class="my_daily_author_name_row">

												<span class="my_daily_author_name">
													${rev.authorNickname} </span>

											</div>


											<%-- 리뷰 작성 날짜 - YYYY-MM-DD --%>
											<div class="my_daily_date font-mono">
												${fn:substring(rev.reviewDate, 0, 10)}</div>

										</div>

									</div>



									<%-- 좋아요한 리뷰 평점 --%>
									<div class="my_daily_header_right">

										<div class="my_daily_rating font-mono">★
											${rev.totalRating}</div>

									</div>

								</div>



								<%-- =========================================
                                     하루 총평
                                ========================================= --%>
								<div class="my_daily_comment">${rev.overallComment}</div>



								<%-- =========================================
                                     무드 태그
                                ========================================= --%>
								<c:if test="${not empty rev.moodTags}">

									<div class="my_daily_mood_tags">

										<c:forEach var="tag" items="${fn:split(rev.moodTags, ',')}">

											<span class="my_daily_mood_tag"> #${tag} </span>

										</c:forEach>

									</div>

								</c:if>

								<%--좋아요한 리뷰 - 메인 이미지--%>

								<c:if test="${not empty rev.mainImageUrl}">

									<div class="my_daily_main_image">

										<img
											src="${pageContext.request.contextPath}${rev.mainImageUrl}"
											alt="리뷰 메인 이미지"
											onerror="this.parentElement.style.display='none';">
									</div>

								</c:if>

								<%-- =========================================
                                     좋아요한 리뷰 - 서브 리뷰 목록
                                ========================================= --%>
								<c:if test="${not empty rev.subReviews}">

									<div class="my_daily_sub_list">


										<c:forEach var="sub" items="${rev.subReviews}">


											<%-- 좋아요한 리뷰 - 서브 리뷰 1개 --%>
											<div class="my_daily_sub_item">


												<%-- 서브 리뷰 상단 : 카테고리 / 별점 --%>
												<div class="my_daily_sub_top">


													<%-- 서브 리뷰 카테고리 한글 표시 --%>
													<span class="my_daily_sub_category"> <c:choose>

															<%-- 장소 --%>
															<c:when test="${sub.category eq 'place'}">
                                                                장소
                                                            </c:when>

															<%-- 아이템 --%>
															<c:when test="${sub.category eq 'item'}">
                                                                아이템
                                                            </c:when>

															<%-- 이동수단 --%>
															<c:when test="${sub.category eq 'transport'}">
                                                                이동수단
                                                            </c:when>

															<%-- 콘텐츠 --%>
															<c:when test="${sub.category eq 'content'}">
                                                                콘텐츠
                                                            </c:when>

															<%-- 그 외 값은 원본 그대로 표시 --%>
															<c:otherwise>
                                                                ${sub.category}
                                                            </c:otherwise>

														</c:choose>

													</span>


													<%-- 서브 리뷰 평점 --%>
													<span class="my_daily_sub_rating font-mono"> ★
														${sub.subRating} </span>

												</div>


												<%-- 서브 리뷰 항목명 --%>
												<div class="my_daily_sub_name">${sub.itemName}</div>


												<%-- 위치 / 브랜드 --%>
												<c:if test="${not empty sub.locationBrand}">

													<div class="my_daily_sub_location">
														${sub.locationBrand}</div>

												</c:if>


												<%-- 서브 리뷰 한줄평 --%>
												<c:if test="${not empty sub.subComment}">

													<div class="my_daily_sub_comment">${sub.subComment}</div>

												</c:if>


												<%-- 서브 리뷰 하단 : 인증 / 태그 --%>
												<div class="my_daily_sub_bottom">


													<%-- 내돈내산 인증 --%>
													<c:if test="${sub.isCertified eq 'Y'}">

														<span class="my_daily_certified"> ✓ 내돈내산 </span>

													</c:if>


													<%-- 서브 리뷰 태그 --%>
													<c:if test="${not empty sub.tags}">

														<span class="my_daily_sub_tags"> ${sub.tags} </span>

													</c:if>

												</div>

											</div>

										</c:forEach>

									</div>

								</c:if>



								<%-- =========================================
                                     좋아요한 리뷰 - 카드 하단
                                ========================================= --%>
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

		</div>

	</div>



	<%-- =========================================
         프로필 이미지 선택 / 미리보기 / 자동 저장
    ========================================= --%>
	<script>
		document.addEventListener("DOMContentLoaded", function() {

			const profileImageInput = document
					.getElementById("profileImageInput");

			const profileImageForm = document
					.getElementById("profileImageForm");

			/* 프로필 이미지 input이 있을 때만 이벤트 연결 */
			if (profileImageInput && profileImageForm) {

				profileImageInput.addEventListener("change", function() {

					const file = this.files[0];

					/* 파일 선택을 취소한 경우 */
					if (!file) {
						return;
					}

					/* 이미지 파일인지 확인 */
					if (!file.type.startsWith("image/")) {

						alert("이미지 파일만 선택할 수 있습니다.");

						this.value = "";

						return;
					}

					/* 프로필 이미지 최대 10MB 제한 */
					if (file.size > 10 * 1024 * 1024) {

						alert("프로필 이미지는 10MB 이하만 가능합니다.");

						this.value = "";

						return;
					}

					const reader = new FileReader();

					/* 이미지 미리보기 후 자동 저장 */
					reader.onload = function(e) {

						const preview = document
								.getElementById("profilePreview");

						const defaultAvatar = document
								.getElementById("profileDefault");

						if (preview) {

							preview.src = e.target.result;

							preview.style.display = "block";
						}

						if (defaultAvatar) {

							defaultAvatar.style.display = "none";
						}

						/* 미리보기 후 프로필 이미지 자동 저장 */
						profileImageForm.submit();
					};

					reader.readAsDataURL(file);
				});
			}

		});
	</script>

</body>
</html>