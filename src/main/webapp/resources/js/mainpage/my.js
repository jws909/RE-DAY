/**
 * MY 페이지
 * 탭 전환 + 오늘 하루 쓰기 이동
 */

document.addEventListener("DOMContentLoaded", function() {

    /* =========================
    MY 페이지 탭 전환
    ========================= */

    const tabs = document.querySelectorAll(".my_curation_tab");

    const dailyContent =
        document.getElementById("tabContent-daily");

    const subreviewsContent =
        document.getElementById("tabContent-subreviews");

    const likesContent =
        document.getElementById("tabContent-likes");


    tabs.forEach(function(tab) {

        tab.addEventListener("click", function() {

            const selectedTab =
                this.dataset.tab;


            /* 모든 탭 active 제거 */
            tabs.forEach(function(item) {
                item.classList.remove("active");
            });


            /* 클릭한 탭 active */
            this.classList.add("active");


            /* 모든 컨텐츠 숨기기 */
            dailyContent.style.display = "none";

            subreviewsContent.style.display = "none";

            likesContent.style.display = "none";


            /* 선택한 컨텐츠만 표시 */
            if (selectedTab === "daily") {

                dailyContent.style.display = "grid";

            } else if (selectedTab === "subreviews") {

                subreviewsContent.style.display = "grid";

            } else if (selectedTab === "likes") {

                likesContent.style.display = "grid";

            }

        });

    });


    /* =========================
    오늘 하루 쓰기
    ========================= */

    const reviewWriteButton =
        document.querySelector(".my_review_write");

    if (reviewWriteButton) {

        reviewWriteButton.addEventListener(
            "click",
            function() {

                location.href = "/RE:DAY/review/write";

            }
        );

    }

});
    document.querySelector('.my_review_write').addEventListener('click', () => {
        location.href = "/RE:DAY/review/write";
    })



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
