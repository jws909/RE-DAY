/**
 * RE:DAY - mainpage.js
 */

// 전역 contextPath 안전 참조
var ctx = (typeof contextPath !== 'undefined') ? contextPath : '';

/* 필터 바 정렬 버튼 기능 (현재 선택된 카테고리 유지) */
document.addEventListener("DOMContentLoaded", function() {
    var filterButtons = document.querySelectorAll('.filter_button button');

    filterButtons.forEach(function(button) {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            var sortType = this.getAttribute('data-sort');
            if (!sortType) {
                sortType = (this.textContent.indexOf('평점') !== -1) ? 'rating' : 'latest';
            }
            var container = document.getElementById('mainReviewContainer');
            var currentCategory = container ? (container.getAttribute('data-category') || 'all') : 'all';
            location.href = ctx + '/RE:DAY/mainpage?sort=' + encodeURIComponent(sortType) + '&category=' + encodeURIComponent(currentCategory);
        });
    });
});

/* 카테고리 매칭 헬퍼 함수 (영문/한글 모두 지원) */
function isCategoryMatching(filterCat, itemCat) {
    if (!filterCat || filterCat === 'all') return true;
    if (!itemCat) return false;
    var fc = filterCat.trim().toLowerCase();
    var ic = itemCat.trim().toLowerCase();
    if (fc === ic) return true;
    if (fc === 'place' && (ic === '장소' || ic.indexOf('식당') !== -1 || ic.indexOf('카페') !== -1)) return true;
    if (fc === 'item' && (ic === '아이템' || ic.indexOf('기기') !== -1)) return true;
    if (fc === 'transport' && (ic === '이동수단' || ic.indexOf('모빌리티') !== -1)) return true;
    if (fc === 'content' && (ic === '콘텐츠' || ic.indexOf('미디어') !== -1)) return true;
    return false;
}

