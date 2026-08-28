/**
 * 
 */
/*필터 바 분류 버튼 기능*/
document.addEventListener("DOMContentLoaded", function () {
    const filterButton = document.querySelectorAll('.filter_button button');

    filterButton.forEach(button => {
        button.addEventListener('click', function () {
            filterButton.forEach(btn => btn.classList.remove('active'));
            
            this.classList.add('active');
        });
    });
});

document.addEventListener("DOMContentLoaded", function () {
    const mp_sub_review_category_filter = document.querySelectorAll('.sub_review_category_filter_card');

    mp_sub_review_category_filter.forEach(button => {
        button.addEventListener('click', function () {
            mp_sub_review_category_filter.forEach(btn => btn.classList.remove('active'));
            
            this.classList.add('active');
        });
    });
});

document.addEventListener("DOMContentLoaded", function (){
	const review_create_button = document.querySelectorAll('.mp_top_right_column button');
	const create_main_review = document.querySelector('.main_review_container');
	
	review_create_button.forEach(button => {
		button.addEventListener('click', function () {
			 create_main_review.insertAdjacentHTML('afterbegin', `
				<div class="mp_review_card">
									<div class="mp_review_header">
										<div class="mp_review_author_info">
											<div class="mp_author_avatar font-mono"></div>
											<div class="mp_author_meta">
												<div class="mp_author_name_row">
													<span class="mp_author_name">승북이</span> <span
														class="mp_author_level font-mono">lv.100 집에 얼른 가고 싶은 군산 출신 막내 팀장
														</span> <span class="mp_author_badge">5</span>
												</div>
												<div class="mp_review_date_row">
													<span class="material-symbols-outlined">calendar_today</span> <span
														class="font-mono">2026-09-08</span> <span
														class="mp_today_badge font-mono">TODAY</span>
												</div>
											</div>
										</div>

										<div class="mp_review_score_box">
											<span class="mp_score_title">오늘의 하루 평점</span>
											<div class="mp_score_stars">
												<span class="material-symbols-outlined star_fill">star</span> <span
													class="font-mono font-bold">5</span>
											</div>
										</div>
									</div>
									<div class="mp_mood_tags_wrapper">
										<span class="mp_mood_tag">피곤함</span>
									</div>
									<p class="mp_review_summary">집 가고 싶다~!!! 집 가고 싶다~!!!집 가고
										싶다~!!!집 가고 싶다~!!!집 가고 싶다~!!!</p>

									<div class="mp_review_image_placeholder">
										<span class="material-symbols-outlined">image</span>
										<p class="placeholder_title">'[오늘 하루 대표 이미지 영역]' :</p>
										<span class="placeholder_sub">일기 대표 컷 / 장소 뷰 / 하이라이트 사진</span>
									</div>

									<!-- 서브 리뷰 목록 리본 -->
									<div class="mp_sub_reviews_container">
										<div class="mp_sub_reviews_header">
											<div class="mp_sub_reviews_title">
												<span class="material-symbols-outlined">layers</span> <span>이
													날의 서브 리뷰 (n개)</span>
											</div>
											<span class="mp_sub_reviews_caption font-mono">세부 평가 항목</span>
										</div>

										<div class="mp_sub_reviews_grid">
											<div class="mp_sub_review_item">
												<div class="mp_sub_item_left">
													<span class="mp_category_badge">카테고리 뱃지</span> <span
														class="mp_sub_item_name">그냥 사람1</span> <span
														class="material-symbols-outlined icon_verified">check_circle</span>
												</div>
												<div class="mp_sub_item_right">
													<span class="material-symbols-outlined star_fill">star</span> <span
														class="font-mono font-bold">5</span>
												</div>
											</div>
										</div>
									</div>
									<div class="mp_review_footer">
										<div class="mp_interaction_group">
											<button type="button" class="mp_action_btn">
												<span class="material-symbols-outlined icon_heart">favorite</span>
												<span class="font-mono">100</span>
											</button>
											<span class="mp_action_info"> <span
												class="material-symbols-outlined">chat_bubble</span> <span>댓글
													100</span>
											</span>
										</div>
										<div class="mp_detail_link">
											<span>상세 보기</span> <span class="material-symbols-outlined">arrow_forward</span>
										</div>
									</div>
								</div>` )
		});
	});
});