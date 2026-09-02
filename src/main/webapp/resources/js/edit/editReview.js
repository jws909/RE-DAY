/**
 * RE:DAY - editReview.js
 * 리뷰 수정 페이지 클라이언트 인터랙션 및 기존 데이터 프리필(Pre-fill) 바인딩 로직
 * (0.5점 단위 정밀 별점 컨트롤러, 기존 서브리뷰 수정/삭제/추가, 대표 사진 교체/삭제 지원)
 */

var POPULAR_MOOD_TAGS = [
    '생산적인하루',
    '카페투어',
    '오운완',
    '재택근무',
    '힐링성공',
    '야근',
    '드라이브',
    '장비빨',
    '미라클모닝',
    '소소한행복'
];

// 전역 상태(State) 변수들
var totalRating = 0.0;
var selectedMoodTags = [];
var subReviews = [];

// 서브리뷰 모달 폼 상태
var currentSubCategory = 'place';
var currentSubRating = 0.0;
var currentSubTags = [];

// =============================================================================
// 별점 계산 및 비주얼 갱신 공통 함수 (100% 즉시 클릭/호버 반응)
// =============================================================================
function calcScoreFromEvent(event, element, starIndex) {
    var rect = element.getBoundingClientRect();
    var clickX = event.clientX - rect.left;
    var isHalf = (clickX < rect.width / 2);
    return isHalf ? (starIndex - 0.5) : starIndex;
}

function updateStarVisuals(containerId, score, iconSize) {
    var container = document.getElementById(containerId);
    if (!container) return;
    var starUnits = container.querySelectorAll('.star-unit');
    for (var i = 0; i < starUnits.length; i++) {
        var starIndex = i + 1;
        var icon = starUnits[i].querySelector('i');
        if (!icon) continue;

        if (score >= starIndex) {
            icon.className = 'fa-solid fa-star text-amber-400 ' + iconSize + ' star-fa pointer-events-none transition-transform';
        } else if (score >= (starIndex - 0.5)) {
            icon.className = 'fa-solid fa-star-half-stroke text-amber-400 ' + iconSize + ' star-fa pointer-events-none transition-transform';
        } else {
            icon.className = 'fa-solid fa-star text-slate-200 ' + iconSize + ' star-fa pointer-events-none transition-transform';
        }
    }
}

// [메인 별점] 호버 미리보기
function previewMainRating(e, el, starIndex) {
    var score = calcScoreFromEvent(e, el, starIndex);
    updateStarVisuals('mainStarContainer', score, 'text-lg');
    var scoreText = document.getElementById('mainScoreText');
    if (scoreText) {
        scoreText.innerHTML = score.toFixed(1) + ' <span class="text-slate-400 font-normal">/ 5.0</span>';
    }
}

// [메인 별점] 클릭 시 점수 확정 & input 값 변경
function setMainRating(e, el, starIndex) {
    var chosenScore = calcScoreFromEvent(e, el, starIndex);
    totalRating = chosenScore;
    var hiddenInput = document.getElementById('totalRatingInput');
    if (hiddenInput) {
        hiddenInput.value = chosenScore;
    }
    updateStarVisuals('mainStarContainer', chosenScore, 'text-lg');
    var scoreText = document.getElementById('mainScoreText');
    if (scoreText) {
        scoreText.innerHTML = chosenScore.toFixed(1) + ' <span class="text-slate-400 font-normal">/ 5.0</span>';
    }
}

// [메인 별점] 마우스 이탈 시 기존 확정 점수로 복구
function restoreMainRating() {
    updateStarVisuals('mainStarContainer', totalRating, 'text-lg');
    var scoreText = document.getElementById('mainScoreText');
    if (scoreText) {
        scoreText.innerHTML = totalRating.toFixed(1) + ' <span class="text-slate-400 font-normal">/ 5.0</span>';
    }
}

// [서브 별점] 호버 미리보기
function previewSubRating(e, el, starIndex) {
    var score = calcScoreFromEvent(e, el, starIndex);
    updateStarVisuals('subStarContainer', score, 'text-sm');
    var scoreText = document.getElementById('subScoreText');
    if (scoreText) {
        scoreText.textContent = score.toFixed(1) + ' / 5.0';
    }
}