/* 서브 리뷰 카테고리 필터링 기능 (즉시 DOM 필터링 + 비동기 AJAX 피드 갱신) */
document.addEventListener("DOMContentLoaded", function() {
    var mpSubReviewCategoryFilter = document.querySelectorAll('.sub_review_category_filter_card');
    var container = document.getElementById('mainReviewContainer');
    var feedTotalCount = document.getElementById('feedTotalCount');
    var feedMoreContainer = document.getElementById('feedMoreContainer');

    mpSubReviewCategoryFilter.forEach(function(button) {
        button.addEventListener('click', function() {
            var selectedCategory = this.getAttribute('data-category') || 'all';

            // 1. 카테고리 탭 UI 활성화 전환
            mpSubReviewCategoryFilter.forEach(function(btn) {
                btn.classList.remove('active');
                var score = btn.querySelector('.sub_review_category_filter_score');
                if (score) score.classList.remove('active');
            });
            this.classList.add('active');
            var thisScore = this.querySelector('.sub_review_category_filter_score');
            if (thisScore) thisScore.classList.add('active');

            if (!container) return;

            // 2. 현재 정렬 방식 가져오기
            var currentSort = container.getAttribute('data-sort') || 'latest';

            // 3. 브라우저 URL 갱신 (새로고침 시에도 유지되도록 history.pushState 사용)
            var newUrl = ctx + '/RE:DAY/mainpage?sort=' + encodeURIComponent(currentSort) + '&category=' + encodeURIComponent(selectedCategory);
            if (window.history && window.history.pushState) {
                window.history.pushState(null, '', newUrl);
            }

            // 4. 즉시 클라이언트 DOM 필터링 (서버 응답 전에도 즉각적으로 화면 반영)
            var cards = container.querySelectorAll('.mp_review_card');
            var visibleCardCount = 0;

            cards.forEach(function(card) {
                var subItems = card.querySelectorAll('.mp_sub_review_item');
                var matchedSubCount = 0;

                subItems.forEach(function(item) {
                    var itemCat = item.getAttribute('data-category') || '';
                    var badge = item.querySelector('.mp_category_badge');
                    var badgeText = badge ? badge.textContent.trim() : '';

                    if (isCategoryMatching(selectedCategory, itemCat) || isCategoryMatching(selectedCategory, badgeText)) {
                        item.style.display = '';
                        matchedSubCount++;
                    } else {
                        item.style.display = 'none';
                    }
                });

                // 카드 내 서브리뷰 개수 텍스트 갱신
                var titleSpan = card.querySelector('.mp_sub_reviews_title span:last-child');
                if (titleSpan) {
                    titleSpan.textContent = '이 날의 서브 리뷰 (' + matchedSubCount + '개)';
                }

                // 해당 카테고리 서브리뷰가 1개 이상이거나 '전체'인 경우만 카드 표시
                if (selectedCategory === 'all' || matchedSubCount > 0) {
                    card.style.display = '';
                    visibleCardCount++;
                } else {
                    card.style.display = 'none';
                }
            });

            // 5. 서버에 카테고리별 1페이지 비동기 요청 (전체 데이터 동기화 및 페이징)
            var feedUrl = ctx + '/RE:DAY/feed?page=1&size=5&sort=' + encodeURIComponent(currentSort) + '&category=' + encodeURIComponent(selectedCategory);

            fetch(feedUrl)
                .then(function(res) {
                    return res.json();
                })
                .then(function(response) {
                    if (response.success && response.data) {
                        var data = response.data;
                        var reviews = data.reviews;

                        // 컨테이너 상태 갱신
                        container.setAttribute('data-page', '1');
                        container.setAttribute('data-category', selectedCategory);
                        container.setAttribute('data-has-more', data.hasMore);

                        // 상단 총 개수 텍스트 갱신
                        if (feedTotalCount) {
                            feedTotalCount.textContent = data.totalCount;
                        }

                        if (!reviews || reviews.length === 0) {
                            container.innerHTML = '<div class="empty_feed_box" style="text-align: center; padding: 60px 20px; background: #ffffff; border: 2px dashed #CBD5E1; border-radius: 16px; margin-top: 20px;">' +
                                                  '<span class="material-symbols-outlined" style="font-size: 48px; color: #94A3B8;">sentiment_dissatisfied</span>' +
                                                  '<p style="margin-top: 12px; font-size: 15px; font-weight: bold; color: #475569;">선택한 카테고리에 해당하는 리뷰가 없습니다.</p>' +
                                                  '<p style="font-size: 13px; color: #94A3B8; margin-top: 4px;">다른 카테고리를 선택하거나 새 리뷰를 작성해보세요!</p>' +
                                                  '</div>';
                        } else {
                            var html = '';
                            var seenIds = {};
                            reviews.forEach(function(rev) {
                                if (!seenIds[rev.reviewId]) {
                                    seenIds[rev.reviewId] = true;
                                    html += buildReviewCardHtml(rev);
                                }
                            });
                            container.innerHTML = html;

                            if (typeof syncReviewStatesFromSession === 'function') {
                                syncReviewStatesFromSession();
                            }
                        }

                        // 더보기 버튼 가시성 제어
                        if (feedMoreContainer) {
                            feedMoreContainer.style.display = data.hasMore ? '' : 'none';
                        }
                    }
                })
                .catch(function(err) {
                    console.error('카테고리 필터링 요청 실패:', err);
                });
        });
    });
});

/* 리뷰쓰기 이동버튼 */
document.addEventListener("DOMContentLoaded", function() {
    var writeBtn = document.getElementById('mp_review_write');
    if (writeBtn) {
        writeBtn.addEventListener('click', function() {
            location.href = ctx + "/RE:DAY/review/write";
        });
    }
});

