/**
 * 큐레이션 카테고리 필터 함수
 * @param {string} category - 필터링할 카테고리 식별값
 * @param {HTMLElement} [clickedTab] - 클릭된 버튼 요소 
 */
function filterCuration(category, clickedTab) {
    // 탭 활성화 상태 변경
    const allTabs = document.querySelectorAll('.ex_curation_tab');
    allTabs.forEach(tab => tab.classList.remove('active'));

    const targetTab = clickedTab || document.getElementById('tab-' + category);
    if (targetTab) {
        targetTab.classList.add('active');
    }

    //  큐레이션 카드 노출/숨김 처리
    const allCards = document.querySelectorAll('.ex_curation_card');
    allCards.forEach(card => {
        const itemCategory = card.getAttribute('data-category');
        if (category === 'all' || itemCategory === category) {
            card.style.display = 'flex';
        } else {
            card.style.display = 'none';
        }
    });
}

// 테마 필터 및 스트릭 응원 버튼 이벤트 바인딩
document.addEventListener('DOMContentLoaded', () => {
    //  상단 라이프스타일 테마 버튼 클릭 시 활성화 토글
    const themeButtons = document.querySelectorAll('.ex_theme_btn');
    themeButtons.forEach(btn => {
        btn.addEventListener('click', function() {
            themeButtons.forEach(b => b.classList.remove('active'));
            this.classList.add('active');
        }
        );
    });
}
);