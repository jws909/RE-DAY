document.addEventListener('DOMContentLoaded', function () {
    initUserLevelBadge();
    initUserStreakBadge();
    initCommentCounter();
    initLikeFormAjaxEnhancement();
});

/**
 * 1. 유저 레벨(LV1~LV5) 칭호 및 스타일 동적 변환
 */
function initUserLevelBadge() {
    var levelBadge = document.getElementById('userLevelBadge');
    if (!levelBadge) return;

    var rawLevel = (levelBadge.getAttribute('data-level') || levelBadge.textContent || '').trim().toUpperCase();

    // LV1 ~ LV5 매핑 테이블
    var levelTitles = {
        'LV1': 'Lv.1 일상 기록러',
        '1': 'Lv.1 일상 기록러',
        'LV.1': 'Lv.1 일상 기록러',

        'LV2': 'Lv.2 루키 아카이버',
        '2': 'Lv.2 루키 아카이버',
        'LV.2': 'Lv.2 루키 아카이버',

        'LV3': 'Lv.3 데일리 아카이버',
        '3': 'Lv.3 데일리 아카이버',
        'LV.3': 'Lv.3 데일리 아카이버',

        'LV4': 'Lv.4 프로 기록러',
        '4': 'Lv.4 프로 기록러',
        'LV.4': 'Lv.4 프로 기록러',

        'LV5': 'Lv.5 라이프 해커',
        '5': 'Lv.5 라이프 해커',
        'LV.5': 'Lv.5 라이프 해커'
    };

    var title = levelTitles[rawLevel] || (rawLevel ? rawLevel : 'Lv.1 일상 기록러');
    levelBadge.textContent = title;

    // 레벨 티어별 은은한 뱃지 스타일 적용 (와이어프레임 톤 유지)
    if (rawLevel === 'LV5' || rawLevel === '5') {
        levelBadge.className = 'text-xs font-mono px-2 py-0.5 rounded border border-purple-300 bg-purple-50 text-purple-700 font-bold';
    } else if (rawLevel === 'LV4' || rawLevel === '4') {
        levelBadge.className = 'text-xs font-mono px-2 py-0.5 rounded border border-blue-300 bg-blue-50 text-blue-700 font-semibold';
    } else if (rawLevel === 'LV3' || rawLevel === '3') {
        levelBadge.className = 'text-xs font-mono px-2 py-0.5 rounded border border-emerald-300 bg-emerald-50 text-emerald-700 font-semibold';
    } else {
        levelBadge.className = 'text-xs font-mono px-2 py-0.5 rounded border border-slate-200 bg-slate-100 text-slate-600 font-medium';
    }
}

/**
 * 2. 스트릭(연속 기록 일수)에 따른 칭호 및 뱃지 동적 생성
 */
function initUserStreakBadge() {
    var streakBadge = document.getElementById('userStreakBadge');
    var streakText = document.getElementById('userStreakText');
    if (!streakBadge || !streakText) return;

    var rawStreakStr = streakBadge.getAttribute('data-streak') || '0';
    var streak = parseInt(rawStreakStr, 10);

    if (isNaN(streak) || streak <= 0) {
        streakBadge.classList.add('hidden');
        return;
    }

    streakBadge.classList.remove('hidden');

    var iconEl = streakBadge.querySelector('i');

    // 일수 구간별 칭호 분기
    if (streak >= 30) {
        // 30일 이상: 챔피언
        if (iconEl) iconEl.className = 'fa-solid fa-trophy text-amber-500 text-xs';
        streakText.textContent = streak + '일 연속 챔피언';
        streakBadge.className = 'text-[11px] font-bold text-amber-800 bg-amber-50 px-2 py-0.5 rounded border border-amber-300 font-mono inline-flex items-center gap-1 shadow-2xs streak-badge';
    } else if (streak >= 14) {
        // 14일 ~ 29일: 마스터
        if (iconEl) iconEl.className = 'fa-solid fa-fire text-orange-500 text-xs';
        streakText.textContent = streak + '일 연속 마스터';
        streakBadge.className = 'text-[11px] font-semibold text-orange-600 bg-orange-50 px-2 py-0.5 rounded border border-orange-200 font-mono inline-flex items-center gap-1 shadow-2xs streak-badge';
    } else if (streak >= 7) {
        // 7일 ~ 13일: 챌린저
        if (iconEl) iconEl.className = 'fa-solid fa-fire text-orange-500 text-xs';
        streakText.textContent = streak + '일 연속 챌린저';
        streakBadge.className = 'text-[11px] font-semibold text-orange-600 bg-orange-50 px-2 py-0.5 rounded border border-orange-200 font-mono inline-flex items-center gap-1 shadow-2xs streak-badge';
    } else {
        // 1일 ~ 6일: 기본 기록
        if (iconEl) iconEl.className = 'fa-solid fa-fire text-orange-500 text-xs';
        streakText.textContent = streak + '일 연속 기록';
        streakBadge.className = 'text-[11px] font-medium text-orange-600 bg-orange-50 px-2 py-0.5 rounded border border-orange-200 font-mono inline-flex items-center gap-1 shadow-2xs streak-badge';
    }
}

/**
 * 3. 현재 리뷰 URL 클립보드 복사 & 토스트 알림 표시
 */