/* 좋아요 기능 (이벤트 위임 - 동적 추가 카드 완벽 지원 & 로그인 검증) */
document.addEventListener("DOMContentLoaded", function() {
    document.addEventListener("click", function(e) {
        var button = e.target.closest(".like_btn");
        if (!button) return;

        // 1. 로그인 여부 체크 (reviewDetail과 동일)
        var isLoggedIn = (typeof isUserLoggedIn !== 'undefined') ? isUserLoggedIn : false;
        if (!isLoggedIn) {
            if (confirm('좋아요 기능은 로그인이 필요합니다.\n로그인 페이지로 이동하시겠습니까?')) {
                window.location.href = ctx + '/member/signin';
            }
            return;
        }

        var reviewId = button.getAttribute("data-review-id");
        var isLiked = button.getAttribute("data-liked") === "true";
        var countSpan = button.querySelector(".like_count");
        var currentCount = parseInt(countSpan ? countSpan.textContent : "0", 10) || 0;

        // 2. 백엔드 LikeServiceImpl.insert 가 이미 토글(존재시 삭제, 미존재시 삽입)을 수행하므로 POST 전송
        var url = ctx + "/RE:DAY/like";

        fetch(url, {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "X-Requested-With": "XMLHttpRequest"
            },
            body: JSON.stringify({ reviewId: parseInt(reviewId, 10) })
        })
        .then(function(response) {
            if (!response.ok) {
                throw new Error('서버 응답 오류: ' + response.status);
            }
            return response.json();
        })
        .then(function(result) {
            if (result && result.success) {
                if (result.data && typeof result.data.liked === 'boolean') {
                    isLiked = result.data.liked;
                    button.setAttribute("data-liked", isLiked ? "true" : "false");
                    if (countSpan) countSpan.textContent = result.data.likeCount;
                } else {
                    // UI 상태 반전 (토글 Fallback)
                    isLiked = !isLiked;
                    button.setAttribute("data-liked", isLiked ? "true" : "false");
                    if (isLiked) {
                        if (countSpan) countSpan.textContent = currentCount + 1;
                    } else {
                        if (countSpan) countSpan.textContent = Math.max(0, currentCount - 1);
                    }
                }
                if (isLiked) {
                    button.classList.add("active");
                } else {
                    button.classList.remove("active");
                }

                var newLikeCount = (result.data && typeof result.data.likeCount === 'number')
                    ? result.data.likeCount
                    : (isLiked ? currentCount + 1 : Math.max(0, currentCount - 1));
                saveReviewSyncState(parseInt(reviewId, 10), isLiked, newLikeCount);
            } else {
                if (result && result.message && result.message.indexOf("로그인") !== -1) {
                    if (confirm('좋아요 기능은 로그인이 필요합니다.\n로그인 페이지로 이동하시겠습니까?')) {
                        window.location.href = ctx + '/member/signin';
                    }
                } else {
                    alert((result && result.message) ? result.message : "좋아요 처리에 실패했습니다.");
                }
            }
        })
        .catch(function(error) {
            console.error("좋아요 처리 실패:", error);
            alert("처리 중 오류가 발생했습니다.");
        });
    });
});

