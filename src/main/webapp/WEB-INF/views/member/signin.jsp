<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8">
<title>RE:DAY - 로그인</title>

<%@ include file="/WEB-INF/views/include/head.jsp"%>
</head>

<body class="bg-slate-50 min-h-screen">

	<!-- 공통 네비게이션 -->
	<%@ include file="/WEB-INF/views/include/navbar.jsp"%>

	<main class="max-w-md mx-auto px-4 pb-12">

		<!-- 메인으로 돌아가기 -->
		<div class="mb-6">
			<a href="${pageContext.request.contextPath}/RE:DAY/mainpage"
				class="text-sm text-slate-500 hover:text-slate-800"> ← 메인 피드로
				돌아가기 </a>
		</div>

		<!-- 로그인 카드 -->
		<section
			class="bg-white border-2 border-dashed border-slate-300
                   rounded-2xl p-8 shadow-sm">

			<!-- 상단 로고 -->
			<div class="text-center mb-6">

				<div class="w-12 h-12 mx-auto mb-4">
					<img
						src="${pageContext.request.contextPath}/images/logo/RE_DAY_LOGO.png"
						class="w-full h-full object-contain" alt="RE:DAY 로고" />
				</div>

				<h1 class="text-xl font-bold text-slate-900">RE:DAY 로그인</h1>

				<p class="text-xs text-slate-500 mt-2">나의 하루를 기록하고 라이프 트렌드를 함께
					나눠보세요.</p>

			</div>


			<!-- 소셜 로그인 -->
			<div class="space-y-2 mb-6">
    			<button type="button"
        			onclick="location.href='${pageContext.request.contextPath}/oauth/kakao'"
        			class="w-full py-2.5 rounded-xl
               			bg-yellow-400 hover:bg-yellow-500
               			text-xs font-bold">
        			카카오로 1초 만에 시작하기
    			</button>

    			<button type="button"
        			onclick="location.href='${pageContext.request.contextPath}/oauth/google'"
        			class="w-full py-2.5 rounded-xl
               			border border-slate-300
               			bg-white hover:bg-slate-50
               			text-xs font-bold">
        			Google 계정으로 계속하기
    			</button>

			</div>


			<!-- 구분선 -->
			<div class="flex items-center gap-3 my-6">

				<div class="flex-1 border-t border-dashed border-slate-300"></div>

				<span class="text-xs text-slate-400"> 또는 이메일로 로그인 </span>

				<div class="flex-1 border-t border-dashed border-slate-300"></div>

			</div>


			<!-- 이메일 로그인 -->
			<form action="${pageContext.request.contextPath}/member/signin"
				method="post" class="space-y-4">

				<!-- 이메일 -->
				<div>

					<label for="email"
						class="block text-xs font-bold text-slate-700 mb-1.5"> <i
						class="fa-regular fa-envelope mr-1"></i> 이메일 주소

					</label> <input type="email" id="email" name="email"
						placeholder="example@reday.app" required
						class="w-full px-3 py-2.5
                               border-2 border-dashed border-slate-300
                               rounded-lg bg-slate-50
                               text-sm
                               focus:outline-none
                               focus:border-blue-500">

				</div>


				<!-- 비밀번호 -->
				<div>

					<div class="flex items-center justify-between mb-1.5">

						<label for="password" class="text-xs font-bold text-slate-700">

							<i class="fa-solid fa-lock mr-1"></i> 비밀번호

						</label> <a href="#" class="text-xs text-slate-400 underline"> 비밀번호 찾기
						</a>

					</div>

					<input type="password" id="password" name="password" required
						class="w-full px-3 py-2.5
                               border-2 border-dashed border-slate-300
                               rounded-lg bg-slate-50
                               text-sm
                               focus:outline-none
                               focus:border-blue-500">

				</div>


				<!-- 로그인 유지 -->
				<label
					class="flex items-center gap-2
                           text-xs text-slate-700
                           cursor-pointer">

					<input type="checkbox" name="rememberMe" value="Y"> 로그인 상태
					유지

				</label>


				<!-- 로그인 버튼 -->
				<button type="submit"
					class="w-full py-3
                           bg-slate-900 hover:bg-slate-800
                           text-white rounded-xl
                           text-sm font-bold">

					<i class="fa-solid fa-arrow-right-to-bracket mr-1"></i> 이메일로 로그인

				</button>

			</form>
			

			</div>


			<!-- 회원가입 -->
			<div
				class="mt-6 pt-4
                       border-t border-slate-200
                       text-center text-xs text-slate-500">

				아직 RE:DAY 회원이 아니신가요? <a
					href="${pageContext.request.contextPath}/member/signup"
					class="text-blue-600 font-bold ml-1"> 회원가입하기 </a>

			</div>

		</section>

	</main>

</body>

</html>