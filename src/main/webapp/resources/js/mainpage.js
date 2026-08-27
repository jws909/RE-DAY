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