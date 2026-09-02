/**
 * 
 */
/*필터 바 분류 버튼 기능*/
document.addEventListener("DOMContentLoaded", function() {
    var filterButton = document.querySelectorAll('.filter_button button');

    filterButton.forEach(function(button) {
        button.addEventListener('click', function() {
            filterButton.forEach(function(btn) {
                btn.classList.remove('active');
            });
            this.classList.add('active');
        });
    });
});

/*카테고리분류 필터바*/
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

/*리뷰쓰기 이동버튼*/
document.addEventListener("DOMContentLoaded", function() {
    var writeBtn = document.getElementById('mp_review_write');
    if (writeBtn) {
        writeBtn.addEventListener('click', function() {
            location.href = "/RE:DAY/review/write";
        });
    }
});

/*좋아요 기능*/
document.addEventListener("DOMContentLoaded", function() {
    var likeButtons = document.querySelectorAll(".like_btn");

    likeButtons.forEach(function(button) {
        button.addEventListener("click", function() {
            var reviewId = button.getAttribute("data-review-id");
            var isLiked = button.getAttribute("data-liked") === "true";
            var countSpan = button.querySelector(".like_count");
            var currentCount = parseInt(countSpan.textContent, 10);

            // 임시 사용자 ID (로그인한 세션 정보나 전역 변수에서 가져오도록 수정 필요)
            var userId = "testUser"; 

            var url = "/RE:DAY/like";
            var method = isLiked ? "DELETE" : "POST";

            fetch(url, {
                method: method,
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({ userId: userId, reviewId: parseInt(reviewId, 10) })
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
                        // 좋아요 취소 성공
                        button.setAttribute("data-liked", "false");
                        button.classList.remove("active");
                        countSpan.textContent = currentCount - 1;
                    } else {
                        // 좋아요 등록 성공
                        button.setAttribute("data-liked", "true");
                        button.classList.add("active");
                        countSpan.textContent = currentCount + 1;
                    }
                } else {
                    alert("처리 실패: " + (result.message || "오류가 발생했어."));
                }
            })
            .catch(function(error) {
                console.error("통신 오류:", error);
            });
        });
    });
});

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