/* 메인 피드 더보기 기능 (전역 함수 및 이벤트 리스너) */
window.loadMoreReviews = function() {
    var btnLoadMore = document.getElementById('btnLoadMore');
    var container = document.getElementById('mainReviewContainer');
    var feedMoreContainer = document.getElementById('feedMoreContainer');

    if (!btnLoadMore || !container) return;

    // 이미 요청 중이면 중복 실행 방지 (연타 및 중복 이벤트 가드)
    if (btnLoadMore.disabled || btnLoadMore.getAttribute('data-loading') === 'true') {
        return;
    }

    var currentPage = parseInt(container.getAttribute('data-page') || '1', 10);
    var currentSort = container.getAttribute('data-sort') || 'latest';
    var currentCategory = container.getAttribute('data-category') || 'all';
    var nextPage = currentPage + 1;

    btnLoadMore.disabled = true;
    btnLoadMore.setAttribute('data-loading', 'true');
    btnLoadMore.innerHTML = '<span class="material-symbols-outlined" style="font-size: 18px;">sync</span> <span>로딩 중...</span>';

    var feedUrl = ctx + '/RE:DAY/feed?page=' + nextPage + '&size=5&sort=' + encodeURIComponent(currentSort) + '&category=' + encodeURIComponent(currentCategory);

    fetch(feedUrl)
        .then(function(res) {
            return res.json();
        })
        .then(function(response) {
            if (response.success && response.data) {
                var data = response.data;
                var reviews = data.reviews;

                if (reviews && reviews.length > 0) {
                    reviews.forEach(function(rev) {
                        // 중복 방지: 이미 DOM에 렌더링된 동일한 리뷰 ID는 건너뜀
                        var existing = container.querySelector('.mp_review_card[data-review-id="' + rev.reviewId + '"]');
                        if (!existing) {
                            var cardHtml = buildReviewCardHtml(rev);
                            container.insertAdjacentHTML('beforeend', cardHtml);
                        }
                    });
                    container.setAttribute('data-page', nextPage);

                    // 세션 스토리지에 동기화된 좋아요/댓글 상태 적용
                    if (typeof syncReviewStatesFromSession === 'function') {
                        syncReviewStatesFromSession();
                    }
                }

                if (!data.hasMore) {
                    if (feedMoreContainer) {
                        feedMoreContainer.style.display = 'none';
                    }
                }
            } else {
                alert('리뷰를 불러오지 못했습니다.');
            }
        })
        .catch(function(err) {
            console.error('피드 로딩 오류:', err);
            alert('피드 로딩 중 오류가 발생했습니다.');
        })
        .finally(function() {
            btnLoadMore.disabled = false;
            btnLoadMore.removeAttribute('data-loading');
            btnLoadMore.innerHTML = '<span class="material-symbols-outlined" style="font-size: 18px;">expand_more</span> <span>리뷰 더보기 (+5개)</span>';
        });
};

document.addEventListener("DOMContentLoaded", function() {
    var btnLoadMore = document.getElementById('btnLoadMore');
    if (btnLoadMore) {
        btnLoadMore.onclick = function(e) {
            e.preventDefault();
            window.loadMoreReviews();
        };
    }
});

function escapeHtml(text) {
    if (!text) return '';
    return String(text)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#039;');
}

/**
 * 🎁 [이스터에그] '승북이'인지 확인하는 함수
 */
function isSeungbuk(userId, nickname) {
    var uid = (userId || '').toString().toLowerCase().trim();
    var nick = (nickname || '').toString().toLowerCase().trim();
    return nick === '승북이' || nick.indexOf('승북') !== -1 || uid === '승북이';
}

function getLevelBadgeHtml(rawLevel, userId, nickname) {
    // 🎁 [이스터에그] '승북이' 전용 특별 레벨 뱃지
    if (isSeungbuk(userId, nickname)) {
        return '<span class="seungbuk_level_badge font-mono" style="display: inline-flex; align-items: center; gap: 4px; padding: 2px 8px; font-size: 11px; font-weight: 700; color: #713F12; background-color: #ECFCCB; border: 1px solid #22C55E; border-radius: 6px; vertical-align: middle; box-shadow: 0 1px 2px rgba(34, 197, 94, 0.15);">Lv.100 RE:DAY 막내 팀장</span>';
    }

    rawLevel = (rawLevel || 'LV1').toString().trim().toUpperCase();
    if (rawLevel === 'LV5' || rawLevel === '5') {
        return '<span class="text-xs font-mono px-2 py-0.5 rounded border border-purple-300 bg-purple-50 text-purple-700 font-bold">Lv.5 라이프 해커</span>';
    } else if (rawLevel === 'LV4' || rawLevel === '4') {
        return '<span class="text-xs font-mono px-2 py-0.5 rounded border border-blue-300 bg-blue-50 text-blue-700 font-semibold">Lv.4 프로 기록러</span>';
    } else if (rawLevel === 'LV3' || rawLevel === '3') {
        return '<span class="text-xs font-mono px-2 py-0.5 rounded border border-emerald-300 bg-emerald-50 text-emerald-700 font-semibold">Lv.3 데일리 아카이버</span>';
    } else if (rawLevel === 'LV2' || rawLevel === '2') {
        return '<span class="text-xs font-mono px-2 py-0.5 rounded border border-slate-200 bg-slate-100 text-slate-600 font-medium">Lv.2 루키 아카이버</span>';
    } else {
        return '<span class="text-xs font-mono px-2 py-0.5 rounded border border-slate-200 bg-slate-100 text-slate-600 font-medium">Lv.1 일상 기록러</span>';
    }
}

