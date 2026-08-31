<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>RE:DAY - 마이페이지</title>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<link href="/css/mainpage/my.css" rel="stylesheet">
<script src="/js/mainpage/my.js"></script>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0" />
</head>
<body>
  <!-- 상단 네비게이션 바 -->
  <%@ include file="/WEB-INF/views/include/navbar.jsp"%>

  <div class="my_container">
        <!-- 상단 프로필 & 상태 바 -->
        <div class="my_top_column">
          <div class="my_profile_wrapper">
            <div class="my_challenger_card">
              <div class="my_challenger_info">
                <!-- 아바타 박스 -->
                <div class="my_avatar_box">👤</div>
                <!-- 유저 정보 -->
                <div class="my_meta_content">
                  <div class="my_meta_row_top">
                    <h1 class="my_user_name">유저</h1>
                    <span class="my_badge_blue font-mono">Lv.1000</span>
                    <span class="my_streak_badge font-mono">
                      <span class="material-symbols-outlined icon_flame">local_fire_department</span>
                     nn일 연속 기록
                    </span>
                  </div>
                  <div class="meta_row_bottom">
                    <span class="my_user_email font-mono">user.email.com</span>
                  </div>
                </div>
              </div>

              <!-- 우측 액션 버튼 그룹 -->
              <button type="button" class="my_review_write">
                <span class="material-symbols-outlined" style="font-size: 16px;">edit_square</span>
                오늘 하루 쓰기
              </button>
            </div>

            <!-- 통계 카드 그리드 -->
            <div class="my_stat_grid">
              <div class="my_stat_card">
                <span class="my_stat_label">총 데일리 기록</span>
                <div class="my_stat_value font-mono">
                 nn<span class="my_stat_unit">편</span>
                </div>
              </div>
              <div class="my_stat_card">
                <span class="my_stat_label">평균 하루 평점</span>
                <div class="my_stat_value rating font-mono">
                  n<span class="my_stat_unit">/ 5.0</span>
                </div>
              </div>
              <div class="my_stat_card">
                <span class="my_stat_label">총 서브 리뷰</span>
                <div class="my_stat_value sub font-mono">
                 nn<span class="my_stat_unit">개</span>
                </div>
              </div>
              <div class="my_stat_card">
                <span class="my_stat_label">내돈내산 인증률</span>
                <div class="my_stat_value verify font-mono">n%</div>
              </div>
            </div>
          </div>
        </div>

        <!-- 하단 컨텐츠 영역 -->
        <div class="my_bottom_column">
          <!-- 탭 네비게이션 -->
          <div class="my_curation_tab_bar">
            <button type="button" onclick="switchTab('daily')" id="tabBtn-daily" class="my_curation_tab active">
              <span class="material-symbols-outlined">calendar_today</span> 내 데일리 기록
            </button>
            <button type="button" onclick="switchTab('subreviews')" id="tabBtn-subreviews" class="my_curation_tab">
              <span class="material-symbols-outlined">category</span> 내 서브 리뷰
            </button>
          </div>

          <!-- 데일리 기록 컨텐츠 -->
          <div id="tabContent-daily" class="my_curation_grid daily_view">
            <c:choose>
              <c:when test="${empty myReviews}">
                <div class="my_card my_empty_card">작성된 데일리 기록이 없습니다.</div>
              </c:when>
              <c:otherwise>
                <c:forEach var="rev" items="${myReviews}">
                  <div class="my_card">
                    <div class="my_card_header">
                      <span class="my_card_date font-mono">week</span>
                      <span class="my_card_rating font-mono">★ 5.0</span>
                    </div>
                    <p class="my_card_comment">${rev.summary}</p>
                    <div class="my_card_footer">
                      <span class="my_card_sub_count">서브 리뷰 n}개</span>
                      <a href="${pageContext.request.contextPath}/review/${rev.id}" class="my_card_link">상세보기 →</a>
                    </div>
                  </div>
                </c:forEach>
              </c:otherwise>
            </c:choose>
          </div>

          <!-- 서브 리뷰 컨텐츠 -->
          <div id="tabContent-subreviews" class="my_curation_grid sub_view" style="display: none;">
            <c:choose>
              <c:when test="${empty mySubReviews}">
                <div class="my_card my_empty_card">작성된 서브 리뷰가 없습니다.</div>
              </c:when>
              <c:otherwise>
                <c:forEach var="item" items="${mySubReviews}">
                  <div class="my_card">
                    <div class="my_card_header">
                      <span class="my_card_category">${item.sub.category}</span>
                      <span class="my_card_date font-mono">${item.parentDate}</span>
                    </div>
                    <h4 class="my_card_title">${item.sub.name} <span class="my_card_rating font-mono">★ ${item.sub.rating}</span></h4>
                    <p class="my_card_comment">"${item.sub.comment}"</p>
                  </div>
                </c:forEach>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
  </div>
</body>
</html>