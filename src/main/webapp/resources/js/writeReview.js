/**
 * RE:DAY - writeReview.js
 * 리뷰 작성 페이지 클라이언트 인터랙션 및 폼 데이터 바인딩 로직
 * (기본값/예시 완전 제거, 0.5점 단위 정밀 별점 컨트롤러 탑재)
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

// 전역 상태(State) 변수들 (기본값 없음: 0점, 빈 태그, 빈 서브리뷰)
var overallRating = 0.0;
var selectedMoodTags = [];
var subReviews = [];

// 서브리뷰 모달 폼 상태
var currentSubCategory = 'place';
var currentSubRating = 0.0;
var currentSubTags = [];

// =============================================================================
// 0.5점 단위 인터랙티브 별점 컨트롤러
// =============================================================================
function setupInteractiveStarRating(containerId, hiddenInputId, textScoreId, initialRating, isSub) {
    var container = document.getElementById(containerId);
    var hiddenInput = hiddenInputId ? document.getElementById(hiddenInputId) : null;
    var textScore = textScoreId ? document.getElementById(textScoreId) : null;
    if (!container) return;

    // 초기 점수 설정
    var currentScore = Number(initialRating) || 0.0;
    if (isSub) {
        currentSubRating = currentScore;
    } else {
        overallRating = currentScore;
        if (hiddenInput) hiddenInput.value = currentScore;
    }

    // 별 5개 정적 렌더링 (최초 1회만 DOM 생성)
    var iconSize = isSub ? 'text-sm' : 'text-lg';
    var html = '';
    for (var i = 1; i <= 5; i++) {
        html += '<div class="star-unit relative inline-flex items-center justify-center p-1 cursor-pointer select-none group" data-index="' + i + '">' +
                '<i class="fa-regular fa-star text-slate-300 ' + iconSize + ' star-fa pointer-events-none transition-transform group-hover:scale-110"></i>' +
                '</div>';
    }
    container.innerHTML = html;

    var starUnits = container.querySelectorAll('.star-unit');

    // 별 모양 및 텍스트 업데이트 내부 함수
    function updateVisuals(score) {
        for (var i = 0; i < starUnits.length; i++) {
            var starIndex = i + 1;
            var icon = starUnits[i].querySelector('i');
            if (!icon) continue;

            if (score >= starIndex) {
                icon.className = 'fa-solid fa-star text-amber-400 ' + iconSize + ' star-fa pointer-events-none transition-transform';
            } else if (score >= (starIndex - 0.5)) {
                icon.className = 'fa-solid fa-star-half-stroke text-amber-400 ' + iconSize + ' star-fa pointer-events-none transition-transform';
            } else {
                icon.className = 'fa-regular fa-star text-slate-300 ' + iconSize + ' star-fa pointer-events-none transition-transform';
            }
        }
        if (textScore) {
            if (isSub) {
                textScore.textContent = score.toFixed(1) + ' / 5.0';
            } else {
                textScore.innerHTML = score.toFixed(1) + ' <span class="text-slate-400 font-normal">/ 5.0</span>';
            }
        }
    }

    // 초기 표시 렌더링
    updateVisuals(currentScore);

    // 각 별 유닛에 마우스 이벤트 바인딩
    for (var j = 0; j < starUnits.length; j++) {
        (function(idx) {
            var unit = starUnits[idx];
            var starIndex = idx + 1;

            // 마우스 호버 시 실시간 좌/우 50% 감지 및 미리보기
            unit.addEventListener('mousemove', function(e) {
                var rect = unit.getBoundingClientRect();
                var clickX = e.clientX - rect.left;
                var isHalf = (clickX < rect.width / 2);
                var hoverScore = isHalf ? (starIndex - 0.5) : starIndex;
                updateVisuals(hoverScore);
            });

            // 클릭 시 점수 확정 및 영구 저장!
            unit.addEventListener('click', function(e) {
                var rect = unit.getBoundingClientRect();
                var clickX = e.clientX - rect.left;
                var isHalf = (clickX < rect.width / 2);
                var chosenScore = isHalf ? (starIndex - 0.5) : starIndex;

                if (isSub) {
                    currentSubRating = chosenScore;
                } else {
                    overallRating = chosenScore;
                    if (hiddenInput) hiddenInput.value = chosenScore;
                }
                currentScore = chosenScore;
                updateVisuals(chosenScore);
            });
        })(j);
    }

    // 마우스가 영역을 벗어났을 때 확정된 점수로 복원
    container.addEventListener('mouseleave', function() {
        var confirmedScore = isSub ? currentSubRating : overallRating;
        updateVisuals(confirmedScore);
    });
}

// 읽기 전용 별점 렌더링 함수 (서브 리뷰 카드 목록용)
function renderReadOnlyStarsHtml(score) {
    var html = '';
    for (var i = 1; i <= 5; i++) {
        var isFull = (score >= i);
        var isHalf = (!isFull && score >= (i - 0.5));
        
        var starClass = 'fa-regular fa-star text-slate-300';
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
// 이미지 첨부 및 실시간 썸네일 미리보기
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
        if (fileName) fileName.textContent = file.name;
        
        var fileSize = document.getElementById('previewFileSize');
        if (fileSize) fileSize.textContent = (file.size / (1024 * 1024)).toFixed(2) + ' MB';
        
        var emptyBox = document.getElementById('imageUploadEmptyBox');
        if (emptyBox) emptyBox.classList.add('hidden');
        
        var previewBox = document.getElementById('imagePreviewBox');
        if (previewBox) previewBox.classList.remove('hidden');
    };
    reader.readAsDataURL(file);
}

function removeSelectedImage() {
    var input = document.getElementById('imageFileInput');
    if (input) input.value = '';
    
    var previewImg = document.getElementById('previewImgElement');
    if (previewImg) previewImg.src = '';
    
    var previewBox = document.getElementById('imagePreviewBox');
    if (previewBox) previewBox.classList.add('hidden');
    
    var emptyBox = document.getElementById('imageUploadEmptyBox');
    if (emptyBox) emptyBox.classList.remove('hidden');
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
// 서브 리뷰 모달/폼 제어
// =============================================================================
function openSubReviewForm() {
    var formBox = document.getElementById('subReviewFormBox');
    if (formBox) formBox.classList.remove('hidden');
    var nameInput = document.getElementById('subNameInput');
    if (nameInput) nameInput.focus();
}

function closeSubReviewForm() {
    var formBox = document.getElementById('subReviewFormBox');
    if (formBox) formBox.classList.add('hidden');
    resetSubForm();
}

function resetSubForm() {
    var nameInput = document.getElementById('subNameInput');
    if (nameInput) nameInput.value = '';
    var placeInput = document.getElementById('subPlaceInput');
    if (placeInput) placeInput.value = '';
    var commentInput = document.getElementById('subCommentInput');
    if (commentInput) commentInput.value = '';
    var tagInput = document.getElementById('subTagInput');
    if (tagInput) tagInput.value = '';
    var verifiedInput = document.getElementById('subVerifiedInput');
    if (verifiedInput) verifiedInput.checked = true;
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

// 서브 리뷰 저장
function saveSubReview() {
    var nameInput = document.getElementById('subNameInput');
    var name = nameInput ? nameInput.value.trim() : '';
    if (!name) {
        alert('서브 리뷰 항목명을 입력해주세요.');
        if (nameInput) nameInput.focus();
        return;
    }

    var commentInput = document.getElementById('subCommentInput');
    var comment = (commentInput && commentInput.value.trim()) ? commentInput.value.trim() : '세부 평가 코멘트가 작성되지 않았습니다.';
    
    var placeInput = document.getElementById('subPlaceInput');
    var placeOrBrand = placeInput ? placeInput.value.trim() : '';
    
    var verifiedInput = document.getElementById('subVerifiedInput');
    var verified = verifiedInput ? verifiedInput.checked : true;

    var tagsCopy = [];
    if (currentSubTags.length > 0) {
        for (var i = 0; i < currentSubTags.length; i++) {
            tagsCopy.push(currentSubTags[i]);
        }
    } else {
        tagsCopy.push('#' + currentSubCategory);
    }

    var newSub = {
        category: currentSubCategory,
        name: name,
        rating: currentSubRating,
        comment: comment,
        placeOrBrand: placeOrBrand,
        verified: verified,
        tags: tagsCopy
    };

    subReviews.push(newSub);
    renderSubReviewsList();
    closeSubReviewForm();
}

function deleteSubReview(idx) {
    if (confirm('이 서브 리뷰를 삭제하시겠습니까?')) {
        subReviews.splice(idx, 1);
        renderSubReviewsList();
    }
}

// 카테고리 뱃지 HTML 헬퍼 (Font Awesome 적용)
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

// 서브 리뷰 카드 목록 렌더링
function renderSubReviewsList() {
    var container = document.getElementById('subReviewsList');
    if (!container) return;
    
    var submitInfo = document.getElementById('submitInfoText');
    if (submitInfo) {
        submitInfo.textContent = '* 등록 시 메인 데일리 리뷰 1건과 서브 리뷰 ' + subReviews.length + '건이 발행됩니다.';
    }

    if (subReviews.length === 0) {
        container.innerHTML = 
            '<div class="text-center py-8 border-2 border-dashed border-blue-200 rounded-xl bg-white/60 p-6 text-slate-400">' +
            '<i class="fa-solid fa-layer-group text-2xl mx-auto mb-2 text-blue-300"></i>' +
            '<p class="text-xs font-bold text-slate-600">등록된 서브 리뷰가 없습니다</p>' +
            '<p class="text-[11px] text-slate-400 mt-0.5">' +
            '상단의 \'+ 서브 리뷰 추가\' 버튼을 눌러 첫 번째 세부 리뷰를 작성해보세요.' +
            '</p>' +
            '</div>';
        updateFormHiddenInputs();
        return;
    }

    var html = '';
    for (var idx = 0; idx < subReviews.length; idx++) {
        var sub = subReviews[idx];
        
        var verifiedBadge = sub.verified 
            ? '<span class="inline-flex items-center gap-1 text-[11px] font-medium text-emerald-700 bg-emerald-50 px-1.5 py-0.5 rounded border border-emerald-200">' +
              '<i class="fa-solid fa-circle-check text-emerald-600"></i> 내돈내산 인증</span>'
            : '';

        var placeHtml = sub.placeOrBrand
            ? '<p class="text-xs text-slate-500 flex items-center gap-1 mt-0.5">' +
              '<i class="fa-solid fa-location-dot text-slate-400 text-xs"></i>' +
              '<span>' + sub.placeOrBrand + '</span></p>'
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

        html += 
            '<div class="border-2 border-dashed border-slate-300 rounded-lg p-4 bg-white/90 shadow-xs space-y-3 hover:border-slate-400 transition-all">' +
                '<div class="flex items-center justify-between">' +
                    '<div class="flex items-center gap-2">' +
                        getCategoryBadgeHtml(sub.category) +
                        verifiedBadge +
                    '</div>' +
                    '<div class="flex items-center gap-2">' +
                        '<div class="flex items-center gap-1 font-mono text-xs font-bold text-slate-700">' +
                            renderReadOnlyStarsHtml(sub.rating) +
                            '<span>' + sub.rating.toFixed(1) + ' / 5.0</span>' +
                        '</div>' +
                        '<button type="button" onclick="deleteSubReview(' + idx + ')" class="text-xs text-rose-500 hover:text-rose-700 font-semibold px-2 py-0.5 border border-dashed border-rose-300 rounded bg-rose-50 hover:bg-rose-100 transition-colors cursor-pointer">' +
                            '삭제' +
                        '</button>' +
                    '</div>' +
                '</div>' +

                '<div>' +
                    '<h4 class="text-base font-bold text-slate-800">' + sub.name + '</h4>' +
                    placeHtml +
                '</div>' +

                '<p class="text-sm text-slate-700 bg-slate-50 p-2.5 rounded border border-slate-200 leading-relaxed font-sans">' +
                    sub.comment +
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
        html += '<input type="hidden" name="subReviews[' + i + '].category" value="' + (sub.category || '') + '">' +
                '<input type="hidden" name="subReviews[' + i + '].name" value="' + (sub.name || '') + '">' +
                '<input type="hidden" name="subReviews[' + i + '].rating" value="' + (sub.rating || 0) + '">' +
                '<input type="hidden" name="subReviews[' + i + '].comment" value="' + (sub.comment || '') + '">' +
                '<input type="hidden" name="subReviews[' + i + '].placeOrBrand" value="' + (sub.placeOrBrand || '') + '">' +
                '<input type="hidden" name="subReviews[' + i + '].verified" value="' + (sub.verified ? 'true' : 'false') + '">' +
                '<input type="hidden" name="subReviews[' + i + '].tags" value="' + tagsStr + '">';
    }
    container.innerHTML = html;
}

// =============================================================================
// 요일 계산 헬퍼 (로컬 타임존 기준 100% 정확한 요일 텍스트 계산)
// =============================================================================
function getDayOfWeekText(dateStr) {
    if (!dateStr) return '';
    var parts = dateStr.split('-');
    if (parts.length === 3) {
        var d = new Date(parseInt(parts[0], 10), parseInt(parts[1], 10) - 1, parseInt(parts[2], 10));
        var days = ['일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일'];
        return days[d.getDay()] + ' 기록';
    }
    return '';
}

function updateHeaderDayBadge() {
    var dateInput = document.getElementById('reviewDate');
    var badge = document.getElementById('headerDayOfWeek');
    if (dateInput && badge) {
        badge.textContent = getDayOfWeekText(dateInput.value);
    }
}

// =============================================================================
// 초기화
// =============================================================================
document.addEventListener('DOMContentLoaded', function() {
    // 날짜 입력 필드에 오늘 날짜 자동 기본값 채움 및 요일 뱃지 실시간 계산
    var todayStr = new Date().toISOString().split('T')[0];
    var dateInput = document.getElementById('reviewDate');
    if (dateInput) {
        dateInput.value = todayStr;
        updateHeaderDayBadge();

        dateInput.addEventListener('change', updateHeaderDayBadge);
        dateInput.addEventListener('input', updateHeaderDayBadge);
    }

    // 0.5점 단위 별점 컨트롤러 초기화 (0.0점 빈 별로 시작)
    setupInteractiveStarRating('mainStarContainer', 'overallRatingInput', 'mainScoreText', 0.0, false);
    setupInteractiveStarRating('subStarContainer', null, 'subScoreText', 0.0, true);

    // 태그 및 서브리뷰 목록 초기화 (선택/등록된 것 없는 깨끗한 상태)
    renderMoodTags();
    renderSubReviewsList();

    // 폼 제출 유효성 검사
    var reviewForm = document.getElementById('reviewForm');
    if (reviewForm) {
        reviewForm.addEventListener('submit', function(e) {
            // 종합 평점 유효성 검사 (0점인 경우)
            if (overallRating <= 0) {
                alert('오늘 하루 종합 평점을 별점으로 선택해주세요.');
                e.preventDefault();
                return false;
            }

            // 총평 입력 유효성 검사
            var summaryInput = document.getElementById('summaryInput');
            var summary = summaryInput ? summaryInput.value.trim() : '';
            if (!summary) {
                alert('오늘 하루 총평을 입력해주세요.');
                if (summaryInput) summaryInput.focus();
                e.preventDefault();
                return false;
            }

            updateFormHiddenInputs();
            return true;
        });
    }
});