function getStreakBadgeHtml(streak) {
    var rawStreak = parseInt(streak, 10);
    if (isNaN(rawStreak) || rawStreak <= 0) return '';

    if (rawStreak >= 30) {
        return '<span class="text-[11px] font-bold text-amber-800 bg-amber-50 px-2 py-0.5 rounded border border-amber-300 font-mono inline-flex items-center gap-1 shadow-2xs streak-badge">' +
               '<i class="fa-solid fa-trophy text-amber-500 text-xs"></i> <span>' + rawStreak + '일 연속 챔피언</span></span>';
    } else if (rawStreak >= 14) {
        return '<span class="text-[11px] font-semibold text-orange-600 bg-orange-50 px-2 py-0.5 rounded border border-orange-200 font-mono inline-flex items-center gap-1 shadow-2xs streak-badge">' +
               '<i class="fa-solid fa-fire text-orange-500 text-xs"></i> <span>' + rawStreak + '일 연속 마스터</span></span>';
    } else if (rawStreak >= 7) {
        return '<span class="text-[11px] font-semibold text-orange-600 bg-orange-50 px-2 py-0.5 rounded border border-orange-200 font-mono inline-flex items-center gap-1 shadow-2xs streak-badge">' +
               '<i class="fa-solid fa-fire text-orange-500 text-xs"></i> <span>' + rawStreak + '일 연속 챌린저</span></span>';
    } else {
        return '<span class="text-[11px] font-medium text-orange-600 bg-orange-50 px-2 py-0.5 rounded border border-orange-200 font-mono inline-flex items-center gap-1 shadow-2xs streak-badge">' +
               '<i class="fa-solid fa-fire text-orange-500 text-xs"></i> <span>' + rawStreak + '일 연속 기록</span></span>';
    }
}

function getCategoryLabel(category) {
    if (!category) return '';
    var cat = category.toLowerCase().trim();
    if (cat === 'place' || cat === '장소') return '장소';
    if (cat === 'item' || cat === '아이템') return '아이템';
    if (cat === 'transport' || cat === '이동수단') return '이동수단';
    if (cat === 'content' || cat === '콘텐츠') return '콘텐츠';
    return category;
}

