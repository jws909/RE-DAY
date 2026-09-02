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


/*통계표*/
document.addEventListener("DOMContentLoaded", () => {
    fetch('/RE:DAY/member/my')
        .then(response => response.json())
        .then(result => {
            if (result.success) {
                const stats = result.data;
                
                setStat('dailyCount', stats.dailyCount);
                setStat('avgTotalRating', stats.avgTotalRating);
                setStat('subCount', stats.subCount);
                setStat('certifiedRate', stats.certifiedRate);
            } else {
                alert(result.message);
                if (result.message.includes("로그인")) {
                    location.href = "/login";
                }
            }
        })
        .catch(error => {
            console.error("통신 실패:", error);
        });
});

const setStat = (key, value) => {
    const el = document.querySelector(`[data-stat="${key}"]`);
    if (!el) return;

    let displayValue = (value !== null && value !== undefined) ? value : 0;

    if ((key === 'avgTotalRating' || key === 'certifiedRate') && typeof displayValue === 'number') {
        displayValue = displayValue.toFixed(1);
    }

    el.textContent = displayValue;
};