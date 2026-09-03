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

        if (typeof updateSelectionSummary === "function") {
            updateSelectionSummary();
        }
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

                const dailySelectionBar = document.getElementById("myDailySelectionBar");

                /* 내 데일리 기록 */
                if (selectedTab === "daily") {

                    if (dailyContent) {
                        dailyContent.style.display = "grid";
                    }

                    if (dailySelectionBar) {
                        dailySelectionBar.style.display = "flex";
                    }

                }


                /* 내 서브 리뷰 모아보기 */
                else if (selectedTab === "subreviews") {

                    if (subreviewsContent) {
                        subreviewsContent.style.display = "grid";
                    }

                    if (dailySelectionBar) {
                        dailySelectionBar.style.display = "none";
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

                    if (dailySelectionBar) {
                        dailySelectionBar.style.display = "none";
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


    /* ==========================================================================
       MY 페이지 - 데일리 리뷰 선택 및 공개 / 비공개 (is_public) 설정 처리
       ========================================================================== */

    const basePath = window.location.pathname.startsWith("/RE:DAY") ? "/RE:DAY" : "";

    /* --------------------------------------------------------------------------
       1. 개별 토글 버튼 UI 갱신 헬퍼
       -------------------------------------------------------------------------- */
    function updateDailyBtnUI(btn, isPublic) {
        btn.dataset.isPublic = isPublic;
        const icon = btn.querySelector(".public_icon");
        const label = btn.querySelector(".public_label");

        if (isPublic === "Y") {
            btn.classList.remove("is_private");
            btn.classList.add("is_public");
            if (icon) icon.textContent = "public";
            if (label) label.textContent = "공개";
        } else {
            btn.classList.remove("is_public");
            btn.classList.add("is_private");
            if (icon) icon.textContent = "lock";
            if (label) label.textContent = "비공개";
        }
    }

    /* --------------------------------------------------------------------------
       2. 개별 데일리 리뷰 1건 공개/비공개 토글 (원클릭)
       -------------------------------------------------------------------------- */
    document.addEventListener("click", function(e) {
        const toggleBtn = e.target.closest(".my_public_toggle_btn");
        if (!toggleBtn) return;

        const reviewId = toggleBtn.dataset.reviewId;
        const currentIsPublic = toggleBtn.dataset.isPublic || "Y";
        const nextIsPublic = (currentIsPublic === "Y") ? "N" : "Y";
        const stateText = (nextIsPublic === "Y") ? "공개" : "비공개";

        if (!confirm("이 데일리 리뷰를 '" + stateText + "' 상태로 변경하시겠습니까?")) {
            return;
        }

        toggleBtn.disabled = true;

        const params = new URLSearchParams();
        params.append("reviewId", reviewId);
        params.append("isPublic", nextIsPublic);

        fetch(basePath + "/review/public/daily", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
            },
            body: params.toString()
        })
        .then(function(res) {
            return res.json();
        })
        .then(function(result) {
            toggleBtn.disabled = false;
            if (result.success) {
                updateDailyBtnUI(toggleBtn, nextIsPublic);
            } else {
                alert(result.message || "데일리 리뷰 공개 설정 변경에 실패했습니다.");
            }
        })
        .catch(function(err) {
            toggleBtn.disabled = false;
            console.error("데일리 리뷰 공개 토글 오류:", err);
            alert("서버 통신 중 오류가 발생했습니다.");
        });
    });

    /* --------------------------------------------------------------------------
       3. 체크박스 선택 (단일/전체) 및 상태 관리
       -------------------------------------------------------------------------- */
    const selectAllDailyCheckbox = document.getElementById("mySelectAllDaily");
    const selectedCountSpan = document.getElementById("mySelectedCount");
    const btnSelectedPublic = document.getElementById("btnSelectedPublic");
    const btnSelectedPrivate = document.getElementById("btnSelectedPrivate");
    const btnAllPublic = document.getElementById("btnAllPublic");
    const btnAllPrivate = document.getElementById("btnAllPrivate");

    function getVisibleDailyCheckboxes() {
        const dailyTab = document.getElementById("tabContent-daily");
        if (!dailyTab) return [];
        // 화면에 보이는(검색/필터에 의해 숨겨지지 않은) 카드의 체크박스만 대상
        const cards = Array.from(dailyTab.querySelectorAll(".my_daily_card"));
        return cards
            .filter(card => card.style.display !== "none")
            .map(card => card.querySelector(".my_daily_checkbox"))
            .filter(Boolean);
    }

    function updateSelectionSummary() {
        const checkboxes = getVisibleDailyCheckboxes();
        const checkedList = checkboxes.filter(cb => cb.checked);
        const count = checkedList.length;

        if (selectedCountSpan) {
            selectedCountSpan.textContent = count;
        }

        const hasSelected = count > 0;
        if (btnSelectedPublic) btnSelectedPublic.disabled = !hasSelected;
        if (btnSelectedPrivate) btnSelectedPrivate.disabled = !hasSelected;

        if (selectAllDailyCheckbox) {
            if (checkboxes.length === 0) {
                selectAllDailyCheckbox.checked = false;
                selectAllDailyCheckbox.indeterminate = false;
            } else if (count === checkboxes.length) {
                selectAllDailyCheckbox.checked = true;
                selectAllDailyCheckbox.indeterminate = false;
            } else if (count > 0) {
                selectAllDailyCheckbox.checked = false;
                selectAllDailyCheckbox.indeterminate = true;
            } else {
                selectAllDailyCheckbox.checked = false;
                selectAllDailyCheckbox.indeterminate = false;
            }
        }
    }

    // 개별 체크박스 변경 이벤트 위임
    document.addEventListener("change", function(e) {
        if (!e.target.classList.contains("my_daily_checkbox")) return;

        const checkbox = e.target;
        const card = checkbox.closest(".my_daily_card");
        if (card) {
            card.classList.toggle("is_selected", checkbox.checked);
        }
        updateSelectionSummary();
    });

    // 전체 선택 체크박스 클릭
    if (selectAllDailyCheckbox) {
        selectAllDailyCheckbox.addEventListener("change", function() {
            const isChecked = selectAllDailyCheckbox.checked;
            const checkboxes = getVisibleDailyCheckboxes();

            checkboxes.forEach(function(cb) {
                cb.checked = isChecked;
                const card = cb.closest(".my_daily_card");
                if (card) {
                    card.classList.toggle("is_selected", isChecked);
                }
            });

            updateSelectionSummary();
        });
    }

    /* --------------------------------------------------------------------------
       4. 선택된 특정 데일리 리뷰들 일괄 공개 / 비공개
       -------------------------------------------------------------------------- */
    function executeSelectedAction(isPublic) {
        const checkboxes = getVisibleDailyCheckboxes();
        const checkedList = checkboxes.filter(cb => cb.checked);
        if (checkedList.length === 0) {
            alert("선택된 데일리 리뷰가 없습니다.");
            return;
        }

        const stateText = (isPublic === "Y") ? "공개" : "비공개";
        const count = checkedList.length;
        if (!confirm("선택한 " + count + "개의 데일리 리뷰를 '" + stateText + "' 상태로 변경하시겠습니까?")) {
            return;
        }

        const selectedIds = checkedList.map(cb => cb.value);

        if (btnSelectedPublic) btnSelectedPublic.disabled = true;
        if (btnSelectedPrivate) btnSelectedPrivate.disabled = true;

        const params = new URLSearchParams();
        selectedIds.forEach(id => params.append("reviewIds", id));
        params.append("isPublic", isPublic);

        fetch(basePath + "/review/public/selected", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
            },
            body: params.toString()
        })
        .then(function(res) {
            return res.json();
        })
        .then(function(result) {
            if (result.success) {
                checkedList.forEach(function(cb) {
                    const card = cb.closest(".my_daily_card");
                    if (card) {
                        const toggleBtn = card.querySelector(".my_public_toggle_btn");
                        if (toggleBtn) {
                            updateDailyBtnUI(toggleBtn, isPublic);
                        }
                    }
                });
                alert("선택한 " + count + "개 데일리 리뷰가 '" + stateText + "' 상태로 변경되었습니다.");
            } else {
                alert(result.message || "공개 설정 변경에 실패했습니다.");
            }
        })
        .catch(function(err) {
            console.error("선택 리뷰 공개 변경 오류:", err);
            alert("서버 통신 중 오류가 발생했습니다.");
        })
        .finally(function() {
            updateSelectionSummary();
        });
    }

    if (btnSelectedPublic) {
        btnSelectedPublic.addEventListener("click", function() {
            executeSelectedAction("Y");
        });
    }

    if (btnSelectedPrivate) {
        btnSelectedPrivate.addEventListener("click", function() {
            executeSelectedAction("N");
        });
    }

    /* --------------------------------------------------------------------------
       5. 전체 데일리 리뷰 일괄 공개 / 비공개
       -------------------------------------------------------------------------- */
    function executeAllAction(isPublic) {
        const stateText = (isPublic === "Y") ? "전체 공개" : "전체 비공개";
        const warning = (isPublic === "N") ? "\n(모든 데일리 리뷰가 메인 피드 및 타인에게서 숨겨집니다)" : "";

        if (!confirm("모든 데일리 리뷰를 '" + stateText + "' 상태로 변경하시겠습니까?" + warning)) {
            return;
        }

        if (btnAllPublic) btnAllPublic.disabled = true;
        if (btnAllPrivate) btnAllPrivate.disabled = true;

        const params = new URLSearchParams();
        params.append("isPublic", isPublic);

        fetch(basePath + "/review/public/all", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
            },
            body: params.toString()
        })
        .then(function(res) {
            return res.json();
        })
        .then(function(result) {
            if (result.success) {
                document.querySelectorAll(".my_public_toggle_btn").forEach(function(btn) {
                    updateDailyBtnUI(btn, isPublic);
                });
                alert("모든 데일리 리뷰가 '" + stateText + "' 상태로 변경되었습니다.");
            } else {
                alert(result.message || "전체 공개 설정 변경에 실패했습니다.");
            }
        })
        .catch(function(err) {
            console.error("전체 리뷰 공개 변경 오류:", err);
            alert("서버 통신 중 오류가 발생했습니다.");
        })
        .finally(function() {
            if (btnAllPublic) btnAllPublic.disabled = false;
            if (btnAllPrivate) btnAllPrivate.disabled = false;
        });
    }

    if (btnAllPublic) {
        btnAllPublic.addEventListener("click", function() {
            executeAllAction("Y");
        });
    }

    if (btnAllPrivate) {
        btnAllPrivate.addEventListener("click", function() {
            executeAllAction("N");
        });
    }

});