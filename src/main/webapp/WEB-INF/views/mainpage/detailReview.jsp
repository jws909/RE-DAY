<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>RE:DAY - 당신의 오늘 하루는 어땠나요?</title>

  <%@ include file="/WEB-INF/views/include/head.jsp"%>
  <link href="/css/mainpage/detailReview.css" rel="stylesheet">
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0" />
  <script src="/js/mainpage/detailReview.js"></script>
</head>
<body>
  <!-- 상단 네비게이션 바 -->
  <%@ include file="/WEB-INF/views/include/navbar.jsp"%>

  <div class="detail_review_container">
    <!-- 상단 네비게이션 액션 바 -->
    <div class="detail_review_nav_bar">
      <a href="javascript:history.back()" class="detail_review_back_btn font-mono">
        <span class="material-symbols-outlined">arrow_back</span> 목록으로
      </a>
      <div class="detail_review_nav_actions">
        <button type="button" onclick="handleLike('${review.id}')" class="detail_review_like_btn">
          <span class="material-symbols-outlined icon_heart">favorite</span>
          <span class="font-mono">좋아요 ${review.likesCount}</span>
        </button>
      </div>
    </div>

    <!-- 메인 데일리 리뷰 카드 -->
    <article class="detail_review_main_card">
      <div class="detail_review_header">
        <div class="detail_review_author_info">
          <div class="detail_review_author_avatar font-mono">
				👤
          </div>
          <div class="detail_review_author_meta">
            <div class="detail_review_author_name_row">
              <span class="detail_review_author_name">흑화 직전 팀장</span>
            </div>
            <div class="detail_review_date_row">
              <span class="material-symbols-outlined">calendar_today</span>
              <span class="font-mono">2026-09-08</span>
            </div>
          </div>
        </div>

        <div class="detail_review_score_box">
          <span class="detail_review_score_title">하루 종합 평점</span>
          <div class="detail_review_score_stars">
            <span class="material-symbols-outlined star_fill">star</span>
            <span class="font-mono">5.0</span>
          </div>
        </div>
      </div>

      <div class="detail_review_summary_section">
        <p class="detail_review_summary_text">오늘 하루 총평</p>
      </div>
    </article>

    <!-- 서브 리뷰 목록 섹션 -->
    <section class="detail_review_sub_section">
      <div class="detail_review_sub_section_header">
        <span class="material-symbols-outlined icon_layers">layers</span>
        <h3 class="detail_review_sub_section_title">
          이 날의 세부 서브 리뷰 (0개)
        </h3>
      </div>

      <div class="detail_review_sub_list">
              <div class="detail_review_sub_card">
                <div class="detail_review_sub_card_header">
                  <span class="detail_review_category_badge">콘텐츠·미디어</span>
                  <span class="detail_review_sub_rating font-mono">★ 5.0</span>
                </div>
                <h4 class="detail_review_sub_name">흑화 팀장</h4>
                <p class="detail_review_sub_comment">8월 27일에 저 욕 나올 뻔했어요</p>
              </div>
            <div class="detail_review_empty_card">
              <span class="material-symbols-outlined">inventory_2</span>
              <p>등록된 세부 서브 리뷰가 없습니다.</p>
            </div>
      </div>
    </section>
  </div>
</body>
</html>