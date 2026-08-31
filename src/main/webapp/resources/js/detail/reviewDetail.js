/**
 * RE:DAY - reviewDetail.js
 * 리뷰 상세 페이지 클라이언트 인터랙션 및 백엔드 폼 보조 스크립트
 */

document.addEventListener('DOMContentLoaded', function () {
    initCommentCounter();
    initLikeFormAjaxEnhancement();
});

/**
 * 1. 현재 리뷰 URL 클립보드 복사 & 토스트 알림 표시
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
 * 2. 댓글 실시간 글자수 카운팅 및 전송 전 유효성 검사
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
 * 3. 좋아요 버튼 Progressive Enhancement (AJAX 비동기 토글 지원 + 폼 Fallback)
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
                        likeButton.className = 'flex items-center gap-1.5 px-3.5 py-1.5 rounded-lg border text-xs font-semibold transition-all cursor-pointer bg-rose-50 border-rose-300 text-rose-600 shadow-xs';
                        if (heartIcon) heartIcon.className = 'fa-solid fa-heart text-sm text-rose-500';
                    } else {
                        likeButton.className = 'flex items-center gap-1.5 px-3.5 py-1.5 rounded-lg border text-xs font-semibold transition-all cursor-pointer bg-white border-slate-300 text-slate-700 hover:bg-slate-50';
                        if (heartIcon) heartIcon.className = 'fa-solid fa-heart text-sm text-slate-400';
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
