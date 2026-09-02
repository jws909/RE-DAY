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

<title>RE:DAY 회원가입</title>


<style>

/* ==========================================
   기본 설정
========================================== */

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


/* ==========================================
   전체 페이지
========================================== */

.signup-page {

    width: 100%;

    min-height: 100vh;

    padding-top: 45px;

    padding-bottom: 80px;
}


/* ==========================================
   회원가입 전체 영역
========================================== */

.signup-container {

    width: 420px;

    max-width: calc(100% - 30px);

    margin: 0 auto;
}


/* ==========================================
   메인으로 돌아가기
========================================== */

.back-link {

    display: inline-flex;

    align-items: center;

    gap: 5px;

    margin-bottom: 28px;

    color: #64748b;

    text-decoration: none;

    font-size: 14px;

    transition: 0.2s;
}

.back-link:hover {

    color: #0f172a;
}


/* ==========================================
   회원가입 카드
========================================== */

.signup-card {

    background-color: #ffffff;

    border: 2px dashed #cbd5e1;

    border-radius: 18px;

    padding: 32px 32px 25px;
}


/* ==========================================
   RE:DAY 로고
========================================== */

.logo-box {

    width: 72px;

    height: 72px;

    margin: 0 auto 14px;

    display: flex;

    align-items: center;

    justify-content: center;
}


.logo-image {

    width: 100%;

    height: 100%;

    display: block;

    object-fit: contain;
}


/* ==========================================
   제목
========================================== */

.signup-title {

    margin: 0;

    text-align: center;

    color: #0f172a;

    font-size: 21px;

    font-weight: 700;
}


.signup-description {

    margin-top: 8px;

    margin-bottom: 26px;

    text-align: center;

    color: #64748b;

    font-size: 13px;

    line-height: 1.5;
}


/* ==========================================
   서버 회원가입 오류
========================================== */

.signup-error {

    margin-bottom: 18px;

    padding: 10px 12px;

    border: 1px solid #fecaca;

    border-radius: 8px;

    background-color: #fef2f2;

    color: #dc2626;

    font-size: 12px;
}


/* ==========================================
   입력 그룹
========================================== */

.form-group {

    margin-bottom: 17px;
}


.form-label {

    display: block;

    margin-bottom: 7px;

    color: #24324a;

    font-size: 14px;

    font-weight: 600;
}


/* ==========================================
   입력창
========================================== */

