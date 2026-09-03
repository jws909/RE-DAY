<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- =========================================
     RE:DAY 공통 NAVBAR
     PC + MOBILE 반응형
     ========================================= -->

<header
	class="sticky top-0 z-40 bg-white/95 backdrop-blur border-b-2 border-dashed border-slate-300 mb-8">

	<!-- 상단 NAV 영역 -->
	<div
		class="max-w-6xl mx-auto px-4 sm:px-6 h-16 flex items-center justify-between gap-2">

		<!-- =========================================
		     Logo & Concept Tag
		     ========================================= -->
		<a href="${pageContext.request.contextPath}/RE:DAY/mainpage"
			class="flex items-center gap-2 group shrink-0">

			<div class="w-9 h-9 flex items-center justify-center">
				<img
					src="${pageContext.request.contextPath}/images/logo/RE_DAY_LOGO.png"
					class="w-full h-full object-contain" alt="RE:DAY 로고" />
			</div>

			<div>

				<div class="flex items-center gap-1.5">

					<span class="flex items-center"> <img
						src="${pageContext.request.contextPath}/images/logo/RE_DAY_TITLE.png"
						class="h-5 sm:h-6 w-auto object-contain" alt="RE:DAY" />
					</span>

					<!-- 모바일에서는 BETA 숨김 -->
					<span
						class="hidden sm:inline bg-blue-50 text-blue-700 text-[10px]
							   font-mono font-bold px-1.5 py-0.5 rounded
							   border border-blue-200">
						BETA </span>

				</div>

				<!-- 모바일에서는 설명 숨김 -->
				<p class="text-[10px] text-slate-500 hidden sm:block">하루 & 라이프
					리뷰 플랫폼</p>

			</div>

		</a>


		<!-- =========================================
		     PC NAV
		     768px 이상에서만 표시
		     ========================================= -->
		<nav class="main-nav hidden md:flex items-center gap-1 sm:gap-2">

			<!-- 피드 -->
			<a href="${pageContext.request.contextPath}/RE:DAY/mainpage"
				class="flex items-center gap-1.5 px-2.5 sm:px-3 py-1.5
					   rounded-md text-xs sm:text-sm font-medium
					   transition-colors border
					   text-slate-600 hover:text-slate-900
					   hover:bg-slate-100 border-transparent">

				<i class="fa-regular fa-calendar-days"></i> <span>피드</span>

			</a>


			<!-- 탐색 & 트렌드 -->
			<a href="${pageContext.request.contextPath}/RE:DAY/explore"
				class="flex items-center gap-1.5 px-2.5 sm:px-3 py-1.5
					   rounded-md text-xs sm:text-sm font-medium
					   transition-colors border
					   text-slate-600 hover:text-slate-900
					   hover:bg-slate-100 border-transparent">

				<i class="fa-regular fa-compass"></i> <span>탐색 & 트렌드</span>

			</a>


			<!-- 내 기록 -->
			<a href="${pageContext.request.contextPath}/RE:DAY/my"
				class="flex items-center gap-1.5 px-2.5 sm:px-3 py-1.5
					   rounded-md text-xs sm:text-sm font-medium
					   transition-colors border
					   text-slate-600 hover:text-slate-900
					   hover:bg-slate-100 border-transparent">

				<i class="fa-regular fa-user"></i> <span>내 기록</span>

			</a>


			<!-- 하루 쓰기 -->
			<a href="${pageContext.request.contextPath}/RE:DAY/review/write"
				class="flex items-center gap-1.5 px-3 py-1.5
					   rounded-md text-xs sm:text-sm font-semibold
					   transition-all border
					   bg-blue-50 text-blue-700
					   border-blue-200 hover:bg-blue-100">

				<i class="fa-solid fa-circle-plus"></i> <span>하루 쓰기</span>

			</a>


			<!-- =========================================
			     로그인 / 로그아웃 영역
			     ========================================= -->
			<div
				class="flex items-center gap-1.5 pl-1 sm:pl-2
					   border-l border-slate-200">

				<c:choose>

					<%-- 로그인 상태 --%>
					<c:when test="${not empty sessionScope.loginUser}">

						<a href="${pageContext.request.contextPath}/RE:DAY/my"
							title="마이페이지(내 기록)로 이동"
							class="flex items-center gap-1.5 p-1
								   bg-slate-100 hover:bg-slate-200
								   rounded-lg border border-slate-200
								   text-xs transition-colors">