function buildReviewCardHtml(review) {
    var avatarSrc = review.authorProfileImg 
        ? (review.authorProfileImg.startsWith('http') ? review.authorProfileImg : (ctx + review.authorProfileImg))
        : '';
    var avatarHtml = avatarSrc 
        ? '<img src="' + avatarSrc + '" alt="프로필" style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%;" onerror="this.style.display=\'none\';">'
        : '<span class="material-symbols-outlined" style="font-size: 20px; color: #64748B;">person</span>';

    var nickname = escapeHtml(review.authorNickname || '익명');
    var levelBadgeHtml = getLevelBadgeHtml(review.authorLevel, review.userId, review.authorNickname);
    var streakBadgeHtml = getStreakBadgeHtml(review.authorStreakCount);

    var todayBadgeHtml = '';
    var todayStr = new Date().toISOString().substring(0, 10);
    if (review.reviewDate === todayStr) {
        todayBadgeHtml = '<span class="mp_today_badge font-mono">TODAY</span>';
    }

    var dayOfWeekHtml = review.dayOfWeek ? ' <span class="font-mono font-medium text-slate-500">(' + escapeHtml(review.dayOfWeek) + ')</span>' : '';

    var moodTagsHtml = '';
    if (review.moodTags) {
        var tags = review.moodTags.split(',');
        moodTagsHtml = '<div class="mp_mood_tags_wrapper">';
        tags.forEach(function(t) {
            var clean = t.trim();
            if (clean) {
                moodTagsHtml += '<span class="mp_mood_tag">#' + escapeHtml(clean) + '</span>';
            }
        });
        moodTagsHtml += '</div>';
    }

    var imageHtml = '';
    if (review.mainImageUrl) {
        var mainImgSrc = review.mainImageUrl.startsWith('http') ? review.mainImageUrl : (ctx + review.mainImageUrl);
        imageHtml = '<div class="mp_review_main_image" style="margin: 12px 0; border-radius: 12px; overflow: hidden; max-height: 360px; background: #f1f5f9;">' +
                    '<img src="' + mainImgSrc + '" alt="대표 이미지" style="width: 100%; height: 100%; object-fit: cover; display: block;" onerror="this.parentElement.style.display=\'none\';">' +
                    '</div>';
    }

    var subReviewsHtml = '';
    if (review.subReviews && review.subReviews.length > 0) {
        subReviewsHtml = '<div class="mp_sub_reviews_container">' +
                         '<div class="mp_sub_reviews_header">' +
                         '<div class="mp_sub_reviews_title">' +
                         '<span class="material-symbols-outlined">layers</span>' +
                         '<span>이 날의 서브 리뷰 (' + review.subReviews.length + '개)</span>' +
                         '</div>' +
                         '<span class="mp_sub_reviews_caption font-mono">세부 평가 항목</span>' +
                         '</div>' +
                         '<div class="mp_sub_reviews_grid">';
        review.subReviews.forEach(function(sub) {
            var verifiedHtml = sub.isCertified === 'Y' 
                ? '<span class="material-symbols-outlined icon_verified">check_circle</span>' 
                : '';
            var catLabel = getCategoryLabel(sub.category);
            subReviewsHtml += '<div class="mp_sub_review_item" data-category="' + escapeHtml(sub.category || '') + '">' +
                              '<div class="mp_sub_item_left">' +
                              '<span class="mp_category_badge">' + escapeHtml(catLabel) + '</span>' +
                              '<span class="mp_sub_item_name">' + escapeHtml(sub.itemName || '') + '</span>' +
                              verifiedHtml +
                              '</div>' +
                              '<div class="mp_sub_item_right">' +
                              '<span class="material-symbols-outlined star_fill">star</span>' +
                              '<span class="font-mono font-bold">' + (sub.subRating != null ? sub.subRating : 0) + '</span>' +
                              '</div>' +
                              '</div>';
        });
        subReviewsHtml += '</div></div>';
    }

    var syncMap = getStoredReviewSyncMap();
    if (syncMap && syncMap[review.reviewId]) {
        var syncItem = syncMap[review.reviewId];
        if (typeof syncItem.liked === 'boolean') review.likedByMe = syncItem.liked;
        if (typeof syncItem.likeCount === 'number') review.likeCount = syncItem.likeCount;
        if (typeof syncItem.commentCount === 'number') review.commentCount = syncItem.commentCount;
    }

    var likedClass = review.likedByMe ? 'active' : '';
    var isLikedStr = review.likedByMe ? 'true' : 'false';
    var detailUrl = ctx + '/RE:DAY/review/detail/' + review.reviewId;

    return '<div class="mp_review_card" data-review-id="' + review.reviewId + '">' +
           '<div class="mp_review_header">' +
           '<div class="mp_review_author_info">' +
           '<div class="mp_author_avatar font-mono">' + avatarHtml + '</div>' +
           '<div class="mp_author_meta">' +
           '<div class="mp_author_name_row" style="display: flex; align-items: center; gap: 8px; flex-wrap: wrap;">' +
           '<span class="mp_author_name font-bold text-sm text-slate-900">' + nickname + '</span>' +
           levelBadgeHtml +
           streakBadgeHtml +
           '</div>' +
           '<div class="mp_review_date_row flex items-center gap-1.5 text-xs text-slate-500">' +
           '<span class="material-symbols-outlined text-[16px] text-slate-400">calendar_today</span>' +
           '<span class="font-mono font-medium">' + (review.reviewDate || '') + '</span>' +
           dayOfWeekHtml +
           todayBadgeHtml +
           '</div>' +
           '</div>' +
           '</div>' +
           '<div class="mp_review_score_box">' +
           '<span class="mp_score_title">오늘의 하루 평점</span>' +
           '<div class="mp_score_stars">' +
           '<span class="material-symbols-outlined star_fill">star</span>' +
           '<span class="font-mono font-bold">' + (review.totalRating != null ? review.totalRating : 0) + '</span>' +
           '</div>' +
           '</div>' +
           '</div>' +
           moodTagsHtml +
           '<p class="mp_review_summary">' + escapeHtml(review.overallComment || '') + '</p>' +
           imageHtml +
           subReviewsHtml +
           '<div class="mp_review_footer">' +
           '<div class="mp_interaction_group">' +
           '<button type="button" class="mp_action_btn like_btn ' + likedClass + '" data-review-id="' + review.reviewId + '" data-liked="' + isLikedStr + '">' +
           '<span class="material-symbols-outlined icon_heart">favorite</span>' +
           '<span class="font-mono like_count">' + (review.likeCount || 0) + '</span>' +
           '</button>' +
           '<span class="mp_action_info">' +
           '<span class="material-symbols-outlined">chat_bubble</span>' +
           '<span class="mp_comment_count">댓글 ' + (review.commentCount || 0) + '</span>' +
           '</span>' +
           '</div>' +
           '<div class="mp_detail_link" onclick="location.href=\'' + detailUrl + '\'" style="cursor: pointer;">' +
           '<span>상세 보기</span>' +
           '<span class="material-symbols-outlined">arrow_forward</span>' +
           '</div>' +
           '</div>' +
           '</div>';
}