function copyCurrentUrl() {
    var url = window.location.href;

    if (navigator.clipboard && window.isSecureContext) {
        navigator.clipboard.writeText(url).then(function () {
            showToast('리뷰 링크가 클립보드에 복사되었습니다.');
        }).catch(function () {
            fallbackCopyText(url);
        });
    } else {
        fallbackCopyText(url);
    }
}

/**
 * 클립보드 API 미지원 환경을 위한 Fallback 복사 로직
 */
function fallbackCopyText(text) {
    var textArea = document.createElement('textarea');
    textArea.value = text;
    textArea.style.position = 'fixed';
    textArea.style.top = '0';
    textArea.style.left = '0';
    textArea.style.opacity = '0';
    document.body.appendChild(textArea);
    textArea.focus();
    textArea.select();

    try {
        var successful = document.execCommand('copy');
        if (successful) {
            showToast('리뷰 링크가 클립보드에 복사되었습니다.');
        } else {
            prompt('아래 링크를 복사해주세요:', text);
        }
    } catch (err) {
        prompt('아래 링크를 복사해주세요:', text);
    }
    document.body.removeChild(textArea);
}

/**
 * 하단 플로팅 토스트 메시지 출력
 */
function showToast(message) {
    var existingToast = document.querySelector('.toast-notice');
    if (existingToast) {
        existingToast.remove();
    }

    var toast = document.createElement('div');
    toast.className = 'toast-notice bg-slate-900 text-white text-xs font-mono px-4 py-2.5 rounded-xl shadow-lg border border-slate-700 flex items-center gap-2';
    toast.innerHTML = '<i class="fa-solid fa-circle-check text-emerald-400"></i><span>' + message + '</span>';

    document.body.appendChild(toast);

    // 표시 애니메이션
    setTimeout(function () {
        toast.classList.add('show');
    }, 50);

    // 2.5초 후 자동 소멸
    setTimeout(function () {
        toast.classList.remove('show');
        setTimeout(function () {
            if (toast.parentNode) {
                toast.parentNode.removeChild(toast);
            }
        }, 300);
    }, 2500);
}

/**
 * 5. 댓글 실시간 글자수 카운팅 및 전송 전 유효성 검사
 */
function initCommentCounter() {
    var commentInput = document.getElementById('commentInput');
    var counterSpan = document.getElementById('commentLengthCounter');
    var commentForm = document.getElementById('commentForm');

    if (!commentInput || !counterSpan) return;

    commentInput.addEventListener('input', function () {
        var currentLength = this.value.length;
        counterSpan.textContent = currentLength + ' / 500자';

        if (currentLength >= 500) {
            counterSpan.classList.add('text-rose-500');
            counterSpan.classList.remove('text-slate-400');
        } else {
            counterSpan.classList.remove('text-rose-500');
            counterSpan.classList.add('text-slate-400');
        }
    });

    if (commentForm) {
        commentForm.addEventListener('submit', function (e) {
            var content = commentInput.value.trim();
            if (!content) {
                e.preventDefault();
                alert('댓글 내용을 입력해주세요.');
                commentInput.focus();
                return false;
            }
        });
    }
}

/**
 * 6. 좋아요 버튼 Progressive Enhancement (AJAX 비동기 토글 지원 + 폼 Fallback)
 */
function initLikeFormAjaxEnhancement() {
    var likeForm = document.getElementById('likeForm');
    var likeButton = document.getElementById('likeButton');
    var likeCountSpan = document.getElementById('likeCountSpan');

    if (!likeForm || !likeButton || !likeCountSpan) return;

    likeForm.addEventListener('submit', function (e) {
        // Fetch API 지원 시 AJAX로 부드럽게 상태 토글 (서버 응답에 따라 UI 업데이트)
        if (window.fetch) {
            e.preventDefault();
            var formData = new FormData(likeForm);

            fetch(likeForm.action, {
                method: 'POST',
                body: formData,
                headers: {
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
            .then(function (response) {
                if (response.redirected) {
                    window.location.href = response.url;
                    return;
                }
                return response.json();
            })
            .then(function (data) {
                if (data && typeof data.isLiked !== 'undefined') {
                    // UI 상태 업데이트
                    var heartIcon = likeButton.querySelector('i');
                    likeCountSpan.textContent = data.likeCount;

                    if (data.isLiked) {
                        likeButton.className = 'flex items-center gap-1.5 px-3.5 py-1.5 rounded-lg border text-xs font-semibold transition-colors cursor-pointer bg-rose-50 border-rose-300 text-rose-600';
                        if (heartIcon) heartIcon.className = 'fa-solid fa-heart text-xs text-rose-500';
                    } else {
                        likeButton.className = 'flex items-center gap-1.5 px-3.5 py-1.5 rounded-lg border text-xs font-semibold transition-colors cursor-pointer bg-white border-slate-200 text-slate-700 hover:bg-slate-50';
                        if (heartIcon) heartIcon.className = 'fa-solid fa-heart text-xs text-slate-400';
                    }
                } else {
                    // 표준 폼으로 재전송
                    likeForm.submit();
                }
            })
            .catch(function () {
                // 통신 실패 시 일반 Spring Form Submit으로 Fallback
                likeForm.submit();
            });
        }
    });
}