<%-- =========================================
     로그인 회원 프로필 이미지
     - 프로필 이미지가 있으면 실제 이미지 표시
     - 없거나 이미지 로드 실패 시 기본 아이콘 표시
========================================= --%>
							<div class="w-6 h-6 rounded-full bg-slate-800
           						text-white overflow-hidden
          						flex items-center justify-center
           						shrink-0">

								<c:choose>

									<%-- 프로필 이미지가 있는 경우 --%>
									<c:when test="${not empty sessionScope.loginUser.profileImg}">
										<img
											src="${pageContext.request.contextPath}${sessionScope.loginUser.profileImg}"
											alt="프로필 이미지" class="w-full h-full object-cover"
											onerror="
                    this.style.display='none';
                    this.nextElementSibling.style.display='flex';
                ">

										<%-- 이미지 로드 실패 시 기본 아이콘 --%>
										<span style="display: none;"
											class="w-full h-full items-center justify-center text-[11px]">
											<i class="fa-solid fa-user"></i>
										</span>
									</c:when>

									<%-- 프로필 이미지가 없는 경우 --%>
									<c:otherwise>
										<span
											class="w-full h-full flex items-center justify-center text-[11px]">
											<i class="fa-solid fa-user"></i>
										</span>
									</c:otherwise>

								</c:choose>

							</div>


							<div class="hidden md:flex items-center gap-1 text-[11px]">

								<span
									class="font-bold text-slate-800
										   truncate max-w-[80px]">

									${sessionScope.loginUser.nickname} </span> <span
									class="text-orange-600 font-mono
										   flex items-center font-bold">

									<i
									class="fa-solid fa-fire
											   text-orange-500 text-xs mr-0.5">
								</i> ${sessionScope.loginUser.streakCount}일

								</span>

							</div>

						</a>


						<!-- 로그아웃 -->
						<a href="${pageContext.request.contextPath}/member/logout"
							title="로그아웃" onclick="return confirm('로그아웃 하시겠습니까?')"
							class="p-1.5 text-slate-400
								   hover:text-rose-600 hover:bg-rose-50
								   rounded-md transition-colors
								   flex items-center">

							<i class="fa-solid fa-arrow-right-from-bracket"></i>

						</a>

					</c:when>


					<%-- 비로그인 상태 --%>
					<c:otherwise>

						<a href="${pageContext.request.contextPath}/member/signin"
							class="px-2.5 py-1.5 text-xs font-bold
								   text-blue-600 hover:bg-blue-50
								   border border-blue-200
								   rounded-md transition-colors">

							로그인 </a>

					</c:otherwise>

				</c:choose>

			</div>


			<!-- 도움말 -->
			<button type="button"
				onclick="document.getElementById('infoModal').classList.remove('hidden')"
				title="이용 가이드"
				class="p-1.5 text-slate-400
					   hover:text-slate-700 hover:bg-slate-100
					   rounded-md transition-colors">

				<i class="fa-solid fa-circle-question text-sm"></i>

			</button>

		</nav>


		<!-- =========================================
		     모바일 햄버거 버튼
		     768px 미만에서만 표시
		     ========================================= -->
		<button type="button" id="mobileMenuBtn"
			class="md:hidden flex items-center justify-center
				   w-9 h-9 rounded-md
				   border border-slate-200
				   text-slate-600 bg-white
				   hover:bg-slate-100"
			onclick="toggleMobileMenu()" aria-label="모바일 메뉴 열기">

			<i class="fa-solid fa-bars"></i>

		</button>

	</div>


	<!-- =========================================
	     MOBILE MENU
	     ========================================= -->
	<div id="mobileMenu"
		class="hidden md:hidden bg-white
			   border-t border-slate-200">

		<div class="px-4 py-3 flex flex-col gap-2">

			<!-- 피드 -->
			<a href="${pageContext.request.contextPath}/RE:DAY/mainpage"
				class="flex items-center gap-3
					   px-3 py-3 rounded-lg
					   text-sm font-medium text-slate-700
					   hover:bg-slate-100">

				<i class="fa-regular fa-calendar-days w-5 text-center"></i> <span>피드</span>

			</a>


			<!-- 탐색 & 트렌드 -->
			<a href="${pageContext.request.contextPath}/RE:DAY/explore"
				class="flex items-center gap-3
					   px-3 py-3 rounded-lg
					   text-sm font-medium text-slate-700
					   hover:bg-slate-100">

				<i class="fa-regular fa-compass w-5 text-center"></i> <span>탐색
					& 트렌드</span>

			</a>


			<!-- 내 기록 -->
			<a href="${pageContext.request.contextPath}/RE:DAY/my"
				class="flex items-center gap-3
					   px-3 py-3 rounded-lg
					   text-sm font-medium text-slate-700
					   hover:bg-slate-100">

				<i class="fa-regular fa-user w-5 text-center"></i> <span>내 기록</span>

			</a>


			<!-- 하루 쓰기 -->
			<a href="${pageContext.request.contextPath}/RE:DAY/review/write"
				class="flex items-center gap-3
					   px-3 py-3 rounded-lg
					   text-sm font-bold
					   text-blue-700 bg-blue-50
					   border border-blue-200">

				<i class="fa-solid fa-circle-plus w-5 text-center"></i> <span>하루
					쓰기</span>

			</a>


			<!-- 로그인 상태 분기 -->
			<c:choose>

				<c:when test="${not empty sessionScope.loginUser}">

					<div class="border-t border-slate-200 mt-2 pt-2">

						<!-- 마이페이지 -->
						<a href="${pageContext.request.contextPath}/RE:DAY/my"
							class="flex items-center gap-3
								   px-3 py-3 rounded-lg
								   text-sm text-slate-700
								   hover:bg-slate-100">

							<i class="fa-solid fa-user-circle
									   w-5 text-center">
						</i> <span> ${sessionScope.loginUser.nickname} </span>

						</a>


						<!-- 로그아웃 -->
						<a href="${pageContext.request.contextPath}/member/logout"
							onclick="return confirm('로그아웃 하시겠습니까?')"
							class="flex items-center gap-3
								   px-3 py-3 rounded-lg
								   text-sm text-rose-600
								   hover:bg-rose-50">

							<i
							class="fa-solid fa-arrow-right-from-bracket
									   w-5 text-center">
						</i> <span>로그아웃</span>

						</a>

					</div>

				</c:when>


				<c:otherwise>

					<a href="${pageContext.request.contextPath}/member/signin"
						class="flex items-center justify-center gap-2
							   mt-2 px-3 py-3
							   rounded-lg text-sm font-bold
							   text-blue-600
							   border border-blue-200
							   hover:bg-blue-50">

						<i class="fa-solid fa-right-to-bracket"></i> <span>로그인</span>

					</a>

				</c:otherwise>

			</c:choose>


			<!-- 모바일 도움말 -->
			<button type="button"
				onclick="document.getElementById('infoModal').classList.remove('hidden')"
				class="flex items-center gap-3
					   px-3 py-3 rounded-lg
					   text-sm text-slate-500
					   hover:bg-slate-100">

				<i class="fa-solid fa-circle-question w-5 text-center"></i> <span>이용
					가이드</span>

			</button>

		</div>

	</div>