/* 최근 7일 평점 통계 및 바 차트 비동기 렌더링 */
document.addEventListener("DOMContentLoaded", function() {
    fetch('/member/mypage/week-rate')
        .then(function(response) {
            return response.json();
        })
        .then(function(data) {
            if (!data || data.length === 0) return;

            var totalScoreSum = 0;
            var validDaysCount = 0;
            var bars = document.querySelectorAll('.chart_bars_container .bar_item');
            var weekDaysLabels = document.querySelectorAll('.week_days_label span');

            data.forEach(function(item, index) {
                if (index < bars.length) {
                    var rating = item.totalRating || 0.0;
                    var heightPercent = (rating / 5.0) * 100;

                    // 바 높이 및 점수 데이터 셋팅
                    bars[index].style.height = heightPercent + "%";
                    bars[index].setAttribute("data-score", rating.toFixed(1));

                    // 날짜 데이터를 요일로 변환하여 라벨 변경
                    if (item.reviewDate) {
                        var dateObj = new Date(item.reviewDate);
                        var dayNames = ['일', '월', '화', '수', '목', '금', '토'];
                        if (!isNaN(dateObj.getDay())) {
                            weekDaysLabels[index].textContent = dayNames[dateObj.getDay()];
                        }
                    }

                    totalScoreSum += rating;
                    validDaysCount++;
                }
            });

            // 이번 주 평균 점수 계산 후 화면에 반영
			// 평균 점수 반영
			var averageScore = validDaysCount > 0 ? (totalScoreSum / validDaysCount).toFixed(1) : "0.0";
			var scoreMainEl = document.querySelector('.score_main');
			if (scoreMainEl) {
			    scoreMainEl.textContent = averageScore;
			}

			// 만점 고정 또는 동적 처리 (5점 만점이므로 " / 5.0"으로 세팅)
			var scoreTotalEl = document.querySelector('.score_total');
			if (scoreTotalEl) {
			    scoreTotalEl.textContent = " / 5.0";
			}

			// 서브 리뷰 개수나 증감 수치가 데이터에 있다면 여기서 함께 렌더링 가능
        })
        .catch(function(error) {
            console.error('통계 데이터를 불러오는 중 오류 발생:', error);
        });
});

