/**
 * RE:DAY - mainpage.js
 */

// 전역 contextPath 안전 참조
var ctx = (typeof contextPath !== 'undefined') ? contextPath : '';

/* 필터 바 정렬 버튼 기능 */
document.addEventListener("DOMContentLoaded", function() {
    var filterButtons = document.querySelectorAll('.filter_button button');

    filterButtons.forEach(function(button) {
        button.addEventListener('click', function() {
            var sortType = this.getAttribute('data-sort');
            if (!sortType) {
                sortType = (this.textContent.indexOf('평점') !== -1) ? 'rating' : 'latest';
            }
            location.href = ctx + '/RE:DAY/mainpage?sort=' + encodeURIComponent(sortType);
        });
    });
});

/* 카테고리분류 필터바 (기존 유지) */
document.addEventListener("DOMContentLoaded", function() {
    var mpSubReviewCategoryFilter = document.querySelectorAll('.sub_review_category_filter_card');

    mpSubReviewCategoryFilter.forEach(function(button) {
        button.addEventListener('click', function() {
            mpSubReviewCategoryFilter.forEach(function(btn) {
                btn.classList.remove('active');
            });
            this.classList.add('active');
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
                // UI 상태 반전 (토글)
                isLiked = !isLiked;
                button.setAttribute("data-liked", isLiked ? "true" : "false");
                if (isLiked) {
                    button.classList.add("active");
                    if (countSpan) countSpan.textContent = currentCount + 1;
                } else {
                    button.classList.remove("active");
                    if (countSpan) countSpan.textContent = Math.max(0, currentCount - 1);
                }
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

    var currentPage = parseInt(container.getAttribute('data-page') || '1', 10);
    var currentSort = container.getAttribute('data-sort') || 'latest';
    var nextPage = currentPage + 1;

    btnLoadMore.disabled = true;
    btnLoadMore.innerHTML = '<span class="material-symbols-outlined" style="font-size: 18px;">sync</span> <span>로딩 중...</span>';

    var feedUrl = ctx + '/RE:DAY/feed?page=' + nextPage + '&size=5&sort=' + encodeURIComponent(currentSort);

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
                        var cardHtml = buildReviewCardHtml(rev);
                        container.insertAdjacentHTML('beforeend', cardHtml);
                    });
                    container.setAttribute('data-page', nextPage);
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
            btnLoadMore.innerHTML = '<span class="material-symbols-outlined" style="font-size: 18px;">expand_more</span> <span>리뷰 더보기 (+5개)</span>';
        });
};

document.addEventListener("DOMContentLoaded", function() {
    var btnLoadMore = document.getElementById('btnLoadMore');
    if (btnLoadMore) {
        btnLoadMore.addEventListener('click', window.loadMoreReviews);
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

function getLevelBadgeHtml(rawLevel) {
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

function buildReviewCardHtml(review) {
    var avatarSrc = review.authorProfileImg 
        ? (review.authorProfileImg.startsWith('http') ? review.authorProfileImg : (ctx + review.authorProfileImg))
        : '';
    var avatarHtml = avatarSrc 
        ? '<img src="' + avatarSrc + '" alt="프로필" style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%;" onerror="this.style.display=\'none\';">'
        : '<span class="material-symbols-outlined" style="font-size: 20px; color: #64748B;">person</span>';

    var nickname = escapeHtml(review.authorNickname || '익명');
    var levelBadgeHtml = getLevelBadgeHtml(review.authorLevel);
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
            subReviewsHtml += '<div class="mp_sub_review_item">' +
                              '<div class="mp_sub_item_left">' +
                              '<span class="mp_category_badge">' + escapeHtml(sub.category || '') + '</span>' +
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
           '<span>댓글 ' + (review.commentCount || 0) + '</span>' +
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