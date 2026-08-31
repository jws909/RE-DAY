<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c"
    uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>RE:DAY 로그인</title>


<style>

/* =========================================
   기본 설정
========================================= */

* {
    box-sizing: border-box;
}

body {
    margin: 0;

    font-family:
        Arial,
        "Noto Sans KR",
        sans-serif;

    background-color: #f7faff;

    color: #14213d;
}


/* =========================================
   전체 페이지
========================================= */

.login-page {

    width: 100%;

    min-height: 100vh;

    padding-top: 45px;
    padding-bottom: 80px;
}


/* =========================================
   로그인 영역 폭
========================================= */

.login-container {

    width: 420px;

    max-width: calc(100% - 30px);

    margin: 0 auto;
}


/* =========================================
   메인 피드로 돌아가기
========================================= */

.back-link {

    display: inline-flex;

    align-items: center;

    gap: 5px;

    margin-bottom: 28px;

    color: #64748b;

    text-decoration: none;

    font-size: 14px;
}

.back-link:hover {
    color: #2563eb;
}


/* =========================================
   로그인 카드
========================================= */

.login-card {

    background-color: #ffffff;

    border: 2px dashed #cbd5e1;

    border-radius: 18px;

    padding: 32px;
}


/* =========================================
   RE 로고
========================================= */

.logo-box {

    width: 48px;
    height: 48px;

    margin: 0 auto 12px;

    display: flex;

    align-items: center;
    justify-content: center;

    background-color: #0f172a;

    color: white;

    border-radius: 12px;

    font-size: 16px;

    font-weight: bold;
}


/* =========================================
   제목
========================================= */

.login-title {

    margin: 0;

    text-align: center;

    color: #0f172a;

    font-size: 21px;

    font-weight: 700;
}


.login-description {

    margin-top: 8px;
    margin-bottom: 26px;

    text-align: center;

    color: #64748b;

    font-size: 13px;
}


/* =========================================
   오류 메시지
========================================= */

.login-error {

    margin-bottom: 16px;

    padding: 10px 12px;

    border: 1px solid #fecaca;

    border-radius: 8px;

    background-color: #fef2f2;

    color: #dc2626;

    font-size: 12px;
}


/* =========================================
   간편 로그인 버튼 공통
========================================= */

.social-button {

    width: 100%;

    height: 40px;

    margin-bottom: 9px;

    border-radius: 10px;

    font-size: 13px;

    font-weight: 600;

    cursor: pointer;

    display: flex;

    justify-content: center;
    align-items: center;

    gap: 8px;

    text-decoration: none;
}


/* 카카오 */

.kakao-button {

    border: none;

    background-color: #fee500;

    color: #191919;
}

.kakao-button:hover {

    background-color: #f5dc00;
}


/* Google */

.google-button {

    border: 1px solid #cbd5e1;

    background-color: white;

    color: #1e293b;
}

.google-button:hover {

    background-color: #f8fafc;
}


/* =========================================
   작은 아이콘
========================================= */

.social-icon {

    width: 17px;
    height: 17px;

    display: flex;

    align-items: center;
    justify-content: center;

    border-radius: 50%;

    font-size: 10px;

    font-weight: bold;
}


.kakao-icon {

    background-color: #111827;

    color: white;
}


.google-icon {

    background-color: white;

    color: #111827;
}


/* =========================================
   또는 이메일로 로그인
========================================= */

.login-divider {

    display: flex;

    align-items: center;

    gap: 12px;

    margin: 23px 0;

    color: #94a3b8;

    font-size: 12px;
}


.login-divider::before,
.login-divider::after {

    content: "";

    flex: 1;

    border-top: 1px dashed #cbd5e1;
}


/* =========================================
   입력 그룹
========================================= */

.form-group {

    margin-bottom: 16px;
}


.form-label-row {

    display: flex;

    justify-content: space-between;

    align-items: center;

    margin-bottom: 7px;
}


.form-label {

    font-size: 14px;

    font-weight: 600;

    color: #24324a;
}