// [서브 별점] 클릭 시 점수 확정
function setSubRating(e, el, starIndex) {
    var chosenScore = calcScoreFromEvent(e, el, starIndex);
    currentSubRating = chosenScore;
    updateStarVisuals('subStarContainer', chosenScore, 'text-sm');
    var scoreText = document.getElementById('subScoreText');
    if (scoreText) {
        scoreText.textContent = chosenScore.toFixed(1) + ' / 5.0';
    }
}

// [서브 별점] 마우스 이탈 시 기존 확정 점수로 복구
function restoreSubRating() {
    updateStarVisuals('subStarContainer', currentSubRating, 'text-sm');
    var scoreText = document.getElementById('subScoreText');
    if (scoreText) {
        scoreText.textContent = currentSubRating.toFixed(1) + ' / 5.0';
    }
}

// 기존 초기화 헬퍼 (초기 점수 동기화용)
function setupInteractiveStarRating(containerId, hiddenInputId, textScoreId, initialRating, isSub) {
    var currentScore = Number(initialRating) || 0.0;
    if (isSub) {
        currentSubRating = currentScore;
        updateStarVisuals('subStarContainer', currentScore, 'text-sm');
        var textScore = document.getElementById(textScoreId);
        if (textScore) textScore.textContent = currentScore.toFixed(1) + ' / 5.0';
    } else {
        totalRating = currentScore;
        var hiddenInput = hiddenInputId ? document.getElementById(hiddenInputId) : null;
        if (hiddenInput) hiddenInput.value = currentScore;
        updateStarVisuals('mainStarContainer', currentScore, 'text-lg');
        var textScore = document.getElementById(textScoreId);
        if (textScore) textScore.innerHTML = currentScore.toFixed(1) + ' <span class="text-slate-400 font-normal">/ 5.0</span>';
    }
}

// 읽기 전용 별점 렌더링 함수
function renderReadOnlyStarsHtml(score) {
    var html = '';
    for (var i = 1; i <= 5; i++) {
        var isFull = (score >= i);
        var isHalf = (!isFull && score >= (i - 0.5));
        
        var starClass = 'fa-solid fa-star text-slate-200';
        if (isFull) {
            starClass = 'fa-solid fa-star text-amber-400';
        } else if (isHalf) {
            starClass = 'fa-solid fa-star-half-stroke text-amber-400';
        }
        html += '<i class="' + starClass + ' text-xs p-0.5"></i>';
    }
    return html;
}

// =============================================================================
// 이미지 첨부, 교체, 삭제 처리
// =============================================================================
function handleImageFileChange(input) {
    var file = input.files && input.files[0];
    if (!file) return;

    if (!file.type.startsWith('image/')) {
        alert('이미지 파일(JPG, PNG, GIF 등)만 업로드할 수 있습니다.');
        input.value = '';
        return;
    }

    var reader = new FileReader();
    reader.onload = function(e) {
        var previewImg = document.getElementById('previewImgElement');
        if (previewImg) previewImg.src = e.target.result;
        
        var fileName = document.getElementById('previewFileName');
        if (fileName) fileName.textContent = file.name + ' (새로 선택됨)';
        
        var fileSize = document.getElementById('previewFileSize');
        if (fileSize) fileSize.textContent = (file.size / (1024 * 1024)).toFixed(2) + ' MB';
        
        var emptyBox = document.getElementById('imageUploadEmptyBox');
        if (emptyBox) emptyBox.classList.add('hidden');
        
        var previewBox = document.getElementById('imagePreviewBox');
        if (previewBox) previewBox.classList.remove('hidden');

        // 새 파일이 지정되었으므로 삭제 플래그는 N으로 초기화
        var delInput = document.getElementById('deleteMainImageInput');
        if (delInput) delInput.value = 'N';
    };
    reader.readAsDataURL(file);
}

function removeSelectedImage() {
    if (!confirm('대표 사진을 삭제하시겠습니까?\n저장 시 기존에 등록되었던 사진도 함께 제거됩니다.')) return;

    var input = document.getElementById('mainImageFileInput');
    if (input) input.value = '';
    
    var previewImg = document.getElementById('previewImgElement');
    if (previewImg) previewImg.src = '';
    
    var previewBox = document.getElementById('imagePreviewBox');
    if (previewBox) previewBox.classList.add('hidden');
    
    var emptyBox = document.getElementById('imageUploadEmptyBox');
    if (emptyBox) emptyBox.classList.remove('hidden');

    // 서버에 기존 이미지 삭제 및 제거 요청 플래그 설정
    var delInput = document.getElementById('deleteMainImageInput');
    if (delInput) delInput.value = 'Y';

    var existingUrl = document.getElementById('existingImageUrlInput');
    if (existingUrl) existingUrl.value = '';
}

