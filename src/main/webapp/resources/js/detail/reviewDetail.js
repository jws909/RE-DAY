document.addEventListener('DOMContentLoaded', function() {
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

    // 🎁 [이스터에그] '승북이' 전용 뱃지인 경우 덮어쓰지 않고 유지
    if (levelBadge.classList.contains('seungbuk_level_badge') || 
        levelBadge.classList.contains('mp_easter_egg_badge') ||
        (levelBadge.textContent && levelBadge.textContent.indexOf('막내 팀장') !== -1)) {
        return;
    }

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
        navigator.clipboard.writeText(url).then(function() {
            showToast('리뷰 링크가 클립보드에 복사되었습니다.');
        }).catch(function() {
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

document.addEventListener("DOMContentLoaded", function() {
    var shareButton = document.querySelector('#shareButton');
    console.log("찾아낸 공유 버튼:", shareButton);
    console.log("찾아낸 공유 버튼:", shareButton);
    if (shareButton) {
        shareButton.addEventListener('click', function() {
            copyCurrentUrl();
        });
    }
});

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
    setTimeout(function() {
        toast.classList.add('show');
    }, 50);

    // 2.5초 후 자동 소멸
    setTimeout(function() {
        toast.classList.remove('show');
        setTimeout(function() {
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

    commentInput.addEventListener('input', function() {
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
        commentForm.addEventListener('submit', function(e) {
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

    likeForm.addEventListener('submit', function(e) {
        e.preventDefault(); // 기본 폼 제출 방지                                                       

        // 1. 로그인 여부 체크                                                                         
        var isLoggedIn = likeForm.getAttribute('data-logged-in') === 'true';
        if (!isLoggedIn) {
            if (confirm('좋아요 기능은 로그인이 필요합니다.\n로그인 페이지로 이동하시겠습니까?')) {
                window.location.href = '/member/signin'; // 프로젝트 로그인 경로                       
            }
            return false;
        }

        // 2. 백엔드 DTO(LikeRequestDTO)에 맞춘 JSON 바디 생성                                         
        var reviewId = document.getElementById('likeReviewId').value;
        var userId = document.getElementById('likeUserId').value;

        var requestData = {
            reviewId: parseInt(reviewId, 10),
            userId: userId
        };

        // 3. 현재 좋아요 상태 및 카운트 확인                                                          
        var isLiked = likeForm.getAttribute('data-is-liked') === 'true';
        var currentCount = parseInt(likeCountSpan.textContent, 10) || 0;

        // 4. JSON 비동기 통신                                                                         
        fetch(likeForm.action, {
            method: 'POST', // LikeServiceImpl.insert 가 이미 토글(존재시 삭제, 미존재시 삽입)을 수행함
            headers: {
                'Content-Type': 'application/json',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: JSON.stringify(requestData)
        })
            .then(function(response) {
                if (!response.ok) {
                    throw new Error('서버 응답 오류: ' + response.status);
                }
                return response.json();
            })
            .then(function(result) {
                // ResponseResult { success: true, message: "성공", data: null }                           
                if (result && result.success) {
                    // UI 상태 반전 (토글)                                                                 
                    isLiked = !isLiked;
                    likeForm.setAttribute('data-is-liked', isLiked ? 'true' : 'false');

                    var newCount = isLiked ? (currentCount + 1) : Math.max(0, currentCount - 1);
                    likeCountSpan.textContent = newCount;

                    var heartIcon = likeButton.querySelector('i');
                    if (isLiked) {
                        likeButton.className = 'flex items-center gap-1.5 px-3.5 py-1.5 rounded-lg border text-xs font-semibold transition-colors cursor-pointer bg-rose-50 border-rose-300 text-rose-600';
                        if (heartIcon) heartIcon.className = 'fa-solid fa-heart text-xs text-rose-500';
                    } else {
                        likeButton.className = 'flex items-center gap-1.5 px-3.5 py-1.5 rounded-lg border text-xs font-semibold transition-colors cursor-pointer bg-white border-slate-200 text-slate-700 hover:bg-slate-50';
                        if (heartIcon) heartIcon.className = 'fa-solid fa-heart text-xs text-slate-400';
                    }
                } else {
                    alert('좋아요 처리에 실패했습니다.');
                }
            })
            .catch(function(error) {
                console.error('좋아요 처리 실패:', error);
                alert('처리 중 오류가 발생했습니다.');
            });
    });
}

// 1. 댓글 작성 AJAX (POST + JSON)                                                                     
document.addEventListener('DOMContentLoaded', function() {
    var commentForm = document.getElementById('commentForm');
    if (commentForm) {
        commentForm.addEventListener('submit', function(e) {
            e.preventDefault();

            var contentInput = document.getElementById('commentInput');
            var content = contentInput.value.trim();
            if (!content) {
                alert('댓글 내용을 입력해주세요.');
                return;
            }

            var reviewId = document.getElementById('commentReviewId').value;
            var userId = document.getElementById('commentUserId').value;

            // CommentDTO 구조에 맞춘 JSON 생성                                                        
            var requestData = {
                reviewId: parseInt(reviewId, 10),
                userId: userId,
                content: content
            };

            fetch(commentForm.action, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: JSON.stringify(requestData)
            })
                .then(function(res) { return res.json(); })
                .then(function(res) {
                    if (res && res.success) {
                        contentInput.value = ''; // 입력창 비우기                                          
                        location.reload(); // 새로 등록된 댓글 렌더링을 위해 새로고침 또는 동적 추가       
                    } else {
                        alert(res.message || '댓글 등록에 실패했습니다.');
                    }
                })
                .catch(function(err) {
                    console.error(err);
                    alert('댓글 등록 중 오류가 발생했습니다.');
                });
        });
    }
});

// 2. 댓글 삭제 AJAX (DELETE)                                                                          
function removeComment(commentId) {
    if (!confirm('정말 댓글을 삭제하시겠습니까?')) return;

    var commentForm = document.getElementById('commentForm');
    var reviewId = commentForm ? commentForm.getAttribute('data-review-id') : '${review.reviewId}';
    var deleteUrl = (window.contextPath || '') + '/RE:DAY/reviews/' + reviewId + '/comments/' +
        commentId;

    fetch(deleteUrl, {
        method: 'DELETE',
        headers: {
            'X-Requested-With': 'XMLHttpRequest'
        }
    })
        .then(function(res) { return res.json(); })
        .then(function(res) {
            if (res && res.success) {
                // 화면에서 해당 댓글 요소 즉시 제거                                                       
                var targetItem = document.getElementById('comment-item-' + commentId);
                if (targetItem) targetItem.remove();

                // 카운트 숫자 -1 감소                                                                     
                var countSpan = document.getElementById('commentCountSpan');
                if (countSpan) {
                    var cur = parseInt(countSpan.textContent, 10) || 0;
                    countSpan.textContent = Math.max(0, cur - 1);
                }
            } else {
                alert('댓글 삭제에 실패했습니다.');
            }
        })
        .catch(function(err) {
            console.error(err);
            alert('댓글 삭제 중 오류가 발생했습니다.');
        });
}