.form-input {

    width: 100%;

    height: 42px;

    padding: 0 13px;

    border: 2px dashed #cbd5e1;

    border-radius: 10px;

    background-color: #f8fafc;

    color: #334155;

    outline: none;

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


/* ==========================================
   메시지
========================================== */

.message {

    display: block;

    min-height: 16px;

    margin-top: 5px;

    font-size: 12px;
}


.error-message {

    color: #dc2626;
}


.success-message {

    color: #16a34a;
}


/* ==========================================
   관심 키워드
========================================== */

.interest-section {

    margin-top: 6px;

    margin-bottom: 17px;
}


.interest-title {

    margin-bottom: 10px;

    color: #24324a;

    font-size: 14px;

    font-weight: 600;
}


.interest-list {

    display: flex;

    flex-wrap: wrap;

    gap: 8px;
}


/* 실제 checkbox 숨기기 */

.interest-item input {

    display: none;
}


/* 키워드 버튼 */

.interest-item span {

    display: inline-block;

    padding: 7px 11px;

    border: 1px solid #d6deea;

    border-radius: 7px;

    background-color: #f8fafc;

    color: #475569;

    font-size: 12px;

    cursor: pointer;

    transition: 0.2s;
}


.interest-item span:hover {

    border-color: #2563eb;

    color: #2563eb;
}


/* 선택 상태 */

.interest-item input:checked + span {

    border-color: #2563eb;

    background-color: #2563eb;

    color: #ffffff;

    font-weight: 600;
}


/* ==========================================
   구분선
========================================== */

.divider {

    border: 0;

    border-top: 1px solid #edf0f5;

    margin: 19px 0;
}


/* ==========================================
   이용약관
========================================== */

.terms-area {

    display: flex;

    align-items: flex-start;

    gap: 8px;

    margin-bottom: 15px;
}


.terms-area input {

    width: 16px;

    height: 16px;

    margin-top: 2px;

    cursor: pointer;
}


.terms-area label {

    color: #475569;

    font-size: 12px;

    line-height: 1.5;

    cursor: pointer;
}


/* ==========================================
   회원가입 버튼
========================================== */

.signup-button {

    width: 100%;

    height: 42px;

    border: none;

    border-radius: 10px;

    background-color: #2563eb;

    color: #ffffff;

    font-size: 14px;

    font-weight: bold;

    cursor: pointer;

    box-shadow:
        0 3px 6px rgba(37, 99, 235, 0.25);

    transition: 0.2s;
}


.signup-button:hover {

    background-color: #1d4ed8;

    transform: translateY(-1px);
}


.signup-button:active {

    transform: translateY(0);
}


/* ==========================================
   로그인 이동
========================================== */

.login-area {

    margin-top: 24px;

    padding-top: 13px;

    border-top: 1px solid #edf0f5;

    text-align: center;

    color: #64748b;

    font-size: 12px;
}


.login-link {

    margin-left: 4px;

    color: #0f172a;

    text-decoration: underline;

    font-weight: bold;

    transition: 0.2s;
}


.login-link:hover {

    color: #000000;
}


/* ==========================================
   모바일
========================================== */

@media (max-width: 500px) {

    .signup-page {

        padding-top: 25px;
    }


    .signup-card {

        padding: 25px 20px;
    }


    .logo-box {

        width: 65px;

        height: 65px;
    }

}

</style>

</head>


<body>


<div class="signup-page">


    <div class="signup-container">


        <!-- ==================================
             메인 피드로 돌아가기
        =================================== -->

        <a
            href="${pageContext.request.contextPath}/"
            class="back-link">

            ← 메인 피드로 돌아가기

        </a>



        <!-- ==================================
             회원가입 카드
        =================================== -->

        <div class="signup-card">


            <!-- ==================================
                 RE:DAY 로고
            =================================== -->

            <div class="logo-box">

                <img
                    src="${pageContext.request.contextPath}/images/logo/RE_DAY_LOGO.png"
                    alt="RE:DAY 로고"
                    class="logo-image">

            </div>



            <!-- ==================================
                 제목
            =================================== -->

            <h1 class="signup-title">

                RE:DAY 회원가입

            </h1>


            <p class="signup-description">

                나만의 하루를 1:N 서브 리뷰로 기록하고
                <br>
                트렌드를 시작하세요.

            </p>



            <!-- ==================================
                 서버 회원가입 오류
            =================================== -->

            <c:if test="${not empty errorMessage}">

                <div class="signup-error">

                    <c:out value="${errorMessage}" />

                </div>

            </c:if>



            <!-- ==================================
                 회원가입 FORM
            =================================== -->

            <form
                action="${pageContext.request.contextPath}/member/signup"
                method="post"
                id="signupForm">


                <!-- ==================================
                     활동 닉네임
                =================================== -->

                <div class="form-group">


                    <label
                        for="nickname"
                        class="form-label">

                        ♟ 활동 닉네임

                    </label>


                    <input
                        type="text"
                        id="nickname"
                        name="nickname"
                        class="form-input"
                        placeholder="예: 루틴러_민, 테크리뷰어"
                        autocomplete="nickname"
                        required>


                </div>



                <!-- ==================================
                     이메일
                =================================== -->

                <div class="form-group">


                    <label
                        for="email"
                        class="form-label">

                        ✉ 이메일 주소

                    </label>


                    <input
                        type="email"
                        id="email"
                        name="email"
                        class="form-input"
                        placeholder="example@reday.app"
                        autocomplete="email"
                        required>


                </div>



                <!-- ==================================
                     비밀번호
                =================================== -->

                <div class="form-group">


                    <label
                        for="memberPw"
                        class="form-label">

                        ♟ 비밀번호

                    </label>


                    <input
    					type="password"
    					id="memberPw"
    					name="password"
    					class="form-input"
    					placeholder="8자 이상 입력해주세요"
    					minlength="8"
    					autocomplete="new-password"
    					required>


                </div>



                <!-- ==================================
                     비밀번호 확인
                =================================== -->

                <div class="form-group">


                    <label
                        for="memberPwCheck"
                        class="form-label">

                        ✓ 비밀번호 확인

                    </label>


                    <input
                        type="password"
                        id="memberPwCheck"
                        class="form-input"
                        placeholder="비밀번호 재입력"
                        minlength="8"
                        autocomplete="new-password"
                        required>


                    <span
                        id="pwMessage"
                        class="message">
                    </span>


                </div>



                <!-- ==================================
                     관심 라이프스타일
                =================================== -->

                <div class="interest-section">


                    <div class="interest-title">

                        ◇ 관심 라이프스타일 키워드
                        (다중 선택)

                    </div>


                    <div class="interest-list">


                        <!-- 재택근무 -->

                        <label class="interest-item">

                            <input
                                type="checkbox"
                                name="interests"
                                value="재택근무">

                            <span>
                                #재택근무
                            </span>

                        </label>



                        <!-- 카페투어 -->

                        <label class="interest-item">

                            <input
                                type="checkbox"
                                name="interests"
                                value="카페투어">

                            <span>
                                #카페투어
                            </span>

                        </label>



                        <!-- 운동 -->

                        <label class="interest-item">

                            <input
                                type="checkbox"
                                name="interests"
                                value="운동">

                            <span>
                                #오운완/운동
                            </span>

                        </label>



                        <!-- 테크 -->

                        <label class="interest-item">

                            <input
                                type="checkbox"
                                name="interests"
                                value="테크">

                            <span>
                                #테크/데스크셋업
                            </span>

                        </label>



                        <!-- 모빌리티 -->

                        <label class="interest-item">

                            <input
                                type="checkbox"
                                name="interests"
                                value="모빌리티">

                            <span>
                                #전기차/모빌리티
                            </span>

                        </label>



                        <!-- 미라클모닝 -->

                        <label class="interest-item">

                            <input
                                type="checkbox"
                                name="interests"
                                value="미라클모닝">

                            <span>
                                #미라클모닝
                            </span>

                        </label>



                        <!-- 맛집탐방 -->

                        <label class="interest-item">

                            <input
                                type="checkbox"
                                name="interests"
                                value="맛집탐방">

                            <span>
                                #맛집탐방
                            </span>

                        </label>



                        <!-- OTT -->

                        <label class="interest-item">

                            <input
                                type="checkbox"
                                name="interests"
                                value="OTT">

                            <span>
                                #OTT/콘텐츠
                            </span>

                        </label>


                    </div>

                </div>



                <!-- ==================================
                     구분선
                =================================== -->

                <hr class="divider">



                <!-- ==================================
                     이용약관
                =================================== -->

                <div class="terms-area">


                    <input
                        type="checkbox"
                        id="terms"
                        name="termsAgreed"
                        value="true"
                        required>


                    <label for="terms">

                        [필수] 서비스 이용약관 및
                        개인정보 처리방침에 동의합니다.

                    </label>


                </div>



                <!-- ==================================
                     회원가입 버튼
                =================================== -->

                <button
                    type="submit"
                    class="signup-button">

                    ♟ 회원가입 완료 &amp; 1일차 시작

                </button>


            </form>



            <!-- ==================================
                 로그인 이동
            =================================== -->

            <div class="login-area">


                이미 계정이 있으신가요?


                <a
                    href="${pageContext.request.contextPath}/member/signin"
                    class="login-link">

                    로그인하기

                </a>


            </div>


        </div>


    </div>


</div>



<script>

/* ==========================================
   요소 가져오기
========================================== */

const signupForm =
    document.getElementById("signupForm");

const password =
    document.getElementById("memberPw");

const passwordCheck =
    document.getElementById("memberPwCheck");

const pwMessage =
    document.getElementById("pwMessage");

const terms =
    document.getElementById("terms");



/* ==========================================
   비밀번호 확인 함수
========================================== */

function checkPassword() {


    if (passwordCheck.value === "") {

        pwMessage.textContent = "";

        pwMessage.className =
            "message";

        return false;
    }


    if (
        password.value
        ===
        passwordCheck.value
    ) {

        pwMessage.textContent =
            "비밀번호가 일치합니다.";

        pwMessage.className =
            "message success-message";

        return true;
    }


    pwMessage.textContent =
        "비밀번호가 일치하지 않습니다.";

    pwMessage.className =
        "message error-message";

    return false;
}



/* ==========================================
   비밀번호 입력 시 검사
========================================== */

password.addEventListener(
    "input",
    function() {

        if (passwordCheck.value !== "") {

            checkPassword();
        }

    }
);



passwordCheck.addEventListener(
    "input",
    function() {

        checkPassword();

    }
);



/* ==========================================
   회원가입 제출
========================================== */

signupForm.addEventListener(
    "submit",
    function(event) {


        /* 비밀번호 8자 검사 */

        if (password.value.length < 8) {

            event.preventDefault();

            alert(
                "비밀번호는 8자 이상 입력해주세요."
            );

            password.focus();

            return;
        }



        /* 비밀번호 일치 검사 */

        if (!checkPassword()) {

            event.preventDefault();

            passwordCheck.focus();

            return;
        }



        /* 이용약관 검사 */

        if (!terms.checked) {

            event.preventDefault();

            alert(
                "서비스 이용약관 및 개인정보 처리방침에 동의해주세요."
            );

            terms.focus();

            return;
        }


    }
);

</script>


</body>

</html>