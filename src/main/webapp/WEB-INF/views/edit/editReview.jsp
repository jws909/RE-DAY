<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>오늘의 하루 리뷰 수정 - RE:DAY</title>

    <!-- 공통 Head 태그 (Tailwind & Font Awesome 포함) -->
    <%@ include file="/WEB-INF/views/include/head.jsp"%>

    <!-- 리뷰 작성/수정 전용 스타일시트 공유 -->
    <link href="<%=request.getContextPath()%>/css/write/writeReview.css" rel="stylesheet">
</head>
<body class="bg-slate-100 text-slate-900 min-h-screen pb-12 font-sans antialiased">

    <!-- 상단 네비게이션 바 -->
    <%@ include file="/WEB-INF/views/include/navbar.jsp"%>

    <div class="max-w-4xl mx-auto px-4 sm:px-6 space-y-8">

        <!-- ========================================================================= -->
        <!-- Header: 돌아가기 & 타이틀 영역 (수정 모드 안내 및 요일 뱃지) -->
        <!-- ========================================================================= -->
        <header class="flex items-center justify-between pb-4 border-b-2 border-dashed border-slate-300">
            <div>
                <a href="javascript:history.back()" 
                   class="inline-flex items-center gap-1.5 text-xs text-slate-500 hover:text-slate-900 mb-1 font-mono transition-colors">
                    <i class="fa-solid fa-arrow-left text-xs"></i>
                    <span>상세 페이지로 돌아가기</span>
                </a>
                <h1 class="text-xl sm:text-2xl font-bold text-slate-900 flex items-center gap-2">
                    <span>오늘의 하루 리뷰 수정</span>
                    <span class="text-xs bg-amber-100 text-amber-800 border border-amber-300 px-2 py-0.5 rounded font-mono font-medium">
                        수정 모드
                    </span>
                </h1>
            </div>
        </header>

        <!-- ========================================================================= -->
        <!-- Spring MVC 메인 폼 전송 영역 (멀티파트 지원 & 수정 액션) -->
        <!-- ========================================================================= -->
        <form id="reviewEditForm" 
              action="<%=request.getContextPath()%>/review/edit" 
              method="post" 
              enctype="multipart/form-data" 
              class="space-y-8">

            <!-- 수정 대상 메인 리뷰 ID (PK) -->
            <input type="hidden" id="reviewIdInput" name="reviewId" value="${review.reviewId}" />

            <!-- Spring MVC Controller 바인딩용 Hidden 필드 (기존 값 프리필) -->
            <input type="hidden" id="totalRatingInput" name="totalRating" value="${empty review.totalRating ? '0.0' : review.totalRating}" />
            <input type="hidden" id="moodTagsInput" name="moodTags" value="${review.moodTags}" />
            <input type="hidden" id="isPublicInput" name="isPublic" value="${empty review.isPublic ? 'Y' : review.isPublic}" />
            
            <!-- 기존 대표 사진 유지 / 삭제 여부 플래그 -->
            <input type="hidden" id="existingImageUrlInput" name="mainImageUrl" value="${review.mainImageUrl}" />
            <input type="hidden" id="deleteMainImageInput" name="deleteMainImage" value="N" />

            <!-- 서브 리뷰 1:N List DTO 및 JSON 보조 바인딩 -->
            <input type="hidden" id="subReviewsJsonInput" name="subReviewsJson" value="" />
            <div id="subReviewsHiddenContainer"></div>

            <!-- ========================================================================= -->
            <!-- SECTION 1: Main Daily Review (메인 데일리 리뷰 수정) -->
            <!-- ========================================================================= -->
            <section class="border-2 border-dashed border-slate-300 rounded-2xl bg-white p-6 space-y-6 shadow-xs">
                <div class="flex items-center justify-between pb-3 border-b border-slate-200">
                    <div class="flex items-center gap-2">
                        <span class="w-6 h-6 rounded-full bg-slate-900 text-white font-mono text-xs flex items-center justify-center font-bold">
                            1
                        </span>
                        <h2 class="font-bold text-base text-slate-900">
                            메인 데일리 리뷰 (오늘 하루 종합 수정)
                        </h2>
                    </div>
                    <span class="text-xs font-mono text-blue-600 bg-blue-50 px-2 py-0.5 rounded border border-blue-200">
                        필수 입력
                    </span>
                </div>

                <!-- Date & Total Score -->
                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-xs font-bold text-slate-700 mb-1.5 flex items-center gap-1.5">
                            <i class="fa-regular fa-calendar-days text-slate-400"></i>
                            <span>리뷰 일자</span>
                        </label>
                        <input
                            type="date"
                            id="reviewDate"
                            name="reviewDate"
                            value="${review.reviewDate}"
                            required
                            class="w-full px-3 py-2 border-2 border-dashed border-slate-300 rounded-lg text-sm font-mono focus:outline-none focus:border-slate-800 bg-slate-50"
                        />
                    </div>

                    <div>
                        <label class="block text-xs font-bold text-slate-700 mb-1.5 flex items-center gap-1.5">
                            <i class="fa-solid fa-wand-magic-sparkles text-amber-500"></i>
                            <span>오늘 하루 종합 평점 (별점 클릭)</span>
                        </label>
                        <div class="flex items-center justify-between p-2 bg-amber-50/60 border border-dashed border-amber-300 rounded-lg">
                            <div id="mainStarContainer" class="inline-flex items-center gap-1 select-none" onmouseleave="restoreMainRating()">
                                <c:forEach var="i" begin="1" end="5">
                                    <div class="star-unit relative inline-flex items-center justify-center p-1 cursor-pointer select-none group"
                                         data-index="${i}"
                                         onclick="setMainRating(event, this, ${i})"
                                         onmousemove="previewMainRating(event, this, ${i})">
                                        <c:choose>
                                            <c:when test="${not empty review.totalRating and review.totalRating >= i}">
                                                <i class="fa-solid fa-star text-amber-400 text-lg star-fa pointer-events-none transition-transform"></i>
                                            </c:when>
                                            <c:when test="${not empty review.totalRating and review.totalRating >= (i - 0.5)}">
                                                <i class="fa-solid fa-star-half-stroke text-amber-400 text-lg star-fa pointer-events-none transition-transform"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="fa-solid fa-star text-slate-200 text-lg star-fa pointer-events-none transition-transform"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </c:forEach>
                            </div>
                            <span id="mainScoreText" class="text-slate-700 text-sm font-semibold font-mono">
                                ${empty review.totalRating ? '0.0' : review.totalRating} <span class="text-slate-400 font-normal">/ 5.0</span>
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Mood / Tag Selector -->
                <div class="space-y-2">
                    <label class="block text-xs font-bold text-slate-700 flex items-center gap-1.5">
                        <i class="fa-solid fa-tag text-slate-400"></i>
                        <span>오늘의 기분 / 상황 태그</span>
                    </label>
                    <div id="popularTagsList" class="flex flex-wrap gap-1.5">
                        <c:set var="tagArray" value="${fn:split('생산적인하루,카페투어,오운완,재택근무,힐링성공,야근,드라이브,장비빨,미라클모닝,소소한행복', ',')}" />
                        <c:forEach items="${tagArray}" var="tag">
                            <c:set var="isActive" value="${not empty review.moodTags and fn:contains(review.moodTags, tag)}" />
                            <button type="button" onclick="toggleMoodTag('${tag}')"
                                class="text-xs px-2.5 py-1 rounded-md border font-mono transition-colors cursor-pointer ${isActive ? 'bg-slate-900 text-white border-slate-900 font-semibold shadow-xs' : 'bg-slate-100 text-slate-600 border-slate-200 hover:bg-slate-200'}">
                                #${tag}
                            </button>
                        </c:forEach>
                    </div>

                    <!-- Custom Tag Input -->
                    <div class="flex gap-2 pt-1 max-w-sm">
                        <input
                            type="text"
                            id="customTagInput"
                            placeholder="직접 태그 입력 (예: 생산성만점)"
                            class="flex-1 px-3 py-1.5 text-xs border border-dashed border-slate-300 rounded-md bg-slate-50 focus:outline-none focus:border-slate-800"
                            onkeydown="if(event.key==='Enter'){ event.preventDefault(); addCustomTag(); }"
                        />
                        <button
                            type="button"
                            onclick="addCustomTag()"
                            class="px-3 py-1.5 bg-slate-800 text-white rounded-md text-xs font-semibold hover:bg-slate-900 transition-colors cursor-pointer"
                        >
                            + 추가
                        </button>
                    </div>
                </div>

                <!-- Daily Overall Comment Textarea -->
                <div class="space-y-1.5">
                    <div class="flex items-center justify-between">
                        <label class="block text-xs font-bold text-slate-700">
                            오늘 하루 총평 <span class="text-rose-500">*</span>
                        </label>
                        <span id="overallCommentCharCount" class="text-[11px] font-mono text-slate-400">
                            ${empty review.overallComment ? 0 : fn:length(review.overallComment)} / 1,000자
                        </span>
                    </div>
                    <textarea
                        rows="4"
                        id="overallCommentInput"
                        name="overallComment"
                        required
                        maxlength="1000"
                        oninput="document.getElementById('overallCommentCharCount').textContent = this.value.length + ' / 1,000자'"
                        placeholder="오늘 하루 있었던 주요 일과와 총평을 일기처럼 자유롭게 적어주세요."
                        class="w-full p-3 border-2 border-dashed border-slate-300 rounded-lg text-sm focus:outline-none focus:border-slate-800 bg-slate-50/50 leading-relaxed font-sans"
                    ><c:out value="${review.overallComment}" /></textarea>
                </div>

                <!-- Representative Photo Upload & Existing Image Preview -->
                <div class="space-y-1.5">
                    <label class="block text-xs font-bold text-slate-700 flex items-center justify-between">
                        <span>오늘 하루 대표 사진</span>
                        <span class="text-[10px] text-slate-400 font-mono">JPG, PNG, GIF 지원</span>
                    </label>

                    <!-- Hidden Real File Input -->
                    <input 
                        type="file" 
                        id="mainImageFileInput" 
                        name="mainImageFile" 
                        accept="image/*"
                        onchange="handleImageFileChange(this)"
                        class="hidden" 
                    />

                    <div class="p-3 border-2 border-dashed border-slate-300 rounded-lg bg-slate-50 space-y-2">
                        <!-- Empty State Box (기존 이미지가 없을 때 노출) -->
                        <div id="imageUploadEmptyBox" 
                             onclick="document.getElementById('mainImageFileInput').click()"
                             class="${not empty review.mainImageUrl ? 'hidden' : ''} h-28 border-2 border-dashed border-slate-300 hover:border-slate-400 rounded-lg bg-slate-100 flex flex-col items-center justify-center text-center p-3 cursor-pointer transition-colors group">
                            <i class="fa-regular fa-image text-2xl text-slate-400 group-hover:text-blue-600 mb-1 transition-colors"></i>
                            <span class="text-xs font-mono font-bold text-slate-600 group-hover:text-blue-600 transition-colors">
                                [대표 사진 첨부 또는 변경]
                            </span>
                            <span class="text-[10px] text-slate-400 mt-0.5">
                                클릭하여 새로운 사진 파일을 첨부하세요
                            </span>
                        </div>

                        <!-- Photo Preview Box (기존 이미지 또는 새로 선택한 이미지 미리보기) -->
                        <div id="imagePreviewBox" class="${not empty review.mainImageUrl ? '' : 'hidden'} flex items-center gap-3 bg-white p-2.5 rounded-lg border border-slate-200">
                            <div class="w-20 h-20 rounded-md overflow-hidden bg-slate-200 shrink-0 border border-slate-300">
                                <img id="previewImgElement" 
                                     src="${not empty review.mainImageUrl ? review.mainImageUrl : ''}" 
                                     alt="대표 사진 미리보기" 
                                     class="w-full h-full object-cover" />
                            </div>
                            <div class="min-w-0 flex-1 space-y-1">
                                <p id="previewFileName" class="text-xs font-mono font-bold text-slate-800 truncate">
                                    <c:choose>
                                        <c:when test="${not empty review.mainImageUrl}">
                                            현재 등록된 대표 사진
                                        </c:when>
                                        <c:otherwise></c:otherwise>
                                    </c:choose>
                                </p>
                                <p id="previewFileSize" class="text-[10px] font-mono text-slate-400">
                                    <c:if test="${not empty review.mainImageUrl}">[기존 이미지 유지 중]</c:if>
                                </p>
                                <div class="pt-1 flex items-center gap-2">
                                    <button type="button" 
                                            onclick="document.getElementById('mainImageFileInput').click()"
                                            class="px-2 py-0.5 bg-slate-100 hover:bg-slate-200 border border-slate-300 text-slate-700 rounded text-xs font-mono transition-colors">
                                        사진 교체
                                    </button>
                                    <button type="button" 
                                            onclick="removeSelectedImage()"
                                            class="px-2 py-0.5 bg-rose-50 hover:bg-rose-100 border border-rose-200 text-rose-600 rounded text-xs font-mono transition-colors">
                                        사진 삭제
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- ========================================================================= -->
            <!-- SECTION 2: Sub-Reviews System (1 : N 세부 리뷰 수정 및 추가) -->
            <!-- ========================================================================= -->
            <section class="border-2 border-dashed border-blue-300 rounded-2xl bg-blue-50/30 p-6 space-y-6 shadow-xs">
                <div class="flex flex-wrap items-center justify-between gap-3 pb-3 border-b border-blue-200">
                    <div>
                        <div class="flex items-center gap-2">
                            <span class="w-6 h-6 rounded-full bg-blue-600 text-white font-mono text-xs flex items-center justify-center font-bold">
                                2
                            </span>
                            <h2 class="font-bold text-base text-slate-900">
                                서브 리뷰 시스템 (1 : N 세부 리뷰 수정)
                            </h2>
                        </div>
                        <p class="text-xs text-slate-500 mt-0.5">
                            기존 세부 리뷰를 수정하거나 새로운 카드를 추가하고 삭제할 수 있습니다.
                        </p>
                    </div>

                    <button
                        type="button"
                        onclick="openSubReviewForm()"
                        class="inline-flex items-center gap-1.5 px-3.5 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg text-xs font-bold shadow-xs transition-colors cursor-pointer"
                    >
                        <i class="fa-solid fa-plus text-xs"></i>
                        <span>+ 서브 리뷰 추가</span>
                    </button>
                </div>

                <!-- Current Sub-reviews List (JSTL 즉시 렌더링 + JS 실시간 조작 지원) -->
                <div id="subReviewsList" class="space-y-4">
                    <c:choose>
                        <c:when test="${not empty subReviews}">
                            <c:forEach items="${subReviews}" var="sub" varStatus="st">
                                <div class="border-2 border-dashed border-slate-300 rounded-lg p-4 bg-white/90 shadow-xs space-y-3 hover:border-slate-400 transition-all sub-review-card" data-index="${st.index}">
                                    <div class="flex items-center justify-between">
                                        <div class="flex items-center gap-2">
                                            <c:choose>
                                                <c:when test="${sub.category eq 'place'}">
                                                    <span class="inline-flex items-center gap-1.5 font-medium border border-dashed rounded-md px-2 py-0.5 text-xs bg-emerald-50 text-emerald-700 border-emerald-300">
                                                        <i class="fa-solid fa-mug-saucer text-xs"></i><span>장소·식당·카페</span>
                                                    </span>
                                                </c:when>
                                                <c:when test="${sub.category eq 'item'}">
                                                    <span class="inline-flex items-center gap-1.5 font-medium border border-dashed rounded-md px-2 py-0.5 text-xs bg-sky-50 text-sky-700 border-sky-300">
                                                        <i class="fa-solid fa-laptop text-xs"></i><span>아이템·전자기기</span>
                                                    </span>
                                                </c:when>
                                                <c:when test="${sub.category eq 'transport'}">
                                                    <span class="inline-flex items-center gap-1.5 font-medium border border-dashed rounded-md px-2 py-0.5 text-xs bg-amber-50 text-amber-700 border-amber-300">
                                                        <i class="fa-solid fa-car text-xs"></i><span>차량·이동수단</span>
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="inline-flex items-center gap-1.5 font-medium border border-dashed rounded-md px-2 py-0.5 text-xs bg-purple-50 text-purple-700 border-purple-300">
                                                        <i class="fa-solid fa-clapperboard text-xs"></i><span>미디어·콘텐츠</span>
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>

                                            <c:if test="${sub.isCertified eq 'Y'}">
                                                <span class="inline-flex items-center gap-1 text-[11px] font-medium text-emerald-700 bg-emerald-50 px-1.5 py-0.5 rounded border border-emerald-200">
                                                    <i class="fa-solid fa-circle-check text-emerald-600"></i> 내돈내산 인증
                                                </span>
                                            </c:if>
                                        </div>

                                        <div class="flex items-center gap-2">
                                            <div class="flex items-center gap-1 font-mono text-xs font-bold text-slate-700 mr-2">
                                                <c:forEach var="si" begin="1" end="5">
                                                    <c:choose>
                                                        <c:when test="${sub.subRating >= si}">
                                                            <i class="fa-solid fa-star text-amber-400 text-xs p-0.5"></i>
                                                        </c:when>
                                                        <c:when test="${sub.subRating >= (si - 0.5)}">
                                                            <i class="fa-solid fa-star-half-stroke text-amber-400 text-xs p-0.5"></i>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <i class="fa-solid fa-star text-slate-200 text-xs p-0.5"></i>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                                <span>${empty sub.subRating ? '0.0' : sub.subRating} / 5.0</span>
                                            </div>
                                            <button type="button" onclick="openSubReviewForm(${st.index})" class="text-xs text-blue-600 hover:text-blue-800 font-semibold px-2 py-0.5 border border-dashed border-blue-300 rounded bg-blue-50 hover:bg-blue-100 transition-colors cursor-pointer">
                                                <i class="fa-solid fa-pen text-[10px] mr-1"></i>수정
                                            </button>
                                            <button type="button" onclick="deleteSubReview(${st.index})" class="text-xs text-rose-500 hover:text-rose-700 font-semibold px-2 py-0.5 border border-dashed border-rose-300 rounded bg-rose-50 hover:bg-rose-100 transition-colors cursor-pointer">
                                                삭제
                                            </button>
                                        </div>
                                    </div>

                                    <div>
                                        <h4 class="text-base font-bold text-slate-800"><c:out value="${sub.itemName}" /></h4>
                                        <c:if test="${not empty sub.locationBrand}">
                                            <p class="text-xs text-slate-500 flex items-center gap-1 mt-0.5">
                                                <i class="fa-solid fa-location-dot text-slate-400 text-xs"></i>
                                                <span><c:out value="${sub.locationBrand}" /></span>
                                            </p>
                                        </c:if>
                                    </div>

                                    <p class="text-sm text-slate-700 bg-slate-50 p-2.5 rounded border border-slate-200 leading-relaxed font-sans">
                                        <c:out value="${sub.subComment}" />
                                    </p>

                                    <c:if test="${not empty sub.tags}">
                                        <div class="flex flex-wrap gap-1.5 pt-1">
                                            <c:forEach items="${fn:split(sub.tags, ',')}" var="t">
                                                <c:if test="${not empty fn:trim(t)}">
                                                    <span class="inline-flex items-center gap-1 bg-slate-100 text-slate-700 border border-slate-300 rounded font-mono px-1.5 py-0.5 text-xs">
                                                        <c:out value="${fn:startsWith(fn:trim(t), '#') ? fn:trim(t) : '#' += fn:trim(t)}" />
                                                    </span>
                                                </c:if>
                                            </c:forEach>
                                        </div>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-8 border-2 border-dashed border-blue-200 rounded-xl bg-white/60 p-6 text-slate-400">
                                <i class="fa-solid fa-layer-group text-2xl mx-auto mb-2 text-blue-300"></i>
                                <p class="text-xs font-bold text-slate-600">등록된 서브 리뷰가 없습니다</p>
                                <p class="text-[11px] text-slate-400 mt-0.5">상단의 '+ 서브 리뷰 추가' 버튼을 눌러 세부 리뷰를 추가해보세요.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- ===================================================================== -->
                <!-- Sub Review Builder Form (서브 리뷰 등록/수정 모달/폼 박스) -->
                <!-- ===================================================================== -->
                <div id="subReviewFormBox" class="hidden border-2 border-dashed border-blue-400 rounded-xl bg-white p-5 space-y-4 shadow-md">
                    <div class="flex items-center justify-between pb-2 border-b border-slate-200">
                        <span class="font-bold text-sm text-slate-900 flex items-center gap-1.5" id="subReviewFormTitle">
                            <i class="fa-solid fa-layer-group text-blue-600"></i>
                            새 서브 리뷰 작성
                        </span>
                        <button
                            type="button"
                            onclick="closeSubReviewForm()"
                            class="text-slate-400 hover:text-slate-600 text-xs font-mono cursor-pointer"
                        >
                            닫기 ✕
                        </button>
                    </div>

                    <!-- 편집 중인 서브리뷰 인덱스 보관 (-1이면 신규 등록) -->
                    <input type="hidden" id="editingSubIndex" value="-1" />
                    <!-- 기존 서브리뷰 PK (subReviewId) 보관 -->
                    <input type="hidden" id="editingSubReviewId" value="" />

                    <!-- Category Selector Tabs -->
                    <div class="space-y-1.5">
                        <label class="block text-xs font-bold text-slate-700">
                            카테고리 선택
                        </label>
                        <div class="grid grid-cols-2 sm:grid-cols-4 gap-2" id="categoryTabGroup">
                            <button type="button" onclick="selectCategory('place')" data-cat="place" class="cat-btn flex items-center justify-center gap-1.5 py-2 px-3 rounded-lg text-xs font-bold border transition-all bg-blue-600 text-white border-blue-600 shadow-xs cursor-pointer">
                                <i class="fa-solid fa-mug-saucer text-xs"></i>
                                <span>장소/식당</span>
                            </button>
                            <button type="button" onclick="selectCategory('item')" data-cat="item" class="cat-btn flex items-center justify-center gap-1.5 py-2 px-3 rounded-lg text-xs font-medium border transition-all bg-slate-50 text-slate-700 border-slate-300 hover:bg-slate-100 cursor-pointer">
                                <i class="fa-solid fa-laptop text-xs"></i>
                                <span>아이템/기기</span>
                            </button>
                            <button type="button" onclick="selectCategory('transport')" data-cat="transport" class="cat-btn flex items-center justify-center gap-1.5 py-2 px-3 rounded-lg text-xs font-medium border transition-all bg-slate-50 text-slate-700 border-slate-300 hover:bg-slate-100 cursor-pointer">
                                <i class="fa-solid fa-car text-xs"></i>
                                <span>이동수단</span>
                            </button>
                            <button type="button" onclick="selectCategory('content')" data-cat="content" class="cat-btn flex items-center justify-center gap-1.5 py-2 px-3 rounded-lg text-xs font-medium border transition-all bg-slate-50 text-slate-700 border-slate-300 hover:bg-slate-100 cursor-pointer">
                                <i class="fa-solid fa-clapperboard text-xs"></i>
                                <span>미디어/콘텐츠</span>
                            </button>
                        </div>
                    </div>

                    <!-- Item Name -->
                    <div class="space-y-1.5">
                        <label class="block text-xs font-bold text-slate-700">
                            항목 이름 / 모델명 <span class="text-rose-500">*</span>
                        </label>
                        <input
                            type="text"
                            id="itemNameInput"
                            placeholder="예: 성수 어니언 카페, 소니 WH-1000XM5, 쏘카 아이오닉 5, 로지텍 마우스"
                            class="w-full px-3 py-2 border-2 border-dashed border-slate-300 rounded-lg text-sm focus:outline-none focus:border-blue-600 bg-slate-50"
                        />
                    </div>

                    <!-- Location or Brand & Sub Rating -->
                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                        <div>
                            <label class="block text-xs font-bold text-slate-700 mb-1">
                                위치 / 브랜드 / 구매처
                            </label>
                            <input
                                type="text"
                                id="locationBrandInput"
                                placeholder="예: 서울 성동구 성수동, 공식 스토어, 넷플릭스"
                                class="w-full px-3 py-1.5 border border-slate-300 rounded-md text-xs bg-slate-50 focus:outline-none"
                            />
                        </div>

                        <div>
                            <label class="block text-xs font-bold text-slate-700 mb-1">
                                세부 별점
                            </label>
                            <div class="p-1.5 bg-slate-50 border border-slate-300 rounded-md flex items-center justify-between">
                                <div id="subStarContainer" class="inline-flex items-center gap-1 select-none" onmouseleave="restoreSubRating()">
                                    <c:forEach var="i" begin="1" end="5">
                                        <div class="star-unit relative inline-flex items-center justify-center p-0.5 cursor-pointer select-none group"
                                             data-index="${i}"
                                             onclick="setSubRating(event, this, ${i})"
                                             onmousemove="previewSubRating(event, this, ${i})">
                                            <i class="fa-solid fa-star text-slate-200 text-sm star-fa pointer-events-none transition-transform"></i>
                                        </div>
                                    </c:forEach>
                                </div>
                                <span id="subScoreText" class="text-xs font-mono font-bold text-slate-700">0.0 / 5.0</span>
                            </div>
                        </div>
                    </div>

                    <!-- Sub Comment -->
                    <div class="space-y-1">
                        <label class="block text-xs font-bold text-slate-700">
                            세부 리뷰 한줄평 / 후기
                        </label>
                        <textarea
                            rows="2"
                            id="subCommentInput"
                            placeholder="이 장소나 아이템에 대한 솔직한 평을 적어주세요."
                            class="w-full p-2.5 border border-slate-300 rounded-md text-xs bg-slate-50 focus:outline-none"
                        ></textarea>
                    </div>

                    <!-- Sub Tags -->
                    <div class="space-y-1">
                        <label class="block text-xs font-bold text-slate-700">
                            서브 리뷰 태그
                        </label>
                        <div class="flex gap-2">
                            <input
                                type="text"
                                id="subTagInput"
                                placeholder="태그 입력 (예: 노이즈캔슬링, 작업하기좋은)"
                                class="flex-1 px-3 py-1.5 border border-slate-300 rounded-md text-xs bg-slate-50 focus:outline-none"
                                onkeydown="if(event.key==='Enter'){ event.preventDefault(); addSubTag(); }"
                            />
                            <button
                                type="button"
                                onclick="addSubTag()"
                                class="px-3 py-1.5 bg-slate-800 text-white rounded-md text-xs font-semibold hover:bg-slate-900 transition-colors cursor-pointer"
                            >
                                + 태그 추가
                            </button>
                        </div>
                        <div id="currentSubTagsList" class="flex flex-wrap gap-1 pt-1"></div>
                    </div>

                    <!-- Verified Checkbox -->
                    <div class="flex items-center gap-2 pt-1">
                        <label class="flex items-center gap-2 cursor-pointer select-none text-xs font-semibold text-slate-800">
                            <input
                                type="checkbox"
                                id="isCertifiedInput"
                                checked
                                class="w-4 h-4 text-blue-600 rounded border-slate-300 focus:ring-0 cursor-pointer"
                            />
                            <span class="flex items-center gap-1.5">
                                <i class="fa-solid fa-circle-check text-emerald-600"></i>
                                내돈내산 / 영수증 인증 뱃지 표시
                            </span>
                        </label>
                    </div>

                    <!-- Action buttons -->
                    <div class="flex items-center justify-end gap-2 pt-2 border-t border-slate-200">
                        <button
                            type="button"
                            onclick="closeSubReviewForm()"
                            class="px-3 py-1.5 text-xs text-slate-600 hover:text-slate-800 font-medium cursor-pointer"
                        >
                            취소
                        </button>
                        <button
                            type="button"
                            onclick="saveSubReview()"
                            class="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg text-xs font-bold shadow-xs cursor-pointer"
                        >
                            <span id="saveSubReviewBtnText">서브 리뷰 카드 등록</span>
                        </button>
                    </div>
                </div>
            </section>

            <!-- ========================================================================= -->
            <!-- Submit Bar: 수정 완료 버튼 & 취소 버튼 -->
            <!-- ========================================================================= -->
            <div class="pt-4 flex flex-col sm:flex-row items-center justify-between gap-4 border-t-2 border-dashed border-slate-300">
                <p id="submitInfoText" class="text-xs text-slate-500 font-mono">
                    * 수정 시 메인 데일리 리뷰 1건과 서브 리뷰 ${empty subReviews ? 0 : subReviews.size()}건이 업데이트됩니다.
                </p>

                <div class="flex items-center gap-3 w-full sm:w-auto">
                    <button
                        type="button"
                        onclick="history.back()"
                        class="w-1/2 sm:w-auto px-5 py-3.5 bg-slate-200 hover:bg-slate-300 text-slate-700 font-bold rounded-xl text-sm transition-all cursor-pointer text-center"
                    >
                        수정 취소
                    </button>
                    <button
                        type="submit"
                        class="w-1/2 sm:w-auto px-8 py-3.5 bg-blue-600 hover:bg-blue-700 text-white font-bold rounded-xl text-sm shadow-md transition-all flex items-center justify-center gap-2 cursor-pointer"
                    >
                        <i class="fa-solid fa-check text-sm"></i>
                        <span>리뷰 수정 완료</span>
                    </button>
                </div>
            </div>
        </form>
    </div>

    <!-- ============================================================================= -->
    <!-- 서버 바인딩된 기존 서브 리뷰 데이터 (안전한 DOM 전달: EL 따옴표 파싱 에러 100% 원천 방지) -->
    <!-- ============================================================================= -->
    <div id="initialSubReviewsData" class="hidden">
        <c:forEach items="${subReviews}" var="sub">
            <div class="raw-sub-item"
                 data-sub-id="${empty sub.subReviewId ? 0 : sub.subReviewId}"
                 data-category="${sub.category}"
                 data-rating="${empty sub.subRating ? 0.0 : sub.subRating}"
                 data-certified="${sub.isCertified}"
                 data-tags="${sub.tags}">
                <span class="raw-item-name"><c:out value="${sub.itemName}" /></span>
                <span class="raw-location-brand"><c:out value="${sub.locationBrand}" /></span>
                <span class="raw-sub-comment"><c:out value="${sub.subComment}" /></span>
            </div>
        </c:forEach>
    </div>

    <!-- 리뷰 수정 전용 스크립트 연결 -->
    <script src="<%=request.getContextPath()%>/js/edit/editReview.js"></script>
</body>
</html>