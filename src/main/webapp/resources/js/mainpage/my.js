/**
 * MY 페이지
 *
 * 기능
 * 1. MY 페이지 탭 전환
 * 2. 서브 리뷰 카테고리 필터
 * 3. 기록 검색
 * 4. 기록 정렬
 * 5. 오늘 하루 쓰기 페이지 이동
 */
document.addEventListener("DOMContentLoaded", function() {

    /* =========================================
       MY 페이지 탭 요소
    ========================================= */

    const tabs =
        document.querySelectorAll(".my_curation_tab");

    const dailyContent =
        document.getElementById("tabContent-daily");

    const subreviewsContent =
        document.getElementById("tabContent-subreviews");

    const likesContent =
        document.getElementById("tabContent-likes");


    /* =========================================
       서브 리뷰 카테고리 필터 요소
    ========================================= */

    const subCategoryFilter =
        document.getElementById("mySubCategoryFilter");

    const categoryButtons =
        document.querySelectorAll(".my_sub_category_btn");

    /*
     * 현재 선택된 서브 리뷰 카테고리
     *
     * all       : 전체
     * place     : 장소 / 식당
     * item      : 아이템 / 장비
     * transport : 이동수단 / 차량
     * content   : 미디어 / 콘텐츠
     */
    let selectedCategory = "all";


    /* =========================================
       검색 / 정렬 요소
    ========================================= */

    const searchInput =
        document.getElementById("mySearchInput");

    const sortSelect =
        document.getElementById("mySortSelect");


    /* =========================================
       현재 선택된 탭 컨텐츠 찾기
    ========================================= */

    function getActiveContent() {

        if (
            dailyContent
            && dailyContent.style.display !== "none"
        ) {
            return dailyContent;
        }

        if (
            subreviewsContent
            && subreviewsContent.style.display !== "none"
        ) {
            return subreviewsContent;
        }

        if (
            likesContent
            && likesContent.style.display !== "none"
        ) {
            return likesContent;
        }

        return null;
    }


    /* =========================================
       서브 리뷰 카드의 카테고리 값 가져오기
    ========================================= */

    function getSubReviewCategory(card) {

        /*
         * 현재 JSP의 서브 리뷰 카드 안에는
         * .my_card_category에 한글 카테고리가 표시된다.
         *
         * 장소     → place
         * 아이템   → item
         * 이동수단 → transport
         * 콘텐츠   → content
         */
        const categoryElement =
            card.querySelector(".my_card_category");

        if (!categoryElement) {
            return "";
        }

        const categoryText =
            categoryElement.textContent.trim();

        if (categoryText === "장소") {
            return "place";
        }

        if (categoryText === "아이템") {
            return "item";
        }

        if (categoryText === "이동수단") {
            return "transport";
        }

        if (categoryText === "콘텐츠") {
            return "content";
        }

        return "";
    }


    /* =========================================
       MY 페이지 기록 필터 적용
       
       검색 조건 + 카테고리 조건을
       한 번에 적용한다.
    ========================================= */

    function applyFilters() {

        const activeContent =
            getActiveContent();

        if (!activeContent) {
            return;
        }


        /* 검색어 */
        const keyword =
            searchInput
                ? searchInput.value
                    .trim()
                    .toLowerCase()
                : "";


        /*
         * 현재 탭 안의 리뷰 카드
         *
         * 데일리 / 좋아요 리뷰 : .my_daily_card
         * 서브 리뷰           : .my_card
         */
        const cards =
            activeContent.querySelectorAll(
                ".my_daily_card, .my_card"
            );


        cards.forEach(function(card) {

            /* =========================================
               1. 검색 조건 확인
            ========================================= */

            const cardText =
                card.innerText.toLowerCase();

            const matchesSearch =
                keyword === ""
                || cardText.includes(keyword);


            /* =========================================
               2. 카테고리 조건 확인
               
               카테고리 필터는
               서브 리뷰 탭에서만 적용
            ========================================= */

            let matchesCategory = true;

            if (activeContent === subreviewsContent) {

                const cardCategory =
                    getSubReviewCategory(card);

                matchesCategory =
                    selectedCategory === "all"
                    || cardCategory === selectedCategory;
            }


            /* =========================================
               검색 + 카테고리 모두 만족하면 표시
            ========================================= */

            if (
                matchesSearch
                && matchesCategory
            ) {
                card.style.display = "";
            } else {
                card.style.display = "none";
            }

        });
    }


    /* =========================================
       MY 페이지 기록 검색
    ========================================= */

    function applySearch() {

        /*
         * 실제 검색 처리는 applyFilters()에서
         * 카테고리 조건과 함께 처리한다.
         */
        applyFilters();
    }


    /* =========================================
       MY 페이지 기록 정렬
    ========================================= */

    function applySort() {

        /* 정렬창이 없는 경우 종료 */
        if (!sortSelect) {
            return;
        }

        const activeContent =
            getActiveContent();

        /* 현재 보이는 탭이 없는 경우 종료 */
        if (!activeContent) {
            return;
        }

        const sortType =
            sortSelect.value;


        /*
         * 현재 탭의 리뷰 카드 목록
         */
        const cards =
            Array.from(
                activeContent.querySelectorAll(
                    ".my_daily_card, .my_card"
                )
            );


        cards.sort(function(a, b) {

            /* =========================================
               카드 날짜 가져오기
            ========================================= */

            const dateAElement =
                a.querySelector(
                    ".my_daily_date, .my_card_date"
                );

            const dateBElement =
                b.querySelector(
                    ".my_daily_date, .my_card_date"
                );


            const dateA =
                dateAElement
                    ? new Date(
                        dateAElement.textContent.trim()
                    )
                    : new Date(0);

            const dateB =
                dateBElement
                    ? new Date(
                        dateBElement.textContent.trim()
                    )
                    : new Date(0);


            /* =========================================
               카드 평점 가져오기
            ========================================= */

            const ratingAElement =
                a.querySelector(
                    ".my_daily_rating, .my_card_rating"
                );

            const ratingBElement =
                b.querySelector(
                    ".my_daily_rating, .my_card_rating"
                );


            const ratingA =
                ratingAElement
                    ? parseFloat(
                        ratingAElement.textContent
                            .replace("★", "")
                            .trim()
                    )
                    : 0;

            const ratingB =
                ratingBElement
                    ? parseFloat(
                        ratingBElement.textContent
                            .replace("★", "")
                            .trim()
                    )
                    : 0;


            /* =========================================
               선택한 정렬 방식 적용
            ========================================= */

            /* 최신순 */
            if (sortType === "latest") {
                return dateB - dateA;
            }

            /* 오래된순 */
            if (sortType === "oldest") {
                return dateA - dateB;
            }

            /* 평점 높은순 */
            if (sortType === "ratingHigh") {
                return ratingB - ratingA;
            }

            /* 평점 낮은순 */
            if (sortType === "ratingLow") {
                return ratingA - ratingB;
            }

            return 0;
        });


        /*
         * 정렬된 카드 순서대로
         * 현재 탭 안에 다시 배치
         */
        cards.forEach(function(card) {
            activeContent.appendChild(card);
        });
    }


    /* =========================================
       서브 리뷰 카테고리 버튼 클릭
    ========================================= */

    categoryButtons.forEach(function(button) {

        button.addEventListener(
            "click",
            function() {

                /* 클릭한 카테고리 값 저장 */
                selectedCategory =
                    this.dataset.category;


                /* 모든 카테고리 버튼 active 제거 */
                categoryButtons.forEach(
                    function(item) {
                        item.classList.remove("active");
                    }
                );


                /* 클릭한 카테고리 버튼 active */
                this.classList.add("active");


                /*
                 * 검색 조건도 함께 유지하면서
                 * 카테고리 필터 다시 적용
                 */
                applyFilters();
            }
        );

    });


    /* =========================================
       MY 페이지 탭 클릭
    ========================================= */

    tabs.forEach(function(tab) {

        tab.addEventListener(
            "click",
            function() {

                const selectedTab =
                    this.dataset.tab;


                /* =========================================
                   모든 탭 active 제거
                ========================================= */

                tabs.forEach(function(item) {
                    item.classList.remove("active");
                });


                /* 클릭한 탭 active */
                this.classList.add("active");


                /* =========================================
                   모든 컨텐츠 숨기기
                ========================================= */

                if (dailyContent) {
                    dailyContent.style.display = "none";
                }

                if (subreviewsContent) {
                    subreviewsContent.style.display = "none";
                }

                if (likesContent) {
                    likesContent.style.display = "none";
                }


                /* =========================================
                   카테고리 필터 기본 숨김
                ========================================= */

                if (subCategoryFilter) {
                    subCategoryFilter.style.display = "none";
                }


                /* =========================================
                   선택한 컨텐츠만 표시
                ========================================= */

                /* 내 데일리 기록 */
                if (selectedTab === "daily") {

                    if (dailyContent) {
                        dailyContent.style.display = "grid";
                    }

                }


                /* 내 서브 리뷰 모아보기 */
                else if (selectedTab === "subreviews") {

                    if (subreviewsContent) {
                        subreviewsContent.style.display = "grid";
                    }

                    /*
                     * 서브 리뷰 탭에서만
                     * 카테고리 필터 표시
                     */
                    if (subCategoryFilter) {
                        subCategoryFilter.style.display = "flex";
                    }

                }


                /* 좋아요한 리뷰 */
                else if (selectedTab === "likes") {

                    if (likesContent) {
                        likesContent.style.display = "grid";
                    }

                }


                /*
                 * 탭을 바꿔도
                 * 현재 정렬 / 검색 조건 유지
                 */
                applySort();
                applyFilters();

            }
        );

    });


    /* =========================================
       검색창 입력 이벤트
    ========================================= */

    if (searchInput) {

        searchInput.addEventListener(
            "input",
            function() {
                applySearch();
            }
        );

    }


    /* =========================================
       정렬 선택 이벤트
    ========================================= */

    if (sortSelect) {

        sortSelect.addEventListener(
            "change",
            function() {

                applySort();

                /*
                 * 정렬 후에도
                 * 검색 / 카테고리 조건 유지
                 */
                applyFilters();

            }
        );

    }


    /* =========================================
       오늘 하루 쓰기
    ========================================= */

    const reviewWriteButton =
        document.querySelector(".my_review_write");


    if (reviewWriteButton) {

        reviewWriteButton.addEventListener(
            "click",
            function() {

                location.href =
                    "/RE:DAY/review/write";

            }
        );

    }

});