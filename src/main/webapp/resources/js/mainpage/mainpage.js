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