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

/* 좋아요 기능 (이벤트 위임 - 동적 추가 카드 완벽 지원) */
document.addEventListener("DOMContentLoaded", function() {
    document.addEventListener("click", function(e) {
        var button = e.target.closest(".like_btn");
        if (!button) return;

        var reviewId = button.getAttribute("data-review-id");
        var isLiked = button.getAttribute("data-liked") === "true";
        var countSpan = button.querySelector(".like_count");
        var currentCount = parseInt(countSpan ? countSpan.textContent : "0", 10) || 0;

        var url = ctx + "/RE:DAY/like";
        var method = isLiked ? "DELETE" : "POST";

        fetch(url, {
            method: method,
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({ reviewId: parseInt(reviewId, 10) })
        })
        .then(function(response) {
            return response.json().then(function(result) {
                return { ok: response.ok, result: result };
            });
        })
        .then(function(data) {
            var responseOk = data.ok;
            var result = data.result;

            if (responseOk && result.success) {
                if (isLiked) {
                    button.setAttribute("data-liked", "false");
                    button.classList.remove("active");
                    if (countSpan) countSpan.textContent = Math.max(0, currentCount - 1);
                } else {
                    button.setAttribute("data-liked", "true");
                    button.classList.add("active");
                    if (countSpan) countSpan.textContent = currentCount + 1;
                }
            } else {
                if (result.message && result.message.indexOf("로그인") !== -1) {
                    if (confirm("로그인이 필요한 기능입니다. 로그인 페이지로 이동하시겠습니까?")) {
                        location.href = ctx + "/member/signin";
                    }
                } else {
                    alert("처리 실패: " + (result.message || "오류가 발생했습니다."));
                }
            }
        })
        .catch(function(error) {
            console.error("통신 오류:", error);
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

function buildReviewCardHtml(review) {
    var avatarSrc = review.authorProfileImg 
        ? (review.authorProfileImg.startsWith('http') ? review.authorProfileImg : (ctx + review.authorProfileImg))
        : '';
    var avatarHtml = avatarSrc 
        ? '<img src="' + avatarSrc + '" alt="프로필" style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%;" onerror="this.style.display=\'none\';">'
        : '<span class="material-symbols-outlined" style="font-size: 20px; color: #64748B;">person</span>';

    var nickname = escapeHtml(review.authorNickname || '익명');
    var level = escapeHtml(review.authorLevel || 'lv.1 초보 기록러');
    var badgeHtml = (review.authorStreakCount && review.authorStreakCount > 0) 
        ? '<span class="mp_author_badge font-mono">' + review.authorStreakCount + '</span>' 
        : '';

    var todayBadgeHtml = '';
    var todayStr = new Date().toISOString().substring(0, 10);
    if (review.reviewDate === todayStr) {
        todayBadgeHtml = '<span class="mp_today_badge font-mono">TODAY</span>';
    }

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
           '<div class="mp_author_name_row">' +
           '<span class="mp_author_name">' + nickname + '</span>' +
           '<span class="mp_author_level font-mono">' + level + '</span>' +
           badgeHtml +
           '</div>' +
           '<div class="mp_review_date_row">' +
           '<span class="material-symbols-outlined">calendar_today</span>' +
           '<span class="font-mono">' + (review.reviewDate || '') + '</span>' +
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