.find-password {
    color: #94a3b8;
    font-size: 11px;
    text-decoration: underline;
    cursor: pointer;
}

.find-password:hover {
    color: #111111;
}


/* =========================================
   입력창
========================================= */

.form-input {

    width: 100%;

    height: 38px;

    padding: 0 13px;

    border: 2px dashed #cbd5e1;

    border-radius: 10px;

    background-color: #f8fafc;

    outline: none;

    color: #334155;

    font-size: 13px;

    transition: 0.2s;
}


.form-input::placeholder {

    color: #94a3b8;
}


.form-input:focus {

    border-color: #2563eb;

    background-color: #ffffff;
}


/* =========================================
   비밀번호 눈 아이콘
========================================= */

.password-wrap {

    position: relative;
}


.password-wrap .form-input {

    padding-right: 45px;
}


.password-eye {

    position: absolute;

    right: 12px;

    top: 50%;

    transform: translateY(-50%);

    padding: 0;

    border: none;

    background: transparent;

    color: #64748b;

    cursor: pointer;

    display: flex;

    align-items: center;
    justify-content: center;
}


.password-eye:hover {

    color: #2563eb;
}


.password-eye svg {

    width: 19px;
    height: 19px;
}


/* Edge 기본 눈 아이콘 제거 */

input[type="password"]::-ms-reveal,
input[type="password"]::-ms-clear {

    display: none;
}


/* =========================================
   로그인 유지
========================================= */

.remember-area {

    display: flex;

    align-items: center;

    gap: 7px;

    margin: 7px 0 17px;

    color: #475569;

    font-size: 13px;
}


.remember-area input {

    width: 15px;
    height: 15px;

    accent-color: #2563eb;

    cursor: pointer;
}


.remember-area label {

    cursor: pointer;
}


/* =========================================
   이메일 로그인 버튼
========================================= */

.login-button {

    width: 100%;

    height: 42px;

    border: none;

    border-radius: 10px;

    background-color: #0f172a;

    color: white;

    font-size: 14px;

    font-weight: bold;

    cursor: pointer;

    transition: 0.2s;
}


.login-button:hover {

    background-color: #1e293b;

    transform: translateY(-1px);
}



/* =========================================
   회원가입
========================================= */

.signup-area {

    margin-top: 24px;

    padding-top: 14px;

    border-top: 1px solid #edf0f5;

    text-align: center;

    color: #64748b;

    font-size: 12px;
}


.signup-link {

    margin-left: 4px;

    color: #2563eb;

    font-weight: bold;

    text-decoration: underline;
}


/* =========================================
   모바일
========================================= */

@media (max-width: 500px) {

    .login-page {

        padding-top: 25px;
    }

    .login-card {

        padding: 25px 20px;
    }

}

</style>

</head>


<body>


