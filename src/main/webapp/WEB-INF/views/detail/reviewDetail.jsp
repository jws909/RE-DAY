<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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

    <!-- 공통 Head 태그 (Tailwind CSS CDN & Font Awesome 6 포함) -->
    <%@ include file="/WEB-INF/views/include/head.jsp"%>

    <!-- 리뷰 상세 전용 스타일시트 분리 -->
    <link href="<%=request.getContextPath()%>/css/detail/reviewDetail.css" rel="stylesheet">
</head>
<body class="bg-slate-100 text-slate-900 min-h-screen pb-16 font-sans antialiased">

    <!-- 상단 네비게이션 바 -->
    <%@ include file="/WEB-INF/views/include/navbar.jsp"%>

    <div class="max-w-4xl mx-auto px-4 sm:px-6 space-y-8">

        <%-- ========================================================================= --%>
        <%-- CASE 1: 리뷰 데이터가 존재하지 않는 경우 (예외/삭제된 리뷰 처리) --%>
        <%-- ========================================================================= --%>
        <c:if test="${empty review}">
            <div class="py-16 text-center">
                <div class="p-8 border-2 border-dashed border-slate-300 rounded-2xl bg-white space-y-4 max-w-md mx-auto shadow-xs">
                    <div class="w-16 h-16 rounded-full bg-slate-100 text-slate-400 mx-auto flex items-center justify-center text-2xl">
                        <i class="fa-solid fa-layer-group"></i>
                    </div>
                    <h2 class="text-xl font-bold text-slate-800">리뷰를 찾을 수 없습니다</h2>
                    <p class="text-xs text-slate-500 leading-relaxed">
                        요청하신 데일리 리뷰가 삭제되었거나, 비공개 상태이거나, 존재하지 않는 ID입니다.
                    </p>
                    <div class="pt-2">
                        <a href="${pageContext.request.contextPath}/" 
                           class="inline-flex items-center gap-2 px-5 py-2.5 bg-slate-900 hover:bg-slate-800 text-white rounded-xl text-xs font-bold transition-all shadow-xs">
                            <i class="fa-solid fa-arrow-left text-xs"></i>
                            <span>홈 피드로 돌아가기</span>
                        </a>
                    </div>
                </div>
            </div>
        </c:if>

        <%-- ========================================================================= --%>
        <%-- CASE 2: 정상적인 리뷰 상세 화면 렌더링 (Server-Side Rendering) --%>
        <%-- ========================================================================= --%>
        <c:if test="${not empty review}">

            <!-- --------------------------------------------------------------------- -->
            <!-- 1. Header Navigation & Top Action Toolbar -->
            <!-- --------------------------------------------------------------------- -->
            <header class="flex flex-wrap items-center justify-between gap-3 pb-4 border-b-2 border-dashed border-slate-300">
                <div>
                    <a href="javascript:history.back()" 
                       class="inline-flex items-center gap-1.5 text-xs text-slate-500 hover:text-slate-900 font-mono transition-colors">
                        <i class="fa-solid fa-arrow-left text-xs"></i>
                        <span>목록으로</span>
                    </a>
                    <h1 class="text-xl sm:text-2xl font-bold text-slate-900 flex items-center gap-2 mt-1">
                        <span>${review.reviewDate} 하루 상세</span>
                        <c:choose>
                            <c:when test="${review.isPublic eq 'Y'}">
                                <span class="text-[11px] bg-emerald-50 text-emerald-700 border border-emerald-200 px-2 py-0.5 rounded font-mono font-medium">
                                    <i class="fa-solid fa-globe text-[10px] mr-1"></i>전체공개
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="text-[11px] bg-slate-200 text-slate-700 border border-slate-300 px-2 py-0.5 rounded font-mono font-medium">
                                    <i class="fa-solid fa-lock text-[10px] mr-1"></i>비공개
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </h1>
                </div>

                <!-- Top Right Action Buttons (좋아요, 공유, 수정/삭제) -->
                <div class="flex items-center gap-2">
                    <!-- 좋아요 버튼 (Spring MVC 백엔드 POST 처리) -->
                    <form action="${pageContext.request.contextPath}/review/like" method="post" class="inline m-0" id="likeForm">
                        <input type="hidden" name="reviewId" value="${review.reviewId}" />
                        <button type="submit" 
                                id="likeButton"
                                class="flex items-center gap-1.5 px-3.5 py-1.5 rounded-lg border text-xs font-semibold transition-all cursor-pointer ${isLiked ? 'bg-rose-50 border-rose-300 text-rose-600 shadow-xs' : 'bg-white border-slate-300 text-slate-700 hover:bg-slate-50'}">
                            <i class="fa-solid fa-heart text-sm ${isLiked ? 'text-rose-500' : 'text-slate-400'}"></i>
                            <span>좋아요</span>
                            <span id="likeCountSpan" class="font-mono font-bold">${review.likeCount}</span>
                        </button>
                    </form>

                    <!-- 공유하기 버튼 (클립보드 URL 복사) -->
                    <button type="button" 
                            id="shareButton"
                            onclick="copyCurrentUrl()"
                            title="리뷰 URL 복사"
                            class="p-2 rounded-lg border border-slate-300 bg-white hover:bg-slate-50 text-slate-600 transition-colors cursor-pointer text-xs flex items-center justify-center">
                        <i class="fa-solid fa-share-nodes text-sm"></i>
                    </button>

                    <!-- 작성자 본인일 경우 수정 / 삭제 버튼 노출 -->
                    <c:if test="${not empty sessionScope.loginUser and (sessionScope.loginUser.userId eq review.userId or sessionScope.loginUser.user_id eq review.userId)}">
                        <div class="flex items-center gap-1.5 pl-2 border-l border-slate-300">
                            <!-- 수정 이동 -->
                            <a href="${pageContext.request.contextPath}/review/edit?id=${review.reviewId}"
                               class="px-2.5 py-1.5 rounded-lg border border-slate-300 bg-white hover:bg-slate-50 text-slate-700 text-xs font-medium transition-colors">
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
            </header>

            <!-- --------------------------------------------------------------------- -->
            <!-- 2. SECTION 1: Main Daily Review (메인 데일리 종합 리뷰) -->
            <!-- --------------------------------------------------------------------- -->
            <article class="border-2 border-dashed border-slate-300 rounded-2xl bg-white p-6 sm:p-8 space-y-6 shadow-xs">
                
                <!-- 작성자 정보 + 리뷰 일자 + 하루 종합 별점 점수 박스 -->
                <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-5 border-b border-slate-200">
                    
                    <!-- 작성자 프로필 카드 -->
                    <div class="flex items-center gap-3.5">
                        <c:choose>
                            <c:when test="${not empty review.authorProfileImg}">
                                <img src="${review.authorProfileImg}" alt="${review.authorNickname}" class="w-12 h-12 rounded-full object-cover border border-slate-300 shadow-xs" />
                            </c:when>
                            <c:otherwise>
                                <div class="w-12 h-12 rounded-full bg-slate-900 text-white font-mono font-bold flex items-center justify-center text-base shadow-xs">
                                    <c:choose>
                                        <c:when test="${not empty review.authorAvatar}">
                                            ${review.authorAvatar}
                                        </c:when>
                                        <c:when test="${not empty review.authorNickname}">
                                            ${review.authorNickname}
                                        </c:when>
                                        <c:otherwise>
                                            ${review.userId}
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <div class="space-y-0.5">
                            <div class="flex items-center gap-2 flex-wrap">
                                <span class="font-bold text-base text-slate-900">
                                    ${empty review.authorNickname ? review.userId : review.authorNickname}
                                </span>
                                <span class="text-[11px] font-mono text-slate-600 bg-slate-100 px-2 py-0.5 rounded border border-slate-200 font-semibold">
                                    ${empty review.authorLevel ? 'LV1' : review.authorLevel}
                                </span>
                                <c:if test="${not empty review.streakCount and review.streakCount > 0}">
                                    <span class="text-[11px] font-mono text-orange-600 bg-orange-50 px-2 py-0.5 rounded border border-orange-200 font-bold flex items-center gap-1">
                                        <i class="fa-solid fa-fire text-orange-500 text-xs"></i>
                                        <span>${review.streakCount}일 연속</span>
                                    </span>
                                </c:if>
                            </div>
                            <div class="flex items-center gap-2 text-xs text-slate-500 font-mono">
                                <i class="fa-regular fa-calendar-days text-slate-400"></i>
                                <span>${review.reviewDate}</span>
                                <c:if test="${not empty review.dayOfWeek}">
                                    <span class="text-slate-400">(${review.dayOfWeek})</span>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <!-- 하루 종합 평점 대형 박스 -->
                    <div class="flex flex-col sm:items-end bg-amber-50/90 p-4 rounded-xl border border-amber-200/80">
                        <span class="text-[11px] font-bold text-amber-800 uppercase tracking-wider mb-1 flex items-center gap-1">
                            <i class="fa-solid fa-star text-amber-500 text-xs"></i>
                            <span>오늘 하루 종합 평점</span>
                        </span>
                        <div class="flex items-center gap-2">
                            <!-- 별점 5개 시각화 (JSTL core 렌더링) -->
                            <div class="flex items-center text-amber-400 text-base" title="평점: ${review.totalRating} / 5.0">
                                <c:forEach var="i" begin="1" end="5">
                                    <c:choose>
                                        <c:when test="${review.totalRating >= i}">
                                            <i class="fa-solid fa-star"></i>
                                        </c:when>
                                        <c:when test="${review.totalRating >= (i - 0.5)}">
                                            <i class="fa-solid fa-star-half-stroke"></i>
                                        </c:when>
                                        <c:otherwise>
                                            <i class="fa-regular fa-star text-slate-300"></i>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </div>
                            <span class="font-mono font-bold text-lg text-slate-900 ml-1">
                                ${review.totalRating}
                            </span>
                            <span class="text-xs text-slate-400 font-mono">/ 5.0</span>
                        </div>
                    </div>
                </div>

                <!-- 오늘 하루 무드 태그 목록 (백엔드 List<String> 바인딩) -->
                <c:if test="${not empty review.moodTagList}">
                    <div class="space-y-1.5">
                        <span class="text-[11px] font-bold uppercase tracking-wider text-slate-400 font-mono">
                            오늘의 기분 & 무드 태그
                        </span>
                        <div class="flex flex-wrap gap-1.5">
                            <c:forEach items="${review.moodTagList}" var="tag">
                                <c:if test="${not empty tag}">
                                    <span class="inline-flex items-center gap-1 px-2.5 py-1 bg-slate-100 text-slate-700 text-xs rounded-lg font-mono border border-slate-200">
                                        <span class="text-blue-500 font-bold">#</span>
                                        <span><c:out value="${tag}" /></span>
                                    </span>
                                </c:if>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>

                <!-- 오늘 하루 총평 본문 -->
                <div class="space-y-2">
                    <h2 class="text-xs font-bold uppercase tracking-wider text-slate-400 font-mono">
                        Daily Summary (오늘 하루 총평)
                    </h2>
                    <div class="text-sm sm:text-base text-slate-800 leading-relaxed font-sans bg-slate-50/70 p-5 rounded-xl border border-slate-200 whitespace-pre-line">
                        <c:out value="${review.overallComment}" />
                    </div>
                </div>

                <!-- 하루 대표 이미지 영역 -->
                <div class="pt-2">
                    <c:choose>
                        <%-- 실제 업로드된 이미지가 있는 경우 --%>
                        <c:when test="${not empty review.mainImageUrl}">
                            <div class="rounded-xl overflow-hidden border-2 border-dashed border-slate-300 bg-slate-50 relative group">
                                <img src="${review.mainImageUrl}" 
                                     alt="오늘 하루 대표 이미지" 
                                     class="w-full max-h-[420px] object-cover rounded-lg transition-transform group-hover:scale-[1.01]" />
                                <div class="absolute bottom-2 right-2 bg-slate-900/80 backdrop-blur-xs text-white text-[11px] font-mono px-2.5 py-1 rounded-md">
                                    <i class="fa-solid fa-camera mr-1 text-slate-300"></i>대표 사진
                                </div>
                            </div>
                        </c:when>
                        <%-- 등록된 이미지가 없을 때의 와이어프레임 플레이스홀더 --%>
                        <c:otherwise>
                            <div class="border-2 border-dashed border-slate-300 rounded-xl p-8 bg-slate-50/80 text-center space-y-2 flex flex-col items-center justify-center">
                                <div class="w-10 h-10 rounded-full bg-slate-200 text-slate-400 flex items-center justify-center text-base">
                                    <i class="fa-regular fa-image"></i>
                                </div>
                                <div class="text-xs font-mono font-bold text-slate-600">
                                    [오늘 하루 대표 하이라이트 사진 영역]
                                </div>
                                <p class="text-[11px] text-slate-400 font-mono">
                                    대표 이미지 또는 영수증 인증 샷이 등록되지 않은 리뷰입니다.
                                </p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </article>

            <!-- --------------------------------------------------------------------- -->
            <!-- 3. SECTION 2: Sub-Reviews Section (1 : N 세부 리뷰 카드 목록) -->
            <!-- --------------------------------------------------------------------- -->
            <section class="space-y-4">
                <div class="flex items-center justify-between pb-2 border-b-2 border-dashed border-slate-300">
                    <div class="flex items-center gap-2">
                        <span class="w-6 h-6 rounded-full bg-blue-600 text-white font-mono text-xs flex items-center justify-center font-bold">
                            2
                        </span>
                        <h2 class="text-lg font-bold text-slate-900 flex items-center gap-2">
                            <span>이 날의 세부 서브 리뷰</span>
                            <span class="text-xs font-mono bg-blue-50 text-blue-700 px-2 py-0.5 rounded border border-blue-200 font-bold">
                                ${empty subReviews ? 0 : subReviews.size()}개
                            </span>
                        </h2>
                    </div>
                    <span class="text-xs text-slate-400 font-mono hidden sm:inline">
                        1:N 종속 서브 리뷰 시스템
                    </span>
                </div>

                <!-- 서브 리뷰 목록 출력 -->
                <c:choose>
                    <%-- 등록된 서브 리뷰가 있는 경우 --%>
                    <c:when test="${not empty subReviews}">
                        <div class="space-y-4">
                            <c:forEach items="${subReviews}" var="sub" varStatus="status">
                                <article class="border-2 border-dashed border-slate-300 rounded-2xl bg-white p-5 sm:p-6 space-y-4 shadow-xs transition-all hover:border-slate-400">
                                    
                                    <!-- 서브리뷰 상단: 카테고리 뱃지 + 인증 뱃지 + 평점 -->
                                    <div class="flex flex-wrap items-center justify-between gap-2 pb-3 border-b border-slate-100">
                                        <div class="flex items-center gap-2 flex-wrap">
                                            <!-- 카테고리 뱃지 (장소, 아이템, 이동수단, 콘텐츠) -->
                                            <c:choose>
                                                <c:when test="${sub.category eq 'place'}">
                                                    <span class="px-2.5 py-1 bg-emerald-50 text-emerald-700 border border-emerald-200 rounded-md text-xs font-bold flex items-center gap-1.5">
                                                        <i class="fa-solid fa-location-dot text-xs"></i>
                                                        <span>방문 장소/공간</span>
                                                    </span>
                                                </c:when>
                                                <c:when test="${sub.category eq 'item'}">
                                                    <span class="px-2.5 py-1 bg-blue-50 text-blue-700 border border-blue-200 rounded-md text-xs font-bold flex items-center gap-1.5">
                                                        <i class="fa-solid fa-box-open text-xs"></i>
                                                        <span>사용 아이템/장비</span>
                                                    </span>
                                                </c:when>
                                                <c:when test="${sub.category eq 'transport'}">
                                                    <span class="px-2.5 py-1 bg-purple-50 text-purple-700 border border-purple-200 rounded-md text-xs font-bold flex items-center gap-1.5">
                                                        <i class="fa-solid fa-car-side text-xs"></i>
                                                        <span>이동수단/교통</span>
                                                    </span>
                                                </c:when>
                                                <c:when test="${sub.category eq 'content'}">
                                                    <span class="px-2.5 py-1 bg-amber-50 text-amber-700 border border-amber-200 rounded-md text-xs font-bold flex items-center gap-1.5">
                                                        <i class="fa-solid fa-film text-xs"></i>
                                                        <span>콘텐츠/미디어</span>
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="px-2.5 py-1 bg-slate-100 text-slate-700 border border-slate-200 rounded-md text-xs font-bold">
                                                        ${sub.category}
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>

                                            <!-- 영수증 / 내돈내산 인증 뱃지 -->
                                            <c:if test="${sub.isCertified eq 'Y'}">
                                                <span class="px-2 py-0.5 bg-blue-600 text-white rounded text-[11px] font-bold flex items-center gap-1 shadow-2xs">
                                                    <i class="fa-solid fa-receipt text-[10px]"></i>
                                                    <span>영수증 인증 완료</span>
                                                </span>
                                            </c:if>
                                        </div>

                                        <!-- 서브 평점 별점 표시 -->
                                        <div class="flex items-center gap-1.5 bg-slate-50 px-2.5 py-1 rounded-lg border border-slate-200">
                                            <div class="flex items-center text-amber-400 text-xs">
                                                <c:forEach var="si" begin="1" end="5">
                                                    <c:choose>
                                                        <c:when test="${sub.subRating >= si}">
                                                            <i class="fa-solid fa-star"></i>
                                                        </c:when>
                                                        <c:when test="${sub.subRating >= (si - 0.5)}">
                                                            <i class="fa-solid fa-star-half-stroke"></i>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <i class="fa-regular fa-star text-slate-300"></i>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </div>
                                            <span class="font-mono font-bold text-xs text-slate-900">
                                                ${sub.subRating}
                                            </span>
                                        </div>
                                    </div>

                                    <!-- 서브 항목명 & 위치/브랜드 정보 -->
                                    <div>
                                        <h3 class="text-base sm:text-lg font-bold text-slate-900 flex items-center gap-2">
                                            <span><c:out value="${sub.itemName}" /></span>
                                        </h3>
                                        <c:if test="${not empty sub.locationBrand}">
                                            <p class="text-xs text-slate-500 font-mono mt-0.5 flex items-center gap-1">
                                                <i class="fa-solid fa-location-crosshairs text-slate-400 text-[11px]"></i>
                                                <span><c:out value="${sub.locationBrand}" /></span>
                                            </p>
                                        </c:if>
                                    </div>

                                    <!-- 세부 후기 코멘트 -->
                                    <div class="text-xs sm:text-sm text-slate-700 bg-slate-50/80 p-3.5 rounded-xl border border-slate-200/80 whitespace-pre-line leading-relaxed">
                                        <c:out value="${sub.subComment}" />
                                    </div>

                                    <!-- 세부 태그 목록 (백엔드 List<String> 바인딩) -->
                                    <c:if test="${not empty sub.tagList}">
                                        <div class="flex flex-wrap gap-1 pt-1">
                                            <c:forEach items="${sub.tagList}" var="subTag">
                                                <c:if test="${not empty subTag}">
                                                    <span class="text-[11px] font-mono text-slate-500 bg-slate-100 px-2 py-0.5 rounded border border-slate-200">
                                                        <c:out value="${subTag}" />
                                                    </span>
                                                </c:if>
                                            </c:forEach>
                                        </div>
                                    </c:if>

                                    <!-- 개별 서브리뷰 연계 제휴 상품 (스폰서드 영역) -->
                                    <c:if test="${not empty sub.sponsoredInfo}">
                                        <div class="mt-3 p-3.5 bg-amber-50/60 border-2 border-dashed border-amber-300 rounded-xl space-y-2">
                                            <div class="flex items-center justify-between text-xs">
                                                <span class="font-bold text-amber-900 flex items-center gap-1.5">
                                                    <i class="fa-solid fa-bag-shopping text-amber-600"></i>
                                                    <span>제휴 파트너스 최저가 추천</span>
                                                </span>
                                                <span class="text-[10px] font-mono text-amber-700 bg-amber-200/70 px-1.5 py-0.5 rounded">
                                                    AD / 제휴링크
                                                </span>
                                            </div>
                                            <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-2 text-xs">
                                                <div>
                                                    <p class="font-semibold text-slate-800"><c:out value="${sub.sponsoredInfo.productName}" /></p>
                                                    <p class="text-[11px] text-amber-700 font-mono">
                                                        최저가 <strong class="text-sm font-bold text-amber-900">${sub.sponsoredInfo.discountPrice}원</strong>
                                                        <c:if test="${not empty sub.sponsoredInfo.discountRate}">
                                                            <span class="text-rose-600 font-bold ml-1">(${sub.sponsoredInfo.discountRate} OFF)</span>
                                                        </c:if>
                                                    </p>
                                                </div>
                                                <a href="${empty sub.sponsoredInfo.affiliateUrl ? '#' : sub.sponsoredInfo.affiliateUrl}" 
                                                   target="_blank" 
                                                   rel="noopener noreferrer"
                                                   class="inline-flex items-center justify-center gap-1.5 px-3 py-1.5 bg-amber-500 hover:bg-amber-600 text-white font-bold rounded-lg text-xs transition-colors shadow-2xs">
                                                    <span>최저가 보러가기</span>
                                                    <i class="fa-solid fa-arrow-up-right-from-square text-[10px]"></i>
                                                </a>
                                            </div>
                                        </div>
                                    </c:if>
                                </article>
                            </c:forEach>
                        </div>
                    </c:when>
                    <%-- 등록된 서브 리뷰가 없는 경우 --%>
                    <c:otherwise>
                        <div class="p-8 border-2 border-dashed border-slate-300 rounded-2xl bg-white text-center space-y-2">
                            <p class="text-xs text-slate-500 font-mono">
                                등록된 세부 서브 리뷰가 없습니다.
                            </p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </section>

            <!-- --------------------------------------------------------------------- -->
            <!-- 4. SECTION 3: BM Sponsored Overview Box (이 날의 연계 제휴 상품 모아보기) -->
            <!-- --------------------------------------------------------------------- -->
            <c:if test="${not empty allSponsored}">
                <section class="border-2 border-dashed border-amber-300 rounded-2xl bg-amber-50/50 p-6 space-y-4">
                    <div class="flex items-center justify-between pb-3 border-b border-amber-200">
                        <div class="flex items-center gap-2">
                            <i class="fa-solid fa-sparkles text-amber-600 text-lg"></i>
                            <h2 class="text-base font-bold text-amber-950">
                                BM 제휴 큐레이션: 이 날의 추천 아이템 & 장소 최저가
                            </h2>
                        </div>
                        <span class="text-xs font-mono text-amber-800 bg-amber-200/70 px-2 py-0.5 rounded font-semibold">
                            제휴 파트너스 연동
                        </span>
                    </div>

                    <p class="text-xs text-amber-800 leading-relaxed">
                        리뷰어가 직접 경험하고 높은 평점을 남긴 장소/아이템의 실시간 최저가 및 예약 링크입니다. 구매 및 예약 시 플랫폼과 리뷰어에게 소정의 리워드가 제공됩니다.
                    </p>

                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-3.5 pt-1">
                        <c:forEach items="${allSponsored}" var="sp">
                            <div class="p-3.5 bg-white rounded-xl border border-amber-200 shadow-2xs space-y-2 flex flex-col justify-between">
                                <div>
                                    <div class="flex items-center justify-between text-[11px] text-amber-700 font-mono mb-1">
                                        <span class="font-bold">${sp.category} 연계 상품</span>
                                        <span>${sp.merchantName}</span>
                                    </div>
                                    <h4 class="font-bold text-xs sm:text-sm text-slate-900 leading-tight">
                                        <c:out value="${sp.productName}" />
                                    </h4>
                                </div>
                                <div class="pt-2 flex items-center justify-between border-t border-slate-100">
                                    <span class="text-xs font-mono text-slate-600">
                                        최저 <strong class="text-sm font-bold text-slate-900">${sp.discountPrice}원</strong>
                                    </span>
                                    <a href="${empty sp.affiliateUrl ? '#' : sp.affiliateUrl}" 
                                       target="_blank"
                                       rel="noopener noreferrer"
                                       class="px-2.5 py-1 bg-amber-100 hover:bg-amber-200 text-amber-900 rounded text-xs font-bold transition-colors font-mono flex items-center gap-1">
                                        <span>구매/예약</span>
                                        <i class="fa-solid fa-chevron-right text-[10px]"></i>
                                    </a>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </section>
            </c:if>

            <!-- --------------------------------------------------------------------- -->
            <!-- 5. SECTION 4: Social Comments & Reactions (댓글 & 실시간 피드백) -->
            <!-- --------------------------------------------------------------------- -->
            <section class="border-2 border-dashed border-slate-300 rounded-2xl bg-white p-6 space-y-5 shadow-xs">
                
                <div class="flex items-center justify-between pb-3 border-b border-slate-200">
                    <div class="flex items-center gap-2">
                        <i class="fa-regular fa-comment-dots text-slate-600 text-base"></i>
                        <h2 class="text-sm font-bold text-slate-800 flex items-center gap-1.5">
                            <span>댓글 및 반응</span>
                            <span class="text-xs font-mono font-bold text-blue-600 bg-blue-50 px-1.5 py-0.2 rounded border border-blue-200">
                                ${empty comments ? 0 : comments.size()}
                            </span>
                        </h2>
                    </div>
                    <span class="text-xs text-slate-400 font-mono">실시간 피드백</span>
                </div>

                <!-- 댓글 목록 출력 (Server-Side JSTL 반복문) -->
                <div class="space-y-3" id="commentsContainer">
                    <c:choose>
                        <c:when test="${not empty comments}">
                            <c:forEach items="${comments}" var="comment">
                                <div class="p-3.5 bg-slate-50 rounded-xl border border-slate-200 text-xs space-y-1.5">
                                    <div class="flex items-center justify-between">
                                        <div class="flex items-center gap-2">
                                            <!-- 댓글 작성자 아바타/이니셜 -->
                                            <div class="w-5 h-5 rounded-full bg-slate-800 text-white font-mono text-[10px] flex items-center justify-center font-bold">
                                                <c:choose>
                                                    <c:when test="${not empty comment.authorAvatar}">
                                                        ${comment.authorAvatar}
                                                    </c:when>
                                                    <c:when test="${not empty comment.nickname}">
                                                        ${comment.nickname}
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${comment.userId}
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

                                            <!-- 댓글 삭제 버튼 (작성자 본인 또는 관리자일 경우) -->
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
                                    <p class="text-slate-700 leading-relaxed pl-7">
                                        <c:out value="${comment.content}" />
                                    </p>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="py-6 text-center text-xs text-slate-400 font-mono">
                                아직 작성된 댓글이 없습니다. 첫 번째 응원의 한마디를 남겨보세요!
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- 댓글 작성 영역 (Spring MVC POST 폼) -->
                <c:choose>
                    <%-- 로그인 상태: 댓글 작성 폼 활성화 --%>
                    <c:when test="${not empty sessionScope.loginUser}">
                        <form id="commentForm" 
                              action="${pageContext.request.contextPath}/comment/write" 
                              method="post" 
                              class="space-y-2 pt-2 border-t border-slate-200">
                            <input type="hidden" name="reviewId" value="${review.reviewId}" />
                            <div class="flex gap-2">
                                <input
                                    type="text"
                                    name="content"
                                    id="commentInput"
                                    required
                                    maxlength="500"
                                    placeholder="이 날의 하루에 응원의 한마디나 질문을 남겨보세요..."
                                    class="flex-1 px-3.5 py-2.5 text-xs border-2 border-dashed border-slate-300 rounded-xl bg-slate-50 focus:outline-none focus:border-slate-800 focus:bg-white transition-all font-sans"
                                />
                                <button
                                    type="submit"
                                    class="px-4 py-2.5 bg-slate-900 hover:bg-slate-800 text-white rounded-xl text-xs font-semibold flex items-center gap-1.5 transition-all shadow-xs cursor-pointer"
                                >
                                    <i class="fa-solid fa-paper-plane text-xs"></i>
                                    <span>등록</span>
                                </button>
                            </div>
                            <div class="flex justify-between items-center text-[10px] text-slate-400 font-mono px-1">
                                <span>* 부적절한 언어 사용 시 삭제될 수 있습니다.</span>
                                <span id="commentLengthCounter">0 / 500자</span>
                            </div>
                        </form>
                    </c:when>

                    <%-- 비로그인 상태: 로그인 안내 및 이동 버튼 --%>
                    <c:otherwise>
                        <div class="p-4 bg-slate-50 rounded-xl border border-dashed border-slate-300 text-center space-y-2">
                            <p class="text-xs text-slate-500">
                                댓글을 작성하려면 로그인이 필요합니다.
                            </p>
                            <a href="${pageContext.request.contextPath}/member/signin" 
                               class="inline-flex items-center gap-1.5 px-3 py-1.5 bg-blue-50 text-blue-700 border border-blue-200 rounded-lg text-xs font-bold hover:bg-blue-100 transition-colors">
                                <i class="fa-solid fa-right-to-bracket text-xs"></i>
                                <span>로그인하러 가기</span>
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </section>

            <!-- --------------------------------------------------------------------- -->
            <!-- 6. Floating CTA Banner (나의 하루 작성 유도 배너) -->
            <!-- --------------------------------------------------------------------- -->
            <div class="border-2 border-dashed border-blue-300 rounded-2xl bg-blue-50/70 p-5 flex flex-col sm:flex-row items-center justify-between gap-4 shadow-xs">
                <div class="space-y-0.5 text-center sm:text-left">
                    <h3 class="text-sm font-bold text-blue-950">
                        나의 오늘 하루도 기록해 볼까요?
                    </h3>
                    <p class="text-xs text-blue-800">
                        하루 총평과 방문 장소, 소비 아이템을 1:N 서브 리뷰로 남겨보세요.
                    </p>
                </div>
                <a href="${pageContext.request.contextPath}/RE:DAY/review/write" 
                   class="w-full sm:w-auto px-5 py-2.5 bg-blue-600 hover:bg-blue-700 text-white rounded-xl text-xs font-bold shadow-xs flex items-center justify-center gap-1.5 transition-all">
                    <i class="fa-solid fa-circle-plus text-xs"></i>
                    <span>오늘 리뷰 작성하기</span>
                </a>
            </div>

        </c:if>
    </div>

    <!-- 리뷰 상세 전용 스크립트 분리 -->
    <script src="<%=request.getContextPath()%>/js/detail/reviewDetail.js"></script>
</body>
</html>