// =============================================================================
// 기분 태그 렌더링 & 토글
// =============================================================================
function renderMoodTags() {
    var container = document.getElementById('popularTagsList');
    if (!container) return;
    
    var html = '';
    for (var i = 0; i < POPULAR_MOOD_TAGS.length; i++) {
        var tag = POPULAR_MOOD_TAGS[i];
        var active = selectedMoodTags.indexOf(tag) !== -1;
        var activeClass = active
            ? 'bg-slate-900 text-white border-slate-900 font-semibold shadow-xs'
            : 'bg-slate-100 text-slate-600 border-slate-200 hover:bg-slate-200';
        
        html += '<button type="button" onclick="toggleMoodTag(\'' + tag + '\')" class="text-xs px-2.5 py-1 rounded-md border font-mono transition-colors ' + activeClass + ' cursor-pointer">' +
                '#' + tag +
                '</button>';
    }
    container.innerHTML = html;
    
    var moodInput = document.getElementById('moodTagsInput');
    if (moodInput) moodInput.value = selectedMoodTags.join(',');
}

function toggleMoodTag(tag) {
    var idx = selectedMoodTags.indexOf(tag);
    if (idx !== -1) {
        selectedMoodTags.splice(idx, 1);
    } else {
        selectedMoodTags.push(tag);
    }
    renderMoodTags();
}