/**
 * =========================================================================
 * 메인 피드 ↔ 상세 페이지 상태 실시간 동기화 (BFCache / 뒤로가기 / 탭 전환 완벽 대응)
 * =========================================================================
 */

/**
 * 세션/로컬 스토리지에서 최신 리뷰 상태 맵 조회
 */
function getStoredReviewSyncMap() {
    try {
        var str = sessionStorage.getItem('reday_review_sync_map') || localStorage.getItem('reday_review_sync_map');
        return str ? JSON.parse(str) : {};
    } catch (e) {
        return {};
    }
}

/**
 * 특정 리뷰 상태를 세션/로컬 스토리지에 동기화 저장
 */
function saveReviewSyncState(reviewId, liked, likeCount, commentCount) {
    try {
        var map = getStoredReviewSyncMap();
        var existing = map[reviewId] || {};
        map[reviewId] = {
            reviewId: reviewId,
            liked: (typeof liked === 'boolean') ? liked : existing.liked,
            likeCount: (typeof likeCount === 'number') ? likeCount : existing.likeCount,
            commentCount: (typeof commentCount === 'number') ? commentCount : existing.commentCount,
            updatedAt: Date.now()
        };
        var str = JSON.stringify(map);
        sessionStorage.setItem('reday_review_sync_map', str);
        localStorage.setItem('reday_review_sync_map', str);
    } catch (e) {}
}

/**
 * 상세 페이지 등에서 변경된 최신 좋아요/댓글 상태를 메인 피드의 모든 카드에 동기화 반영
 */
function syncReviewStatesFromSession() {
    try {
        var map = getStoredReviewSyncMap();
        if (!map || typeof map !== 'object') return;

        Object.keys(map).forEach(function(reviewIdStr) {
            var item = map[reviewIdStr];
            if (!item || !item.reviewId) return;

            var likeButtons = document.querySelectorAll('.like_btn[data-review-id="' + item.reviewId + '"]');
            likeButtons.forEach(function(btn) {
                // 1. 좋아요 활성화/비활성화 상태 및 클래스 동기화
                if (typeof item.liked === 'boolean') {
                    btn.setAttribute('data-liked', item.liked ? 'true' : 'false');
                    if (item.liked) {
                        btn.classList.add('active');
                    } else {
                        btn.classList.remove('active');
                    }
                }

                // 2. 좋아요 개수 동기화
                if (typeof item.likeCount === 'number') {
                    var countSpan = btn.querySelector('.like_count');
                    if (countSpan) {
                        countSpan.textContent = item.likeCount;
                    }
                }

                // 3. 댓글 개수 동기화
                if (typeof item.commentCount === 'number') {
                    var card = btn.closest('.mp_review_card');
                    if (card) {
                        var commentSpan = card.querySelector('.mp_comment_count');
                        if (commentSpan) {
                            commentSpan.textContent = '댓글 ' + item.commentCount;
                        }
                    }
                }
            });
        });
    } catch (e) {
        console.warn('Failed to sync review states from storage', e);
    }
}

// 1. DOM 로드 시 동기화
document.addEventListener("DOMContentLoaded", function() {
    syncReviewStatesFromSession();
});

// 2. 브라우저 뒤로가기(BFCache) 및 페이지 복원 시 즉시 동기화
window.addEventListener('pageshow', function() {
    syncReviewStatesFromSession();
});

// 3. 탭 전환 또는 창 다시 활성화 시 동기화
document.addEventListener('visibilitychange', function() {
    if (document.visibilityState === 'visible') {
        syncReviewStatesFromSession();
    }
});

// 4. 다른 탭이나 창에서 좋아요 변경 시 실시간 동기화
window.addEventListener('storage', function(e) {
    if (e.key === 'reday_review_sync_map') {
        syncReviewStatesFromSession();
    }
});