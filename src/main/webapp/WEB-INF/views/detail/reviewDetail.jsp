<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:choose>
            <c:when test="${not empty review}">
                ${review.reviewDate} 하루 리뷰 - RE:DAY
            </c:when>
            <c:otherwise>
                리뷰 상세 - RE:DAY
            </c:otherwise>
        </c:choose>
    </title>

    <!-- 공통 Head 태그 (Tailwind CSS CDN & Font Awesome 6 CDN 포함) -->
    <%@ include file="/WEB-INF/views/include/head.jsp"%>

    <!-- 리뷰 상세 전용 스타일시트 분리 -->
    <link href="<%=request.getContextPath()%>/css/reviewDetail.css" rel="stylesheet">
</head>
<body class="bg-slate-100 text-slate-900 min-h-screen pb-16 font-sans antialiased">

    <!-- 상단 네비게이션 바 -->
    <%@ include file="/WEB-INF/views/include/navbar.jsp"%>

    <div class="max-w-4xl mx-auto px-4 sm:px-6 py-8 space-y-8">

        <%-- ========================================================================= --%>
        <%-- CASE 1: 리뷰 데이터가 존재하지 않는 경우 (예외/삭제된 리뷰 처리) --%>
        <%-- ========================================================================= --%>
        <c:if test="${empty review}">
            <div class="max-w-3xl mx-auto px-4 py-16 text-center space-y-4">
                <div class="p-8 border-2 border-dashed border-slate-300 rounded-2xl bg-white space-y-3">
                    <div class="w-12 h-12 rounded-full bg-slate-100 text-slate-400 mx-auto flex items-center justify-center text-xl">
                        <i class="fa-solid fa-layer-group"></i>
                    </div>
                    <h2 class="text-xl font-bold text-slate-800">리뷰를 찾을 수 없습니다</h2>
                    <p class="text-sm text-slate-500">
                        요청하신 데일리 리뷰가 삭제되었거나 존재하지 않는 ID입니다.
                    </p>
                    <div class="pt-2">
                        <a href="${pageContext.request.contextPath}/" 
                           class="inline-flex items-center gap-2 px-4 py-2 bg-slate-900 hover:bg-slate-800 text-white rounded-lg text-xs font-bold transition-colors">
                            <i class="fa-solid fa-arrow-left text-xs"></i>
                            <span>피드로 돌아가기</span>
                        </a>
                    </div>
                </div>
            </div>
        </c:if>

        <%-- ========================================================================= --%>
        <%-- CASE 2: 정상적인 리뷰 상세 화면 렌더링 (와이어프레임 완벽 일치) --%>
        <%-- ========================================================================= --%>
        <c:if test="${not empty review}">

            <!-- --------------------------------------------------------------------- -->
            <!-- Top Navigation & Action Buttons -->
            <!-- --------------------------------------------------------------------- -->
            <div class="flex items-center justify-between pb-4 border-b-2 border-dashed border-slate-300">
                <!-- 목록으로 버튼 -->
                <button type="button"
                        onclick="history.back()"
                        class="inline-flex items-center gap-1.5 text-xs font-bold text-slate-600 hover:text-slate-900 bg-slate-100 hover:bg-slate-200 px-3 py-1.5 rounded-lg transition-colors font-mono cursor-pointer">
                    <i class="fa-solid fa-arrow-left text-xs"></i>
                    <span>목록으로</span>
                </button>

                <!-- 우측 액션 버튼들 (좋아요, 공유, 수정/삭제) -->
                <div class="flex items-center gap-2">
                    <!-- 좋아요 버튼 (비동기 AJAX / 폼 제출 지원) -->
                    <form action="${pageContext.request.contextPath}/review/like" method="post" class="inline m-0" id="likeForm">
                        <input type="hidden" name="reviewId" value="${review.reviewId}" />
                        <button type="submit" 
                                id="likeButton"
                                class="flex items-center gap-1.5 px-3 py-1.5 rounded-lg border text-xs font-semibold transition-colors cursor-pointer ${isLiked ? 'bg-rose-50 border-rose-300 text-rose-600' : 'bg-white border-slate-200 text-slate-700 hover:bg-slate-50'}">
                            <i class="fa-solid fa-heart text-xs ${isLiked ? 'text-rose-500' : 'text-slate-400'}"></i>
                            <span>좋아요</span>
                            <span id="likeCountSpan" class="font-mono">${empty likeCount ? 0 : likeCount}</span>
                        </button>
                    </form>

                    <!-- 공유하기 버튼 (클립보드 URL 복사) -->
                    <button type="button" 
                            id="shareButton"
                            onclick="copyCurrentUrl()"
                            title="공유하기"
                            class="p-2 rounded-lg border border-slate-200 bg-white hover:bg-slate-50 text-slate-600 transition-colors cursor-pointer text-xs flex items-center justify-center">
                        <i class="fa-solid fa-share-nodes text-xs"></i>
                    </button>

                    <!-- 작성자 본인일 경우 수정 / 삭제 버튼 -->
                    <c:if test="${not empty sessionScope.loginUser and (sessionScope.loginUser.userId eq review.userId or sessionScope.loginUser.user_id eq review.userId)}">
                        <div class="flex items-center gap-1.5 pl-2 border-l border-slate-300">
                            <!-- 수정 이동 -->
                            <a href="${pageContext.request.contextPath}/review/edit?id=${review.reviewId}"
                               class="px-2.5 py-1.5 rounded-lg border border-slate-200 bg-white hover:bg-slate-50 text-slate-700 text-xs font-medium transition-colors">
                                <i class="fa-solid fa-pen text-xs mr-1 text-slate-500"></i>수정
                            </a>
                            <!-- 삭제 폼 -->
                            <form action="${pageContext.request.contextPath}/review/delete" 
                                  method="post" 
                                  class="inline m-0"
                                  onsubmit="return confirm('정말 이 하루 리뷰를 삭제하시겠습니까?\n종속된 모든 서브 리뷰도 함께 삭제됩니다.');">
                                <input type="hidden" name="reviewId" value="${review.reviewId}" />
                                <button type="submit"
                                        class="px-2.5 py-1.5 rounded-lg border border-rose-200 bg-rose-50 hover:bg-rose-100 text-rose-600 text-xs font-medium transition-colors cursor-pointer">
                                    <i class="fa-solid fa-trash-can text-xs mr-1"></i>삭제
                                </button>
                            </form>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- --------------------------------------------------------------------- -->
            <!-- 1. Main Daily Review Detail Section (메인 데일리 종합 리뷰) -->
            <!-- --------------------------------------------------------------------- -->
            <article class="border-2 border-dashed border-slate-300 rounded-2xl bg-white p-6 sm:p-8 space-y-6 shadow-sm">
                <!-- Header: Author + Date + Overall Rating -->
                <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-4 border-b border-slate-200">
                    <!-- 작성자 프로필 카드 -->
                    <div class="flex items-center gap-3">
                        <!-- 프로필 이미지 또는 이니셜 아바타 -->
                        <c:choose>
                            <c:when test="${not empty user.profileImg or not empty user.profile_img or not empty profileImg}">
                                <img src="${not empty user.profileImg ? user.profileImg : (not empty user.profile_img ? user.profile_img : profileImg)}" 
                                     alt="프로필 이미지" 
                                     class="w-12 h-12 rounded-full object-cover border border-slate-300 shadow-sm" />
                            </c:when>
                            <c:otherwise>
                                <div class="w-12 h-12 rounded-full bg-slate-900 text-white font-mono font-bold flex items-center justify-center text-base shadow uppercase">
                                    <c:choose>
                                        <c:when test="${not empty user.avatar}">
                                            ${user.avatar}
                                        </c:when>
                                        <c:when test="${not empty user.nickname}">
                                            ${fn:substring(user.nickname, 0, 1)}
                                        </c:when>
                                        <c:when test="${not empty user.userId}">
                                            ${fn:substring(user.userId, 0, 1)}
                                        </c:when>
                                        <c:when test="${not empty review.userId}">
                                            ${fn:substring(review.userId, 0, 1)}
                                        </c:when>
                                        <c:otherwise>R</c:otherwise>
                                    </c:choose>
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <div>
                            <!-- 1. 유저 닉네임 + 레벨(USER_LEVEL) 뱃지 + 스트릭(STREAK_COUNT) 뱃지 + 공개여부 -->
                            <div class="flex items-center gap-2 flex-wrap">
                                <h3 class="font-bold text-base text-slate-900">
                                    <c:choose>
                                        <c:when test="${not empty user.nickname}">
                                            ${user.nickname}
                                        </c:when>
                                        <c:when test="${not empty nickname}">
                                            ${nickname}
                                        </c:when>
                                        <c:when test="${not empty user.userId}">
                                            ${user.userId}
                                        </c:when>
                                        <c:otherwise>
                                            ${review.userId}
                                        </c:otherwise>
                                    </c:choose>
                                </h3>

                                <!-- 유저 레벨 (USER_LEVEL: LV1~LV5) 뱃지 : 서버 JSTL 즉시 완성 + JS 연동 -->
                                <c:set var="rawLevel" value="${not empty user.userLevel ? user.userLevel : (not empty user.user_level ? user.user_level : (not empty userLevel ? userLevel : 'LV1'))}" />
                                <c:choose>
                                    <c:when test="${rawLevel eq 'LV5' or rawLevel eq '5'}">
                                        <span id="userLevelBadge" data-level="${rawLevel}" class="text-xs font-mono px-2 py-0.5 rounded border border-purple-300 bg-purple-50 text-purple-700 font-bold">
                                            Lv.5 라이프 해커
                                        </span>
                                    </c:when>
                                    <c:when test="${rawLevel eq 'LV4' or rawLevel eq '4'}">
                                        <span id="userLevelBadge" data-level="${rawLevel}" class="text-xs font-mono px-2 py-0.5 rounded border border-blue-300 bg-blue-50 text-blue-700 font-semibold">
                                            Lv.4 프로 기록러
                                        </span>
                                    </c:when>
                                    <c:when test="${rawLevel eq 'LV3' or rawLevel eq '3'}">
                                        <span id="userLevelBadge" data-level="${rawLevel}" class="text-xs font-mono px-2 py-0.5 rounded border border-emerald-300 bg-emerald-50 text-emerald-700 font-semibold">
                                            Lv.3 데일리 아카이버
                                        </span>
                                    </c:when>
                                    <c:when test="${rawLevel eq 'LV2' or rawLevel eq '2'}">
                                        <span id="userLevelBadge" data-level="${rawLevel}" class="text-xs font-mono px-2 py-0.5 rounded border border-slate-200 bg-slate-100 text-slate-600 font-medium">
                                            Lv.2 루키 아카이버
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span id="userLevelBadge" data-level="${rawLevel}" class="text-xs font-mono px-2 py-0.5 rounded border border-slate-200 bg-slate-100 text-slate-600 font-medium">
                                            Lv.1 일상 기록러
                                        </span>
                                    </c:otherwise>
                                </c:choose>

                                <!-- 스트릭 연속 기록 (STREAK_COUNT) 뱃지 : 서버 JSTL 즉시 완성 + JS 연동 -->
                                <c:set var="rawStreak" value="${not empty user.streakCount ? user.streakCount : (not empty user.streak_count ? user.streak_count : (not empty streakCount ? streakCount : 0))}" />
                                <c:choose>
                                    <c:when test="${rawStreak >= 30}">
                                        <span id="userStreakBadge" data-streak="${rawStreak}" class="text-[11px] font-bold text-amber-800 bg-amber-50 px-2 py-0.5 rounded border border-amber-300 font-mono inline-flex items-center gap-1 shadow-2xs streak-badge">
                                            <i class="fa-solid fa-trophy text-amber-500 text-xs"></i>
                                            <span id="userStreakText">${rawStreak}일 연속 챔피언</span>
                                        </span>
                                    </c:when>
                                    <c:when test="${rawStreak >= 14}">
                                        <span id="userStreakBadge" data-streak="${rawStreak}" class="text-[11px] font-semibold text-orange-600 bg-orange-50 px-2 py-0.5 rounded border border-orange-200 font-mono inline-flex items-center gap-1 shadow-2xs streak-badge">
                                            <i class="fa-solid fa-fire text-orange-500 text-xs"></i>
                                            <span id="userStreakText">${rawStreak}일 연속 마스터</span>
                                        </span>
                                    </c:when>
                                    <c:when test="${rawStreak >= 7}">
                                        <span id="userStreakBadge" data-streak="${rawStreak}" class="text-[11px] font-semibold text-orange-600 bg-orange-50 px-2 py-0.5 rounded border border-orange-200 font-mono inline-flex items-center gap-1 shadow-2xs streak-badge">
                                            <i class="fa-solid fa-fire text-orange-500 text-xs"></i>
                                            <span id="userStreakText">${rawStreak}일 연속 챌린저</span>
                                        </span>
                                    </c:when>
                                    <c:when test="${rawStreak > 0}">
                                        <span id="userStreakBadge" data-streak="${rawStreak}" class="text-[11px] font-medium text-orange-600 bg-orange-50 px-2 py-0.5 rounded border border-orange-200 font-mono inline-flex items-center gap-1 shadow-2xs streak-badge">
                                            <i class="fa-solid fa-fire text-orange-500 text-xs"></i>
                                            <span id="userStreakText">${rawStreak}일 연속 기록</span>
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span id="userStreakBadge" data-streak="0" class="hidden"></span>
                                    </c:otherwise>
                                </c:choose>

                                <!-- 공개 여부 뱃지 (기본값: 전체공개, 'N'일 때만 비공개) -->
                                <c:choose>
                                    <c:when test="${empty review.isPublic or review.isPublic eq 'Y'}">
                                        <span class="text-[10px] font-semibold text-emerald-700 bg-emerald-50 px-1.5 py-0.5 rounded border border-emerald-200 font-mono">
                                            전체공개
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-[10px] font-semibold text-slate-600 bg-slate-100 px-1.5 py-0.5 rounded border border-slate-200 font-mono">
                                            비공개
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- 2. 날짜 + 요일 표시 (백엔드 Model의 dayOfWeek / review.dayOfWeek 바인딩) -->
                            <div class="flex items-center gap-1.5 text-xs text-slate-500 mt-1">
                                <i class="fa-regular fa-calendar-days text-slate-400"></i>
                                <span class="font-mono font-medium">${review.reviewDate}</span>
                                <c:set var="dw" value="${not empty dayOfWeek ? dayOfWeek : (not empty review.dayOfWeek ? review.dayOfWeek : '')}" />
                                <c:if test="${not empty dw}">
                                    <span class="font-mono font-medium text-slate-500">(${dw})</span>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <!-- Daily Overall Score Large Box -->
                    <div class="flex flex-col sm:items-end bg-amber-50/80 p-3.5 rounded-xl border border-amber-200">
                        <span class="text-[11px] font-bold text-amber-800 uppercase tracking-wider mb-1">
                            오늘 하루 종합 평점
                        </span>
                        <!-- 별점 5개 시각화 + 텍스트 점수 -->
                        <div class="inline-flex items-center gap-1.5 select-none">
                            <div class="flex items-center gap-0.5">
                                <c:forEach var="i" begin="1" end="5">
                                    <c:choose>
                                        <c:when test="${review.totalRating >= i}">
                                            <i class="fa-solid fa-star text-amber-400 text-lg"></i>
                                        </c:when>
                                        <c:when test="${review.totalRating >= (i - 0.5)}">
                                            <i class="fa-solid fa-star-half-stroke text-amber-400 text-lg"></i>
                                        </c:when>
                                        <c:otherwise>
                                            <i class="fa-solid fa-star text-slate-200 text-lg"></i>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </div>
                            <span class="text-slate-700 ml-1 font-mono text-lg font-bold">
                                ${review.totalRating} <span class="text-slate-400 font-normal text-sm">/ 5.0</span>
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Mood Tags (와이어프레임 MoodBadge 스타일) -->
                <c:if test="${not empty review.moodTags}">
                    <div class="flex flex-wrap gap-2">
                        <c:forEach items="${fn:split(review.moodTags, ',')}" var="tag">
                            <c:if test="${not empty fn:trim(tag)}">
                                <span class="inline-flex items-center gap-1 bg-slate-100 text-slate-700 border border-slate-300 rounded font-mono px-2 py-1 text-xs">
                                    <i class="fa-solid fa-tag text-[10px] text-slate-400"></i>
                                    <span><c:out value="${fn:startsWith(fn:trim(tag), '#') ? fn:trim(tag) : '#' += fn:trim(tag)}" /></span>
                                </span>
                            </c:if>
                        </c:forEach>
                    </div>
                </c:if>

                <!-- Daily Summary Body -->
                <div class="space-y-2">
                    <h4 class="text-xs font-bold uppercase tracking-wider text-slate-400 font-mono">
                        Daily Summary (오늘 하루 총평)
                    </h4>
                    <p class="text-base text-slate-800 leading-relaxed font-sans bg-slate-50/60 p-4 rounded-xl border border-slate-200 whitespace-pre-line">
                        <c:out value="${review.overallComment}" />
                    </p>
                </div>

                <!-- Representative Image / PlaceholderBox -->
                <div class="pt-2">
                    <c:choose>
                        <%-- 실제 업로드된 이미지가 있는 경우 (사진 크기에 맞춰 영역이 자동 확장되며 원본 전체 표시) --%>
                        <c:when test="${not empty review.mainImageUrl}">
                            <div class="w-full border-2 border-dashed border-slate-300 rounded-xl overflow-hidden bg-slate-50 relative group">
                                <img src="${review.mainImageUrl}" 
                                     alt="오늘 하루 대표 이미지" 
                                     class="w-full h-auto block rounded-lg transition-transform group-hover:scale-[1.005]" />
                                <div class="absolute bottom-3 right-3 bg-slate-900/80 backdrop-blur-xs text-white text-[11px] font-mono px-2.5 py-1 rounded-md shadow-xs">
                                    <i class="fa-solid fa-camera mr-1 text-slate-300"></i>대표 사진
                                </div>
                            </div>
                        </c:when>
                        <%-- 등록된 이미지가 없을 때의 와이어프레임 PlaceholderBox --%>
                        <c:otherwise>
                            <div class="w-full h-56 border-2 border-dashed border-slate-300 rounded-lg bg-slate-100/70 flex flex-col items-center justify-center p-4 text-center text-slate-500 hover:bg-slate-100 transition-colors">
                                <div class="w-10 h-10 rounded-full bg-slate-200/80 flex items-center justify-center mb-2 text-slate-400">
                                    <i class="fa-regular fa-image text-lg"></i>
                                </div>
                                <span class="font-mono text-xs font-semibold text-slate-600">
                                    [오늘 하루 대표 이미지 영역]
                                </span>
                                <span class="text-[11px] text-slate-400 mt-1 max-w-xs">
                                    하루의 대표 하이라이트 사진 / 영수증 인증 샷
                                </span>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </article>

            <!-- --------------------------------------------------------------------- -->
            <!-- 2. Sub-Reviews Section (1 : N 세부 리뷰 카드 목록) -->
            <!-- --------------------------------------------------------------------- -->
            <section class="space-y-4">
                <div class="flex items-center justify-between pb-2 border-b-2 border-dashed border-slate-300">
                    <div class="flex items-center gap-2">
                        <i class="fa-solid fa-layer-group text-blue-600 text-lg"></i>
                        <h3 class="text-lg font-bold text-slate-900">
                            이 날의 세부 서브 리뷰 (${empty subReviews ? 0 : subReviews.size()}개)
                        </h3>
                    </div>
                    <span class="text-xs text-slate-500 font-mono">
                        1:N 세부 리뷰 카드 목록
                    </span>
                </div>

                <!-- 서브 리뷰 카드 리스트 (SubReviewCard 컴포넌트 완벽 일치) -->
                <c:choose>
                    <c:when test="${not empty subReviews}">
                        <div class="space-y-4">
                            <c:forEach items="${subReviews}" var="sub">
                                <div class="border-2 border-dashed border-slate-300 rounded-lg p-4 bg-white/90 shadow-sm space-y-3 relative group transition-all hover:border-slate-400">
                                    
                                    <!-- Top row: Category Badge, Verified mark, Rating -->
                                    <div class="flex items-center justify-between">
                                        <div class="flex items-center gap-2">
                                            <!-- CategoryBadge (점선 테두리 카테고리 뱃지) -->
                                            <c:choose>
                                                <c:when test="${sub.category eq 'place'}">
                                                    <span class="inline-flex items-center gap-1 font-medium border border-dashed rounded-md px-2.5 py-1 text-xs bg-emerald-50 text-emerald-700 border-emerald-300">
                                                        <i class="fa-solid fa-mug-hot text-xs"></i>
                                                        <span>장소·식당·카페</span>
                                                    </span>
                                                </c:when>
                                                <c:when test="${sub.category eq 'item'}">
                                                    <span class="inline-flex items-center gap-1 font-medium border border-dashed rounded-md px-2.5 py-1 text-xs bg-sky-50 text-sky-700 border-sky-300">
                                                        <i class="fa-solid fa-laptop text-xs"></i>
                                                        <span>아이템·전자기기</span>
                                                    </span>
                                                </c:when>
                                                <c:when test="${sub.category eq 'transport'}">
                                                    <span class="inline-flex items-center gap-1 font-medium border border-dashed rounded-md px-2.5 py-1 text-xs bg-amber-50 text-amber-700 border-amber-300">
                                                        <i class="fa-solid fa-car text-xs"></i>
                                                        <span>차량·이동수단</span>
                                                    </span>
                                                </c:when>
                                                <c:when test="${sub.category eq 'content'}">
                                                    <span class="inline-flex items-center gap-1 font-medium border border-dashed rounded-md px-2.5 py-1 text-xs bg-purple-50 text-purple-700 border-purple-300">
                                                        <i class="fa-solid fa-clapperboard text-xs"></i>
                                                        <span>미디어·콘텐츠</span>
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="inline-flex items-center gap-1 font-medium border border-dashed rounded-md px-2.5 py-1 text-xs bg-slate-100 text-slate-700 border-slate-300">
                                                        <i class="fa-solid fa-tag text-xs"></i>
                                                        <span>${sub.category}</span>
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>

                                            <!-- 내돈내산 인증 뱃지 -->
                                            <c:if test="${sub.isCertified eq 'Y'}">
                                                <span class="inline-flex items-center gap-1 text-[11px] font-medium text-emerald-700 bg-emerald-50 px-1.5 py-0.5 rounded border border-emerald-200">
                                                    <i class="fa-regular fa-circle-check text-emerald-600 text-xs"></i>
                                                    <span>내돈내산 인증</span>
                                                </span>
                                            </c:if>
                                        </div>

                                        <!-- 서브 평점 별점 표시 -->
                                        <div class="inline-flex items-center gap-1.5 select-none">
                                            <div class="flex items-center gap-0.5">
                                                <c:forEach var="si" begin="1" end="5">
                                                    <c:choose>
                                                        <c:when test="${sub.subRating >= si}">
                                                            <i class="fa-solid fa-star text-amber-400 text-xs"></i>
                                                        </c:when>
                                                        <c:when test="${sub.subRating >= (si - 0.5)}">
                                                            <i class="fa-solid fa-star-half-stroke text-amber-400 text-xs"></i>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <i class="fa-solid fa-star text-slate-200 text-xs"></i>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </div>
                                            <span class="text-slate-700 ml-1 font-mono text-xs">
                                                ${sub.subRating} <span class="text-slate-400 font-normal">/ 5.0</span>
                                            </span>
                                        </div>
                                    </div>

                                    <!-- Sub-item Title & Brand/Place -->
                                    <div>
                                        <h4 class="text-base font-bold text-slate-800 flex items-center gap-1.5">
                                            <c:out value="${sub.itemName}" />
                                        </h4>
                                        <c:if test="${not empty sub.locationBrand}">
                                            <p class="text-xs text-slate-500 flex items-center gap-1 mt-0.5">
                                                <i class="fa-solid fa-location-dot text-slate-400 text-xs"></i>
                                                <span><c:out value="${sub.locationBrand}" /></span>
                                            </p>
                                        </c:if>
                                    </div>

                                    <!-- Comment / Review text -->
                                    <p class="text-sm text-slate-700 bg-slate-50 p-2.5 rounded border border-slate-200 leading-relaxed font-sans whitespace-pre-line">
                                        <c:out value="${sub.subComment}" />
                                    </p>

                                    <!-- Tags (MoodBadge 스타일) -->
                                    <c:if test="${not empty sub.tags}">
                                        <div class="flex flex-wrap gap-1.5 pt-1">
                                            <c:forEach items="${fn:split(sub.tags, ',')}" var="subTag">
                                                <c:if test="${not empty fn:trim(subTag)}">
                                                    <span class="inline-flex items-center gap-1 bg-slate-100 text-slate-700 border border-slate-300 rounded font-mono px-1.5 py-0.5 text-xs">
                                                        <i class="fa-solid fa-tag text-[10px] text-slate-400"></i>
                                                        <span><c:out value="${fn:startsWith(fn:trim(subTag), '#') ? fn:trim(subTag) : '#' += fn:trim(subTag)}" /></span>
                                                    </span>
                                                </c:if>
                                            </c:forEach>
                                        </div>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="p-8 border-2 border-dashed border-slate-300 rounded-lg bg-white/90 text-center space-y-2">
                            <p class="text-xs text-slate-500 font-mono">
                                등록된 세부 서브 리뷰가 없습니다.
                            </p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </section>

            <!-- --------------------------------------------------------------------- -->
            <!-- 3. BM Sponsored Overview Box (이 날의 연계 제휴 상품 모아보기) -->
            <!-- --------------------------------------------------------------------- -->
            <c:if test="${not empty allSponsored}">
                <section class="border-2 border-dashed border-amber-300 rounded-2xl bg-amber-50/40 p-6 space-y-4">
                    <div class="flex items-center justify-between pb-3 border-b border-amber-200">
                        <div class="flex items-center gap-2">
                            <i class="fa-solid fa-wand-magic-sparkles text-amber-600 text-lg"></i>
                            <h3 class="text-base font-bold text-amber-950">
                                BM 제휴 큐레이션: 이 날의 추천 아이템 & 장소 최저가
                            </h3>
                        </div>
                        <span class="text-xs font-mono text-amber-700 bg-amber-200/60 px-2 py-0.5 rounded font-semibold">
                            제휴 파트너스 연동
                        </span>
                    </div>

                    <p class="text-xs text-amber-800 leading-relaxed">
                        리뷰어가 직접 경험하고 높은 평점을 남긴 장소/아이템의 실시간 최저가 및 예약 링크입니다. 구매 및 예약 시 플랫폼과 리뷰어에게 소정의 리워드가 제공됩니다.
                    </p>

                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-3 pt-2">
                        <c:forEach items="${allSponsored}" var="sp">
                            <div class="border-2 border-dashed border-amber-300 bg-amber-50/50 rounded-xl p-3.5 space-y-3 transition-all hover:border-amber-400 w-full">
                                <div class="flex items-center justify-between gap-1 pb-2 border-b border-amber-200/80">
                                    <div class="flex items-center gap-1.5 min-w-0 flex-1">
                                        <span class="bg-amber-400 text-amber-950 text-[10px] font-mono font-bold px-1.5 py-0.5 rounded shrink-0">
                                            BM 제휴 광고
                                        </span>
                                        <span class="text-xs text-amber-900 font-medium truncate flex items-center gap-1">
                                            <i class="fa-solid fa-sparkles text-amber-600 text-xs"></i>
                                            <span class="truncate">${sp.category} 연계 제휴</span>
                                        </span>
                                    </div>
                                    <span class="text-[10px] text-amber-700 font-mono shrink-0 hidden sm:inline">
                                        파트너스 추천
                                    </span>
                                </div>

                                <div class="flex items-start gap-2.5">
                                    <div class="w-10 h-10 rounded-lg bg-amber-100 border border-dashed border-amber-300 flex items-center justify-center text-amber-700 shrink-0">
                                        <i class="fa-solid fa-bag-shopping text-base"></i>
                                    </div>
                                    <div class="min-w-0 flex-1">
                                        <div class="flex flex-wrap items-center gap-1.5">
                                            <span class="text-[10px] font-bold text-amber-900 bg-amber-200/80 px-1.5 py-0.5 rounded">
                                                ${sp.merchantName}
                                            </span>
                                        </div>
                                        <p class="text-xs font-bold text-slate-800 mt-1 truncate" title="${sp.productName}">
                                            <c:out value="${sp.productName}" />
                                        </p>
                                        <div class="flex flex-wrap items-baseline gap-1.5 mt-0.5">
                                            <span class="text-sm font-bold text-slate-900 font-mono">
                                                ${sp.discountPrice}원
                                            </span>
                                            <c:if test="${not empty sp.discountRate}">
                                                <span class="text-[11px] font-bold text-rose-600 font-mono">
                                                    (${sp.discountRate} OFF)
                                                </span>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>

                                <div class="pt-0.5">
                                    <a href="${empty sp.affiliateUrl ? '#' : sp.affiliateUrl}" 
                                       target="_blank" 
                                       rel="noopener noreferrer"
                                       class="inline-flex items-center justify-center gap-1.5 w-full py-2 px-3 bg-slate-900 hover:bg-slate-800 text-white rounded-lg text-xs font-bold shadow-xs transition-colors">
                                        <span>제휴 최저가 확인</span>
                                        <i class="fa-solid fa-arrow-up-right-from-square text-[11px]"></i>
                                    </a>
                                    <p class="text-[10px] text-slate-400 text-center mt-1 font-mono">
                                        * 구매/예약 시 소정의 파트너스 수수료가 정산됩니다
                                    </p>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </section>
            </c:if>

            <!-- --------------------------------------------------------------------- -->
            <!-- 4. Comments / Social Skeleton Section (댓글 및 반응) -->
            <!-- --------------------------------------------------------------------- -->
            <section class="border-2 border-dashed border-slate-300 rounded-2xl bg-white p-6 space-y-4">
                <div class="flex items-center justify-between pb-3 border-b border-slate-200">
                    <div class="flex items-center gap-2">
                        <i class="fa-regular fa-comment-dots text-slate-600 text-base"></i>
                        <h4 class="text-sm font-bold text-slate-800">
                            댓글 및 반응 (${empty comments ? 0 : comments.size()})
                        </h4>
                    </div>
                    <span class="text-xs text-slate-400 font-mono">와이어프레임 영역</span>
                </div>

                <!-- 댓글 목록 출력 -->
                <div class="space-y-3" id="commentsContainer">
                    <c:choose>
                        <c:when test="${not empty comments}">
                            <c:forEach items="${comments}" var="comment">
                                <div class="p-3 bg-slate-50 rounded-lg border border-slate-200 text-xs space-y-1">
                                    <div class="flex items-center justify-between">
                                        <div class="flex items-center gap-1.5">
                                            <div class="w-5 h-5 rounded-full bg-slate-800 text-white font-mono text-[10px] flex items-center justify-center font-bold uppercase">
                                                <c:choose>
                                                    <c:when test="${not empty comment.authorAvatar}">
                                                        ${comment.authorAvatar}
                                                    </c:when>
                                                    <c:when test="${not empty comment.nickname}">
                                                        ${fn:substring(comment.nickname, 0, 1)}
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${fn:substring(comment.userId, 0, 1)}
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <span class="font-bold text-slate-800">
                                                ${empty comment.nickname ? comment.userId : comment.nickname}
                                            </span>
                                        </div>
                                        <div class="flex items-center gap-2">
                                            <span class="text-[10px] text-slate-400 font-mono">
                                                <c:choose>
                                                    <c:when test="${not empty comment.timeAgo}">
                                                        ${comment.timeAgo}
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${comment.createdAt}
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>

                                            <!-- 작성자 본인 댓글 삭제 폼 -->
                                            <c:if test="${not empty sessionScope.loginUser and (sessionScope.loginUser.userId eq comment.userId or sessionScope.loginUser.user_id eq comment.userId)}">
                                                <form action="${pageContext.request.contextPath}/comment/delete" 
                                                      method="post" 
                                                      class="inline m-0"
                                                      onsubmit="return confirm('댓글을 삭제하시겠습니까?');">
                                                    <input type="hidden" name="commentId" value="${comment.commentId}" />
                                                    <input type="hidden" name="reviewId" value="${review.reviewId}" />
                                                    <button type="submit" 
                                                            class="text-slate-400 hover:text-rose-600 transition-colors p-0.5 cursor-pointer" 
                                                            title="댓글 삭제">
                                                        <i class="fa-regular fa-trash-can text-xs"></i>
                                                    </button>
                                                </form>
                                            </c:if>
                                        </div>
                                    </div>
                                    <p class="text-slate-600 pl-6.5 leading-relaxed">
                                        <c:out value="${comment.content}" />
                                    </p>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="py-4 text-center text-xs text-slate-400 font-mono">
                                아직 작성된 댓글이 없습니다. 첫 번째 응원의 한마디를 남겨보세요!
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Comment Input Skeleton -->
                <c:choose>
                    <%-- 로그인 상태: 댓글 작성 폼 활성화 --%>
                    <c:when test="${not empty sessionScope.loginUser}">
                        <form id="commentForm" 
                              action="${pageContext.request.contextPath}/comment/write" 
                              method="post" 
                              class="space-y-1.5 pt-2">
                            <input type="hidden" name="reviewId" value="${review.reviewId}" />
                            <div class="flex gap-2">
                                <input
                                    type="text"
                                    name="content"
                                    id="commentInput"
                                    required
                                    maxlength="500"
                                    placeholder="이 날의 하루에 응원의 한마디나 질문을 남겨보세요..."
                                    class="flex-1 px-3 py-2 text-xs border border-dashed border-slate-300 rounded-lg bg-slate-50 focus:outline-none focus:border-slate-700 transition-colors font-sans"
                                />
                                <button
                                    type="submit"
                                    class="px-4 py-2 bg-slate-900 hover:bg-slate-800 text-white rounded-lg text-xs font-semibold flex items-center gap-1.5 transition-colors cursor-pointer"
                                >
                                    <i class="fa-solid fa-paper-plane text-[10px]"></i>
                                    <span>등록</span>
                                </button>
                            </div>
                            <div class="flex justify-between items-center text-[10px] text-slate-400 font-mono px-1">
                                <span>* 부적절한 언어 사용 시 삭제될 수 있습니다.</span>
                                <span id="commentLengthCounter">0 / 500자</span>
                            </div>
                        </form>
                    </c:when>

                    <%-- 비로그인 상태: 로그인 안내 링크 --%>
                    <c:otherwise>
                        <div class="p-3 bg-slate-50 rounded-lg border border-dashed border-slate-300 text-center space-y-1.5">
                            <p class="text-xs text-slate-500">
                                댓글을 작성하려면 로그인이 필요합니다.
                            </p>
                            <a href="${pageContext.request.contextPath}/member/signin" 
                               class="inline-flex items-center gap-1.5 px-3 py-1 bg-blue-50 text-blue-700 border border-blue-200 rounded-md text-xs font-bold hover:bg-blue-100 transition-colors">
                                <i class="fa-solid fa-right-to-bracket text-xs"></i>
                                <span>로그인하러 가기</span>
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </section>

            <!-- --------------------------------------------------------------------- -->
            <!-- 5. Floating CTA Banner (나의 하루 작성 유도 배너) -->
            <!-- --------------------------------------------------------------------- -->
            <div class="border-2 border-dashed border-blue-300 rounded-xl bg-blue-50/60 p-4 flex flex-col sm:flex-row items-center justify-between gap-3">
                <div class="text-xs text-blue-950">
                    <strong>나의 하루도 기록해 볼까요?</strong> 오늘 있었던 일과 서브 리뷰를 남겨보세요.
                </div>
                <a href="${pageContext.request.contextPath}/RE:DAY/review/write" 
                   class="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg text-xs font-bold shadow flex items-center gap-1.5 shrink-0 transition-colors">
                    <i class="fa-solid fa-circle-plus text-xs"></i>
                    <span>오늘 리뷰 작성하기</span>
                </a>
            </div>

        </c:if>
    </div>

    <!-- 리뷰 상세 전용 스크립트 분리 -->
    <script src="<%=request.getContextPath()%>/js/reviewDetail.js"></script>
</body>
</html>