<div class="login-page">

    <div class="login-container">


        <!-- =====================================
             메인 피드
        ====================================== -->

        <a href="${pageContext.request.contextPath}/"
           class="back-link">

            ← 메인 피드로 돌아가기

        </a>



        <div class="login-card">


            <!-- =====================================
                 로고
            ====================================== -->

            <div class="logo-box">
                RE
            </div>



            <!-- =====================================
                 제목
            ====================================== -->

            <h1 class="login-title">
                RE:DAY 로그인
            </h1>


            <p class="login-description">

                나의 하루를 기록하고 라이프 트렌드를
                함께 나눠보세요.

            </p>



            <!-- =====================================
                 로그인 오류
            ====================================== -->

            <c:if test="${not empty errorMessage}">

                <div class="login-error">

                    <c:out value="${errorMessage}" />

                </div>

            </c:if>



            <!-- =====================================
                 카카오 로그인
            ====================================== -->

            <a
                href="${pageContext.request.contextPath}/member/login/kakao"
                class="social-button kakao-button">

                <span class="social-icon kakao-icon">
                    K
                </span>

                카카오로 1초 만에 시작하기

            </a>



            <!-- =====================================
                 Google 로그인
            ====================================== -->

            <a
                href="${pageContext.request.contextPath}/member/login/google"
                class="social-button google-button">

                <span class="social-icon google-icon">
                    G
                </span>

                Google 계정으로 계속하기

            </a>



            <!-- =====================================
                 구분선
            ====================================== -->

            <div class="login-divider">

                또는 이메일로 로그인

            </div>



            <!-- =====================================
                 이메일 로그인 Form
            ====================================== -->

            <form
                action="${pageContext.request.contextPath}/member/login"
                method="post"
                id="loginForm">


                <!-- 이메일 -->

                <div class="form-group">


                    <div class="form-label-row">

                        <label
                            for="email"
                            class="form-label">

                            ✉ 이메일 주소

                        </label>

                    </div>


                    <input
                        type="email"
                        id="email"
                        name="email"
                        class="form-input"
                        placeholder="example@reday.app"
                        value="<c:out value='${email}' />"
                        required>

                </div>



                <!-- 비밀번호 -->

                <div class="form-group">


                    <div class="form-label-row">

                        <label
                            for="memberPw"
                            class="form-label">

                            ♙ 비밀번호

                        </label>


                        <a
    						href="#"
    						class="find-password"
    						onclick="sendPasswordEmail(event)">

    						비밀번호 찾기

						</a>

                    </div>



                    <div class="password-wrap">


                        <input
                            type="password"
                            id="memberPw"
                            name="memberPw"
                            class="form-input"
                            placeholder="••••••••"
                            required>



                        <!-- 눈 모양 -->

                        <button
                            type="button"
                            class="password-eye"
                            onclick="togglePassword()"
                            aria-label="비밀번호 보기">


                            <svg
                                viewBox="0 0 24 24"
                                fill="none"
                                stroke="currentColor"
                                stroke-width="1.8"
                                stroke-linecap="round"
                                stroke-linejoin="round">

                                <path
                                    d="M2 12s3.5-6 10-6 10 6 10 6-3.5 6-10 6S2 12 2 12z"/>

                                <circle
                                    cx="12"
                                    cy="12"
                                    r="3"/>

                            </svg>


                        </button>


                    </div>

                </div>



                <!-- =====================================
                     로그인 유지
                ====================================== -->

                <div class="remember-area">

                    <input
                        type="checkbox"
                        id="rememberLogin"
                        name="rememberLogin"
                        value="true">


                    <label for="rememberLogin">

                        로그인 상태 유지

                    </label>

                </div>



                <!-- =====================================
                     이메일 로그인
                ====================================== -->

                <button
                    type="submit"
                    class="login-button">

                    → &nbsp; 이메일로 로그인

                </button>


            </form>


            <!-- =====================================
                 회원가입 이동
            ====================================== -->

            <div class="signup-area">

                아직 RE:DAY 회원이 아니신가요?

                <a
                    href="${pageContext.request.contextPath}/member/signup"
                    class="signup-link">

                    회원가입하기

                </a>

            </div>


        </div>

    </div>

</div>



<script>

/* =========================================
   비밀번호 보기/숨기기
========================================= */

function togglePassword() {

    const password =
        document.getElementById("memberPw");


    const button =
        document.querySelector(".password-eye");


    if (password.type === "password") {

        password.type = "text";

        button.setAttribute(
            "aria-label",
            "비밀번호 숨기기"
        );

    }

    else {

        password.type = "password";

        button.setAttribute(
            "aria-label",
            "비밀번호 보기"
        );
    }	

}

	function sendPasswordEmail(event) {

    	event.preventDefault();

    	const email =
        	document.getElementById("email").value.trim();

    	if (email === "") {

        	alert("이메일 주소를 먼저 입력해주세요.");

        	document.getElementById("email").focus();

        	return;
    	}

    	alert(
        	"입력하신 이메일로 비밀번호 재설정 메일이 발송되었습니다."
    	);
	}

</script>


</body>
</html>