function addCustomTag() {
    var input = document.getElementById('customTagInput');
    if (!input) return;
    var clean = input.value.trim().replace(/^#/, '');
    if (clean && selectedMoodTags.indexOf(clean) === -1) {
        selectedMoodTags.push(clean);
        if (POPULAR_MOOD_TAGS.indexOf(clean) === -1) {
            POPULAR_MOOD_TAGS.push(clean);
        }
        input.value = '';
        renderMoodTags();
    }
}

// =============================================================================
// 서브 리뷰 모달/폼 제어 (추가 & 수정 양방향 지원)
// =============================================================================
function openSubReviewForm(editIndex) {
    var formBox = document.getElementById('subReviewFormBox');
    if (!formBox) return;

    var titleSpan = document.getElementById('subReviewFormTitle');
    var btnTextSpan = document.getElementById('saveSubReviewBtnText');
    var editIndexInput = document.getElementById('editingSubIndex');
    var editSubIdInput = document.getElementById('editingSubReviewId');

    if (typeof editIndex === 'number' && editIndex >= 0 && editIndex < subReviews.length) {
        // 기존 서브 리뷰 수정 모드
        var targetSub = subReviews[editIndex];
        if (editIndexInput) editIndexInput.value = editIndex;
        if (editSubIdInput) editSubIdInput.value = targetSub.subReviewId || '';

        if (titleSpan) titleSpan.innerHTML = '<i class="fa-solid fa-pen text-blue-600"></i> 서브 리뷰 수정';
        if (btnTextSpan) btnTextSpan.textContent = '서브 리뷰 수정 완료';

        // 필드 값 채우기
        var itemNameInput = document.getElementById('itemNameInput');
        if (itemNameInput) itemNameInput.value = targetSub.itemName || '';

        var locationBrandInput = document.getElementById('locationBrandInput');
        if (locationBrandInput) locationBrandInput.value = targetSub.locationBrand || '';

        var subCommentInput = document.getElementById('subCommentInput');
        if (subCommentInput) subCommentInput.value = targetSub.subComment || '';

        var isCertifiedInput = document.getElementById('isCertifiedInput');
        if (isCertifiedInput) isCertifiedInput.checked = (targetSub.isCertified === 'Y' || targetSub.isCertified === true);

        currentSubTags = targetSub.tags ? targetSub.tags.slice() : [];
        renderSubTagsList();

        selectCategory(targetSub.category || 'place');
        setupInteractiveStarRating('subStarContainer', null, 'subScoreText', targetSub.subRating || 0.0, true);

    } else {
        // 신규 등록 모드
        if (editIndexInput) editIndexInput.value = -1;
        if (editSubIdInput) editSubIdInput.value = '';
        if (titleSpan) titleSpan.innerHTML = '<i class="fa-solid fa-layer-group text-blue-600"></i> 새 서브 리뷰 작성';
        if (btnTextSpan) btnTextSpan.textContent = '서브 리뷰 카드 등록';

        resetSubForm();
    }

    formBox.classList.remove('hidden');
    var itemNameInput = document.getElementById('itemNameInput');
    if (itemNameInput) itemNameInput.focus();
}

function closeSubReviewForm() {
    var formBox = document.getElementById('subReviewFormBox');
    if (formBox) formBox.classList.add('hidden');
    resetSubForm();
}

function resetSubForm() {
    var itemNameInput = document.getElementById('itemNameInput');
    if (itemNameInput) itemNameInput.value = '';
    var locationBrandInput = document.getElementById('locationBrandInput');
    if (locationBrandInput) locationBrandInput.value = '';
    var subCommentInput = document.getElementById('subCommentInput');
    if (subCommentInput) subCommentInput.value = '';
    var tagInput = document.getElementById('subTagInput');
    if (tagInput) tagInput.value = '';
    var isCertifiedInput = document.getElementById('isCertifiedInput');
    if (isCertifiedInput) isCertifiedInput.checked = true;
    var editIndexInput = document.getElementById('editingSubIndex');
    if (editIndexInput) editIndexInput.value = -1;
    var editSubIdInput = document.getElementById('editingSubReviewId');
    if (editSubIdInput) editSubIdInput.value = '';

    currentSubTags = [];
    renderSubTagsList();
    selectCategory('place');
    setupInteractiveStarRating('subStarContainer', null, 'subScoreText', 0.0, true);
}

function selectCategory(cat) {
    currentSubCategory = cat;
    var buttons = document.querySelectorAll('#categoryTabGroup .cat-btn');
    for (var i = 0; i < buttons.length; i++) {
        var btn = buttons[i];
        if (btn.getAttribute('data-cat') === cat) {
            btn.className = 'cat-btn flex items-center justify-center gap-1.5 py-2 px-3 rounded-lg text-xs font-bold border transition-all bg-blue-600 text-white border-blue-600 shadow-xs cursor-pointer';
        } else {
            btn.className = 'cat-btn flex items-center justify-center gap-1.5 py-2 px-3 rounded-lg text-xs font-medium border transition-all bg-slate-50 text-slate-700 border-slate-300 hover:bg-slate-100 cursor-pointer';
        }
    }
}

function addSubTag() {
    var input = document.getElementById('subTagInput');
    if (!input) return;
    var clean = input.value.trim().replace(/^#/, '');
    if (clean && currentSubTags.indexOf(clean) === -1) {
        currentSubTags.push(clean);
        input.value = '';
        renderSubTagsList();
    }
}

function removeSubTag(idx) {
    currentSubTags.splice(idx, 1);
    renderSubTagsList();
}

function renderSubTagsList() {
    var container = document.getElementById('currentSubTagsList');
    if (!container) return;
    var html = '';
    for (var i = 0; i < currentSubTags.length; i++) {
        var tag = currentSubTags[i];
        html += '<span class="inline-flex items-center gap-1 text-[11px] bg-blue-50 text-blue-700 px-2 py-0.5 rounded border border-blue-200 font-mono">' +
                '#' + tag +
                '<button type="button" onclick="removeSubTag(' + i + ')" class="text-blue-400 hover:text-blue-700 font-bold ml-0.5 cursor-pointer">×</button>' +
                '</span>';
    }
    container.innerHTML = html;
}

// 서브 리뷰 저장 (추가 또는 수정 분기)
function saveSubReview() {
    var itemNameInput = document.getElementById('itemNameInput');
    var itemName = itemNameInput ? itemNameInput.value.trim() : '';
    if (!itemName) {
        alert('서브 리뷰 항목명을 입력해주세요.');
        if (itemNameInput) itemNameInput.focus();
        return;
    }

    var subCommentInput = document.getElementById('subCommentInput');
    var subComment = (subCommentInput && subCommentInput.value.trim()) ? subCommentInput.value.trim() : '세부 평가 코멘트가 작성되지 않았습니다.';
    
    var locationBrandInput = document.getElementById('locationBrandInput');
    var locationBrand = locationBrandInput ? locationBrandInput.value.trim() : '';
    
    var isCertifiedInput = document.getElementById('isCertifiedInput');
    var isCertified = isCertifiedInput ? (isCertifiedInput.checked ? 'Y' : 'N') : 'Y';

    var tagsCopy = [];
    if (currentSubTags.length > 0) {
        for (var i = 0; i < currentSubTags.length; i++) {
            tagsCopy.push(currentSubTags[i]);
        }
    } else {
        tagsCopy.push('#' + currentSubCategory);
    }

    var editIndexInput = document.getElementById('editingSubIndex');
    var editIdx = editIndexInput ? parseInt(editIndexInput.value, 10) : -1;

    var editSubIdInput = document.getElementById('editingSubReviewId');
    var subReviewId = editSubIdInput && editSubIdInput.value ? Number(editSubIdInput.value) : null;

    var targetSubData = {
        subReviewId: subReviewId,
        category: currentSubCategory,
        itemName: itemName,
        subRating: currentSubRating,
        subComment: subComment,
        locationBrand: locationBrand,
        isCertified: isCertified,
        tags: tagsCopy
    };

    if (editIdx >= 0 && editIdx < subReviews.length) {
        // 기존 서브 리뷰 업데이트
        subReviews[editIdx] = targetSubData;
    } else {
        // 신규 서브 리뷰 등록
        subReviews.push(targetSubData);
    }

    renderSubReviewsList();
    closeSubReviewForm();
}

function deleteSubReview(idx) {
    if (confirm('이 서브 리뷰를 삭제하시겠습니까?')) {
        subReviews.splice(idx, 1);
        renderSubReviewsList();
    }
}

// 카테고리 뱃지 HTML 헬퍼
function getCategoryBadgeHtml(cat) {
    var map = {
        place: { label: '장소·식당·카페', icon: 'fa-solid fa-mug-saucer', style: 'bg-emerald-50 text-emerald-700 border-emerald-300' },
        item: { label: '아이템·전자기기', icon: 'fa-solid fa-laptop', style: 'bg-sky-50 text-sky-700 border-sky-300' },
        transport: { label: '차량·이동수단', icon: 'fa-solid fa-car', style: 'bg-amber-50 text-amber-700 border-amber-300' },
        content: { label: '미디어·콘텐츠', icon: 'fa-solid fa-clapperboard', style: 'bg-purple-50 text-purple-700 border-purple-300' }
    };
    var cur = map[cat] || map.place;
    return '<span class="inline-flex items-center gap-1.5 font-medium border border-dashed rounded-md px-2 py-0.5 text-xs ' + cur.style + '">' +
           '<i class="' + cur.icon + ' text-xs"></i>' +
           '<span>' + cur.label + '</span>' +
           '</span>';
}

// 서브 리뷰 카드 목록 렌더링 (수정 & 삭제 버튼 제공)
function renderSubReviewsList() {
    var container = document.getElementById('subReviewsList');
    if (!container) return;
    
    var submitInfo = document.getElementById('submitInfoText');
    if (submitInfo) {
        submitInfo.textContent = '* 수정 시 메인 데일리 리뷰 1건과 서브 리뷰 ' + subReviews.length + '건이 업데이트됩니다.';
    }

    if (subReviews.length === 0) {
        container.innerHTML = 
            '<div class="text-center py-8 border-2 border-dashed border-blue-200 rounded-xl bg-white/60 p-6 text-slate-400">' +
            '<i class="fa-solid fa-layer-group text-2xl mx-auto mb-2 text-blue-300"></i>' +
            '<p class="text-xs font-bold text-slate-600">등록된 서브 리뷰가 없습니다</p>' +
            '<p class="text-[11px] text-slate-400 mt-0.5">' +
            '상단의 \'+ 서브 리뷰 추가\' 버튼을 눌러 세부 리뷰를 추가해보세요.' +
            '</p>' +
            '</div>';
        updateFormHiddenInputs();
        return;
    }

    var html = '';
    for (var idx = 0; idx < subReviews.length; idx++) {
        var sub = subReviews[idx];
        
        var isCert = (sub.isCertified === 'Y' || sub.isCertified === true);
        var verifiedBadge = isCert 
            ? '<span class="inline-flex items-center gap-1 text-[11px] font-medium text-emerald-700 bg-emerald-50 px-1.5 py-0.5 rounded border border-emerald-200">' +
              '<i class="fa-solid fa-circle-check text-emerald-600"></i> 내돈내산 인증</span>'
            : '';

        var locationBrandHtml = sub.locationBrand
            ? '<p class="text-xs text-slate-500 flex items-center gap-1 mt-0.5">' +
              '<i class="fa-solid fa-location-dot text-slate-400 text-xs"></i>' +
              '<span>' + sub.locationBrand + '</span></p>'
            : '';

        var tagsHtml = '';
        if (sub.tags && sub.tags.length > 0) {
            tagsHtml += '<div class="flex flex-wrap gap-1.5 pt-1">';
            for (var t = 0; t < sub.tags.length; t++) {
                var tagText = sub.tags[t];
                var displayTag = (tagText.indexOf('#') === 0) ? tagText : ('#' + tagText);
                tagsHtml += '<span class="inline-flex items-center gap-1 bg-slate-100 text-slate-700 border border-slate-300 rounded font-mono px-1.5 py-0.5 text-xs">' + displayTag + '</span>';
            }
            tagsHtml += '</div>';
        }

        var currentRating = Number(sub.subRating) || 0.0;

        html += 
            '<div class="border-2 border-dashed border-slate-300 rounded-lg p-4 bg-white/90 shadow-xs space-y-3 hover:border-slate-400 transition-all">' +
                '<div class="flex items-center justify-between">' +
                    '<div class="flex items-center gap-2">' +
                        getCategoryBadgeHtml(sub.category) +
                        verifiedBadge +
                    '</div>' +
                    '<div class="flex items-center gap-2">' +
                        '<div class="flex items-center gap-1 font-mono text-xs font-bold text-slate-700 mr-2">' +
                            renderReadOnlyStarsHtml(currentRating) +
                            '<span>' + currentRating.toFixed(1) + ' / 5.0</span>' +
                        '</div>' +
                        '<!-- 서브리뷰 개별 수정 버튼 -->' +
                        '<button type="button" onclick="openSubReviewForm(' + idx + ')" class="text-xs text-blue-600 hover:text-blue-800 font-semibold px-2 py-0.5 border border-dashed border-blue-300 rounded bg-blue-50 hover:bg-blue-100 transition-colors cursor-pointer">' +
                            '<i class="fa-solid fa-pen text-[10px] mr-1"></i>수정' +
                        '</button>' +
                        '<!-- 서브리뷰 개별 삭제 버튼 -->' +
                        '<button type="button" onclick="deleteSubReview(' + idx + ')" class="text-xs text-rose-500 hover:text-rose-700 font-semibold px-2 py-0.5 border border-dashed border-rose-300 rounded bg-rose-50 hover:bg-rose-100 transition-colors cursor-pointer">' +
                            '삭제' +
                        '</button>' +
                    '</div>' +
                '</div>' +

                '<div>' +
                    '<h4 class="text-base font-bold text-slate-800">' + (sub.itemName || '') + '</h4>' +
                    locationBrandHtml +
                '</div>' +

                '<p class="text-sm text-slate-700 bg-slate-50 p-2.5 rounded border border-slate-200 leading-relaxed font-sans">' +
                    (sub.subComment || '') +
                '</p>' +
                tagsHtml +
            '</div>';
    }

    container.innerHTML = html;
    updateFormHiddenInputs();
}

// =============================================================================
// Spring MVC 바인딩용 Hidden Input 생성
// =============================================================================
function updateFormHiddenInputs() {
    var jsonInput = document.getElementById('subReviewsJsonInput');
    if (jsonInput) jsonInput.value = JSON.stringify(subReviews);

    var container = document.getElementById('subReviewsHiddenContainer');
    if (!container) return;
    
    var html = '';
    for (var i = 0; i < subReviews.length; i++) {
        var sub = subReviews[i];
        var tagsStr = (sub.tags || []).join(',');
        var certValue = (sub.isCertified === 'Y' || sub.isCertified === true) ? 'Y' : 'N';
        
        if (sub.subReviewId) {
            html += '<input type="hidden" name="subReviews[' + i + '].subReviewId" value="' + sub.subReviewId + '">';
        }
        html += '<input type="hidden" name="subReviews[' + i + '].category" value="' + (sub.category || '') + '">' +
                '<input type="hidden" name="subReviews[' + i + '].itemName" value="' + (sub.itemName || '') + '">' +
                '<input type="hidden" name="subReviews[' + i + '].subRating" value="' + (sub.subRating || 0) + '">' +
                '<input type="hidden" name="subReviews[' + i + '].subComment" value="' + (sub.subComment || '') + '">' +
                '<input type="hidden" name="subReviews[' + i + '].locationBrand" value="' + (sub.locationBrand || '') + '">' +
                '<input type="hidden" name="subReviews[' + i + '].isCertified" value="' + certValue + '">' +
                '<input type="hidden" name="subReviews[' + i + '].tags" value="' + tagsStr + '">';
    }
    container.innerHTML = html;
}

// =============================================================================
// 페이지 초기화 및 기존 데이터 프리필(Pre-fill) 바인딩
// =============================================================================
function initEditReviewPage() {
    // 1. 초기 종합 평점 복원 (DOM hidden input에서 직접 추출)
    var ratingInput = document.getElementById('totalRatingInput');
    var initRating = ratingInput ? (parseFloat(ratingInput.value) || 0.0) : 0.0;
    setupInteractiveStarRating('mainStarContainer', 'totalRatingInput', 'mainScoreText', initRating, false);
    setupInteractiveStarRating('subStarContainer', null, 'subScoreText', 0.0, true);

    // 3. 기존 무드 태그 복원 (DOM hidden input에서 직접 추출)
    var moodTagsInput = document.getElementById('moodTagsInput');
    var rawMoodTags = moodTagsInput ? moodTagsInput.value : '';
    if (rawMoodTags && typeof rawMoodTags === 'string') {
        var tags = rawMoodTags.split(',');
        for (var t = 0; t < tags.length; t++) {
            var cleanTag = tags[t].trim().replace(/^#/, '');
            if (cleanTag && selectedMoodTags.indexOf(cleanTag) === -1) {
                selectedMoodTags.push(cleanTag);
                if (POPULAR_MOOD_TAGS.indexOf(cleanTag) === -1) {
                    POPULAR_MOOD_TAGS.push(cleanTag);
                }
            }
        }
    }
    renderMoodTags();

    // 4. 기존 서브 리뷰 복원 (DOM #initialSubReviewsData 에서 안전하게 추출)
    subReviews = [];
    var rawSubItems = document.querySelectorAll('#initialSubReviewsData .raw-sub-item');
    for (var i = 0; i < rawSubItems.length; i++) {
        var itemEl = rawSubItems[i];
        var rawSubId = itemEl.getAttribute('data-sub-id');
        var subId = (rawSubId && rawSubId !== '0') ? parseInt(rawSubId, 10) : null;
        var cat = itemEl.getAttribute('data-category') || 'place';
        var rating = parseFloat(itemEl.getAttribute('data-rating')) || 0.0;
        var cert = itemEl.getAttribute('data-certified') || 'Y';
        var tagsAttr = itemEl.getAttribute('data-tags') || '';

        var nameEl = itemEl.querySelector('.raw-item-name');
        var locEl = itemEl.querySelector('.raw-location-brand');
        var commentEl = itemEl.querySelector('.raw-sub-comment');

        var itemName = nameEl ? nameEl.textContent.trim() : '';
        var locationBrand = locEl ? locEl.textContent.trim() : '';
        var subComment = commentEl ? commentEl.textContent.trim() : '';

        var tagArray = [];
        if (tagsAttr) {
            var splitted = tagsAttr.split(',');
            for (var k = 0; k < splitted.length; k++) {
                var clean = splitted[k].trim();
                if (clean) tagArray.push(clean);
            }
        }

        subReviews.push({
            subReviewId: subId,
            category: cat,
            itemName: itemName,
            subRating: rating,
            subComment: subComment,
            locationBrand: locationBrand,
            isCertified: cert,
            tags: tagArray
        });
    }
    renderSubReviewsList();

    // 5. 폼 제출 전 유효성 검증
    var reviewEditForm = document.getElementById('reviewEditForm');
    if (reviewEditForm) {
        reviewEditForm.addEventListener('submit', function(e) {
            if (totalRating <= 0) {
                alert('오늘 하루 종합 평점을 별점으로 선택해주세요.');
                e.preventDefault();
                return false;
            }

            var overallCommentInput = document.getElementById('overallCommentInput');
            var overallComment = overallCommentInput ? overallCommentInput.value.trim() : '';
            if (!overallComment) {
                alert('오늘 하루 총평을 입력해주세요.');
                if (overallCommentInput) overallCommentInput.focus();
                e.preventDefault();
                return false;
            }

            updateFormHiddenInputs();
            return true;
        });
    }
}

// DOM 로드 완료 여부에 따라 즉시 또는 이벤트 후 실행
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initEditReviewPage);
} else {
    initEditReviewPage();
}