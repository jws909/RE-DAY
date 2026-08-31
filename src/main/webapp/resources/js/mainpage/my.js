/**
 * 
 */

function switchTab(tab) {
    const dailyTab = document.getElementById('tabBtn-daily');
    const subTab = document.getElementById('tabBtn-subreviews');
    const dailyContent = document.getElementById('tabContent-daily');
    const subContent = document.getElementById('tabContent-subreviews');

    if (tab === 'daily') {
        dailyTab.classList.add('active');
        subTab.classList.remove('active');
        dailyContent.style.display = 'grid';
        subContent.style.display = 'none';
    } else {
        subTab.classList.add('active');
        dailyTab.classList.remove('active');
        dailyContent.style.display = 'none';
        subContent.style.display = 'grid';
    }
}
document.addEventListener("DOMContentLoaded", function() {
    document.querySelector('.my_review_write').addEventListener('click', () => {
        location.href = "/RE:DAY/review/write";
    })
});