</header>


<!-- =========================================
     INFO MODAL
     ========================================= -->
<div id="infoModal"
	class="hidden fixed inset-0 z-50
		   bg-slate-900/60 backdrop-blur-sm
		   flex items-center justify-center p-4">

	<div
		class="bg-white rounded-xl max-w-lg w-full
			   p-6 border border-slate-200
			   shadow-2xl space-y-4">

		<!-- 헤더 영역 -->
		<div
			class="flex items-center justify-between
				   pb-3 border-b border-slate-200">

			<div class="flex items-center gap-2">

				<span class="text-lg">📖</span>

				<h3 class="font-bold text-base text-slate-900">RE:DAY 서비스 이용
					가이드</h3>

			</div>


			<button type="button"
				onclick="document.getElementById('infoModal').classList.add('hidden')"
				class="text-slate-400
					   hover:text-slate-600
					   text-xs font-semibold
					   px-2.5 py-1
					   bg-slate-100 hover:bg-slate-200
					   rounded transition-colors">

				닫기 ✕</button>

		</div>


		<!-- 가이드 본문 -->
		<div class="space-y-3 text-xs text-slate-600 leading-relaxed">

			<!-- 1 -->
			<div
				class="p-3 bg-slate-50
					   border border-slate-200
					   rounded-lg">

				<p
					class="font-bold text-slate-800
						   flex items-center gap-1.5 mb-1">

					<span>⭐</span> 1. 메인 데일리 리뷰

				</p>

				<p>일기장처럼 오늘 하루 전체를 기록하고, 종합 평점과 기분 태그로 하루의 무드를 남겨보세요.</p>

			</div>


			<!-- 2 -->
			<div
				class="p-3 bg-slate-50
					   border border-slate-200
					   rounded-lg">

				<p
					class="font-bold text-slate-800
						   flex items-center gap-1.5 mb-1">

					<span>📌</span> 2. 1:N 서브 리뷰

				</p>

				<p>하루 리뷰 안에 다녀온 맛집/카페, 사용한 아이템, 감상한 영화 등 세부 리뷰를 자유롭게 추가할 수 있습니다.
				</p>

			</div>


			<!-- 3 -->
			<div
				class="p-3 bg-blue-50/60
					   border border-blue-100
					   rounded-lg">

				<p
					class="font-bold text-blue-900
						   flex items-center gap-1.5 mb-1">

					<span>🔥</span> 3. 연속 기록(Streak) & 트렌드 탐색

				</p>

				<p class="text-blue-800">매일 기록을 이어가며 연속 일수(Streak)를 달성하고, 탐색 탭에서
					다른 사람들의 트렌디한 하루를 둘러보세요.</p>

			</div>

		</div>


		<button type="button"
			onclick="document.getElementById('infoModal').classList.add('hidden')"
			class="w-full py-2.5
				   bg-slate-900 text-white
				   rounded-lg font-medium text-xs
				   hover:bg-slate-800
				   transition-colors">

			확인했습니다</button>

	</div>

</div>


<!-- =========================================
     MOBILE MENU SCRIPT
     ========================================= -->
<script>
	function toggleMobileMenu() {

		const mobileMenu = document.getElementById("mobileMenu");

		const menuIcon = document.querySelector("#mobileMenuBtn i");

		mobileMenu.classList.toggle("hidden");

		if (mobileMenu.classList.contains("hidden")) {

			menuIcon.classList.remove("fa-xmark");
			menuIcon.classList.add("fa-bars");

		} else {

			menuIcon.classList.remove("fa-bars");
			menuIcon.classList.add("fa-xmark");

		}

	}
</script>

<c:if test="${not empty errorMessage}">
<script>
	document.addEventListener('DOMContentLoaded', function() {
		alert("${errorMessage}");
	});
</script>
</c:if>